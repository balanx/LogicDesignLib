// https://github.com/balanx/LogicDesignLib

module  LDL_afifo_v1
#(parameter
    DW  = 8
   ,AW  = 8
   ,LEVEL = 2  // min. is 2
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
wire  [AW    : 0]  w_pt2r, r_pt2w;
wire               mem_we, mem_re;

LDL_fifo_ws_v1 #(
        .AW                     ( AW                     ),
        .AHEAD                  ( AHEAD                  )
    )
    fifo_ws
    (
        .clk                    ( w_clk                  ), //I
        .rst                    ( w_rst                  ), //I
        .we                     ( we                     ), //I
        .full                   ( full                   ), //O
        .wa                     ( wa                     ), //O [AW-1:0]
        .r_pt                   ( r_pt2w                 ), //I [AW  :0]
        .w_pt                   ( w_pt                   ), //O [AW  :0]
        .mw                     ( mem_we                 ), //O
        .wcnt                   ( wcnt                   )  //O [AW  :0]
    );


LDL_fifo_rs_v1 #(
        .AW                     ( AW                     ),
        .AHEAD                  ( AHEAD                  )
    )
    fifo_rs
    (
        .clk                    ( r_clk                  ), //I
        .rst                    ( r_rst                  ), //I
        .re                     ( re                     ), //I
        .empty                  ( empty                  ), //O
        .ra                     ( ra                     ), //O [AW-1:0]
        .r_pt                   ( r_pt                   ), //O [AW  :0]
        .w_pt                   ( w_pt2r                 ), //I [AW  :0]
        .mr                     ( mem_re                 ), //O
        .rcnt                   ( rcnt                   )  //O [AW  :0]
    );


LDL_cdc_ring_v1 #(
        .WIDTH                  ( AW + 1                 ),
        .LEVEL                  ( LEVEL                  )
    )
    fifo_w2r
    (
        .tx_clk                 ( w_clk                  ), //I
        .tx_rst                 ( w_rst                  ), //I
        .rx_clk                 ( r_clk                  ), //I
        .rx_rst                 ( r_rst                  ), //I
        .din                    ( w_pt                   ), //I [WIDTH-1:0]
        .dout                   ( w_pt2r                 )  //O [WIDTH-1:0]
    );


LDL_cdc_ring_v1 #(
        .WIDTH                  ( AW + 1                 ),
        .LEVEL                  ( LEVEL                  )
    )
    fifo_r2w
    (
        .tx_clk                 ( w_clk                  ), //I
        .tx_rst                 ( w_rst                  ), //I
        .rx_clk                 ( r_clk                  ), //I
        .rx_rst                 ( r_rst                  ), //I
        .din                    ( r_pt                   ), //I [WIDTH-1:0]
        .dout                   ( r_pt2w                 )  //O [WIDTH-1:0]
    );


LDL_p2ram_ra_v1 #(
        .DW                     ( DW                     ),
        .DEPTH                  ( 1 << AW                ),
        .AW                     ( AW                     )
    )
    p2ram_ra (
        .wclk                   ( w_clk                  ), //I
        .we                     ( mem_we                 ), //I
        .wa                     ( wa                     ), //I [AW-1:0]
        .din                    ( din                    ), //I [DW-1:0]
        .rclk                   ( r_clk                  ), //I
        .re                     ( mem_re                 ), //I
        .ra                     ( ra                     ), //I [AW-1:0]
        .dout                   ( dout                   )  //O [DW-1:0]
    );

endmodule // LDL.

