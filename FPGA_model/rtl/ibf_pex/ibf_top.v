module ibf_top 

# ( 
    parameter   DATA_WIDTH                  = 16, // 4096 ,
                MODE_WIDTH                  = 2, // 2 ,
                STAGE_NUM_2_2               = 2, // 7 ,
                CFG_WIDTH_2_2               = DATA_WIDTH/2 , //单级stage的config width
                CFG_DEPTH                   = 3 ,
                PIPED_MASK_2_2              = 2'b11,//7'b111_1111 ,
                INIT_FILE_2_2               = 'b0,
                N_NUM_2_1                   = 4,//32 ,
                CFG_WIDTH_2_1               = $clog2(N_NUM_2_1)*(DATA_WIDTH/N_NUM_2_1) , //只有一级
                INIT_FILE_2_1               = 'b0
 )

(
    // 系统信号
    input  wire                                    clk,
    
    // 数据路径
    input  wire [MODE_WIDTH-1:0]                   mode_i,
    input  wire                                    dval_i,
    input  wire [DATA_WIDTH-1:0]                   data_i,  
    output wire                                    dval_o,
    output wire [DATA_WIDTH/N_NUM_2_1-1:0]         data_o 



);

// define population count function,which is a constant function
function integer POP_CNT;
    input integer  MASK ;
    integer loop_var;
    begin
        POP_CNT = 0;
        for (loop_var = 0; MASK!=0; loop_var=loop_var+1) begin
            if(MASK[0] == 1'b1) begin
                POP_CNT = POP_CNT+1;
            end
            MASK = MASK >> 1;
        end
    end

    
endfunction

reg [MODE_WIDTH-1:0] mode_ff_1 ;
reg [MODE_WIDTH-1:0] mode_ff_2 ;

always @(posedge clk) begin
    mode_ff_1 <= mode_i ;
    mode_ff_2 <= mode_ff_1 ;
end




localparam LATENCY = POP_CNT(PIPED_MASK_2_2)+1 ; // 这里加1是因为MUX的延迟
localparam LATENCY_IBF = POP_CNT(PIPED_MASK_2_2) ; // mode仍然提前2个钟


wire [MODE_WIDTH+DATA_WIDTH-1:0] data_2_2_temp [0:STAGE_NUM_2_2] ;

wire [CFG_WIDTH_2_1-1:0]                        config_data_2_1;

wire [1:0] addr_mode ;

wire [DATA_WIDTH-1:0] data_to_mux ;

assign data_2_2_temp[0] = {data_i,mode_ff_2} ;

reg  [LATENCY-1:0] dval_temp ;



reg [MODE_WIDTH-1:0] mode_dff [0:LATENCY_IBF] ;

integer pp;
always @(posedge clk) begin
    mode_dff[0] <= mode_i ;
    for ( pp=1 ;pp<=LATENCY_IBF ;pp=pp+1 ) begin
        mode_dff[pp] <= mode_dff[pp-1] ;
    end
end


genvar j;
generate
    for (j=0; j<STAGE_NUM_2_2; j=j+1) begin : IBF_2_2_STAGE
        
        ibf_2_2_stage 
        #(
            .DATA_WIDTH             (DATA_WIDTH             ),
            .MODE_WIDTH             (MODE_WIDTH),
            .STAGE_ORDER            (j                      ),
            .IS_PIPED               (PIPED_MASK_2_2[(STAGE_NUM_2_2-1-j)]      ), // 为了方便看，pipe0位于最左边，在parameter中对应最高位地址，因此需要倒一下
            .LUT_INIT               ( INIT_FILE_2_2[(STAGE_NUM_2_2-1-j)*CFG_WIDTH_2_2 +: CFG_WIDTH_2_2]  )
        )
        u_2_2_stage(
            .clk         (clk         ),
            .din_mod     (data_2_2_temp[j]          ),
            .dout        (data_2_2_temp[j+1]        )
        );


    end
endgenerate






assign addr_mode = data_2_2_temp[STAGE_NUM_2_2][1:0];
assign data_to_mux = data_2_2_temp[STAGE_NUM_2_2][DATA_WIDTH+MODE_WIDTH-1:MODE_WIDTH];

ibf_config_ram_2_1 
#(
    .CFG_WIDTH  ( CFG_WIDTH_2_1 ),
    .CFG_DEPTH  ( CFG_DEPTH ),
    .ADDR_WIDTH ( MODE_WIDTH ),
    .INIT_FILE  ( INIT_FILE_2_1 )
    )
 u_ibf_config_ram_2_1 (
    .clk                     ( clk           ),
    .rst                     ( rst           ),
    .addr                    ( mode_dff[LATENCY_IBF-1]         ),
    // .wr_en                   ( wr_en_2_1         ),
    // .din                     ( wr_cfg_2_1           ),
    .config_data             ( config_data_2_1   )
);




