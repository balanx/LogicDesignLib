// https://github.com/balanx/LogicDesignLib

//`include  "LDL_macros.vh"

module  LDL_cdc_buff_v1
#(parameter
    WIDTH = 1
   ,LEVEL = 2  // min. is 2
)(
     input                  clk
   , input                  rst
   , input                  en
   , input [WIDTH -1 : 0]   din
   ,output [WIDTH -1 : 0]   dout
);

LDL_dff_array_v1 #(
        .WIDTH                  ( WIDTH                  ),
        .LEVEL                  ( LEVEL                  ) 
    )
cdc_buff (
        .clk                    ( clk                    ), //I 
        .rst                    ( rst                    ), //I 
        .en                     ( en                     ), //I 
        .din                    ( din                    ), //I [WIDTH-1:0]
        .dout                   ( dout                   )  //O [WIDTH-1:0]
    );

endmodule // LDL.

