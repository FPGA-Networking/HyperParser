// 限制：INIT_FILE的每个文件都得是88bit，也就是类似test_01.mem

module ibf_config_ram_2_2

# (
    parameter   STAGE_NUM               = 0 ,
                CFG_WIDTH               = 0 , //单级stage的config width
                CFG_DEPTH               = 0 ,
                ADDR_WIDTH              = 0 ,
                PIPED_MASK              = 0 ,
                INIT_FILE               = ""
)

 (
    input  wire                                    clk,
    // input  wire                                    rst,
    input  wire [ADDR_WIDTH-1:0]                   addr, 
    output wire [ADDR_WIDTH-1:0]                   addr_o, 
    output wire [STAGE_NUM*CFG_WIDTH-1:0]          config_data,

    // config, write
    input  wire [7:0]                              sram_sel, 
    input  wire [1:0]                              wr_addr,
    input  wire                                    wr_en,
    input  wire [63:0]                             din

);


reg [ADDR_WIDTH-1:0] addr_sram_reg[0:STAGE_NUM-1] ;
// reg [CFG_WIDTH-1:0]  din_sram_reg[0:STAGE_NUM-1];
// reg [STAGE_NUM-1:0]  wr_en_sram_reg;
// reg [7:0]            sram_sel_sram_reg[0:STAGE_NUM-1];

wire [ADDR_WIDTH-1:0] addr_sram_wire[0:STAGE_NUM-1] ;
// wire [CFG_WIDTH-1:0]  din_sram_wire[0:STAGE_NUM-1];
// wire [STAGE_NUM-1:0]  wr_en_sram_wire;
// wire [7:0]            sram_sel_sram_wire[0:STAGE_NUM-1];

wire [ADDR_WIDTH-1:0] addr_sram[0:STAGE_NUM-1] ;
// wire [CFG_WIDTH-1:0]  din_sram[0:STAGE_NUM-1];
// wire [STAGE_NUM-1:0]  wr_en_sram;
// wire [7:0]            sram_sel_sram[0:STAGE_NUM-1];

integer i;  
always @(posedge clk) begin
    addr_sram_reg [0]       <= addr    ; 
    // din_sram_reg  [0]       <= din     ;
    // wr_en_sram_reg[0]       <= wr_en   ;  
    // sram_sel_sram_reg[0]    <= sram_sel;
    for (i = 1;i<STAGE_NUM ;i=i+1 ) begin
        addr_sram_reg [i]       <= addr_sram [i-1] ; 
        // din_sram_reg  [i]       <= din_sram  [i-1] ;
        // wr_en_sram_reg[i]       <= wr_en_sram[i-1] ;  
        // sram_sel_sram_reg[i]    <= sram_sel_sram[i-1];
    end
end

genvar m;
generate
    assign addr_sram_wire [0]       = addr    ; 
    // assign din_sram_wire  [0]       = din     ;
    // assign wr_en_sram_wire[0]       = wr_en   ;  
    // assign sram_sel_sram_wire[0]    = sram_sel;
    for (m = 1;m<STAGE_NUM ;m=m+1 ) begin
        assign addr_sram_wire [m]       = addr_sram [m-1] ; 
        // assign din_sram_wire  [m]       = din_sram  [m-1] ; 
        // assign wr_en_sram_wire[m]       = wr_en_sram[m-1] ; 
        // assign sram_sel_sram_wire[m]    = sram_sel_sram[m-1];
    end
endgenerate



// genvar p;
// generate
//     for (p = 0; p<STAGE_NUM; p=p+1) begin
//         assign addr_sram[p]     = ( PIPED_MASK[STAGE_NUM-1-p] == 1'b1 )?addr_sram_reg[p] :addr_sram_wire[p]  ;
//         assign din_sram[p]      = ( PIPED_MASK[STAGE_NUM-1-p] == 1'b1 )?din_sram_reg[p]  :din_sram_wire[p]   ;
//         assign wr_en_sram[p]    = ( PIPED_MASK[STAGE_NUM-1-p] == 1'b1 )?wr_en_sram_reg[p]:wr_en_sram_wire[p] ;
//         assign sram_sel_sram[p] = ( PIPED_MASK[STAGE_NUM-1-p] == 1'b1 )?sram_sel_sram_reg[p]:sram_sel_sram_wire[p];
//     end
// endgenerate


genvar p;
generate
    for (p = 0; p<STAGE_NUM; p=p+1) begin
        assign addr_sram[p]     = ( PIPED_MASK[p] == 1'b1 )?addr_sram_reg[p] :addr_sram_wire[p]  ;
        // assign din_sram[p]      = ( PIPED_MASK[p] == 1'b1 )?din_sram_reg[p]  :din_sram_wire[p]   ;
        // assign wr_en_sram[p]    = ( PIPED_MASK[p] == 1'b1 )?wr_en_sram_reg[p]:wr_en_sram_wire[p] ;
        // assign sram_sel_sram[p] = ( PIPED_MASK[p] == 1'b1 )?sram_sel_sram_reg[p]:sram_sel_sram_wire[p];
    end
endgenerate




genvar j;
generate
    for (j=0; j<STAGE_NUM; j=j+1) begin : CFG_SRAM_IBF
        
        cfg_ram_ibf 
        #(
            .ADDR_WIDTH (ADDR_WIDTH ),
            .DATA_WIDTH (CFG_WIDTH  ),
            .DATA_DEPTH (CFG_DEPTH  ),
            .RAM_INDEX  (j  ),
            .INIT_FILE  (INIT_FILE[88*j +: 88]  )  // j=0 对应file 07
        )
        u_cfg_ram_ibf(
            .clk      (clk      ),
            // .rst      (rst      ),
            .addr_rd     (addr_sram[STAGE_NUM-1-j]     ),
            .dout        (config_data[CFG_WIDTH*j +: CFG_WIDTH]     ),

            .addr_wr  (wr_addr),
            .sram_sel (sram_sel ),
            .wr_en    (wr_en    ),
            .din      (din      )

        );

    end
endgenerate


assign addr_o = addr_sram[STAGE_NUM-1];


// sram_sel, 
// wr_addr,
// wr_en,
// din



endmodule //ibf_config_ram_2_2



// 备份
// genvar j;
// generate
//     for (j=0; j<STAGE_NUM; j=j+1) begin : CFG_SRAM
        
//         cfg_ram 
//         #(
//             .ADDR_WIDTH (ADDR_WIDTH ),
//             .DATA_WIDTH (CFG_WIDTH  ),
//             .DATA_DEPTH (CFG_DEPTH  ),
//             .RAM_INDEX  (j  ),
//             .INIT_FILE  (INIT_FILE[88*j +: 88]  )
//         )
//         u_cfg_ram(
//             .clk      (clk      ),
//             .rst      (rst      ),
//             .addr     (addr_sram[j]     ),
//             .sram_sel (sram_sel_sram[j] ),
//             .wr_en    (wr_en_sram[j]    ),
//             .din      (din_sram[j]      ),
//             .dout     (config_data[CFG_WIDTH*j +: CFG_WIDTH]     )
//         );

//     end
// endgenerate