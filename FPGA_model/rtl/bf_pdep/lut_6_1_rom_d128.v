
module lut_6_1_rom_d128
    # ( parameter       INIT_VALUE    = 0   ,
                        BUS_WIDTH     = 32   
                        // ROM_DEPTH     = 64  
        )
(
    input       clk ,
    // input       rst ,
    input       [6:0] addr ,
    output reg  [BUS_WIDTH-1:0] dout
);

// (*DONT_TOUCH = "TRUE"*) 

// reg [63:0] mem [0:BUS_WIDTH/2-1] ;

wire [BUS_WIDTH-1:0] dout_pre_1 ;
wire [BUS_WIDTH-1:0] dout_pre_2 ;
wire [BUS_WIDTH-1:0] mux_out ;


// 最高位是mem[BUS_WIDTH/2-1]

// initial begin
//     $readmemb(INIT_FILE,mem,0,ROM_DEPTH-1);
// end


// parameter INIT_VALUE = mem ;





// (* DONT_TOUCH= "TRUE" *) 
genvar i;
generate
    for (i=0; i<BUS_WIDTH; i=i+1) begin : lut_6_1_rom_d64_1
        
             LUT6 #(
                  .INIT(INIT_VALUE[64*(i+1)-1 -: 64]) 
               ) LUT6_inst (
                  .O (dout_pre_1[i]), 
                  .I0(addr[0]),  
                  .I1(addr[1]),  
                  .I2(addr[2]),  
                  .I3(addr[3]),  
                  .I4(addr[4]),  
                  .I5(addr[5]) 
               );

    end
endgenerate

genvar j;
generate
    for (j=0; j<BUS_WIDTH; j=j+1) begin : lut_6_1_rom_d64_2
        
             LUT6 #(
                  .INIT(INIT_VALUE[64*BUS_WIDTH+64*(j+1)-1 -: 64]) 
               ) LUT6_inst (
                  .O (dout_pre_2[j]), 
                  .I0(addr[0]),  
                  .I1(addr[1]),  
                  .I2(addr[2]),  
                  .I3(addr[3]),  
                  .I4(addr[4]),  
                  .I5(addr[5]) 
               );

    end
endgenerate


genvar k;
generate
    for (k=0; k<BUS_WIDTH; k=k+1) begin : mux
        MUXF7 MUXF7_inst (
           .O(mux_out[k]),   // 1-bit output: Output of MUX
           .I0(dout_pre_1[k]), // 1-bit input: Connect to LUT6 output
           .I1(dout_pre_2[k]), // 1-bit input: Connect to LUT6 output
           .S(addr[6])    // 1-bit input: Input select to MUX
        );
    end
endgenerate










always @(posedge clk) begin
    dout <= mux_out ;  
end









    
endmodule



