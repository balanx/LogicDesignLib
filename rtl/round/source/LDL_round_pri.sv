// +FHDR------------------------------------------------------------------------
// Project Name  : LogicDesignLib
// Author        : 热干面
// Email         : tobalanx@qq.com
// Website       : https://github.com/balanx/LogicDesignLib
// Created On    : 2022/08/20
//
// Description   : Round Robin Arbitor with Priority
// 
// -----------------------------------------------------------------------------
// Modification History:
// Date         By           Version      Change Description
// -----------------------------------------------------------------------------
// 2022/08/19   热干面       1.0          Original
// -FHDR------------------------------------------------------------------------

module  LDL_round_pri
#(parameter
    BIN_WIDTH = 3
   ,COS_WIDTH = 2
   ,REQ_WIDTH = 1 << BIN_WIDTH
)(
     input                          clk
   , input                          rst_n  // 0 is reset
   , input       [REQ_WIDTH -1:0]   req
   , input       [REQ_WIDTH -1:0][COS_WIDTH -1:0]   cos // 0 is the lowest
   ,output                          ack
   ,output       [REQ_WIDTH -1:0]   hot
   ,output       [BIN_WIDTH -1:0]   bin
   ,output       [BIN_WIDTH -1:0]   pre_bin
);


reg  [COS_WIDTH -1:0]  max_cos;
reg  [REQ_WIDTH -1:0]  max_req;

always @* begin
    max_cos = 0;
    for(int i=0; i<REQ_WIDTH; i++) begin
        if (req[i] && (cos[i]>max_cos) )
            max_cos = cos[i];
    end

    for(int i=0; i<REQ_WIDTH; i++) begin
        max_req[i] = req[i];
        if (cos[i]<max_cos)
            max_req[i] = 0;
    end
end


LDL_round #(
        .BIN_WIDTH              ( BIN_WIDTH              )
    )
    round (
        .clk                    ( clk                    ), // input
        .rst_n                  ( rst_n                  ), // input
        .req                    ( max_req                ), // input[REQ_WIDTH-1:0]
        .ack                    ( ack                    ), //output
        .hot                    ( hot                    ), //output[REQ_WIDTH-1:0]
        .bin                    ( bin                    ), //output[BIN_WIDTH-1:0]
        .pre_bin                ( pre_bin                )  //output[BIN_WIDTH-1:0]
    );


endmodule // Logic Design Library

