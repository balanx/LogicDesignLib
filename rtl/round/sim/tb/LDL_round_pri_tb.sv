// https://github.com/balanx/LogicDesignLib

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
reg                      ready   = 1;
wire                     valid;
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
        .ready                  ( ready                  ), // input
        .hot                    ( hot                    ), //output[REQ_WIDTH-1:0]
        .bin                    ( bin                    ), //output[BIN_WIDTH-1:0]
        .valid                  ( valid                  )  //output
    );


initial begin
    $monitor("cos=%h, req=%b, ready=%h, bin=%h, valid=%b, hot=%b", cos, req, ready, bin, valid, hot);
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

