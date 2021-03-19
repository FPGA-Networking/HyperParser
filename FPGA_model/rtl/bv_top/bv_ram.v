
module bv_ram 
  # ( 
      parameter ADDR_WIDTH = 4 ,  
                DATA_WIDTH = 32,
                INIT_FILE  = ""

  )

(
    input   clk ,
    input   rst ,
    input   [ADDR_WIDTH-1:0] addr ,
    // input   wr_en ,
    // input   [DATA_WIDTH-1:0] din  ,
    output  [DATA_WIDTH-1:0] dout 

);





(* DONT_TOUCH= "TRUE" *)lut_6_1_rom_d64 
#(
  .INIT_VALUE (INIT_FILE ),
  .BUS_WIDTH  (DATA_WIDTH  )
  // .ROM_DEPTH  (ROM_DEPTH  )
)
u_lut_6_1_rom_d64(
  .clk  (clk  ),
  .rst  (rst  ),
  .addr (addr ),
  .dout (dout )
);





    
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
//   .wea            (wr_en),
//   .addra          (addr),
//   .dina           (din),
//   .injectsbiterra (1'b0),
//   .injectdbiterra (1'b0),
//   .douta          (dout),
//   .sbiterra       (),
//   .dbiterra       ()

// );