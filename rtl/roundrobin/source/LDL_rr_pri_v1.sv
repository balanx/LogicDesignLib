// https://github.com/balanx/LogicDesignLib

module  LDL_rr_pri_v1
#(parameter
    BIN_WIDTH = 3
   ,COS_WIDTH = 2
   ,REQ_WIDTH = 1 << BIN_WIDTH
)(
     input                          clk
   , input                          rst
   , input       [REQ_WIDTH -1:0]   req
   , input       [REQ_WIDTH -1:0][COS_WIDTH -1:0]   cos // 0 is the lowest
   , input                          ready
   ,output       [REQ_WIDTH -1:0]   hot
   ,output       [BIN_WIDTH -1:0]   bin
   ,output                          valid
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


LDL_rr_v1 #(
        .BIN_WIDTH              ( BIN_WIDTH              )
    )
    round (
        .clk                    ( clk                    ), // input
        .rst                    ( rst                    ), // input
        .req                    ( max_req                ), // input[REQ_WIDTH-1:0]
        .ready                  ( ready                  ), // input
        .hot                    ( hot                    ), //output[REQ_WIDTH-1:0]
        .bin                    ( bin                    ), //output[BIN_WIDTH-1:0]
        .valid                  ( valid                  )  //output
    );


endmodule // LDL.

