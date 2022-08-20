// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Priority encoder testbench
//
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------
`timescale  1ns/1ns

module  LDL_pri_enc_tb;


parameter
    WIDTH = 8;

reg        [WIDTH -1:0] x = 0;
wire       [$clog2(WIDTH) -1:0] y;
wire                    valid;

LDL_pri_enc #(
        .WIDTH                  ( WIDTH                  ) 
    )
    dut (
        .x                      ( x                      ), // input[WIDTH-1:0]
        .y                      ( y                      ), //output[$clog2(WIDTH)-1:0]
        .valid                  ( valid                  )  //output
    );


initial begin
    $monitor("x=%h, y=%h, v=%b", x, y, valid);

    #5 x = '1;
    repeat(9) begin
        #5 x = x << 1;
    end

    #20 $finish;
end


endmodule // Logic Design Lib.

