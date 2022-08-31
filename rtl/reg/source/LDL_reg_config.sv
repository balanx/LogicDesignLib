// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/28
//
// Description   : Config Register
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/28   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_reg_config
#(parameter
    WIDTH  = 8
)(
     input                     clk
   , input                     rst_n  // 0 is reset
   , input                     en     // 1 is enable
   , input       [WIDTH -1:0]  x
   ,output reg   [WIDTH -1:0]  y
);

always @(posedge clk)
    if (!rst_n)
        y  <=  '0;
    else if (en)
        y  <=   x;


endmodule // Logic Design Lib.

