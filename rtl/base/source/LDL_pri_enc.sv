// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Priority encoder
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/19   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_pri_enc
#(parameter
    WIDTH = 4
)(
     input       [WIDTH -1:0]          x
   ,output reg   [$clog2(WIDTH) -1:0]  y
   ,output                             valid
);

always @* begin
    y = '0;
    for (integer j=WIDTH -1; j>=0; j=j-1)
        if (x[j]) begin
            y = j[$clog2(WIDTH) -1:0];
            //break;
        end
end

// x != 0
assign  valid =  |x;

endmodule // Logic Design Library

