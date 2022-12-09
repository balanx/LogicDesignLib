// https://github.com/balanx/LogicDesignLib

`include  "LDL_macros.vh"

module  LDL_fifo_ws_v1  // write-side
#(parameter
    AW  = 8
   ,AHEAD   = 1 //1 is read-operation ahead
)(
     input                  clk
   , input                  rst
   , input                  we
   ,output                  full
   ,output       [AW -1:0]  wa
   , input       [AW   :0]  r_pt
   ,output reg   [AW   :0]  w_pt
   ,output                  mw
   ,output       [AW   :0]  wcnt
);

wire    fw    = (~full & we);
assign  wa    =  w_pt[AW-1:0];
assign  wcnt  = (w_pt  - r_pt);
assign  full  = (w_pt[AW] != r_pt[AW] && w_pt[AW-1:0] == r_pt[AW-1:0]);
assign  mw    =  fw;

`LDL_ALWAYS
begin
    if (rst) begin
        w_pt  <=  '0;
    end
    else begin
        if (fw) w_pt <= w_pt + 1'b1;
    end
end

endmodule // LDL.

