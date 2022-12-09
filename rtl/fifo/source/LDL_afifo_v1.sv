// https://github.com/balanx/LogicDesignLib

module  LDL_afifo_v1
#(parameter
    DW  = 8
   ,AW  = 8
   ,AHEAD  = 1 //1 is mem_read_address ahead
)(
     input                  w_clk
   , input                  w_rst
   , input                  r_clk
   , input                  r_rst
   , input                  we
   , input                  re
   , input       [DW -1:0]  din
   ,output                  empty
   ,output                  full
   ,output       [DW -1:0]  dout
   ,output       [AW   :0]  wcnt
   ,output       [AW   :0]  rcnt
);

wire  [AW -1 : 0]  wa, ra;
wire  [AW    : 0]  w_pt, r_pt;
wire               mem_we, mem_re;

LDL_fifo_ws_v1 #(
        .AW                     ( AW                     ),
        .AHEAD                  ( AHEAD                  )
    )
    fifo_ws
    (
        .clk                    ( clk                    ), //I
        .rst                    ( rst                    ), //I
        .we                     ( we                     ), //I
        .full                   ( full                   ), //O
        .wa                     ( wa                     ), //O [AW-1:0]
        .r_pt                   ( r_pt                   ), //I [AW  :0]
        .w_pt                   ( w_pt                   ), //O [AW  :0]
        .mw                     ( mem_re                 ), //O
        .wcnt                   ( wcnt                   )  //O [AW:0]
    );


LDL_fifo_rs_v1 #(
        .AW                     ( AW                     ),
        .AHEAD                  ( AHEAD                  )
    )
    fifo_rs
    (
        .clk                    ( clk                    ), //I
        .rst                    ( rst                    ), //I
        .re                     ( re                     ), //I
        .empty                  ( empty                  ), //O
        .ra                     ( ra                     ), //O [AW-1:0]
        .r_pt                   ( r_pt                   ), //O [AW  :0]
        .w_pt                   ( w_pt                   ), //I [AW  :0]
        .mr                     ( mem_re                 ), //O
        .rcnt                   ( rcnt                   )  //O [AW:0]
    );


LDL_cdc_ring_v1 #(
        .WIDTH                  ( WIDTH                  ),
        .LEVEL                  ( LEVEL                  )
    )
    fifo_w2r
    (
        .tx_clk                 ( tx_clk                 ), //I
        .tx_rst                 ( tx_rst                 ), //I
        .rx_clk                 ( rx_clk                 ), //I
        .rx_rst                 ( rx_rst                 ), //I
        .din                    ( din                    ), //I [WIDTH-1:0]
        .dout                   ( dout                   )  //O [WIDTH-1:0]
    );


LDL_cdc_ring_v1 #(
        .WIDTH                  ( WIDTH                  ),
        .LEVEL                  ( LEVEL                  )
    )
    fifo_r2w
    (
        .tx_clk                 ( tx_clk                 ), //I
        .tx_rst                 ( tx_rst                 ), //I
        .rx_clk                 ( rx_clk                 ), //I
        .rx_rst                 ( rx_rst                 ), //I
        .din                    ( din                    ), //I [WIDTH-1:0]
        .dout                   ( dout                   )  //O [WIDTH-1:0]
    );


LDL_p2ram_ra_v1 #(
        .DW                     ( DW                     ),
        .DEPTH                  ( 1 << AW                ),
        .AW                     ( AW                     )
    )
    p2ram_ra (
        .wclk                   ( wclk                   ), //I
        .we                     ( mem_we                 ), //I
        .wa                     ( wa                     ), //I [AW-1:0]
        .din                    ( din                    ), //I [DW-1:0]
        .rclk                   ( rclk                   ), //I
        .re                     ( mem_re                 ), //I
        .ra                     ( ra                     ), //I [AW-1:0]
        .dout                   ( dout                   )  //O [DW-1:0]
    );

endmodule // LDL.

