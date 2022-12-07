// https://github.com/balanx/LogicDesignLib

`timescale  1ns/1ns

module  LDL_hot2bin_pri_tb;


parameter
    WIDTH = 3;

reg        [(1<<WIDTH) -1:0] x = 0;
wire       [WIDTH -1:0] y;
wire                    valid;

LDL_hot2bin_pri #(
        .BIN_WIDTH      ( WIDTH          ) 
    )
    dut (
        .x              ( x              ), // input[WIDTH-1:0]
        .y              ( y              ), //output[$clog2(WIDTH)-1:0]
        .valid          ( valid          )  //output
    );


initial begin
    $monitor("x=%h, y=%h, v=%b", x, y, valid);

    #5 x = '1;
    repeat(9) begin
        #5 x = x << 1;
    end

    #20 $finish;
end


endmodule // Logic Design Lib.

