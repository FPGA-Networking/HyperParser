
module final_accumulation 

  # ( 
      parameter ONE_HOT_RESULT_WIDTH            = 64    ,
                BIN_RESULT_WIDTH = $clog2(ONE_HOT_RESULT_WIDTH)
  )

(
    input  wire                     clk,
    input  wire [ONE_HOT_RESULT_WIDTH-1:0]  result_i_01,
    input  wire [ONE_HOT_RESULT_WIDTH-1:0]  result_i_02,
    input  wire [ONE_HOT_RESULT_WIDTH-1:0]  result_i_03,
    input  wire [ONE_HOT_RESULT_WIDTH-1:0]  result_i_04,
    input  wire [1:0]               mode_i ,

    output wire  [2+BIN_RESULT_WIDTH-1:0]  result_o_01,
    output wire  [2+BIN_RESULT_WIDTH-1:0]  result_o_02,
    output wire  [2+BIN_RESULT_WIDTH-1:0]  result_o_03,
    output wire  [2+BIN_RESULT_WIDTH-1:0]  result_o_04


);


// localparam BIN_RESULT_WIDTH = $clog2(ONE_HOT_RESULT_WIDTH) ;

reg  [ONE_HOT_RESULT_WIDTH-1:0]  bv_result_o_01;
reg  [ONE_HOT_RESULT_WIDTH-1:0]  bv_result_o_02;
reg  [ONE_HOT_RESULT_WIDTH-1:0]  bv_result_o_03;
reg  [ONE_HOT_RESULT_WIDTH-1:0]  bv_result_o_04;

reg  [BIN_RESULT_WIDTH-1:0]  bin_result_o_01;
reg  [BIN_RESULT_WIDTH-1:0]  bin_result_o_02;
reg  [BIN_RESULT_WIDTH-1:0]  bin_result_o_03;
reg  [BIN_RESULT_WIDTH-1:0]  bin_result_o_04;





reg [1:0] mode_ff_1;
reg [1:0] mode_ff_2;


always @(posedge clk) begin
    mode_ff_1 <= mode_i;
    mode_ff_2 <= mode_ff_1;
end

always @(posedge clk) begin
    case (mode_i)
        2'b00 : bv_result_o_01 <= result_i_01&result_i_02&result_i_03&result_i_04;
        2'b01 : bv_result_o_01 <= result_i_01&result_i_02;
        2'b10 : bv_result_o_01 <= result_i_01;
        default: bv_result_o_01 <= result_i_01&result_i_02&result_i_03&result_i_04;
    endcase
end

always @(posedge clk) begin
    case (mode_i)
        2'b00 : bv_result_o_02 <= result_i_01&result_i_02&result_i_03&result_i_04;
        2'b01 : bv_result_o_02 <= result_i_01&result_i_02;
        2'b10 : bv_result_o_02 <= result_i_02;
        default: bv_result_o_02 <= result_i_01&result_i_02&result_i_03&result_i_04;
    endcase
end


always @(posedge clk) begin
    case (mode_i)
        2'b00 : bv_result_o_03 <= result_i_01&result_i_02&result_i_03&result_i_04;
        2'b01 : bv_result_o_03 <= result_i_03&result_i_04;
        2'b10 : bv_result_o_03 <= result_i_03;
        default: bv_result_o_03 <= result_i_01&result_i_02&result_i_03&result_i_04;
    endcase
end

always @(posedge clk) begin
    case (mode_i)
        2'b00 : bv_result_o_04 <= result_i_01&result_i_02&result_i_03&result_i_04;
        2'b01 : bv_result_o_04 <= result_i_03&result_i_04;
        2'b10 : bv_result_o_04 <= result_i_04;
        default: bv_result_o_04 <= result_i_01&result_i_02&result_i_03&result_i_04;
    endcase
end

// integer i;
// always @(posedge clk) begin
//     for (i = 0; i<ONE_HOT_RESULT_WIDTH;i=i+1 ) begin
//         if(bv_result_o_01[i]=1'b1) begin
//             bin_result_o_01 <= i[BIN_RESULT_WIDTH-1:0];
//         end
//         else begin
//             bin_result_o_01 <= 'b0 ;
//         end
//         if(bv_result_o_02[i]=1'b1) begin
//             bin_result_o_02 <= i[BIN_RESULT_WIDTH-1:0];
//         end
//         else begin
//             bin_result_o_02 <= 'b0 ;
//         end
//         if(bv_result_o_03[i]=1'b1) begin
//             bin_result_o_03 <= i[BIN_RESULT_WIDTH-1:0];
//         end
//         else begin
//             bin_result_o_03 <= 'b0 ;
//         end
//         if(bv_result_o_04[i]=1'b1) begin
//             bin_result_o_04 <= i[BIN_RESULT_WIDTH-1:0];
//         end
//         else begin
//             bin_result_o_04 <= 'b0 ;
//         end
//     end
// end

