// https://github.com/balanx/LogicDesignLib

`include  "LDL_macros.vh"

module  LDL_cdc_hand_v1
#(parameter
    DW     = 8  // data  width
   ,CW     = 8  // count width
   ,LEVEL  = 2  // min. is 2
)(
     input                  tx_clk
   , input                  tx_rst
   , input                  rx_clk
   , input                  rx_rst
   , input     [CW -1 : 0]  interval  // n*tx_clk_period > 3*rx_clk_period
   , input     [DW -1 : 0]  din
   ,output     [DW -1 : 0]  dout
);

//
wire [CW -1:0]  tx_cnt;
LDL_count_v1  #(.WIDTH(CW)) cdc_tx_cnt  (tx_clk, tx_rst, 1'b1, interval, tx_cnt);

//
reg                 tx_st, rx_st;
wire                t2r;

LDL_cdc_buff_v1 #(.WIDTH(1), .LEVEL(LEVEL)) cdc_bit_t2r (rx_clk, rx_rst, 1'b1, tx_st, t2r);

//
wire  tx_en = (tx_cnt >= interval);
reg  [DW -1:0] ibuff;

LDL_dff_array_v1 #(.WIDTH( 1)) cdc_tx_st   (tx_clk, tx_rst, tx_en, ~tx_st, tx_st);
LDL_dff_array_v1 #(.WIDTH(DW)) cdc_tx_data (tx_clk, tx_rst, tx_en,    din, ibuff);

//
wire  rx_en = (rx_st != t2r);

LDL_dff_array_v1 #(.WIDTH(1)) cdc_rx_st (rx_clk, rx_rst, 1'b1, t2r, rx_st);
LDL_cdc_buff_v1  #(.WIDTH(DW), .LEVEL(1)) cdc_rx_data (rx_clk, rx_rst, rx_en, ibuff, dout);

endmodule // LDL.

