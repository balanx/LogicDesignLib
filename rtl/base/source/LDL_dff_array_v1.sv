// https://github.com/balanx/LogicDesignLib

`include  "LDL_macros.vh"

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

`LDL_ALWAYS_STATEMENT(clk, rst)
begin
    if (rst)
        buff <=  '0;
    else if (en) begin // shift left
        buff <=  buff << WIDTH;
        buff[WIDTH -1 : 0] <=  din;
    end
end

assign  dout = buff[LEVEL * WIDTH -1 : LEVEL * WIDTH - WIDTH];

endmodule // LDL.

