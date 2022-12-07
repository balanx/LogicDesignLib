// https://github.com/balanx/LogicDesignLib

module LDL_parity_check
#(
    parameter  PAR_BYTES  = 4
   ,parameter  DATA_WIDTH = 256
   ,parameter  BYTE_NUM = DATA_WIDTH / 8
)(
    input       clk
   ,input       rst
   ,input       en
   ,input   [DATA_WIDTH -1:0]   data
   ,input   [$clog2(BYTE_NUM) -1:0] bnum
   ,input       valid
   ,input       eop
   ,output      err
);

localparam  PAR_BITS = PAR_BYTES * 8;

reg     sof;
reg  [PAR_BITS   -1:0]   parity;
reg  [DATA_WIDTH -1:0]   nx_par;

always @(posedge clk) begin
    if (rst) begin
        sof    <= '1;
        parity <= '1;
    end
    else if (valid) begin
        sof    <=  sof ?  0 : eop;
        parity <=  sof ?  nx_par[PAR_BITS -1:0] : (parity ^ nx_par[PAR_BITS -1:0]);
    end
end

//assign err = sof ? (parity != 32'hFFFF_FFFF) : 0;
assign err = sof ? (parity != '1) : 0;

always @* begin
    nx_par = '1;
    if (eop && (bnum > 0) )
        nx_par = nx_par << (8*(BYTE_NUM - bnum) );

    nx_par = nx_par & data;

    for (int i=1; i < (BYTE_NUM/PAR_BYTES); i++)
        nx_par[PAR_BITS -1:0] = nx_par[PAR_BITS -1:0] ^ nx_par[i*PAR_BITS +: PAR_BITS];
end

endmodule // Logic Design Lib.
