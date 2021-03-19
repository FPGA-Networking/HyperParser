

module bv_tcam_top 
  # ( 
      parameter STRIDE                  = 4,
                // SEG_NUM                 = 4,
                MODE_WIDTH              = 2,
                RESULT_WIDTH            = 32, // 按bv长度算
                SRAM_NUM                = 32,
                INIT_FILE               = "INIT_00.memINIT_01.memINIT_02.memINIT_03.memINIT_04.memINIT_05.memINIT_06.memINIT_07.memINIT_08.memINIT_09.memINIT_10.memINIT_11.memINIT_12.memINIT_13.memINIT_14.memINIT_15.memINIT_16.memINIT_17.memINIT_18.memINIT_19.memINIT_20.memINIT_21.memINIT_22.memINIT_23.memINIT_24.memINIT_25.memINIT_26.memINIT_27.memINIT_28.memINIT_29.memINIT_30.memINIT_31.mem"
  )

(
    input                                  clk,
    // input                                  rst,
    // Write
    input   [4:0]                           sram_sel ,      
    input                                   config_en,       
    input   [5:0]                           config_addr,                            
    input   [31:0]                          config_i ,           
    // Read
    input                                  din_val,
    input   [STRIDE*SRAM_NUM-1:0]          din,
    input   [MODE_WIDTH-1:0]               bus_mode,   


    // output                                  dout_val,
    // output  [MODE_WIDTH-1:0]                mode_o,
    output  [MODE_WIDTH+$clog2(RESULT_WIDTH)-1:0]   dout_seg_01,
    output  [MODE_WIDTH+$clog2(RESULT_WIDTH)-1:0]   dout_seg_02,
    output  [MODE_WIDTH+$clog2(RESULT_WIDTH)-1:0]   dout_seg_03,
    output  [MODE_WIDTH+$clog2(RESULT_WIDTH)-1:0]   dout_seg_04


);
    

// parameter SRAM_NUM = DATA_WIDTH_I/STRIDE ;

parameter SRAM_ADDR_WIDTH = STRIDE+MODE_WIDTH;
// parameter SRAM_ADDR_WIDTH = STRIDE; // 这里需要修改，因为bus_mode,还需要修改config_data_mux.v
parameter LATENCY = 3+1+1; // 前3个钟是BV+初步聚合结果花的，后面1个钟是根据seg聚合结果花的，最后一个钟是bit vector独热码结果转二进制数花的

wire [SRAM_NUM-1:0]                       wr_en;
wire [SRAM_ADDR_WIDTH*SRAM_NUM-1:0]       sram_addr;
wire [RESULT_WIDTH*SRAM_NUM-1:0]          config_data;

wire [RESULT_WIDTH*SRAM_NUM-1:0] temp_result;

wire [RESULT_WIDTH-1:0] bit_vector_temp[0:4];

reg  [LATENCY-1:0] dval_temp ;


// MUX the config data and bit-vector
config_data_mux 
#(
    .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH),
    .STRIDE       (STRIDE       ),
    .MODE_WIDTH   (MODE_WIDTH   ),
    .RESULT_WIDTH (RESULT_WIDTH ),
    .SRAM_NUM     (SRAM_NUM     )
)
u_config_data_mux(
    .clk         (clk         ),
    // .rst         (rst         ),
    // .sram_sel    (sram_sel    ),
    // .config_en   (config_en   ),
    // .config_addr (config_addr ),
    // .config_i    (config_i    ),
    .din         (din         ),
    .bus_mode    (bus_mode    ),
    // .wr_en       (wr_en       ),
    .sram_addr   (sram_addr   )
    // .config_data (config_data )
);


genvar i;
generate
    for (i=0; i<SRAM_NUM; i=i+1) begin : BV_SRAM
        
        bv_ram 
        #(
            .ADDR_WIDTH (SRAM_ADDR_WIDTH ),
            .DATA_DEPTH (48),
            .DATA_WIDTH (RESULT_WIDTH ),
            .RAM_INDEX  (i),
            .INIT_FILE  (INIT_FILE[88*i +: 88]  )
        )
        u_bv_ram(
            .clk      (clk      ),
            // .rst      (rst      ),
            
            .wr_en    (config_en    ),
            .sram_sel (sram_sel),
            .addr_wr  (config_addr),
            .din      (config_i      ),


            .addr_rd     (sram_addr[SRAM_ADDR_WIDTH*i +: SRAM_ADDR_WIDTH]     ),
            .dout     (temp_result[RESULT_WIDTH*i +: RESULT_WIDTH]     )
        );

    end
