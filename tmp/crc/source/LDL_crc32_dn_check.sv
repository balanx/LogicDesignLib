// https://github.com/balanx/LogicDesignLib

module LDL_crc32_dn_check
#(parameter
  NUM = 4
)(
  input  [8*NUM -1:0]        data, //MSB first
  input  [$clog2(NUM) -1:0]  bnum, //byte_num, 0 is all
  input         valid,
  input         eof  ,
  output reg    err  ,
  input         rst_n,
  input         clk
);

reg  [31:0]  crc_in ;
wire [31:0]  crc_out;

always @(posedge clk) begin
    if (!rst_n) begin
        crc_in  <=  '1;
        err  <=  0;
    end
    else if (valid) begin
        crc_in  <= eof ? '1 : crc_out;
        err  <= eof ? (crc_out != 32'hc704dd7b) : 0;
    end
    else
        err  <=  0;
end


LDL_crc32_dn #(
        .NUM                    ( NUM                    )
    ) crc32_dn (
        .data                   ( data                   ), // input
        .bnum                   ( eof ? bnum : 0         ), // input[$clog2(NUM)-1:0]
        .crc_in                 ( crc_in                 ), // input[31:0]
        .crc_out                ( crc_out                )  //output[31:0]
    );

endmodule // Logic Design Lib.

