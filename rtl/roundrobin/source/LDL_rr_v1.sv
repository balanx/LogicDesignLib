// https://github.com/balanx/LogicDesignLib

`include  "LDL_rtl_define.vh"

module  LDL_rr_v1
#(parameter
    BIN_WIDTH = 3
   ,REQ_WIDTH = 1 << BIN_WIDTH
)(
     input                          clk
   , input                          rst
   , input       [REQ_WIDTH -1:0]   req
   , input                          ready
   ,output reg                      valid
   ,output       [REQ_WIDTH -1:0]   hot
   ,output reg   [BIN_WIDTH -1:0]   bin
);


//e.g. bin = 1
//msb_mask = 1100
//lsb_mask = 0011
reg  [REQ_WIDTH -1:0]  msb_mask = '0;
always @* begin
    msb_mask = '1;
    msb_mask =  msb_mask << (bin + 1'b1);
end

reg  [REQ_WIDTH -1:0]  lsb_mask = '0;
always @* begin
    lsb_mask = ~msb_mask;
    lsb_mask[bin] =  ~valid; // req -> bin ，即轮询过了
end

wire [BIN_WIDTH -1:0]  msb_bin, lsb_bin;
wire                   msb_vld, lsb_vld;

LDL_hot2bin_pri_v1 #(
        .BIN_WIDTH              ( BIN_WIDTH              )
    )
    msb_pri (
        .x                      ( req & msb_mask         ), // input [WIDTH-1:0]
        .y                      ( msb_bin                ), //output [$clog2(WIDTH)-1:0]
        .valid                  ( msb_vld                )  //output 
    );


LDL_hot2bin_pri_v1 #(
        .BIN_WIDTH              ( BIN_WIDTH              )
    )
    lsb_pri (
        .x                      ( req & lsb_mask         ), // input [WIDTH-1:0]
        .y                      ( lsb_bin                ), //output [$clog2(WIDTH)-1:0]
        .valid                  ( lsb_vld                )  //output 
    );

wire  vld = msb_vld | lsb_vld;

`LDL_ALWAYS_STATEMENT(clk, rst)
begin
    if (rst) begin
        valid <=  0;
        bin <=  0;
    end
    else if (~valid || ready) begin
        valid <= vld;
        if (vld) // 有新请求才变 bin
            bin <= msb_vld ? msb_bin : lsb_bin;
    end
end


LDL_bin2hot_v1 #(
        .BIN_WIDTH              ( BIN_WIDTH              ) 
    )
    bin2hot (
        .en                     ( valid                  ), // input
        .x                      ( bin                    ), // input [WIDTH-1:0]
        .y                      ( hot                    )  //output [(1<<WIDTH)-1:0]
    );

endmodule // LDL.

