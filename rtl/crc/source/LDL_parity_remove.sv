// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/09/16
//
// Description   : 
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/09/16   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module LDL_parity_remove
#(
    parameter  PAR_BYTES   = 4
   ,parameter  DATA_WIDTH  = 256
   ,parameter  FLOW_NUM    = 8
   ,parameter  LENGTH_BITS = 15
)(
    input           clk
   ,input           rst
   ,input           en      // 1 enable, 0 bypass
   ,input           eop_in
   ,input           vld_in
   ,input      [LENGTH_BITS -1:0]       leng_in
   ,input      [$clog2(FLOW_NUM) -1:0]  fid_in
   ,input      [DATA_WIDTH  -1:0]       din
   ,output reg [DATA_WIDTH  -1:0]       dout
   ,output reg [LENGTH_BITS -1:0]       leng_out
   ,output reg [$clog2(FLOW_NUM) -1:0]  fid_out
   ,output reg      vld_out
   ,output reg      eop_out
   ,output reg      err
);

localparam  BYTE_NUM = DATA_WIDTH / 8;

reg  [FLOW_NUM -1:0]    sof;
reg  [FLOW_NUM -1:0][LENGTH_BITS -1:0]  length;

always @(posedge clk) begin
    if (rst)begin
        sof      <= '1;
        length   <= '0;

        fid_out  <= '0;
        dout     <= '0;
        leng_out <= '0;
        vld_out  <= '0;
        eop_out  <= '0;
    end
    else begin
        fid_out  <=  fid_in;
        dout     <=  din;

        if (!en) begin
            leng_out <=  leng_in;
            vld_out  <=  vld_in;
            eop_out  <=  eop_in;
        end
        else if (vld_in) begin
            leng_out <=  leng_in - PAR_BYTES;
            sof   [fid_in]  <=  sof[fid_in] ? 0 : eop_in;
            length[fid_in]  <=  sof[fid_in] ? (leng_in - BYTE_NUM) : (length[fid_in] - BYTE_NUM);
            eop_out  <=  sof[fid_in] ? 0 : (length[fid_in] <= (BYTE_NUM + PAR_BYTES) );
            vld_out  <=  eop_in ? (length[fid_in] > PAR_BYTES) : 1;
        end
        else begin
            vld_out  <=  0;
            eop_out  <=  0;
        end
    end
end


endmodule // Logic Design Lib.

