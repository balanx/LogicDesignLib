// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/13
//
// Description   : 2-Port RAM fully
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_ram_p4
#(parameter
    DWIDTH = 8
   ,AWIDTH = 4
)(
     input                     clka
   , input                     rea
   , input                     wea
   , input       [AWIDTH -1:0] addra
   , input       [DWIDTH -1:0] dina
   ,output reg   [DWIDTH -1:0] douta

   , input                     clkb
   , input                     reb
   , input                     web
   , input       [AWIDTH -1:0] addrb
   , input       [DWIDTH -1:0] dinb
   ,output reg   [DWIDTH -1:0] doutb
);

localparam  DEPTH = 1<<AWIDTH;

//(* ramstyle = "auto" *)
reg  [DWIDTH -1:0]  mem [DEPTH -1:0];

always @(posedge clka) begin
    if (rea)
        douta <= mem[addra];

    if (wea)
        mem[addra] <= dina;
end

always @(posedge clkb) begin
    if (reb)
        doutb <= mem[addrb];

    if (web)
        mem[addrb] <= dinb;
end

// synthesis translate_off
integer  i;

initial begin
    $display("@%m : RAM_P4 : %d : %d", DWIDTH, AWIDTH);
    for (i=0; i<DEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // Logic Design Lib.

