// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/23
//
// Description   : 
// 
// -----------------------------------------------------------------------------
// Modification History
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/23   热干面    1.0          Original
// -FHDR------------------------------------------------------------------------
`timescale 1ns/1ns

module LDL_cdc_bus_tb;

`ifdef CDC_BUS_1
parameter TX_HALF_PERIOD =  5, RX_HALF_PERIOD = 50;
`else
parameter TX_HALF_PERIOD = 50, RX_HALF_PERIOD =  5;
`endif

wire [7:0]  dout;
reg  [7:0]  din = 0;
reg         tx_rst_n = 0;
reg         tx_clk   = 0;
reg         rx_rst_n = 0;
reg         rx_clk   = 0;

//reg  [8*NUM -1:0] debug = 0;

always #TX_HALF_PERIOD tx_clk = ~tx_clk;
always #RX_HALF_PERIOD rx_clk = ~rx_clk;

LDL_cdc_bus #(
        .WIDTH                  ( 8                      ),
        .DELAY                  ( 2                      ) 
    ) inst (
        .tx_clk                 ( tx_clk                 ), //I 
        .tx_rst_n               ( tx_rst_n               ), //I 
        .rx_clk                 ( rx_clk                 ), //I 
        .rx_rst_n               ( rx_rst_n               ), //I 
        .din                    ( din                    ), //I [WIDTH-1:0]
        .dout                   ( dout                   )  //O [WIDTH-1:0]
    );

initial begin
    //$monitor("%d : %h %b %b %b", $time, dut.data, valid, eof, err);
    $dumpvars();
    #200 tx_rst_n = 1; rx_rst_n = 1;

    repeat(100) @(negedge tx_clk) din = din + 1;

    #200 $finish;
end


endmodule // Logic Design Lib.

