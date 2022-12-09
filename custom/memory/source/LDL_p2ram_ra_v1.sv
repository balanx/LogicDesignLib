// https://github.com/balanx/LogicDesignLib

module  LDL_p2ram_ra_v1
#(parameter
    DW = 8
   ,DEPTH = 10
   ,AW = $clog2(DEPTH)
)(
     input                   wclk
   , input                   we
   , input     [AW -1:0]     wa
   , input     [DW -1:0]     din

   , input                   rclk
   , input                   re
   , input     [AW -1:0]     ra
   ,output reg [DW -1:0]     dout
);


//(* ramstyle = "auto" *)
reg  [DW -1:0]  mem [DEPTH -1:0];

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
    $display("Ram@%m : LDL_p2ram_ra_v1 : %d : %d", DW, DEPTH);

    for (integer i=0; i<DEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // LDL.

