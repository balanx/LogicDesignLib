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
    WIDTH = 8
)(
     input                             clk
   , input                             rst_n  // 0 is reset
   , input       [WIDTH -1:0]          req
   ,output                             ack
   ,output       [$clog2(WIDTH) -1:0]  bin
   ,output       [WIDTH -1:0]          hot
);

reg  [$clog2(WIDTH) -1:0]  next;
wire [WIDTH -1: 0]  req_shift;

LDL_ring_shift_right #(
        .WIDTH                  ( WIDTH                  ) 
    )
    ring_shift_right (
        .sel                    ( next                   ), // input [$clog2(WIDTH)-1:0]
        .x                      ( req                    ), // input [WIDTH-1:0]
        .y                      ( req_shift              )  //output [WIDTH-1:0]
    );

wire [$clog2(WIDTH) -1:0]  bin_shift;

LDL_pri_enc #(
        .WIDTH                  ( WIDTH                  ) 
    )
    pri_enc (
        .x                      ( req_shift              ), // input [WIDTH-1:0]
        .y                      ( bin_shift              ), //output [$clog2(WIDTH)-1:0]
        .valid                  ( ack                    )  //output 
    );


assign  bin  =  bin_shift + next;

always @(posedge clk) begin
    if (!rst_n)
        next <= '0;
    else
        next <= bin + ack;
end

LDL_bin2hot #(
        .WIDTH                  ( $clog2(WIDTH)          ) 
    )
    bin2hot (
        .en                     ( ack                    ), // input
        .x                      ( bin                    ), // input [WIDTH-1:0]
        .y                      ( hot                    )  //output [(1<<WIDTH)-1:0]
    );

endmodule // Logic Design Library

