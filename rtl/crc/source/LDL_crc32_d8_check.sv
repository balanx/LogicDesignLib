// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/23
//
// Description   : 
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/23   热干面    1.0          Original
// -FHDR------------------------------------------------------------------------

module LDL_crc32_d8_check (
  input  [ 7:0] data ,
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

wire [7:0]  d_inv = {data[0], data[1], data[2], data[3],
                     data[4], data[5], data[6], data[7]};

LDL_crc32_d8  crc32_d8 (
        .data                   ( d_inv                  ), // input[7:0]
        .crc_in                 ( crc_in                 ), // input[31:0]
        .crc_out                ( crc_out                )  //output[31:0]
    );

endmodule // Logic Design Lib.

