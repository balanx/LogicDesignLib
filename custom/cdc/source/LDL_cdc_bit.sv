// https://github.com/balanx/LogicDesignLib

module  LDL_cdc_bit
#(parameter
    DELAY = 2   // min. is 2
)(
     input        clk
   , input        rst_n  // 0 is reset
   , input        din
   ,output        dout
);

reg  [DELAY -1:0]  buff;

always @(posedge clk) begin
    if (!rst_n)
        buff <= '0;
    else
        buff <= {buff[DELAY -2:0], din};
end

assign  dout = buff[DELAY -1];

endmodule // Logic Design Lib.