// always @(posedge clk) begin
//     case (bv_result_o_01)
//         {1'b1,{1'b0}*(ONE_HOT_RESULT_WIDTH-1)}:bin_result_o_01 <= {1'b1}*(BIN_RESULT_WIDTH);
//         {{1'b0}*(ONE_HOT_RESULT_WIDTH-1),1'b1}:bin_result_o_01 <= 'b0;
//         for (i = 1;i<ONE_HOT_RESULT_WIDTH-1;i=i+1) begin
//             {{1'b0}*(ONE_HOT_RESULT_WIDTH-1-i) ,1'b1,{1'b0}*i  }:bin_result_o_01 <= i;
//         end
//         default: bin_result_o_01 <= 'b0 ;
//     endcase
// end

//         for (i = 1;i<ONE_HOT_RESULT_WIDTH-1;i=i+1) begin
//             {{1'b0}*(ONE_HOT_RESULT_WIDTH-1-i) ,1'b1,{1'b0}*i  }:bin_result_o_01 <= i;
//         end

// N bits????????????log2(N)????????????????????????????????????????????????????????????bit?????????1????????????N bit????????????N/2???????????????????????????1??????????????????bit?????????1????????????N/4??????N/2-1???????????????3N/4?????????N-1???????????????????????????????????????1?????????????????????????????????3bit???????????????bit???1?????????????????????????????????3???b1XX???????????????????????????


// genvar j;//??????????????????
// genvar k;//???????????????

wire [BIN_RESULT_WIDTH-1:0]  or_result_01 [0:ONE_HOT_RESULT_WIDTH/2-1] ;
wire [BIN_RESULT_WIDTH-1:0]  or_result_02 [0:ONE_HOT_RESULT_WIDTH/2-1] ;
wire [BIN_RESULT_WIDTH-1:0]  or_result_03 [0:ONE_HOT_RESULT_WIDTH/2-1] ;
wire [BIN_RESULT_WIDTH-1:0]  or_result_04 [0:ONE_HOT_RESULT_WIDTH/2-1] ;

genvar m;


generate
    for (m = 0; m<BIN_RESULT_WIDTH;m=m+1 ) begin
        assign or_result_01[0][m] = bv_result_o_01[(2**m)]  ;
        assign or_result_02[0][m] = bv_result_o_02[(2**m)]  ;
        assign or_result_03[0][m] = bv_result_o_03[(2**m)]  ;
        assign or_result_04[0][m] = bv_result_o_04[(2**m)]  ;
    end
endgenerate

genvar i;// ?????????bit?????????
genvar j;// ?????????bit???????????????bit
generate
    for (i = 0; i<BIN_RESULT_WIDTH; i=i+1) begin
        for (j = 1; j<ONE_HOT_RESULT_WIDTH/2; j=j+1) begin
            assign or_result_01[j][i] = or_result_01[j-1][i] | bv_result_o_01[(j>>i)*(2**(i+1))+2**(i)+j-(j>>i)*(2**i)];
            assign or_result_02[j][i] = or_result_02[j-1][i] | bv_result_o_02[(j>>i)*(2**(i+1))+2**(i)+j-(j>>i)*(2**i)];
            assign or_result_03[j][i] = or_result_03[j-1][i] | bv_result_o_03[(j>>i)*(2**(i+1))+2**(i)+j-(j>>i)*(2**i)];
            assign or_result_04[j][i] = or_result_04[j-1][i] | bv_result_o_04[(j>>i)*(2**(i+1))+2**(i)+j-(j>>i)*(2**i)];
        end
    end
endgenerate

always @(posedge clk) begin
    bin_result_o_01 <= or_result_01[ONE_HOT_RESULT_WIDTH/2-1] ;
    bin_result_o_02 <= or_result_02[ONE_HOT_RESULT_WIDTH/2-1] ;
    bin_result_o_03 <= or_result_03[ONE_HOT_RESULT_WIDTH/2-1] ;
    bin_result_o_04 <= or_result_04[ONE_HOT_RESULT_WIDTH/2-1] ;
end





assign result_o_01 = {mode_ff_2,bin_result_o_01} ;
assign result_o_02 = {mode_ff_2,bin_result_o_01} ;
assign result_o_03 = {mode_ff_2,bin_result_o_03} ;
assign result_o_04 = {mode_ff_2,bin_result_o_04} ;









endmodule //final_accumulation