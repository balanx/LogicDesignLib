// https://github.com/balanx/LogicDesignLib

module  LDL_p1ram_v1
#(parameter
    DW = 8
   ,DEPTH = 10
   ,AW = $clog2(DEPTH)
)(
     input                   clk
   , input                   re
   , input                   we
   , input     [AW -1:0]     addr
   , input     [DW -1:0]     din
   ,output reg [DW -1:0]     dout
);


//(* ramstyle = "auto" *)
reg  [DW -1:0]  mem [DEPTH -1:0];

always @(posedge clk) begin
    if (re)
        dout <= mem[addr];

    if (we)
        mem[addr] <= din;
end

// synthesis translate_off
initial begin
    $display("Ram@%m : LDL_p1ram_v1 : %d : %d", DW, DEPTH);

    for (integer i=0; i<DEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // LDL.

