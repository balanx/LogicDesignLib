// https://github.com/balanx/LogicDesignLib

module  LDL_p2ram_rs_v1
#(parameter
    DWIDTH = 8
   ,DEEPTH = 10
   ,AWIDTH = $clog2(DEEPTH)
)(
     input                   clk
   , input                   we
   , input     [AWIDTH -1:0] wa
   , input     [DWIDTH -1:0] din

   , input                   re
   , input     [AWIDTH -1:0] ra
   ,output reg [DWIDTH -1:0] dout
   ,output reg               rv
);


//(* ramstyle = "auto" *)
reg  [DWIDTH -1:0]  mem [DEEPTH -1:0];

always @(posedge clk) begin
    if (we)
        mem[wa] <= din;

    if (re) begin
        dout <= mem[ra];

        if ((wa == ra) && we) begin
            rv  <=  1'b0;
            // synthesis translate_off
            $display("Warning : @%m : read & write on the same address 0x%h", ra);
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
    $display("Ram@%m : LDL_p2ram_rs_v1 : %d : %d", DWIDTH, DEEPTH);

    for (integer i=0; i<DEEPTH; i++)
        mem[i] = ($random > 0) ? '1 : '0;
end
// synthesis translate_on

endmodule // LDL.

