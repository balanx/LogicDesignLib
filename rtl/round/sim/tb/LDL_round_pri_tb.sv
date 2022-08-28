// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/13
//
// Description   : Round Robin testbench
//
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------
`timescale  1ns/1ns

module  LDL_round_pri_tb;


parameter
    BIN_WIDTH = 3,
    COS_WIDTH = 2,
    REQ_WIDTH = 1 << BIN_WIDTH;

reg                      clk   = 0;
reg                      rst_n = 0;
reg    [REQ_WIDTH -1:0]  req   = 0;
reg    [REQ_WIDTH -1:0][COS_WIDTH -1:0]  cos   = 0;
wire                     ack;
wire   [BIN_WIDTH -1:0]  bin;
wire   [REQ_WIDTH -1:0]  hot;

always #5 clk = ~clk;

LDL_round_pri #(
        .BIN_WIDTH              ( BIN_WIDTH              ),
        .COS_WIDTH              ( COS_WIDTH              )
    )
    dut (
        .clk                    ( clk                    ), // input
        .rst_n                  ( rst_n                  ), // input
        .req                    ( req                    ), // input[REQ_WIDTH-1:0]
        .cos                    ( cos                    ), // input
        .ack                    ( ack                    ), //output
        .bin                    ( bin                    ), //output[BIN_WIDTH-1:0]
        .hot                    ( hot                    )  //output[REQ_WIDTH-1:0]
    );


initial begin
    $monitor("cos=%h, req=%b, ack=%h, bin=%h, hot=%b", cos, req, ack, bin, hot);
    $dumpvars(0);
    #20  rst_n  = 1;

    @(negedge clk) req = 'ha5;
    repeat(6) @(negedge clk) ;
    @(negedge clk) req = 0;

    @(negedge clk) req = 'hff; cos = {2'h3, 2'h2, 2'h1, 2'h0, 2'h3, 2'h2, 2'h1, 2'h0};
    repeat(2) @(negedge clk) ;
    @(negedge clk) req = 0;

    @(negedge clk) req = 'hff; cos = {2'h0, 2'h2, 2'h1, 2'h0, 2'h0, 2'h2, 2'h1, 2'h0};
    repeat(2) @(negedge clk) ;
    @(negedge clk) req = 0;

    @(negedge clk) req = 'hff; cos = {2'h0, 2'h0, 2'h1, 2'h0, 2'h0, 2'h0, 2'h1, 2'h0};
    repeat(2) @(negedge clk) ;
    @(negedge clk) req = 0;

    #20 $finish;
end


endmodule // Logic Design Lib.

