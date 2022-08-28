// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Round Robin Arbitor
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/19   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_round
#(parameter
    BIN_WIDTH = 3
   ,REQ_WIDTH = 1 << BIN_WIDTH
)(
     input                          clk
   , input                          rst_n  // 0 is reset
   , input       [REQ_WIDTH -1:0]   req
   ,output                          ack
   ,output       [BIN_WIDTH -1:0]   bin
   ,output       [REQ_WIDTH -1:0]   hot
);

reg  [BIN_WIDTH -1:0]  next;
wire [REQ_WIDTH -1:0]  req_shift;

LDL_ring_shift #(
        .WIDTH                  ( REQ_WIDTH              ) 
    )
    ring_shift (
        .dir                    ( 0                      ), // input
        .step                   ( next                   ), // input [$clog2(WIDTH)-1:0]
        .x                      ( req                    ), // input [WIDTH-1:0]
        .y                      ( req_shift              )  //output [WIDTH-1:0]
    );

wire [BIN_WIDTH -1:0]  bin_shift;

LDL_hot2bin_pri #(
        .BIN_WIDTH              ( BIN_WIDTH              ) 
    )
    hot2bin_pri (
        .x                      ( req_shift              ), // input [WIDTH-1:0]
        .y                      ( bin_shift              ), //output [$clog2(WIDTH)-1:0]
        .valid                  ( ack                    )  //output 
    );


assign  bin  =  bin_shift + next;

always @(posedge clk) begin
    if (!rst_n)
        next <= '0;
    else if (ack)
        next <= bin + 1;
end

LDL_bin2hot #(
        .BIN_WIDTH              ( BIN_WIDTH              ) 
    )
    bin2hot (
        .en                     ( ack                    ), // input
        .x                      ( bin                    ), // input [WIDTH-1:0]
        .y                      ( hot                    )  //output [(1<<WIDTH)-1:0]
    );

endmodule // Logic Design Library

