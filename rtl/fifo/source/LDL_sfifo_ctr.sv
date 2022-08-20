// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/13
//
// Description   : Sync. FIFO Controller
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_sfifo_ctr
#(parameter
    AWIDTH  = 8
   ,AHEAD   = 1 //1 is mem_read_address ahead
)(
     input                     clk
   , input                     rst_n  // 0 is reset
   , input                     we     // fifo write
   , input                     re     // fifo read
   ,output                     empty  // = ~valid
   ,output                     full   // = ~ready
   ,output       [AWIDTH -1:0] wa     // mem write address
   ,output       [AWIDTH -1:0] ra     // mem read  address
   ,output                     mw     // mem write enable
   ,output                     mr     // mem read  enable
   ,output       [AWIDTH   :0] count
);

reg  [AWIDTH : 0]  w_pt, r_pt;
assign  wa    =  w_pt[AWIDTH-1:0];
assign  ra    =  r_pt[AWIDTH-1:0] + (AHEAD ? (~empty & re) : 0);
assign  count = (w_pt  - r_pt);
assign  full  = (w_pt[AWIDTH] != r_pt[AWIDTH] && w_pt[AWIDTH-1:0] == r_pt[AWIDTH-1:0]);
//
assign  mw    = ~full & we;
assign  mr    = (w_pt != r_pt);

//For sync with memory read delay,
//empty delay 1 cycle when 'mr' 0->1, but NO delay when 1->0.
reg     empty_d;
assign  empty =  mr ? empty_d : ~mr;

always @(posedge clk) begin
    if (!rst_n) begin
        w_pt  <=  '0;
        r_pt  <=  '0;
        empty_d  <=   1;
    end
    else begin
        empty_d  <=  ~mr;

        if (~full  & we) w_pt <= w_pt + 1'b1;
        if (~empty & re) r_pt <= r_pt + 1'b1;
    end
end

endmodule // Logic Design Lib.

