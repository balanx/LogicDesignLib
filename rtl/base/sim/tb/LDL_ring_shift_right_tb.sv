// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Ring_shift_right testbench
//
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------
`timescale  1ns/1ns

module  LDL_ring_shift_right_tb;


parameter
    WIDTH = 8;

reg        [$clog2(WIDTH)-1:0] sel = 0;
reg        [WIDTH -1:0] x = 0;
wire       [WIDTH -1:0] y;

LDL_ring_shift_right #(
        .WIDTH                  ( WIDTH                  ) 
    )
    dut (
        .sel                    ( sel                    ), // input[$clog2(WIDTH)-1:0]
        .x                      ( x                      ), // input[WIDTH-1:0]
        .y                      ( y                      )  //output[WIDTH-1:0]
    );


initial begin
    $monitor("s=%h, x=%h, y=%b", sel, x, y);

    #5  x = 8'hA5;
    repeat(8) begin
        #5 sel = sel + 1;
    end

    #20 $finish;
end


endmodule // Logic Design Lib.

