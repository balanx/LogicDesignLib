// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Binary to one-Hot
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/19   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_bin2hot
#(parameter
    WIDTH = 8
)(
     input                          en
   , input       [WIDTH -1:0]       x
   ,output reg   [(1<<WIDTH) -1:0]  y
);

always @* begin
    y = '0;
    if (en) y[x] = 1;
end

endmodule // Logic Design Library

