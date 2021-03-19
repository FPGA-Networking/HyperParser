
module cfg_ram_ibf 
  # ( 
      parameter ADDR_WIDTH = 4 ,  
                DATA_DEPTH = 0 ,
                DATA_WIDTH = 32,
                RAM_INDEX  = 0 ,
                INIT_FILE  = ""

  )

(
    input                       clk ,
    // input                       rst ,

    input   [ADDR_WIDTH-1:0]    addr_rd ,
    output  [DATA_WIDTH-1:0]    dout    ,

    input   [1:0]               addr_wr ,
    input   [7:0]               sram_sel,
    input                       wr_en ,
    input   [63:0]              din  

);


// wire    wr_en_sel ;
// assign  wr_en_sel = (sram_sel==RAM_INDEX)&wr_en;

reg   [1:0]               ff_addr_wr  ;
reg   [7:0]               ff_sram_sel ;
reg                       ff_wr_en    ;
reg   [63:0]              ff_din      ;


always @(posedge clk) begin
    ff_addr_wr  <= addr_wr  ;
    ff_sram_sel <= sram_sel ;
    ff_wr_en    <= wr_en    ;
    ff_din      <= din      ;
end



localparam RAM_NUM = DATA_WIDTH/64;



genvar j;
generate
    for (j=0; j<RAM_NUM; j=j+1) begin : CFG_SRAM_UNIT_IBF
        
      cfg_ram_unit 
      #(
        .ADDR_WIDTH (2 ),
        .DATA_DEPTH (4 ),
        .DATA_WIDTH (64 ),
        .RAM_INDEX  (RAM_INDEX*RAM_NUM+j  ),
        .RAM_INDEX_IN_GROUP  (j  ), // 所选sram在一组中的第几个（一共7组）
        .INIT_FILE  (INIT_FILE  )
      )
      u_cfg_ram_unit(
        .clk      (clk      ),
        .addr_rd  (addr_rd  ),
        .dout     (dout[64*j +: 64]     ),
        .addr_wr  (ff_addr_wr  ),
        .sram_sel (ff_sram_sel ),
        .wr_en    (ff_wr_en    ),
        .din      (ff_din      )
      );

    end
endgenerate






// assign  dout = {} ;











    
endmodule




// xpm_memory_spram # (

//   // Common module parameters
//   .MEMORY_SIZE        ((2**ADDR_WIDTH)*DATA_WIDTH),           //positive integer
//   .MEMORY_PRIMITIVE   ("distributed"),         //string; "auto", "distributed", "block" or "ultra";
//   .MEMORY_INIT_FILE   (INIT_FILE),         //string; "none" or "<filename>.mem" 
//   .MEMORY_INIT_PARAM  (""    ),         //string;
//   .USE_MEM_INIT       (1),              //integer; 0,1
//   .WAKEUP_TIME        ("disable_sleep"),//string; "disable_sleep" or "use_sleep_pin" 
//   .MESSAGE_CONTROL    (0),              //integer; 0,1

//   // Port A module parameters
//   .WRITE_DATA_WIDTH_A (DATA_WIDTH),             //positive integer
//   .READ_DATA_WIDTH_A  (DATA_WIDTH),             //positive integer
//   .BYTE_WRITE_WIDTH_A (DATA_WIDTH),             //integer; 8, 9, or WRITE_DATA_WIDTH_A value
//   .ADDR_WIDTH_A       (ADDR_WIDTH),              //positive integer
//   .READ_RESET_VALUE_A ("0"),            //string
//   .ECC_MODE           ("no_ecc"),       //string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
//   .AUTO_SLEEP_TIME    (0),              //Do not Change
//   .READ_LATENCY_A     (1),              //non-negative integer
//   .WRITE_MODE_A       ("read_first")    //string; "write_first", "read_first", "no_change" 

// ) xpm_memory_spram_inst (

//   // Common module ports
//   .sleep          (1'b0),

//   // Port A module ports
//   .clka           (clk),
//   .rsta           (rst),
//   .ena            (1'b1),
//   .regcea         (1'b1),
//   .wea            (wr_en_sel),
//   .addra          (addr),
//   .dina           (din),
//   .injectsbiterra (1'b0),
//   .injectdbiterra (1'b0),
//   .douta          (dout),
//   .sbiterra       (),
//   .dbiterra       ()

// );