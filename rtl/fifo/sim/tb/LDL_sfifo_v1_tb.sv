// https://github.com/balanx/LogicDesignLib

`timescale  1ns/1ns

module  LDL_sfifo_v1_tb;

`ifdef SFIFO_V1_NO_AHEAD
parameter
    AHEAD = 0;
`else
parameter
    AHEAD = 1;
`endif

parameter
    DW = 8,
    AW = 4;

reg                      clk   = 0;
reg                      rst   = 1;
reg                      we    = 0;
reg                      re    = 0;
reg        [DW -1:0]     din   = 'ha0;
wire                     empty;
wire                     full;
wire       [DW -1:0]     dout;
wire       [AW -1:0]     wcnt, rcnt;

always #5 clk = ~clk;

LDL_sfifo_v1 #(
        .DW                     ( DW                     ),
        .AW                     ( AW                     ),
        .AHEAD                  ( AHEAD                  ) 
    )
    dut (
        .clk                    ( clk                    ), //I
        .rst                    ( rst                    ), //I
        .we                     ( we                     ), //I
        .re                     ( re                     ), //I
        .din                    ( din                    ), //I [DW-1:0]
        .empty                  ( empty                  ), //O
        .full                   ( full                   ), //O
        .dout                   ( dout                   ), //O [DW-1:0]
        .wcnt                   ( wcnt                   ), //O [AW-1:0]
        .rcnt                   ( rcnt                   )  //O [AW-1:0]
    );


initial begin
    $dumpvars(0);
    #20  rst   = 0;

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
    $display("     time : re  dout empty full wcnt  rcnt");
    $monitor("%9d : %b    %h    %b    %b    %2d    %2d", $time, re, dout, empty, full, wcnt, rcnt);
end


endmodule // Logic Design Lib.

