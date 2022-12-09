// https://github.com/balanx/LogicDesignLib

module  LDL_sfifo_v1
#(parameter
    DW  = 8
   ,AW  = 8
   ,AHEAD  = 1 //1 is mem_read_address ahead
)(
     input                  clk
   , input                  rst
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
        .mw                     ( mem_we                 ), //O
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


wire    nc;

LDL_p2ram_rs_v1 #(
        .DW                     ( DW                     ),
        .DEPTH                  ( 1 << AW                ),
        .AW                     ( AW                     )
    )
    p2ram_rs (
        .clk                    ( clk                    ), //I
        .we                     ( mem_we                 ), //I
        .wa                     ( wa                     ), //I [AW-1:0]
        .din                    ( din                    ), //I [DW-1:0]
        .re                     ( mem_re                 ), //I
        .ra                     ( ra                     ), //I [AW-1:0]
        .dout                   ( dout                   ), //O [DW-1:0]
        .rv                     ( nc                     )  //O
    );

endmodule // LDL.

