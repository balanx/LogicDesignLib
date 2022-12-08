// https://github.com/balanx/LogicDesignLib

`timescale 1ns/1ns

module LDL_cdc_ring_v1_tb;

`ifdef CDC_RING_V1_1
parameter TX_HALF_PERIOD =  5, RX_HALF_PERIOD = 50;
`else
parameter TX_HALF_PERIOD = 50, RX_HALF_PERIOD =  5;
`endif

wire [7:0]  dout;
reg  [7:0]  din = 0;
reg         tx_rst   = 1;
reg         tx_clk   = 0;
reg         rx_rst   = 1;
reg         rx_clk   = 0;


always #TX_HALF_PERIOD tx_clk = ~tx_clk;
always #RX_HALF_PERIOD rx_clk = ~rx_clk;

LDL_cdc_ring_v1 #(
        .WIDTH                  ( 8                  ),
        .LEVEL                  ( 2                  ) 
    ) inst (
        .tx_clk                 ( tx_clk                 ), //I 
        .tx_rst                 ( tx_rst                 ), //I 
        .rx_clk                 ( rx_clk                 ), //I 
        .rx_rst                 ( rx_rst                 ), //I 
        .din                    ( din                    ), //I [WIDTH-1:0]
        .dout                   ( dout                   )  //O [WIDTH-1:0]
    );

initial begin
    $monitor("%d : %d %d", $time, din, dout);
    $dumpvars();
    #200 tx_rst = 0; rx_rst = 0;

    repeat(100) @(negedge tx_clk) din = din + 1;

    #200 $finish;
end


endmodule // Logic Design Lib.