ibf_2_1_mux 
#(
    .N_NUM      (N_NUM_2_1      ),
    .DATA_WIDTH (DATA_WIDTH )
)
u_ibf_2_1_mux(
    .clk  (clk  ),
    .din  (data_to_mux  ),
    .cfg  (config_data_2_1  ),
    .dout (data_o )
);



always @(posedge clk) begin
    dval_temp <= {dval_temp[LATENCY-2:0],dval_i};
end

assign dval_o=dval_temp[LATENCY-1];



endmodule //ibf_top














// wire [STAGE_NUM_2_2*CFG_WIDTH_2_2-1:0]          config_data_2_2;
// wire [CFG_WIDTH_2_1-1:0]                        config_data_2_1;


    // // 配置路径-BF网络
    // input  wire [7:0]                                   sram_sel_2_2, 
    // input  wire                                         wr_en_2_2,
    // input  wire [CFG_WIDTH_2_2-1:0]                     wr_cfg_2_2,

    // // 配置路径-MUX
    // input  wire                                         wr_en_2_1,
    // input  wire [CFG_WIDTH_2_1-1:0]                     wr_cfg_2_1





// // 参数转换模块,把PIPED_MASK_2_2转换成配置存储所需的格式，最后一位一定是1，其他位是PIPED_MASK_2_2倒过来，举个例子，PIPED_MASK_2_2=011000100，BF_REVERSE_PIPED_MASK_2_2=010001101，最后一个bit一定是1，是因为mode领先din2个时钟
// function integer MASK_CONVERT;
//     input integer   MASK_INIT ;
//     input integer   STAGE_NUM ;
//     integer loop_var;
//     begin
//         MASK_CONVERT = 1;
//         for (loop_var = STAGE_NUM-1; loop_var>0; loop_var=loop_var-1) begin
//             MASK_CONVERT = MASK_CONVERT+MASK_INIT[loop_var]*(2**(STAGE_NUM-loop_var));
//         end
//     end
// endfunction

// parameter [0:STAGE_NUM_2_2-1] REVERSE_PIPED_MASK_2_2 = MASK_CONVERT(PIPED_MASK_2_2,STAGE_NUM_2_2) ;






// ibf_config_ram_2_2 
// #(
//     .STAGE_NUM  (STAGE_NUM_2_2  ),
//     .CFG_WIDTH  (CFG_WIDTH_2_2  ),
//     .CFG_DEPTH  (CFG_DEPTH  ),
//     .ADDR_WIDTH (MODE_WIDTH ),
//     .PIPED_MASK (REVERSE_PIPED_MASK_2_2 ),
//     .INIT_FILE  (INIT_FILE_2_2  )
// )
// u_ibf_config_ram_2_2(
//     .clk         (clk         ),
//     .rst         (rst         ),
//     .addr        (mode_i        ),
//     .addr_o      (addr_mode     ),   
//     .sram_sel    (sram_sel_2_2    ),
//     .wr_en       (wr_en_2_2       ),
//     .din         (wr_cfg_2_2         ),
//     .config_data (config_data_2_2 )
// );



// ibf_config_ram_2_1 
// #(
//     .CFG_WIDTH  ( CFG_WIDTH_2_1 ),
//     .CFG_DEPTH  ( CFG_DEPTH ),
//     .ADDR_WIDTH ( MODE_WIDTH ),
//     .INIT_FILE  ( INIT_FILE_2_1 )
//     )
//  u_ibf_config_ram_2_1 (
//     .clk                     ( clk           ),
//     .rst                     ( rst           ),
//     .addr                    ( addr_mode         ),
//     .wr_en                   ( wr_en_2_1         ),
//     .din                     ( wr_cfg_2_1           ),
//     .config_data             ( config_data_2_1   )
// );



// another implentation of pop function
    // function integer POP_CNT;
    // // input integer LEN ;
    // // localparam VAR_LEN = LEN ;

    // input integer  MASK ;
    // integer loop_var;
    // integer pop;
    // begin
    //     pop = 0;
    //     for (loop_var = 0; MASK!=0; loop_var=loop_var+1) begin
    //         if(MASK[0] == 1'b1) begin
    //             pop = pop+1;
    //         end
    //         MASK = MASK >> 1;
    //     end
    //     POP_CNT = pop;
    // end