// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Bin to one-hot testbench
//
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------
`timescale  1ns/1ns

module  LDL_bin2hot_tb;


parameter
    WIDTH = 4;

reg                     en = 0;
reg        [WIDTH -1:0] x  = 0;
wire       [(1<<WIDTH) -1:0] y;

LDL_bin2hot #(
        .WIDTH                  ( WIDTH                  ) 
    )
    dut (
        .en                     ( en                     ), // input
        .x                      ( x                      ), // input[WIDTH-1:0]
        .y                      ( y                      )  //output[(1<<WIDTH)-1:0]
    );


initial begin
    $monitor("en=%h, x=%h, y=%h", en, x, y);

    #5  en = 1;
    repeat(16) begin
        #5 x = x + 1;
    end
    #5  en = 0;

    #20 $finish;
end


endmodule // Logic Design Lib.

