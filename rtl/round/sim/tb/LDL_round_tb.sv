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

module  LDL_round_tb;


parameter
    BIN_WIDTH = 3,
    REQ_WIDTH = 1 << BIN_WIDTH;

reg                      clk   = 0;
reg                      rst_n = 0;
reg    [REQ_WIDTH -1:0]  req   = 0;
wire                     ack;
wire   [BIN_WIDTH -1:0]  bin, pre_bin;
wire   [REQ_WIDTH -1:0]  hot;

always #5 clk = ~clk;

LDL_round #(
        .BIN_WIDTH              ( BIN_WIDTH              ) 
    )
    dut (
        .clk                    ( clk                    ), // input
        .rst_n                  ( rst_n                  ), // input
        .req                    ( req                    ), // input[WIDTH-1:0]
        .ack                    ( ack                    ), //output
        .hot                    ( hot                    ), //output[WIDTH-1:0]
        .bin                    ( bin                    ), //output[$clog2(WIDTH)-1:0]
        .pre_bin                ( pre_bin                )  //output[BIN_WIDTH-1:0]
    );


initial begin
    $monitor("req=%b, ack=%h, bin=%h, hot=%b", req, ack, bin, hot);
    $dumpvars(0);
    #20  rst_n  = 1;

    @(negedge clk) req = 'ha5;
    repeat(6) @(negedge clk) ;

    @(negedge clk) req = 0;
    #60 $finish;
end


endmodule // Logic Design Lib.

