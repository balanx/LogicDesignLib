// https://github.com/balanx/LogicDesignLib

`timescale  1ns/1ns

module  LDL_shift_ring_v1_tb;


parameter
    WIDTH = 8;

reg        [$clog2(WIDTH)-1:0] step = 0;
reg        [WIDTH -1:0] x = 0;
wire       [WIDTH -1:0] y;
reg                     dir = 0;

LDL_shift_ring_v1 #(
        .WIDTH          ( WIDTH          ) 
    )
    dut (
        .dir            ( dir            ), // input
        .step           ( step           ), // input[$clog2(WIDTH)-1:0]
        .x              ( x              ), // input[WIDTH-1:0]
        .y              ( y              )  //output[WIDTH-1:0]
    );


initial begin
    $monitor("dir=%b, s=%h, x=%h, y=%b", dir, step, x, y);

    #5  x = 8'hA5;
    repeat(8) begin
        #5 step = step + 1;
    end

    #5  step = 0; dir = 1;
    repeat(8) begin
        #5 step = step + 1;
    end

    #20 $finish;
end


endmodule // Logic Design Lib.

