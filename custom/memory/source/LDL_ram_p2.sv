// https://github.com/balanx/LogicDesignLib

module  LDL_ram_p2
#(parameter
    DWIDTH = 8
   ,AWIDTH = 4
)(
     input                     clka
   , input                     wea
   , input       [AWIDTH -1:0] addra
   , input       [DWIDTH -1:0] dina

   , input                     clkb
   , input                     reb
   , input       [AWIDTH -1:0] addrb
   ,output reg   [DWIDTH -1:0] doutb
);

localparam  DEPTH = 1<<AWIDTH;

//(* ramstyle = "auto" *)
reg  [DWIDTH -1:0]  mem [DEPTH -1:0];

always @(posedge clka) begin
    if (wea)
        mem[addra] <= dina;
end

always @(posedge clkb) begin
    if (reb)
        doutb <= mem[addrb];
end

// synthesis translate_off
integer  i;

initial begin
    $display("@%m : RAM_P2 : %d : %d", DWIDTH, AWIDTH);
    for (i=0; i<DEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // Logic Design Lib.

