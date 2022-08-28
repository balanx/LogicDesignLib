// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Binary encoder with priority
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/19   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_hot2bin_pri
#(parameter
    BIN_WIDTH = 4
   ,HOT_WIDTH = 1 << BIN_WIDTH
)(
     input       [HOT_WIDTH -1:0]  x
   ,output reg   [BIN_WIDTH -1:0]  y
   ,output                         valid
);

always @* begin
    y = '0;
    for (integer j=HOT_WIDTH -1; j>=0; j=j-1)
        if (x[j]) begin
            y = j[BIN_WIDTH -1:0];
            //break;
        end
end

// x != 0
assign  valid =  |x;

endmodule // Logic Design Library

