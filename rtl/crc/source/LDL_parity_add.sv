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

module  LDL_parity_add
#(
    parameter   PAR_BYTES   = 4
   ,parameter   DATA_WIDTH  = 256
   ,parameter   USER_WIDTH  = 6+1 // fid + err
   ,parameter   FLOW_NUM    = 8
   ,parameter   LENGTH_BITS = 15
   ,parameter   PAR_BITS    = PAR_BYTES * 8
)(
    input           clk
   ,input           rst
   ,input           en      //1 enable, 0 bypass
   ,input           eop_in
   ,input           vld_in
   ,input       [LENGTH_BITS -1:0]      leng_in
   ,input       [$clog2(FLOW_NUM) -1:0] port_in
   ,input       [USER_WIDTH  -1:0]      user_in
   ,input       [DATA_WIDTH  -1:0]      din
   ,output reg  [DATA_WIDTH  -1:0]      dout
   ,output reg  [LENGTH_BITS -1:0]      leng_out
   ,output reg  [USER_WIDTH  -1:0]      user_out
   ,output reg      vld_out
   ,output reg      eop_out
   ,output          ready
   ,output reg  [FLOW_NUM -1:0][PAR_BITS -1:0]  parity
);

localparam  BYTE_NUM = DATA_WIDTH / 8;
localparam  BYTE_NUM_1 = BYTE_NUM - PAR_BYTES; //32-4=28
localparam  WORD_NUM   = DATA_WIDTH / PAR_BITS;
localparam  BNUM_BITS  = $clog2(BYTE_NUM);

reg  [DATA_WIDTH -1:0]  nx_data, nx_par;
reg     nx_eop;
reg  [FLOW_NUM -1:0]  sop;

wire [BNUM_BITS -1:0] bnum = leng_in[BNUM_BITS -1:0];
reg  [BNUM_BITS -1:0] eop_st;

assign  ready = (eop_st == 0);

reg  [$clog2(FLOW_NUM) -1:0] port_out;
reg  [2*PAR_BITS  -1:0] par_shift;

always @* begin
    nx_eop =  0;
    nx_par = '1;
    if (eop_in && (bnum >0) )
        nx_par = nx_par << (8*(BYTE_NUM - bnum) );

    //replace to 0 after end-of-byte
    nx_data = nx_par & din;
    nx_par[PAR_BITS -1:0] = sop[port_in] ? '1 : parity[port_in];
    for (int i=0; i<WORD_NUM; i++)
        nx_par[PAR_BITS -1:0] = nx_par[PAR_BITS -1:0] ^  nx_data[i*PAR_BITS +: PAR_BITS];

    if (eop_in && (bnum >0) ) begin
        par_shift =  {nx_par[PAR_BITS -1:0], nx_par[PAR_BITS -1:0]} << (bnum[$clog2(PAR_BYTES) -1:0] * 8);
        //par_shift = (bnum[1:0]==1) ? {nx_par[23:0], nx_par[31:24]} :
        //            (bnum[1:0]==2) ? {nx_par[15:0], nx_par[31:16]} :
        //            (bnum[1:0]==3) ? {nx_par[ 7:0], nx_par[31: 8]} : nx_par[31:0];

        if (bnum > BYTE_NUM_1)begin
            //nx_data = nx_data |  {'0, (par_shift >> ((bnum-BYTE_NUM_1)*8) ) };
            nx_data = nx_data |  {'0, (par_shift[PAR_BITS +: PAR_BITS] >> ((bnum-BYTE_NUM_1)*8) ) };
        end
        else begin
            //nx_data = nx_data | ({'0, par_shift} << ((BYTE_NUM_1-bnum)*8) );
            nx_data = nx_data | ({'0, par_shift[PAR_BITS +: PAR_BITS]} << ((BYTE_NUM_1-bnum)*8) );
            nx_eop = 1;
        end
    end

    //
    if (eop_st)begin
        nx_data[DATA_WIDTH -1 -: PAR_BITS] = parity[port_out];
        nx_eop  = 1;
    end
end

always @(posedge clk)begin
    if (rst)begin
        port_out <=  '0;
        user_out <=  '0;
        dout     <=  '0;
        leng_out <=  '0;
        vld_out  <=  '0;
        eop_out  <=  '0;
        eop_st   <=  '0;
        parity   <=  '0;
    end
    else if (~en) begin
        user_out <= user_in;
        dout     <= din;
        leng_out <= leng_in;
        vld_out  <= vld_in;
        eop_out  <= eop_in;
    end
    else if (eop_st) begin
        eop_st   <=  '0;
        dout     <=  nx_data;
        eop_out  <=  nx_eop;
    end
    else if (vld_in) begin
        port_out <= port_in;
        user_out <= user_in;
        dout     <= nx_data;
        leng_out <= leng_in + PAR_BYTES;
        vld_out  <= eop_st || vld_in;
        eop_out  <= nx_eop;
        eop_st   <= eop_in ? (bnum > BYTE_NUM_1 || bnum == 0) : 0;

        if (!eop_st)
            parity[port_in] <= nx_par[PAR_BITS -1:0];
    end
    else begin
        vld_out  <=  '0;
        eop_out  <=  '0;
    end
end

always @(posedge clk) begin
    if (rst)
        sop <= '1;
    else if (eop_out && vld_out)
        sop[port_out] <= 1;
    else if (vld_in)
        sop[port_in]  <= 0;
end

endmodule // Logic Design Lib.

