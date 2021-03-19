// MODE:
//  00 : 1 SEGMENT
//  01 : 2 SEGMENT
//  10 : 4 SEGMENT

// mode需要领先 din 2个时钟

// 本配置下延迟10个时钟

`include "./define/define.v"

module test_pex_ibf_pdep_bf_top 

# ( 
    parameter   DATA_WIDTH                  = 4096, // 4096 ,
                MODE_WIDTH                  = 2, // 2 ,

                IBF_STAGE_NUM_2_2           = 7, // 7 ,
                IBF_CFG_WIDTH_2_2           = 64*DATA_WIDTH/2 , //单级stage的config width,转换为LUT初始值时需要乘64
                IBF_CFG_DEPTH               = 3 ,
                IBF_PIPED_MASK_2_2          = 7'b1111111 ,//  full_pipe:7'b1111111   no_pipe :    1000000   part_pipe_1:b1001001             part_pipe_2:b1101011  
                
                // 7'b111_1111 , 至少有1个1，满足latency-2的需求，建议1不要出现在开始 b0001000 b1111111 b0000000 b1001001
                // IBF_INIT_FILE_2_2           = "ibf2_01.memibf2_02.memibf2_03.memibf2_04.memibf2_05.memibf2_06.memibf2_07.mem", // 所有文件的格式都需要是88bit，也就是test_01.mem这样的长度
                IBF_N_NUM_2_1               = 32,//32 ,
                IBF_CFG_WIDTH_2_1           = $clog2(IBF_N_NUM_2_1)*(DATA_WIDTH/IBF_N_NUM_2_1) , //只有一级
                // IBF_INIT_FILE_2_1           = "ibf1_01.mem",

                BF_STAGE_NUM_2_2           = $clog2(DATA_WIDTH/8), // 9 ,
                BF_ADDR_WIDTH              = 7 ,// log2(BF_CFG_DEPTH) 取整
                BF_CFG_WIDTH_2_2           = (DATA_WIDTH/(2*8))/4 , //单级stage的config width
                BF_CFG_DEPTH               = 128 ,
                BF_PIPED_MASK_2_2          = 9'b111111111 ,// full_pipe:9'b111111111   no_pipe:100000001 part_pipe_1:b100010001 part_pipe_2 :b101010101
                
                
                //     7'b111_1111 , 里面至少有2个1，满足LATENCY-2的要求  b100010001 b111111111 000000000
                //BF_REVERSE_PIPED_MASK_2_2  = 9'b010001101, // 最右边需要是1
                // BF_INIT_FILE_2_2           = "bf2A_01.membf2A_02.membf2A_03.membf2A_04.membf2A_05.membf2A_06.membf2A_07.membf2A_08.membf2A_09.membf2B_01.membf2B_02.membf2B_03.membf2B_04.membf2B_05.membf2B_06.membf2B_07.membf2B_08.membf2B_09.membf2C_01.membf2C_02.membf2C_03.membf2C_04.membf2C_05.membf2C_06.membf2C_07.membf2C_08.membf2C_09.membf2D_01.membf2D_02.membf2D_03.membf2D_04.membf2D_05.membf2D_06.membf2D_07.membf2D_08.membf2D_09.mem",
                STRIDE                  = 4,
                // SEG_NUM                 = 4,

                // BV部分
                // MODE_WIDTH              = 2,
                RESULT_WIDTH            = 32, // 按bv长度算
                SRAM_NUM                = 32
                // INIT_FILE               = "INIT_00.memINIT_01.memINIT_02.memINIT_03.memINIT_04.memINIT_05.memINIT_06.memINIT_07.memINIT_08.memINIT_09.memINIT_10.memINIT_11.memINIT_12.memINIT_13.memINIT_14.memINIT_15.memINIT_16.memINIT_17.memINIT_18.memINIT_19.memINIT_20.memINIT_21.memINIT_22.memINIT_23.memINIT_24.memINIT_25.memINIT_26.memINIT_27.memINIT_28.memINIT_29.memINIT_30.memINIT_31.mem"
 )

(
    // 系统信号
    input  wire                                    clk,
    // input  wire                                    rst,
    
    // 数据路径
    input  wire [MODE_WIDTH-1:0]                   mode_i,
    input  wire                                    dval_i,
    input  wire [DATA_WIDTH-1:0]                   data_i,  
    output wire                                    dval_o,
    output wire [DATA_WIDTH-1:0]                   data_o

    // // 配置路径-IBF网络
    // input  wire [7:0]                                   ibf_sram_sel_2_2, 
    // input  wire                                         ibf_wr_en_2_2,
    // input  wire [IBF_CFG_WIDTH_2_2-1:0]                 ibf_wr_cfg_2_2,

    // // 配置路径-IBF-MUX
    // input  wire                                         ibf_wr_en_2_1,
    // input  wire [IBF_CFG_WIDTH_2_1-1:0]                 ibf_wr_cfg_2_1,

    // // 配置路径-BF网络
    // input  wire [7:0]                                   bf_sram_sel_2_2, 
    // input  wire                                         bf_wr_en_2_2_A,
    // input  wire                                         bf_wr_en_2_2_B,
    // input  wire                                         bf_wr_en_2_2_C,
    // input  wire                                         bf_wr_en_2_2_D,
    // input  wire [BF_CFG_WIDTH_2_2-1:0]                  bf_wr_cfg_2_2,

    // input   [7:0]                          bv_sram_sel ,
    // input                                  bv_config_en,    
    // input   [(STRIDE+MODE_WIDTH)-1:0]      bv_config_addr,                           
    // input   [RESULT_WIDTH-1:0]             bv_config_i 




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








localparam IBF_BV_LATENCY = POP_CNT(IBF_PIPED_MASK_2_2)+1+ 5 /*1*/+2;// 一个MUX的延迟，5个地址转换(BV)的延迟，地址得先到2个时钟

localparam IBF_MOD_LATENCY = POP_CNT(IBF_PIPED_MASK_2_2)+3 ; // 本来提前2个钟，MUX加入1个钟，一共三个钟

wire                                                ibf_dval_o;
wire [DATA_WIDTH/IBF_N_NUM_2_1-1:0]                 ibf_data_o; 
// reg  [BF_ADDR_WIDTH-1:0]                            addr_to_bf;

wire  [BF_ADDR_WIDTH-1:0]                            addr_A;
wire  [BF_ADDR_WIDTH-1:0]                            addr_B;
wire  [BF_ADDR_WIDTH-1:0]                            addr_C;
wire  [BF_ADDR_WIDTH-1:0]                            addr_D;




// reg                                                 addr_en   ;
reg  [DATA_WIDTH-1:0] data_ibf_bv_temp [0:IBF_BV_LATENCY-1]   ;
reg                   dval_ibf_bv_temp [0:IBF_BV_LATENCY-1]   ;
reg  [1:0]            mode_ibf_temp[0:IBF_MOD_LATENCY-1] ;


integer md;
always @(posedge clk) begin
    mode_ibf_temp[0] <= mode_i ; 
    for ( md=1 ; md<IBF_MOD_LATENCY ; md=md+1 ) begin
        mode_ibf_temp[md] <= mode_ibf_temp[md-1] ;
    end
end

ibf_top 
#(
    .DATA_WIDTH     (DATA_WIDTH     ),
    .MODE_WIDTH     (MODE_WIDTH     ),
    .STAGE_NUM_2_2  (IBF_STAGE_NUM_2_2  ),
    .CFG_WIDTH_2_2  (IBF_CFG_WIDTH_2_2  ),
    .CFG_DEPTH      (IBF_CFG_DEPTH      ),
    .PIPED_MASK_2_2 (IBF_PIPED_MASK_2_2 ),
    .INIT_FILE_2_2  (`IBF_PIPE_INIT  ),
    .N_NUM_2_1      (IBF_N_NUM_2_1      ),
    .CFG_WIDTH_2_1  (IBF_CFG_WIDTH_2_1  ),
    .INIT_FILE_2_1  (`IBF_MUX_INIT  )
)
u_ibf_top(
    .clk          (clk          ),
    // .rst          (rst          ),
    .mode_i       (mode_i       ),
    .dval_i       (dval_i       ),
    .data_i       (data_i       ),
    .dval_o       (ibf_dval_o   ),
    .data_o       (ibf_data_o   )
    // .sram_sel_2_2 (ibf_sram_sel_2_2 ),
    // .wr_en_2_2    (ibf_wr_en_2_2    ),
    // .wr_cfg_2_2   (ibf_wr_cfg_2_2   ),
    // .wr_en_2_1    (ibf_wr_en_2_1    ),
    // .wr_cfg_2_1   (ibf_wr_cfg_2_1   )
);




bv_tcam_top 
#(
    .STRIDE          (STRIDE          ),
    .MODE_WIDTH      (MODE_WIDTH      ),
    .RESULT_WIDTH    (RESULT_WIDTH    ),
    .SRAM_NUM        (SRAM_NUM        ),
    .INIT_FILE       (`BV_INIT        )
)
u_bv_tcam_top(
    .clk         (clk         ),
    // .rst         (rst         ),
    // .sram_sel    (bv_sram_sel    ),
    // .config_en   (bv_config_en   ),
    // .config_addr (bv_config_addr ),
    // .config_i    (bv_config_i    ),
    // .din_val     (  ibf_dval_o   ),
    .din         (  ibf_data_o       ),
    .bus_mode    ( mode_ibf_temp[IBF_MOD_LATENCY-1]   ),
    // .dout_val    (    ),
    // .mode_o      (      ),
    .dout_seg_01 ( addr_A ),
    .dout_seg_02 ( addr_B ),
    .dout_seg_03 ( addr_C ),
    .dout_seg_04 ( addr_D )
);





