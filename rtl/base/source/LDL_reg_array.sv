// https://github.com/balanx/LogicDesignLib

module  LDL_reg_array
#(parameter
    WIDTH = 8
   ,DELAY = 1
)(
     input                          clk
   , input                          rst_n  // 0 is reset
   , input                          hold   // 1 is hold, 0 is pass
   , input       [WIDTH -1:0]       x
   ,output       [WIDTH -1:0]       y
);

reg  [WIDTH*DELAY -1:0]  array;
assign  y = array[WIDTH*DELAY -1  -: WIDTH];

always_ff @(posedge clk) begin
    if (!rst_n)
        array = '0;
    else if (!hold) begin
        array =  array << WIDTH;
        array[WIDTH -1:0] = x;
	end
end

endmodule // Logic Design Library

