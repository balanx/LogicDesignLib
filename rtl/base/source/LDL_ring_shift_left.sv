// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Ring left shifter
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/19   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_ring_shift_left
#(parameter
    WIDTH = 8
)(
     input       [$clog2(WIDTH) -1:0]   sel
   , input       [WIDTH -1:0]           x
   ,output reg   [WIDTH -1:0]           y
);

always @*  begin 
    y = x;
    for (integer j=0; j<WIDTH; j=j+1)
        if (j < sel)
            y = {y[WIDTH-2:0], y[WIDTH-1]};
end

endmodule // Logic Design Library

