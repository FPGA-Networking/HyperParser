module config_management (
    input  wire         clk                   ,
    // 外部输入
    input  wire [1:0]   i_cfg_sel_module      ,
    input  wire [7:0]   i_cfg_sram_sel        ,
    input  wire [6:0]   i_cfg_addr_write      ,
    input  wire         i_cfg_wr_en           ,
    input  wire [63:0]  i_cfg_data            ,
    // 给IBF_PEX 的 蝶形网络
    output  reg [7:0]   ibf_network_cfg_sram_sel        ,
    output  reg [1:0]   ibf_network_cfg_addr_write      ,
    output  reg         ibf_network_cfg_wr_en           ,
    output  reg [63:0]  ibf_network_cfg_data            ,

    // 给IBF_PEX 的 MUX
    output  reg [3:0]   ibf_mux_cfg_sram_sel        ,
    output  reg [1:0]   ibf_mux_cfg_addr_write      ,
    output  reg         ibf_mux_cfg_wr_en           ,
    output  reg [63:0]  ibf_mux_cfg_data            ,

    // 给BV
    output  reg [4:0]   bv_cfg_sram_sel        ,
    output  reg [5:0]   bv_cfg_addr_write      ,
    output  reg         bv_cfg_wr_en           ,
    output  reg [31:0]  bv_cfg_data            ,

    // 给BF_PDEP 的 蝶形网络
    output  reg [5:0]   bf_cfg_sram_sel        ,
    output  reg [6:0]   bf_cfg_addr_write      ,
    output  reg         bf_cfg_wr_en           ,
    output  reg [63:0]  bf_cfg_data             

);

reg [1:0]   ff_1_i_cfg_sel_module      ;
reg [7:0]   ff_1_i_cfg_sram_sel        ;
reg [6:0]   ff_1_i_cfg_addr_write      ;
reg         ff_1_i_cfg_wr_en           ;
reg [63:0]  ff_1_i_cfg_data            ;

reg [1:0]   ff_2_i_cfg_sel_module      ;
reg [7:0]   ff_2_i_cfg_sram_sel        ;
reg [6:0]   ff_2_i_cfg_addr_write      ;
reg         ff_2_i_cfg_wr_en           ;
reg [63:0]  ff_2_i_cfg_data            ;

always @(posedge clk) begin
        ff_1_i_cfg_sel_module  <= i_cfg_sel_module      ;
        ff_1_i_cfg_sram_sel    <= i_cfg_sram_sel        ;
        ff_1_i_cfg_addr_write  <= i_cfg_addr_write      ;
        ff_1_i_cfg_wr_en       <= i_cfg_wr_en           ;
        ff_1_i_cfg_data        <= i_cfg_data            ;

        ff_2_i_cfg_sel_module  <= ff_1_i_cfg_sel_module    ;
        ff_2_i_cfg_sram_sel    <= ff_1_i_cfg_sram_sel      ;
        ff_2_i_cfg_addr_write  <= ff_1_i_cfg_addr_write    ;
        ff_2_i_cfg_wr_en       <= ff_1_i_cfg_wr_en         ;
        ff_2_i_cfg_data        <= ff_1_i_cfg_data          ;
end

// 1
always @(posedge clk) begin
    if ( ff_2_i_cfg_wr_en == 1'b1 && ff_2_i_cfg_sel_module == 2'b00 ) begin
        ibf_network_cfg_sram_sel    <= ff_2_i_cfg_sram_sel   ;
        ibf_network_cfg_addr_write  <= ff_2_i_cfg_addr_write[1:0] ;
        ibf_network_cfg_wr_en       <= ff_2_i_cfg_wr_en      ;
        ibf_network_cfg_data        <= ff_2_i_cfg_data       ;
    end
    else begin
        ibf_network_cfg_sram_sel    <= 'b0;
        ibf_network_cfg_addr_write  <= 'b0;
        ibf_network_cfg_wr_en       <= 'b0;
        ibf_network_cfg_data        <= 'b0;
    end
end

// 2
always @(posedge clk) begin
    if ( ff_2_i_cfg_wr_en == 1'b1 && ff_2_i_cfg_sel_module == 2'b01 ) begin
        ibf_mux_cfg_sram_sel    <= ff_2_i_cfg_sram_sel[3:0]   ;
        ibf_mux_cfg_addr_write  <= ff_2_i_cfg_addr_write[1:0] ;
        ibf_mux_cfg_wr_en       <= ff_2_i_cfg_wr_en      ;
        ibf_mux_cfg_data        <= ff_2_i_cfg_data       ;
    end
    else begin
        ibf_mux_cfg_sram_sel    <= 'b0;
        ibf_mux_cfg_addr_write  <= 'b0;
        ibf_mux_cfg_wr_en       <= 'b0;
        ibf_mux_cfg_data        <= 'b0;
    end
end

// 3
always @(posedge clk) begin
    if ( ff_2_i_cfg_wr_en == 1'b1 && ff_2_i_cfg_sel_module == 2'b10 ) begin
        bv_cfg_sram_sel     <= ff_2_i_cfg_sram_sel[4:0]   ;
        bv_cfg_addr_write   <= ff_2_i_cfg_addr_write[5:0] ;
        bv_cfg_wr_en        <= ff_2_i_cfg_wr_en      ;
        bv_cfg_data         <= ff_2_i_cfg_data[31:0]       ;
    end
    else begin
        bv_cfg_sram_sel     <= 'b0;
        bv_cfg_addr_write   <= 'b0;
        bv_cfg_wr_en        <= 'b0;
        bv_cfg_data         <= 'b0;
    end
end

// 4
always @(posedge clk) begin
    if ( ff_2_i_cfg_wr_en == 1'b1 && ff_2_i_cfg_sel_module == 2'b11 ) begin
        bf_cfg_sram_sel     <= ff_2_i_cfg_sram_sel[5:0] ;
        bf_cfg_addr_write   <= ff_2_i_cfg_addr_write ;
        bf_cfg_wr_en        <= ff_2_i_cfg_wr_en      ;
        bf_cfg_data         <= ff_2_i_cfg_data       ;
    end
    else begin
        bf_cfg_sram_sel    <= 'b0;
        bf_cfg_addr_write  <= 'b0;
        bf_cfg_wr_en       <= 'b0;
        bf_cfg_data        <= 'b0;
    end
end


endmodule //config_management