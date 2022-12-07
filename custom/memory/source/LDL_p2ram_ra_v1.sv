// https://github.com/balanx/LogicDesignLib

module  LDL_p2ram_ra_v1
#(parameter
    DWIDTH = 8
   ,DEEPTH = 10
   ,AWIDTH = $clog2(DEEPTH)
)(
     input                   wclk
   , input                   we
   , input     [AWIDTH -1:0] wa
   , input     [DWIDTH -1:0] din

   , input                   rclk
   , input                   re
   , input     [AWIDTH -1:0] ra
   ,output reg [DWIDTH -1:0] dout
);


//(* ramstyle = "auto" *)
reg  [DWIDTH -1:0]  mem [DEEPTH -1:0];

always @(posedge wclk) begin
    if (we)
        mem[wa] <= din;
end

always @(posedge rclk) begin
    if (re)
        dout <= mem[ra];
end

// synthesis translate_off
initial begin
    $display("Ram@%m : LDL_p2ram_ra_v1 : %d : %d", DWIDTH, DEEPTH);

    for (integer i=0; i<DEEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // LDL.

