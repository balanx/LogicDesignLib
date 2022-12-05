
module  LDL_cdc_bus
#(parameter
    WIDTH = 8
   ,DELAY = 2   // min. is 2
)(
     input               tx_clk
   , input               tx_rst_n  // 0 is reset
   , input               rx_clk
   , input               rx_rst_n  // 0 is reset
   , input [WIDTH -1:0]  din
   ,output [WIDTH -1:0]  dout
);

reg  [WIDTH -1:0]  tx_data, rx_data;
reg                tx_st, rx_st;
wire               t2r, r2t;

LDL_cdc_bit  cdc_bit_t2r (rx_clk, rx_rst_n, tx_st, t2r);
LDL_cdc_bit  cdc_bit_r2t (tx_clk, tx_rst_n, rx_st, r2t);

wire  tx_en = (tx_st == r2t);

always @(posedge tx_clk) begin
    if (!tx_rst_n) begin
        tx_data <= '0;
        tx_st   <= '0;
    end
    else if (tx_en) begin
        tx_data <=  din;
        tx_st   <= ~tx_st;
    end
end

wire  rx_en = (rx_st != t2r);

always @(posedge rx_clk) begin
    if (!rx_rst_n) begin
        rx_data <= '0;
        rx_st   <= '0;
    end
    else if (rx_en) begin
        rx_data <=  tx_data;
        rx_st   <=  t2r;
    end
end

assign  dout = rx_data;

endmodule // Logic Design Lib.

