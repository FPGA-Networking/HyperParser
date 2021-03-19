
module lut_6_1_rom_d64
    # ( parameter       INIT_VALUE    = 0   ,
                        BUS_WIDTH     = 32   
                        // ROM_DEPTH     = 64  
        )
(
    input       clk ,
    input       rst ,
    input       [5:0] addr ,
    output reg  [BUS_WIDTH-1:0] dout
);

// (*DONT_TOUCH = "TRUE"*) 

// reg [63:0] mem [0:BUS_WIDTH/2-1] ;

wire [BUS_WIDTH-1:0] dout_pre ;
// 最高位是mem[BUS_WIDTH/2-1]

// initial begin
//     $readmemb(INIT_FILE,mem,0,ROM_DEPTH-1);
// end


// parameter INIT_VALUE = mem ;



always @(posedge clk) begin
    dout <= dout_pre ;  
end

// (* DONT_TOUCH= "TRUE" *) 
genvar i;
generate
    for (i=0; i<BUS_WIDTH; i=i+1) begin : lut_6_1_rom
        
             LUT6 #(
                  .INIT(INIT_VALUE[64*(i+1)-1 -: 64]) 
               ) LUT6_inst (
                  .O (dout_pre[i]), 
                  .I0(addr[0]),  
                  .I1(addr[1]),  
                  .I2(addr[2]),  
                  .I3(addr[3]),  
                  .I4(addr[4]),  
                  .I5(addr[5]) 
               );

    end
endgenerate
    
endmodule



