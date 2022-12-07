// https://github.com/balanx/LogicDesignLib

module LDL_crc32_dn
#(parameter
  NUM = 4
)(
  input  [NUM -1:0][7:0] data ,
  input  [$clog2(NUM) -1:0]  bnum, //byte_num, 0 is all
  input  [31:0]          crc_in,
  output [31:0]          crc_out
);

wire [NUM-1:0][ 7:0]  d_inv;
wire [NUM  :0][31:0]  connect;

generate
    genvar i;

    for (i=0; i<NUM; i++) begin // MSB first
        assign  d_inv[i] = {data[i][0], data[i][1], data[i][2], data[i][3],
                            data[i][4], data[i][5], data[i][6], data[i][7]};

        LDL_crc32_d8  crc32_d8 (
            .data                   ( d_inv[i]               ), // input[7:0]
            .crc_in                 ( connect[i+1]           ), // input[31:0]
            .crc_out                ( connect[i]             )  //output[31:0]
        );
    end
endgenerate

assign  connect[NUM] = crc_in;
//bnum=0 : d3 d2 d1 d0
//bnum=1 : d3 xx xx xx
//bnum=2 : d3 d2 xx xx
//bnum=3 : d3 d2 d1 xx
wire [$clog2(NUM) -1:0]  sel = (bnum == 0) ? 0 : (NUM - bnum);
assign  crc_out = connect[sel];


endmodule // Logic Design Lib.

