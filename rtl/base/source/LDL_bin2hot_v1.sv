// https://github.com/balanx/LogicDesignLib

module  LDL_bin2hot_v1
#(parameter
    BIN_WIDTH =  8
   ,HOT_WIDTH = (1<<BIN_WIDTH)
)(
     input                         en
   , input       [BIN_WIDTH -1:0]  x
   ,output reg   [HOT_WIDTH -1:0]  y
);

always @* begin
    y = {HOT_WIDTH{1'b0}};
    if (en) y[x] = 1'b1;
end

endmodule // Logic Design Library

