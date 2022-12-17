// https://github.com/balanx/LogicDesignLib

module  LDL_hot2bin_pri_v1
#(parameter
    BIN_WIDTH = 4
   ,HOT_WIDTH = 1 << BIN_WIDTH
)(
     input       [HOT_WIDTH -1:0]  x
   ,output reg   [BIN_WIDTH -1:0]  y
   ,output                         valid
);

always @* begin
    y = '0;
    for (integer j=HOT_WIDTH -1; j>=0; j=j-1)
        if (x[j]) begin
            y = j[BIN_WIDTH -1:0];
            //break;
        end
end

// x != 0
assign  valid =  |x;

endmodule // Logic Design Library

