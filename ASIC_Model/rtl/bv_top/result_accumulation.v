module result_accumulation

  # ( 
      parameter STRIDE                  = 4,
                MODE_WIDTH              = 2 ,
                RESULT_WIDTH            = 64,
                SRAM_NUM                = 4 
  )

 (
    input  wire                                 clk,
    input  wire [RESULT_WIDTH*SRAM_NUM-1:0]     result_i,
    output reg  [RESULT_WIDTH-1:0]              result_o
);


wire [RESULT_WIDTH*SRAM_NUM-1:0] result_temp ;

genvar i;
generate
    assign result_temp[RESULT_WIDTH-1:0] = result_i[RESULT_WIDTH-1:0];
    for (i = 1;i<SRAM_NUM ;i=i+1 ) begin
        assign result_temp[RESULT_WIDTH*i +: RESULT_WIDTH] = result_temp[RESULT_WIDTH*(i-1) +: RESULT_WIDTH]&result_i[RESULT_WIDTH*i +: RESULT_WIDTH];
    end
endgenerate

always @(posedge clk) begin
    result_o <= result_temp[RESULT_WIDTH*SRAM_NUM-1 -: RESULT_WIDTH];
end






endmodule //result_accumulation