// https://github.com/balanx/LogicDesignLib

module  LDL_cdc_ring_v1
#(parameter
    WIDTH = 8
   ,LEVEL = 2   // min. is 2
)(
     input                      tx_clk
   , input                      tx_rst
   , input                      rx_clk
   , input                      rx_rst
   , input     [WIDTH -1 : 0]   din
   ,output     [WIDTH -1 : 0]   dout
);

//
wire               tx_st, rx_st;
wire               t2r, r2t;

LDL_cdc_buff_v1 #(.LEVEL(LEVEL)) cdc_bit_t2r (rx_clk, rx_rst, 1'b1, tx_st, t2r);
LDL_cdc_buff_v1 #(.LEVEL(LEVEL)) cdc_bit_r2t (tx_clk, tx_rst, 1'b1, rx_st, r2t);

//
wire [WIDTH -1:0]  ibuff;
wire  tx_en = (tx_st == r2t);

LDL_dff_array_v1 #(.WIDTH(1)) cdc_tx_st (tx_clk, tx_rst, tx_en, ~tx_st, tx_st);
LDL_dff_array_v1 #(.WIDTH(WIDTH)) cdc_tx_data (tx_clk, tx_rst, tx_en, din, ibuff);

//
wire  rx_en = (rx_st != t2r);

LDL_dff_array_v1 #(.WIDTH(1)) cdc_rx_st (rx_clk, rx_rst, 1'b1, t2r, rx_st);
LDL_cdc_buff_v1 #(.WIDTH(WIDTH), .LEVEL(1)) cdc_rx_data (rx_clk, rx_rst, rx_en, ibuff, dout);


endmodule // LDL.

