// https://github.com/balanx/LogicDesignLib

`include  "LDL_rtl_macros.vh"

module  LDL_dff_array_v1
#(parameter
    WIDTH = 1
   ,LEVEL = 1
)(
     input                      clk
   , input                      rst
   , input                      en
   , input     [WIDTH -1 : 0]   din
   ,output     [WIDTH -1 : 0]   dout
);

reg  [LEVEL * WIDTH -1 : 0] buff;
wire [LEVEL * WIDTH + WIDTH -1 : 0] tt = {buff, din};

`LDL_ALWAYS_STATEMENT(clk, rst)
begin
    if (rst)
        buff <=  '0;
    else if (en) begin  // shift left
        buff <=  tt[LEVEL * WIDTH -1 : 0];
    end
end

assign  dout = tt[LEVEL * WIDTH + WIDTH -1 : LEVEL * WIDTH];

endmodule // LDL.

