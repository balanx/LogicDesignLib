// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/13
//
// Description   : 1-Port RAM
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_ram_p1
#(parameter
    DWIDTH = 8
   ,AWIDTH = 4
)(
     input                     clk
   , input                     re
   , input                     we
   , input       [AWIDTH -1:0] addr
   , input       [DWIDTH -1:0] din
   ,output reg   [DWIDTH -1:0] dout
);

localparam  DEPTH = 1<<AWIDTH;

//(* ramstyle = "auto" *)
reg  [DWIDTH -1:0]  mem [DEPTH -1:0];

always @(posedge clk) begin
    if (re)
        dout <= mem[addr];

    if (we)
        mem[addr] <= din;
end

// synthesis translate_off
integer  i;

initial begin
    $display("@%m : RAM_P1 : %d : %d", DWIDTH, AWIDTH);
    for (i=0; i<DEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // Logic Design Lib.

