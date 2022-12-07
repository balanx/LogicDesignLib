// https://github.com/balanx/LogicDesignLib

module  LDL_p1ram_v1
#(parameter
    DWIDTH = 8
   ,DEEPTH = 10
   ,AWIDTH = $clog2(DEEPTH)
)(
     input                   clk
   , input                   re
   , input                   we
   , input     [AWIDTH -1:0] addr
   , input     [DWIDTH -1:0] din
   ,output reg [DWIDTH -1:0] dout
);


//(* ramstyle = "auto" *)
reg  [DWIDTH -1:0]  mem [DEEPTH -1:0];

always @(posedge clk) begin
    if (re)
        dout <= mem[addr];

    if (we)
        mem[addr] <= din;
end

// synthesis translate_off
initial begin
    $display("Ram@%m : LDL_p1ram_v1 : %d : %d", DWIDTH, DEEPTH);

    for (integer i=0; i<DEEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // LDL.

