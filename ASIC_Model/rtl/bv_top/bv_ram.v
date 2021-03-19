
module bv_ram 
  # ( 
      parameter ADDR_WIDTH = 4 ,  
                DATA_DEPTH = 48,
                DATA_WIDTH = 32,
                RAM_INDEX  = 0,
                INIT_FILE  = ""

  )

(
    input   clk ,
    // input   rst ,

    input             wr_en     ,
    input   [4:0]     sram_sel  ,
    input   [5:0]     addr_wr   ,
    input   [31:0]    din       ,

    input   [ADDR_WIDTH-1:0] addr_rd ,
    output  reg [DATA_WIDTH-1:0] dout 

);








wire    wr_en_sel ;
assign  wr_en_sel = (sram_sel==RAM_INDEX)&wr_en;


reg [DATA_WIDTH-1:0] mem [0:DATA_DEPTH-1] ;

// reg [2047:0]  mem_all [0:2] ;




initial begin
		$readmemh(INIT_FILE,mem);
end


// integer j;
// always @(posedge clk) begin
//   for ( j=0 ; j<DATA_DEPTH ; j=j+1) begin
//     mem[j] <= mem_all[j][(RAM_INDEX_IN_GROUP+1)*DATA_WIDTH-1:RAM_INDEX_IN_GROUP*DATA_WIDTH];
//   end
// end



// integer j;
  // for ( j=0 ; j<DATA_DEPTH ; j=j+1) begin
    
  // end
always @(posedge clk) begin
  if( wr_en_sel == 1'b1 )
    mem[addr_wr] <= din ;
end

always @(posedge clk) begin
  dout<=mem[addr_rd];
end














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

    