module ibf_config_ram_2_1 

# (
    parameter   CFG_WIDTH               = 0 , //只有一级
                CFG_DEPTH               = 0 ,
                ADDR_WIDTH              = 0 ,
                INIT_FILE               = ""
)

 (
    input  wire                                    clk,
    // input  wire                                    rst,
    input  wire [ADDR_WIDTH-1:0]                   addr, 
    output wire [CFG_WIDTH-1:0]                    config_data,


    // config, write
    input  wire [3:0]                              sram_sel, 
    input  wire [1:0]                              wr_addr,
    input  wire                                    wr_en,
    input  wire [63:0]                             din

);

reg [ADDR_WIDTH-1:0]                   addr_ff ;

always @(posedge clk) begin
    addr_ff<=addr;
end

        



cfg_ram_ibf_mux 
#(
    .ADDR_WIDTH (ADDR_WIDTH ),
    .DATA_DEPTH (CFG_DEPTH ),
    .DATA_WIDTH (CFG_WIDTH ),
    .RAM_INDEX  ('b0  ),
    .INIT_FILE  (INIT_FILE  )
)
u_cfg_ram_ibf_mux(
    .clk      (clk      ),
    .addr_rd  (addr_ff  ),
    .dout     (config_data     ),
    .addr_wr  (wr_addr  ),
    .sram_sel (sram_sel ),
    .wr_en    (wr_en    ),
    .din      (din      )
);



endmodule //ibf_config_ram_2_1

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