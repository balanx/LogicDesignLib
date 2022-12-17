// https://github.com/balanx/LogicDesignLib

module  LDL_shift_ring_v1
#(parameter [31:0]
    WIDTH = 8
)(
     input                              dir  //0 right, 1 left
   , input       [$clog2(WIDTH) -1:0]   step
   , input       [WIDTH -1:0]           x
   ,output reg   [WIDTH -1:0]           y
);

wire  [$clog2(WIDTH) -1:0]   s = dir ? $clog2(WIDTH)'(WIDTH - 32'(step)) : step ;

always @* begin 
    y = x;
    for (integer j=0; j<WIDTH; j=j+1)
        if (j < s)
            y = {y[0], y[WIDTH-1:1]};
end

endmodule // LDL.