endgenerate



result_accumulation 
#(
    .STRIDE       (STRIDE       ),
    .MODE_WIDTH   (MODE_WIDTH   ),
    .RESULT_WIDTH (RESULT_WIDTH ),
    .SRAM_NUM     (SRAM_NUM/4     )
)
u_result_accumulation_01(
    .clk      (clk      ),
    .result_i (temp_result[RESULT_WIDTH*SRAM_NUM*0/4 +: RESULT_WIDTH*SRAM_NUM/4] ),
    .result_o (bit_vector_temp[0] )
);

result_accumulation 
#(
    .STRIDE       (STRIDE       ),
    .MODE_WIDTH   (MODE_WIDTH   ),
    .RESULT_WIDTH (RESULT_WIDTH ),
    .SRAM_NUM     (SRAM_NUM/4     )
)
u_result_accumulation_02(
    .clk      (clk      ),
    .result_i (temp_result[RESULT_WIDTH*SRAM_NUM*1/4 +: RESULT_WIDTH*SRAM_NUM/4] ),
    .result_o (bit_vector_temp[1] )
);

result_accumulation 
#(
    .STRIDE       (STRIDE       ),
    .MODE_WIDTH   (MODE_WIDTH   ),
    .RESULT_WIDTH (RESULT_WIDTH ),
    .SRAM_NUM     (SRAM_NUM/4     )
)
u_result_accumulation_03(
    .clk      (clk      ),
    .result_i (temp_result[RESULT_WIDTH*SRAM_NUM*2/4 +: RESULT_WIDTH*SRAM_NUM/4] ),
    .result_o (bit_vector_temp[2] )
);

result_accumulation 
#(
    .STRIDE       (STRIDE       ),
    .MODE_WIDTH   (MODE_WIDTH   ),
    .RESULT_WIDTH (RESULT_WIDTH ),
    .SRAM_NUM     (SRAM_NUM/4     )
)
u_result_accumulation_04(
    .clk      (clk      ),
    .result_i (temp_result[RESULT_WIDTH*SRAM_NUM*3/4 +: RESULT_WIDTH*SRAM_NUM/4] ),
    .result_o (bit_vector_temp[3] )
);


reg [1:0] bus_mode_ff_01;
reg [1:0] bus_mode_ff_02;
reg [1:0] bus_mode_ff_03;

always @(posedge clk) begin
    bus_mode_ff_01 <= bus_mode          ;
    bus_mode_ff_02 <= bus_mode_ff_01    ;
    bus_mode_ff_03 <= bus_mode_ff_02    ;
end

assign mode_o = bus_mode_ff_02;

final_accumulation 
#(
    .ONE_HOT_RESULT_WIDTH (RESULT_WIDTH )
)
u_final_accumulation(
    .clk         (clk         ),
    .result_i_01 (bit_vector_temp[0] ),
    .result_i_02 (bit_vector_temp[1] ),
    .result_i_03 (bit_vector_temp[2] ),
    .result_i_04 (bit_vector_temp[3] ),
    .mode_i      (bus_mode_ff_03     ),
    .result_o_01 (dout_seg_01 ),
    .result_o_02 (dout_seg_02 ),
    .result_o_03 (dout_seg_03 ),
    .result_o_04 (dout_seg_04 )
);





always @(posedge clk) begin
    dval_temp <= {dval_temp[LATENCY-2:0],din_val};
end

assign dout_val=dval_temp[LATENCY-1];




endmodule


    // input   [4:0]                          sram_sel ,
    // input                                  config_en,    
    // input   [(STRIDE+MODE_WIDTH)-1:0]      config_addr,                           
    // input   [RESULT_WIDTH-1:0]             config_i ,       