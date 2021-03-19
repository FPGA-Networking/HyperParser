module ibf_2_2_stage 

# ( 
    parameter   DATA_WIDTH      = 32,
                MODE_WIDTH      = 0,
                STAGE_ORDER     = 0,  // 说明是第几级stage
                IS_PIPED        = 1,
                LUT_INIT        = 'b0

 )

(
    input  wire                                    clk,
    // input  wire                                    rst,
    // input  wire [DATA_WIDTH/2-1:0]                 config_data,
    // input  wire [1:0]                              mode_i,
    input  wire [DATA_WIDTH+MODE_WIDTH-1:0]                   din_mod,
    output wire [DATA_WIDTH+MODE_WIDTH-1:0]                   dout
);

localparam SHIFT                     = 2**STAGE_ORDER ; //ibf网络的偏移量，
localparam REGION_NUM                = (DATA_WIDTH/2)/SHIFT; // 完全一样的子蝶形网络的个数 
localparam ELEMENT_NUM_PER_REGION    = DATA_WIDTH/REGION_NUM;

wire [DATA_WIDTH-1:0] data_temp_wire ;
wire [DATA_WIDTH+MODE_WIDTH-1:0] data_mode_wire ;
reg  [DATA_WIDTH+MODE_WIDTH-1:0] data_mode_reg  ;
wire [MODE_WIDTH-1:0] mode_i ;
wire [DATA_WIDTH-1:0] din ;

assign din = din_mod[DATA_WIDTH+MODE_WIDTH-1:MODE_WIDTH];
assign mode_i = din_mod[MODE_WIDTH-1:0];



assign data_mode_wire = {data_temp_wire,mode_i};


always @(posedge clk) begin
    data_mode_reg <= data_mode_wire ;
end

assign dout = (IS_PIPED==1'b1)?data_mode_reg:data_mode_wire;













genvar i,j;
    for (i = 0;i<REGION_NUM ;i=i+1 ) begin
        for (j = 0; j<ELEMENT_NUM_PER_REGION/2; j=j+1) begin
 			LUT6_2 #(
   			   .INIT(LUT_INIT[64*( (REGION_NUM-1-i)*ELEMENT_NUM_PER_REGION/2 +(ELEMENT_NUM_PER_REGION/2-1-j) )+: 64])  
   			) LUT6_2_inst (
   			   .O6(data_temp_wire[ELEMENT_NUM_PER_REGION*i+j+SHIFT]), 
   			   .O5(data_temp_wire[ELEMENT_NUM_PER_REGION*i+j]), 
   			   .I0(din[ELEMENT_NUM_PER_REGION*i+j]),  
   			   .I1(din[ELEMENT_NUM_PER_REGION*i+j+SHIFT]),  
   			   .I2(mode_i[0]),  
   			   .I3(mode_i[1]),  
   			   .I4(1'b0),  
   			   .I5(1'b1) 
   			);
        end
    end








   			//    .INIT(LUT_INIT[64*( (REGION_NUM-1-i)*ELEMENT_NUM_PER_REGION/2 +(ELEMENT_NUM_PER_REGION/2-1-j) ) +: 64]) 
// .INIT(LUT_INIT[64*( i*ELEMENT_NUM_PER_REGION/2 +j ) +: 64]) 




endmodule //ibf_2_2_stage





























// integer i,j;  
// always @(posedge clk) begin
//     for (i = 0;i<REGION_NUM ;i=i+1 ) begin
//         for (j = 0; j<ELEMENT_NUM_PER_REGION/2; j=j+1) begin
//             if( config_data[i*(ELEMENT_NUM_PER_REGION/2)+j] == 1'b0 ) begin
//                 data_temp_reg[ELEMENT_NUM_PER_REGION*i+j]        <= din[ELEMENT_NUM_PER_REGION*i+j]       ;
//                 data_temp_reg[ELEMENT_NUM_PER_REGION*i+j+SHIFT]  <= din[ELEMENT_NUM_PER_REGION*i+j+SHIFT] ;
//             end
//             else begin
//                 data_temp_reg[ELEMENT_NUM_PER_REGION*i+j]        <= din[ELEMENT_NUM_PER_REGION*i+j+SHIFT] ;
//                 data_temp_reg[ELEMENT_NUM_PER_REGION*i+j+SHIFT]  <= din[ELEMENT_NUM_PER_REGION*i+j]       ;
//             end
//         end
//     end
// end

// genvar m,n;
// generate
//     for (m = 0;m<REGION_NUM ;m=m+1 ) begin
//         for (n = 0; n<ELEMENT_NUM_PER_REGION/2; n=n+1) begin
//             assign data_temp_wire[ELEMENT_NUM_PER_REGION*m+n]       = (config_data[m*(ELEMENT_NUM_PER_REGION/2)+n] == 1'b0)?din[ELEMENT_NUM_PER_REGION*m+n]      :din[ELEMENT_NUM_PER_REGION*m+n+SHIFT] ;
//             assign data_temp_wire[ELEMENT_NUM_PER_REGION*m+n+SHIFT] = (config_data[m*(ELEMENT_NUM_PER_REGION/2)+n] == 1'b0)?din[ELEMENT_NUM_PER_REGION*m+n+SHIFT]:din[ELEMENT_NUM_PER_REGION*m+n]       ;
//         end    
//     end
// endgenerate

// genvar i,j;
// generate
//     for (i = 0;i<REGION_NUM ;i=i+1 ) begin
//         for (j = 0; j<ELEMENT_NUM_PER_REGION/2; j=j+1) begin
//             assign data_temp_wire[ELEMENT_NUM_PER_REGION*i+j]       = (config_data[i] == 1'b0)?din[ELEMENT_NUM_PER_REGION*i+j]      :din[ELEMENT_NUM_PER_REGION*i+j+SHIFT] ;
//             assign data_temp_wire[ELEMENT_NUM_PER_REGION*i+j+SHIFT] = (config_data[i] == 1'b0)?din[ELEMENT_NUM_PER_REGION*i+j+SHIFT]:din[ELEMENT_NUM_PER_REGION*i+j]       ;
//         end    
//     end
// endgenerate

// assign dout = (IS_PIPED == 1'b1)?data_temp_reg:data_temp_wire;


