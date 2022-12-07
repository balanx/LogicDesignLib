// https://github.com/balanx/LogicDesignLib

module  LDL_sfifo_ctr
#(parameter
    AWIDTH  = 8
   ,AHEAD   = 1 //1 is mem_read_address ahead
)(
     input                     clk
   , input                     rst_n  // 0 is reset
   , input                     we     // fifo write
   , input                     re     // fifo read
   ,output reg                 empty  // = ~valid
   ,output                     full   // = ~ready
   ,output       [AWIDTH -1:0] wa     // mem write address
   ,output       [AWIDTH -1:0] ra     // mem read  address
   ,output                     mw     // mem write enable
   ,output                     mr     // mem read  enable
   ,output       [AWIDTH   :0] count
);

wire    fw = (~full  & we);
wire    fr = (~empty & re);
//
reg  [AWIDTH : 0]  w_pt, r_pt;

assign  wa    =  w_pt[AWIDTH-1:0];
assign  ra    =  r_pt[AWIDTH-1:0] + (AHEAD ? fr : '0);
assign  count = (w_pt  - r_pt);
assign  full  = (w_pt[AWIDTH] != r_pt[AWIDTH] && w_pt[AWIDTH-1:0] == r_pt[AWIDTH-1:0]);
//
assign  mw    =  fw;
assign  mr    = (w_pt != r_pt);

//
always @(posedge clk) begin
    if (!rst_n) begin
        w_pt  <=  '0;
        r_pt  <=  '0;
        empty <=   1;
    end
    else begin
        //one data only
        if (fr && (count == 1) )
            empty  <=  1;
        else if (mr) //one cycle delay
            empty  <=  0;

        if (fw) w_pt <= w_pt + 1'b1;

        if (fr) r_pt <= r_pt + 1'b1;
    end
end

endmodule // Logic Design Lib.

