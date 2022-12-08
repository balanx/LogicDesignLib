// https://github.com/balanx/LogicDesignLib

`timescale 1ns/1ns

module LDL_cdc_hand_v1_tb;


wire [7:0]  dout;
reg  [7:0]  din = 0;
reg         tx_rst   = 1;
reg         tx_clk   = 0;
reg         rx_rst   = 1;
reg         rx_clk   = 0;


always #5  tx_clk = ~tx_clk;
always #10 rx_clk = ~rx_clk;

LDL_cdc_hand_v1 #(
        .DW                     ( 8                  ),
        .CW                     ( 8                  ) 
    ) inst (
        .tx_clk                 ( tx_clk                 ), //I 
        .tx_rst                 ( tx_rst                 ), //I 
        .rx_clk                 ( rx_clk                 ), //I 
        .rx_rst                 ( rx_rst                 ), //I 
        .num                    ( 8'd6                   ), //I [WIDTH-1:0]
        .din                    ( din                    ), //I [WIDTH-1:0]
        .dout                   ( dout                   )  //O [WIDTH-1:0]
    );

initial begin
    $monitor("%d : %d %d", $time, din, dout);
    $dumpvars();
    #200 tx_rst = 0; rx_rst = 0;

    repeat(50) @(negedge tx_clk) din = din + 1;

    #200 $finish;
end


endmodule // Logic Design Lib.

