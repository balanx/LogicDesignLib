// https://github.com/balanx/LogicDesignLib

`include  "LDL_macros.vh"

module  LDL_fifo_rs_v1  // read-side
#(parameter
    AW  = 8
   ,AHEAD   = 1 //1 is read-operation ahead
)(
     input                  clk
   , input                  rst
   , input                  re
   ,output reg              empty
   ,output       [AW -1:0]  ra
   ,output reg   [AW   :0]  r_pt
   , input       [AW   :0]  w_pt
   ,output                  mr
   ,output       [AW -1:0]  rcnt
);

wire    fr    = (~empty & re);
assign  ra    = (AHEAD && (rcnt > 1) && fr) ? (r_pt[AW-1:0] + 1'b1) : r_pt[AW-1:0];
assign  rcnt  =  AW'(w_pt - r_pt);
assign  mr    = (w_pt != r_pt);

`LDL_ALWAYS
begin
    if (rst) begin
        r_pt  <=  '0;
        empty <=   1;
    end
    else begin
        if (!mr) //zero data
            empty  <=  1;
        else if ((rcnt == 1) && fr) //one data only
            empty  <=  1;
        else //if (mr) //one cycle delay
            empty  <=  0;

        if (fr) r_pt <= r_pt + 1'b1;
    end
end

endmodule // LDL.

