module ibf_bf_2_2_stage 

# ( 
    parameter   DATA_WIDTH      = 32,
                STAGE_ORDER     = 0,  // 说明是第几级stage
                IS_PIPED        = 1

 )

(
    input  wire                                    clk,
    // input  wire                                    rst,
    input  wire [DATA_WIDTH/2-1:0]                 config_data,
    input  wire [DATA_WIDTH-1:0]                   din,
    output wire [DATA_WIDTH-1:0]                   dout
);

localparam SHIFT                     = 2**STAGE_ORDER ; //ibf网络的偏移量，
localparam REGION_NUM                = (DATA_WIDTH/2)/SHIFT; // 完全一样的子蝶形网络的个数 
localparam ELEMENT_NUM_PER_REGION    = DATA_WIDTH/REGION_NUM;

wire [DATA_WIDTH-1:0] data_temp_wire ;
reg  [DATA_WIDTH-1:0] data_temp_reg  ;


integer i,j;  
always @(posedge clk) begin
    for (i = 0;i<REGION_NUM ;i=i+1 ) begin
        for (j = 0; j<ELEMENT_NUM_PER_REGION/2; j=j+1) begin
            if( config_data[i*(ELEMENT_NUM_PER_REGION/2)+j] == 1'b0 ) begin
                data_temp_reg[ELEMENT_NUM_PER_REGION*i+j]        <= din[ELEMENT_NUM_PER_REGION*i+j]       ;
                data_temp_reg[ELEMENT_NUM_PER_REGION*i+j+SHIFT]  <= din[ELEMENT_NUM_PER_REGION*i+j+SHIFT] ;
            end
            else begin
                data_temp_reg[ELEMENT_NUM_PER_REGION*i+j]        <= din[ELEMENT_NUM_PER_REGION*i+j+SHIFT] ;
                data_temp_reg[ELEMENT_NUM_PER_REGION*i+j+SHIFT]  <= din[ELEMENT_NUM_PER_REGION*i+j]       ;
            end
        end
    end
end

genvar m,n;
generate
    for (m = 0;m<REGION_NUM ;m=m+1 ) begin
        for (n = 0; n<ELEMENT_NUM_PER_REGION/2; n=n+1) begin
            assign data_temp_wire[ELEMENT_NUM_PER_REGION*m+n]       = (config_data[m*(ELEMENT_NUM_PER_REGION/2)+n] == 1'b0)?din[ELEMENT_NUM_PER_REGION*m+n]      :din[ELEMENT_NUM_PER_REGION*m+n+SHIFT] ;
            assign data_temp_wire[ELEMENT_NUM_PER_REGION*m+n+SHIFT] = (config_data[m*(ELEMENT_NUM_PER_REGION/2)+n] == 1'b0)?din[ELEMENT_NUM_PER_REGION*m+n+SHIFT]:din[ELEMENT_NUM_PER_REGION*m+n]       ;
        end    
    end
endgenerate

// genvar i,j;
// generate
//     for (i = 0;i<REGION_NUM ;i=i+1 ) begin
//         for (j = 0; j<ELEMENT_NUM_PER_REGION/2; j=j+1) begin
//             assign data_temp_wire[ELEMENT_NUM_PER_REGION*i+j]       = (config_data[i] == 1'b0)?din[ELEMENT_NUM_PER_REGION*i+j]      :din[ELEMENT_NUM_PER_REGION*i+j+SHIFT] ;
//             assign data_temp_wire[ELEMENT_NUM_PER_REGION*i+j+SHIFT] = (config_data[i] == 1'b0)?din[ELEMENT_NUM_PER_REGION*i+j+SHIFT]:din[ELEMENT_NUM_PER_REGION*i+j]       ;
//         end    
//     end
// endgenerate

assign dout = (IS_PIPED == 1'b1)?data_temp_reg:data_temp_wire;









endmodule //ibf_2_2_stage