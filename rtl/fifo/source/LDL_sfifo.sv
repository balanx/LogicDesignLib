// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/13
//
// Description   : Sync. FIFO parameterized
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/13   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_sfifo
#(parameter
    DWIDTH  = 8
   ,AWIDTH  = 8
   ,AHEAD   = 1 //1 is mem_read_address ahead
)(
     input                     clk
   , input                     rst_n  // 0 is reset
   , input                     we     // fifo write enable
   , input                     re     // fifo read  enable
   , input       [DWIDTH -1:0] din
   ,output                     empty  // = ~valid
   ,output                     full   // = ~ready
   ,output       [DWIDTH -1:0] dout
   ,output       [AWIDTH   :0] count
);

wire  [AWIDTH -1 : 0]  wa, ra;
wire    mem_re ;
wire    mem_we ;

LDL_sfifo_ctr #(
        .AWIDTH                 ( AWIDTH                 ),
        .AHEAD                  ( AHEAD                  ) 
    )
    sfifo_ctr (
        .clk                    ( clk                    ), // input
        .rst_n                  ( rst_n                  ), // input
        .we                     ( we                     ), // input
        .re                     ( re                     ), // input
        .empty                  ( empty                  ), //output
        .full                   ( full                   ), //output
        .wa                     ( wa                     ), //output[AWIDTH-1:0]
        .ra                     ( ra                     ), //output[AWIDTH-1:0]
        .mw                     ( mem_we                 ), //output
        .mr                     ( mem_re                 ), //output
        .count                  ( count                  )  //output[AWIDTH:0]
    );


LDL_ram_p2 #(
        .DWIDTH                 ( DWIDTH                 ),
        .AWIDTH                 ( AWIDTH                 ) 
    )
    ram_inst (
        .clka                   ( clk                    ), // input
        .wea                    ( mem_we                 ), // input
        .addra                  ( wa                     ), // input[AWIDTH-1:0]
        .dina                   ( din                    ), // input[DWIDTH-1:0]
        .clkb                   ( clk                    ), // input
        .reb                    ( mem_re                 ), // input
        .addrb                  ( ra                     ), // input[AWIDTH-1:0]
        .doutb                  ( dout                   )  //output[DWIDTH-1:0]
    );

endmodule // Logic Design Lib.

