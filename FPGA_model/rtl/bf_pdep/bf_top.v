module bf_top 

# ( 
    parameter   DATA_WIDTH                  = 16, // 4096 ,
                ADDR_WIDTH                  = 2, // 2 ,
                STAGE_NUM_2_2               = 1, // 9 ,
                CFG_WIDTH_2_2               = DATA_WIDTH/2 , //单级stage的config width
                CFG_DEPTH                   = 3 ,
                PIPED_MASK_2_2              = 2'b11,//7'b111_1111 ,
                //REVERSE_PIPED_MASK_2_2      = 2'b11,//7'b111_1111 ,
                INIT_FILE_2_2               = 0
 )

(
    // 系统信号
    input  wire                                    clk,
    input  wire                                    rst,
    
    // 数据路径
    input  wire [ADDR_WIDTH-1:0]                   addr_A,
    input  wire [ADDR_WIDTH-1:0]                   addr_B,
    input  wire [ADDR_WIDTH-1:0]                   addr_C,
    input  wire [ADDR_WIDTH-1:0]                   addr_D,

    input  wire                                    dval_i,
    input  wire [DATA_WIDTH-1:0]                   data_i,  
    output wire                                    dval_o,
    output wire [DATA_WIDTH-1:0]                   data_o

    // 配置路径-BF网络
    // input  wire [7:0]                                   sram_sel_2_2, 
    // input  wire                                         wr_en_2_2_A,
    // input  wire                                         wr_en_2_2_B,
    // input  wire                                         wr_en_2_2_C,
    // input  wire                                         wr_en_2_2_D,
    // input  wire [CFG_WIDTH_2_2-1:0]                     wr_cfg_2_2



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

// 参数转换模块,把PIPED_MASK_2_2转换成配置存储所需的格式，最后一位一定是1，其他位是PIPED_MASK_2_2倒过来，举个例子，PIPED_MASK_2_2=011000100，BF_REVERSE_PIPED_MASK_2_2=010001101，最后一个bit一定是1，是因为mode领先din2个时钟
function integer MASK_CONVERT;
    input integer   MASK_INIT ;
    input integer   STAGE_NUM ;
    integer loop_var;
    begin
        MASK_CONVERT = 1;
        for (loop_var = STAGE_NUM-1; loop_var>0; loop_var=loop_var-1) begin
            MASK_CONVERT = MASK_CONVERT+MASK_INIT[loop_var]*(2**(STAGE_NUM-loop_var));
        end
    end
endfunction

parameter [0:STAGE_NUM_2_2-1] REVERSE_PIPED_MASK_2_2 = MASK_CONVERT(PIPED_MASK_2_2,STAGE_NUM_2_2) ;


localparam LATENCY = POP_CNT(PIPED_MASK_2_2) ;

wire [DATA_WIDTH/8-1:0] data_2_2_temp [0:STAGE_NUM_2_2][0:7] ;

wire [STAGE_NUM_2_2*CFG_WIDTH_2_2*4-1:0]          config_data_2_2;


// assign data_2_2_temp[0] = data_i ;

reg  [LATENCY-1:0] dval_temp ;


genvar p,q;
generate
    for ( p = 0; p<8;p=p+1 ) begin
        for (q = 0;q < DATA_WIDTH/8;q=q+1 ) begin
            assign data_2_2_temp[0][7-p][q] = data_i[8*q+p] ;
        end
    end
endgenerate






genvar j,m;
generate
    for (j=0; j<STAGE_NUM_2_2; j=j+1) begin : BF_2_2_STAGE_LAYER_1
        for (m=0; m<8; m=m+1) begin : BF_2_2_STAGE_LAYER_2
            bf_2_2_stage 
            #(
                .DATA_WIDTH             (DATA_WIDTH/8           ),
                .STAGE_ORDER            (STAGE_NUM_2_2-1-j      ),
                .IS_PIPED               (   PIPED_MASK_2_2[STAGE_NUM_2_2-1-j]   )
            ) //     PIPED_MASK_2_2[j]
            u_bf_2_2_stage(
                .clk         (clk         ),
                // .config_data (config_data_2_2[j*CFG_WIDTH_2_2 +: CFG_WIDTH_2_2] ),
                .config_data (config_data_2_2[(STAGE_NUM_2_2-1-j)*CFG_WIDTH_2_2*4 +: CFG_WIDTH_2_2*4] ),
                .din         (data_2_2_temp[j][m]          ),
                .dout        (data_2_2_temp[j+1][m]        )
            );
        end
    end
endgenerate

// parameter [0:STAGE_NUM_2_2-1] REVERSE_PIPED_MASK_2_2 ;

// genvar i;
// generate for(i = 0; i < STAGE_NUM_2_2; i = i + 1) begin
//   REVERSE_PIPED_MASK_2_2[i] = PIPED_MASK_2_2[STAGE_NUM_2_2-1-i];
// end endgenerate

wire [STAGE_NUM_2_2*CFG_WIDTH_2_2-1:0] config_data_2_2_A;
wire [STAGE_NUM_2_2*CFG_WIDTH_2_2-1:0] config_data_2_2_B;
wire [STAGE_NUM_2_2*CFG_WIDTH_2_2-1:0] config_data_2_2_C;
wire [STAGE_NUM_2_2*CFG_WIDTH_2_2-1:0] config_data_2_2_D;



