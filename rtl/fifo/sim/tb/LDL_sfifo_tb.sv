// https://github.com/balanx/LogicDesignLib

`timescale  1ns/1ns

module  LDL_sfifo_tb;

`ifdef SFIFO_NO_AHEAD
parameter
    AHEAD = 0;
`else
parameter
    AHEAD = 1;
`endif

parameter
    DWIDTH = 8,
    AWIDTH = 4;

reg                      clk   = 0;
reg                      rst_n = 0;
reg                      we    = 0;
reg                      re    = 0;
reg        [DWIDTH -1:0] din   = 'ha0;
wire                     empty;
wire                     full;
wire       [DWIDTH -1:0] dout;
wire       [AWIDTH   :0] count;

always #5 clk = ~clk;

LDL_sfifo #(
        .DWIDTH                 ( DWIDTH                 ),
        .AWIDTH                 ( AWIDTH                 ),
        .AHEAD                  ( AHEAD                  )
    )
    dut (
        .clk                    ( clk                    ), // input
        .rst_n                  ( rst_n                  ), // input
        .we                     ( we                     ), // input
        .re                     ( re                     ), // input
        .din                    ( din                    ), // input[DWIDTH-1:0]
        .empty                  ( empty                  ), //output
        .full                   ( full                   ), //output
        .dout                   ( dout                   ), //output[DWIDTH-1:0]
        .count                  ( count                  )  //output[AWIDTH:0]
    );


initial begin
    $dumpvars(0);
    #20  rst_n  = 1;

    @(negedge clk) we = 1;
    repeat(20) begin
        @(negedge clk) din = din + 1;
    end
    @(negedge clk) we = 0;  re = 1;
    repeat(20) @(negedge clk);

    // d * d d d
    @(negedge clk) we = 1; din = din + 1;
    @(negedge clk) we = 0;
    @(negedge clk) we = 1; din = din + 1;
    repeat(10) begin
        @(negedge clk) din = din + 1;
    end

    // d d * d d d
    @(negedge clk) we = 0;
    repeat(10) @(negedge clk);
    @(negedge clk) we = 1; din = din + 1;
    @(negedge clk) din = din + 1;
    @(negedge clk) we = 0;
    @(negedge clk) we = 1; din = din + 1;
    @(negedge clk) din = din + 1;
    @(negedge clk) we = 0;

    repeat(10) @(negedge clk);
    re = 0; we = 1; din = din + 1;
    @(negedge clk) we = 0;
    @(negedge clk) we = 1; re = 1; din = din + 1;
    @(negedge clk) re = 0; din = din + 1;
    @(negedge clk) re = 1; din = din + 1;
    @(negedge clk) din = din + 1;
    @(negedge clk) we = 0;

    #20 $finish;
end

initial begin
    $display("     time : re  dout empty full count  we");
    $monitor("%9d : %b    %h    %b    %b    %2d    %b", $time, re, dout, empty, full, count, we);
end


endmodule // Logic Design Lib.

