// https://github.com/balanx/LogicDesignLib

`include  "LDL_rtl_define.vh"

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

reg  [LEVEL -1 : 0][WIDTH -1 : 0] buff;
wire [LEVEL    : 0][WIDTH -1 : 0] tt = {buff, din};

`LDL_ALWAYS_STATEMENT(clk, rst)
begin
    if (rst)
        buff <=  {LEVEL*WIDTH{1'b0}};
    else if (en) begin  // shift left
        buff <=  tt[LEVEL -1 : 0];
    end
end

assign  dout = tt[LEVEL];

endmodule // LDL.

