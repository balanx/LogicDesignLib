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
reg                      ready = 1;
wire   [BIN_WIDTH -1:0]  bin;
wire   [REQ_WIDTH -1:0]  hot;
wire                     valid;

always #5 clk = ~clk;

LDL_round #(
        .BIN_WIDTH              ( BIN_WIDTH              ) 
    )
    dut (
        .clk                    ( clk                    ), // input
        .rst_n                  ( rst_n                  ), // input
        .req                    ( req                    ), // input[WIDTH-1:0]
        .ready                  ( ready                  ), // input
        .valid                  ( valid                  ), //output
        .hot                    ( hot                    ), //output[WIDTH-1:0]
        .bin                    ( bin                    )  //output[$clog2(WIDTH)-1:0]
    );


initial begin
    $monitor("req=%b, ready=%h, valid=%h, bin=%h, hot=%b", req, ready, valid, bin, hot);
    $dumpvars(0);
    #20  rst_n  = 1;

    @(negedge clk) req = 'h1;
    repeat(6) @(negedge clk) ;

    @(negedge clk) req = 'h3;
    repeat(6) @(negedge clk) ;

    @(negedge clk) req = 'ha5;
    repeat(6) @(negedge clk) ;

    @(negedge clk) ready = 0;
    @(negedge clk) ready = 1;
    repeat(6) @(negedge clk) ;
    @(negedge clk) req = 0;
    #60 $finish;
end


endmodule // Logic Design Lib.

