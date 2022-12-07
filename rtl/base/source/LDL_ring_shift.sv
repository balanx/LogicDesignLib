// https://github.com/balanx/LogicDesignLib

module  LDL_ring_shift
#(parameter
    WIDTH = 8
)(
     input                              dir  //0 right, 1 left
   , input       [$clog2(WIDTH) -1:0]   step
   , input       [WIDTH -1:0]           x
   ,output reg   [WIDTH -1:0]           y
);

wire  [$clog2(WIDTH) -1:0]   s = dir ? (WIDTH - step) : step ;

always @* begin 
    y = x;
    for (integer j=0; j<WIDTH; j=j+1)
        if (j < s)
            y = {y[0], y[WIDTH-1:1]};
end

endmodule // Logic Design Library

