// https://github.com/balanx/LogicDesignLib

`timescale  1ns/1ns

module  LDL_p2ram_rs_v1
#(parameter
    DW = 8
   ,DEPTH = 10
   ,AW = $clog2(DEPTH)
)(
     input                   clk
   , input                   we
   , input     [AW -1:0]     wa
   , input     [DW -1:0]     din

   , input                   re
   , input     [AW -1:0]     ra
   ,output reg [DW -1:0]     dout
   ,output reg               rv
);


//(* ramstyle = "auto" *)
reg  [DW -1:0]  mem [DEPTH -1:0];

always @(posedge clk) begin
    if (we)
        mem[wa] <= din;

    if (re) begin
        dout <= mem[ra];

        if ((wa == ra) && we) begin
            rv  <=  1'b0;
            // synthesis translate_off
            $display("Error : @%m : read & write on the same address (0x%h) at %9t ns", ra, $time);
            // synthesis translate_on
        end
        else
            rv  <=  1'b1;
    end
    else
        rv  <=  1'b0;
end

// synthesis translate_off
initial begin
    $display("Ram@%m : LDL_p2ram_rs_v1 : %d : %d", DW, DEPTH);

    for (integer i=0; i<DEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // LDL.

