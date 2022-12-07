// https://github.com/balanx/LogicDesignLib

module  LDL_bin2hot
#(parameter
    BIN_WIDTH = 8
)(
     input                              en
   , input       [BIN_WIDTH -1:0]       x
   ,output reg   [(1<<BIN_WIDTH) -1:0]  y
);

always @* begin
    y = '0;
    if (en) y[x] = 1;
end

endmodule // Logic Design Library

