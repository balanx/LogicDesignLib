// https://github.com/balanx/LogicDesignLib

`include  "LDL_macros.vh"

module  LDL_count_v1
#(parameter
    WIDTH = 1
   ,MODE  = 0  // 0 is inc, other is dec.
)(
     input                      clk
   , input                      rst
   , input                      en
   , input     [WIDTH -1 : 0]   max  // min. = 0
   ,output reg [WIDTH -1 : 0]   dout
);


`LDL_ALWAYS
begin
    if (rst)
        dout <= MODE ?  max  :  '0;
    else if (en) begin
        if (MODE ? (dout == '0) : (dout >= max) )
            dout <= MODE ?  max  :  '0;
        else
            dout <= MODE ? (dout - 1'b1) : (dout + 1'b1);
    end
end

endmodule // LDL.

