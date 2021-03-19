module ibf_config_ram_2_1 

# (
    parameter   CFG_WIDTH               = 0 , //只有一级
                CFG_DEPTH               = 0 ,
                ADDR_WIDTH              = 0 ,
                INIT_FILE               = ""
)

 (
    input  wire                                    clk,
    input  wire                                    rst,
    input  wire [ADDR_WIDTH-1:0]                   addr, 
    // input  wire                                    wr_en,
    // input  wire [CFG_WIDTH-1:0]                    din,
    output wire [CFG_WIDTH-1:0]                    config_data
);

reg [4:0]                   addr_ff ;

always @(posedge clk) begin
    addr_ff<={3'b0,addr};
end

        
// cfg_ram 
// #(
//     .ADDR_WIDTH (ADDR_WIDTH ),
//     .DATA_WIDTH (CFG_WIDTH  ),
//     .DATA_DEPTH (CFG_DEPTH  ),
//     .RAM_INDEX  ('b1  ),
//     .INIT_FILE  (   INIT_FILE  )
// )
// u_cfg_ram(
//     .clk      (clk      ),
//     .rst      (rst      ),
//     .addr     (addr_ff     ),
//     .sram_sel ('b1      ),
//     .wr_en    (wr_en    ),
//     .din      (din      ),
//     .dout     (config_data    )
// );


lut_6_2_rom_top 
#(
    .INIT_VALUE (INIT_FILE ),
    .BUS_WIDTH  (CFG_WIDTH  )
)
u_lut_6_2_rom_top(
    .clk  (clk  ),
    .rst  (rst  ),
    .addr (addr_ff ),
    .dout (config_data )
);


endmodule //ibf_config_ram_2_1