genvar i;
generate
    for ( i=0 ;i<STAGE_NUM_2_2 ;i=i+1 ) begin
        assign config_data_2_2[CFG_WIDTH_2_2*4*i +: CFG_WIDTH_2_2*4] = {config_data_2_2_A[CFG_WIDTH_2_2*i +: CFG_WIDTH_2_2],config_data_2_2_B[CFG_WIDTH_2_2*i +: CFG_WIDTH_2_2],config_data_2_2_C[CFG_WIDTH_2_2*i +: CFG_WIDTH_2_2],config_data_2_2_D[CFG_WIDTH_2_2*i +: CFG_WIDTH_2_2]};
    end
endgenerate

bf_config_ram_2_2 
#(
    .STAGE_NUM  (STAGE_NUM_2_2  ),
    .CFG_WIDTH  (CFG_WIDTH_2_2  ),
    .CFG_DEPTH  (CFG_DEPTH  ),
    .ADDR_WIDTH (ADDR_WIDTH ),
    .PIPED_MASK (REVERSE_PIPED_MASK_2_2 ),
    .INIT_FILE  (INIT_FILE_2_2[(73728*4-1) -: 73728]  )
)
u_bf_config_ram_2_2_A(
    .clk         (clk         ),
    .rst         (rst         ),
    .addr        (addr_A        ),
    // .addr_o      (),
    // .sram_sel    (sram_sel_2_2    ),
    // .wr_en       (wr_en_2_2_A       ),
    // .din         (wr_cfg_2_2         ),
    .config_data ( config_data_2_2_A) // config_data_2_2[(STAGE_NUM_2_2*CFG_WIDTH_2_2*4-1) -: STAGE_NUM_2_2*CFG_WIDTH_2_2]
);

bf_config_ram_2_2 
#(
    .STAGE_NUM  (STAGE_NUM_2_2  ),
    .CFG_WIDTH  (CFG_WIDTH_2_2  ),
    .CFG_DEPTH  (CFG_DEPTH  ),
    .ADDR_WIDTH (ADDR_WIDTH ),
    .PIPED_MASK (REVERSE_PIPED_MASK_2_2 ),
    .INIT_FILE  (INIT_FILE_2_2[(73728*3-1) -: 73728]  )
)
u_bf_config_ram_2_2_B(
    .clk         (clk         ),
    .rst         (rst         ),
    .addr        (addr_B        ),
    // .addr_o      (),
    // .sram_sel    (sram_sel_2_2    ),
    // .wr_en       (wr_en_2_2_B       ),
    // .din         (wr_cfg_2_2         ),
    .config_data (config_data_2_2_B )
);


bf_config_ram_2_2 
#(
    .STAGE_NUM  (STAGE_NUM_2_2  ),
    .CFG_WIDTH  (CFG_WIDTH_2_2  ),
    .CFG_DEPTH  (CFG_DEPTH  ),
    .ADDR_WIDTH (ADDR_WIDTH ),
    .PIPED_MASK (REVERSE_PIPED_MASK_2_2 ),
    .INIT_FILE  (INIT_FILE_2_2[(73728*2-1) -: 73728]  )
)
u_bf_config_ram_2_2_C(
    .clk         (clk         ),
    .rst         (rst         ),
    .addr        (addr_C        ),
    // .addr_o      (),
    // .sram_sel    (sram_sel_2_2    ),
    // .wr_en       (wr_en_2_2_C       ),
    // .din         (wr_cfg_2_2         ),
    .config_data (config_data_2_2_C )
);


bf_config_ram_2_2 
#(
    .STAGE_NUM  (STAGE_NUM_2_2  ),
    .CFG_WIDTH  (CFG_WIDTH_2_2  ),
    .CFG_DEPTH  (CFG_DEPTH  ),
    .ADDR_WIDTH (ADDR_WIDTH ),
    .PIPED_MASK (REVERSE_PIPED_MASK_2_2 ),
    .INIT_FILE  (INIT_FILE_2_2[(73728*1-1) -: 73728]  )
)
u_bf_config_ram_2_2_D(
    .clk         (clk         ),
    .rst         (rst         ),
    .addr        (addr_D        ),
    // .addr_o      (),
    // .sram_sel    (sram_sel_2_2    ),
    // .wr_en       (wr_en_2_2_D       ),
    // .din         (wr_cfg_2_2         ),
    .config_data (config_data_2_2_D )
);
























always @(posedge clk) begin
    dval_temp <= {dval_temp[LATENCY-2:0],dval_i};
end

assign dval_o=dval_temp[LATENCY-1];

genvar a,b;
generate
    for ( a = 0; a<8;a=a+1 ) begin
        for (b = 0;b < DATA_WIDTH/8;b=b+1 ) begin
            assign  data_o[8*b+a] = data_2_2_temp[STAGE_NUM_2_2][7-a][b] ;
        end
    end
endgenerate


endmodule //bf_top



