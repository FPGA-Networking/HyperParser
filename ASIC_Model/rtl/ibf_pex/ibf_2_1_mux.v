module ibf_2_1_mux 
# (
        parameter   N_NUM       = 0,    // 32 , N选1输出
                    CFG_BIT_NUM = $clog2(N_NUM),
                    DATA_WIDTH  = 0     // 4096
    )
(
    input  wire                                             clk,
    // input  wire                                             rst,
    input  wire [DATA_WIDTH-1:0]                            din, 
    input  wire [$clog2(N_NUM)*(DATA_WIDTH/N_NUM)-1:0]      cfg,           
    output reg  [DATA_WIDTH/N_NUM-1:0]                      dout
);

localparam MUX_NUM = DATA_WIDTH/N_NUM ;
// localparam CFG_BIT_NUM = $clog2(N_NUM);
wire [N_NUM-1:0] data_temp [0:MUX_NUM-1] ;


genvar i,j;
generate
    for (i = 0; i<MUX_NUM; i=i+1 ) begin
        for (j = 0; j<N_NUM;j=j+1 ) begin
            assign data_temp[i][j] =  din[i+MUX_NUM*j] ;  // 错了：din[N_NUM*i+j] ;
        end
    end
endgenerate




integer m;  
always @(posedge clk) begin
    for (m = 0; m<MUX_NUM; m=m+1) begin
        dout[m] <= data_temp[m][cfg[CFG_BIT_NUM*m +: CFG_BIT_NUM]];
    end
end




endmodule //ibf_2_1_mux