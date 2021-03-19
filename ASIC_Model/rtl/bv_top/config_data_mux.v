module config_data_mux 

  # ( 
      parameter SRAM_ADDR_WIDTH         = 6,
                STRIDE                  = 4,
                MODE_WIDTH              = 2 ,
                RESULT_WIDTH            = 64,
                SRAM_NUM                = 4 
  )

(
    input                                  clk,
    // input                                  rst,
    // Write
    // input   [7:0]                          sram_sel ,
    // input                                  config_en,    
    // input   [(SRAM_ADDR_WIDTH)-1:0]      config_addr,                           
    // input   [RESULT_WIDTH-1:0]             config_i ,       
    // Read
    input   [STRIDE*SRAM_NUM-1:0]          din,
    input   [MODE_WIDTH-1:0]               bus_mode,   

    // Output
    // output reg [SRAM_NUM-1:0]                       wr_en,
    output reg [(SRAM_ADDR_WIDTH)*SRAM_NUM-1:0]     sram_addr
    // output reg [RESULT_WIDTH*SRAM_NUM-1:0]          config_data
);



integer i;  
always @(posedge clk) begin
    for (i = 0; i<SRAM_NUM;i=i+1 ) begin
        // if (config_en == 1'b1 && sram_sel==i) begin
        //     wr_en <= 1'b1;
        //     sram_addr[(SRAM_ADDR_WIDTH)*i +: (SRAM_ADDR_WIDTH)] <= config_addr;
        //     config_data[RESULT_WIDTH*i +: RESULT_WIDTH] <= config_i;
        // end
        // else begin
            // wr_en <= 1'b0;
            sram_addr[(SRAM_ADDR_WIDTH)*i +: (SRAM_ADDR_WIDTH)] <= {bus_mode,din[STRIDE*i +: STRIDE]};
            // sram_addr[(SRAM_ADDR_WIDTH)*i +: (SRAM_ADDR_WIDTH)] <= {din[STRIDE*i +: STRIDE]};// 这里需要修改，因为bus_mode
            // config_data[RESULT_WIDTH*i +: RESULT_WIDTH] <= 'b0;
        // end
    end
end


endmodule //config_data_mux