integer j;
always @(posedge clk) begin
    data_ibf_bv_temp[0] <= data_i ; 
    dval_ibf_bv_temp[0] <= dval_i ;
    for ( j=1 ; j<IBF_BV_LATENCY ; j=j+1 ) begin
        data_ibf_bv_temp[j] <= data_ibf_bv_temp[j-1] ;
        dval_ibf_bv_temp[j] <= dval_ibf_bv_temp[j-1] ;
    end
end



bf_top 
#(
    .DATA_WIDTH     (DATA_WIDTH     ),
    .ADDR_WIDTH     (BF_ADDR_WIDTH     ),
    .STAGE_NUM_2_2  (BF_STAGE_NUM_2_2  ),
    .CFG_WIDTH_2_2  (BF_CFG_WIDTH_2_2  ),
    .CFG_DEPTH      (BF_CFG_DEPTH      ),
    .PIPED_MASK_2_2 (BF_PIPED_MASK_2_2 ),
    //.REVERSE_PIPED_MASK_2_2(BF_REVERSE_PIPED_MASK_2_2),
    .INIT_FILE_2_2  (`BF_INIT  )
)
u_bf_top(
    .clk          (clk                      ),
    // .rst          (rst                      ),
    .addr_A       (  addr_A  ),
    .addr_B       (  addr_B  ) ,
    .addr_C       (  addr_C  ) ,
    .addr_D       (  addr_D  ) ,
    .dval_i       (dval_ibf_bv_temp[IBF_BV_LATENCY-1]         ),
    .data_i       (data_ibf_bv_temp[IBF_BV_LATENCY-1]         ),
    .dval_o       (dval_o       ),
    .data_o       (data_o       )
    // .sram_sel_2_2 (bf_sram_sel_2_2 ),
    // .wr_en_2_2_A    (bf_wr_en_2_2_A  ),
    // .wr_en_2_2_B    (bf_wr_en_2_2_B  ),
    // .wr_en_2_2_C    (bf_wr_en_2_2_C  ),
    // .wr_en_2_2_D    (bf_wr_en_2_2_D  ),
    // .wr_cfg_2_2   (bf_wr_cfg_2_2   )
);



// test





parameter ICMP_BIT_MASK_SEG_01 = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter TCP_BIT_MASK_SEG_01  = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter UDP_BIT_MASK_SEG_01  = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;



parameter ICMP_BIT_MASK_SEG_02 = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter TCP_BIT_MASK_SEG_02  = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
parameter UDP_BIT_MASK_SEG_02  = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;



parameter ICMP_BIT_MASK_SEG_04 = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000000000000000;
parameter TCP_BIT_MASK_SEG_04  = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000;
parameter UDP_BIT_MASK_SEG_04  = 4096'hffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000ffffffffffffffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff000000000000000000000000000000000000;



reg [4095:0] data_mask ;

reg [3:0] cnt = 4'b0;
always @(posedge clk) begin
    if( dval_o == 1'b1 ) begin
        cnt <= cnt+1'b1;
    end
    else begin
        cnt <= cnt ;
    end
        
end

always @(posedge clk) begin
    case (cnt)
        4'd0: data_mask <= data_o&ICMP_BIT_MASK_SEG_01;
        4'd1: data_mask <= data_o& TCP_BIT_MASK_SEG_01;
        4'd2: data_mask <= data_o& UDP_BIT_MASK_SEG_01;
        4'd3: data_mask <= data_o&ICMP_BIT_MASK_SEG_02;
        4'd4: data_mask <= data_o& TCP_BIT_MASK_SEG_02;
        4'd5: data_mask <= data_o& UDP_BIT_MASK_SEG_02;
        4'd6: data_mask <= data_o&ICMP_BIT_MASK_SEG_04;
        4'd7: data_mask <= data_o& TCP_BIT_MASK_SEG_04;
        4'd8: data_mask <= data_o& UDP_BIT_MASK_SEG_04;

        default: data_mask <= data_o&ICMP_BIT_MASK_SEG_01;
    endcase
end















reg [511:0] xor_result_1 ;

integer j1;
always @(posedge clk) begin
    for (j1 = 0; j1<512;j1=j1+1 ) begin
        xor_result_1[j1] <= ^data_mask[j1*8 +: 8] ;
    end
end

reg [63:0] xor_result_2 ;

integer j2;
always @(posedge clk) begin
    for (j2 = 0; j2<64;j2=j2+1 ) begin
        xor_result_2[j2] <= ^(xor_result_1[j2*8 +: 8]) ;
    end
end

reg [7:0] xor_result_3 ;

integer j3;
always @(posedge clk) begin
    for (j3 = 0; j3<8;j3=j3+1 ) begin
        xor_result_3[j3] <= ^(xor_result_2[j3*8 +: 8]) ;
    end
end


reg [7:0] latency_test = 8'b0;
always @(posedge clk) begin
    if (dval_i == 1'b1 || dval_o == 1'b1) begin
        latency_test <= 'd0 ;
    end
    else begin
        latency_test <= latency_test+1'b1 ;
    end
        
end








endmodule //test_pex_ibf_pdep_bf_top








// always @(posedge clk) begin
//     if (ibf_dval_o==1'b1) begin
//         casex (ibf_data_o)
    
//             128'b000100000000010000xxxxxxxxxxxxxx000100000000010000xxxxxxxxxxxxxx000100000000010000xxxxxxxxxxxxxx000100000000010000xxxxxxxxxxxxxx: addr_to_bf <= 'd93;
//             128'b000000000110101000xxxxxxxxxxxxxx000000000110101000xxxxxxxxxxxxxx000000000110101000xxxxxxxxxxxxxx000000000110101000xxxxxxxxxxxxxx: addr_to_bf <= 'd94;
//             128'b000010001000000011xxxxxxxxxxxxxx000010001000000011xxxxxxxxxxxxxx000010001000000011xxxxxxxxxxxxxx000010001000000011xxxxxxxxxxxxxx: addr_to_bf <= 'd95;

//             128'b000100000000010000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx000100000000010000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: addr_to_bf <= 'd61;
//             128'b000000000110101000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000110101000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: addr_to_bf <= 'd62;
//             128'b000010001000000011xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx000010001000000011xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: addr_to_bf <= 'd63;

//             128'b000100000000010000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: addr_to_bf <= 'd29;
//             128'b000000000110101000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: addr_to_bf <= 'd30;
//             128'b000010001000000011xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: addr_to_bf <= 'd31;

//             default: addr_to_bf <= 'd0;
//         endcase
//     end
//     else begin
//         addr_to_bf <= 'd0;
//     end
// end