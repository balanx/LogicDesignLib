// https://github.com/balanx/LogicDesignLib

module  LDL_rr_pri_v1
#(parameter
    BIN_WIDTH  =  3
   ,COS_WIDTH  =  2
   ,USER_WIDTH =  1
   ,REQ_WIDTH  = (1 << BIN_WIDTH)
)(
     input                          clk
   , input                          rst
   , input       [REQ_WIDTH -1:0]   req
   , input       [REQ_WIDTH -1:0][ COS_WIDTH -1:0]  icos  // Class of service, 0 is the lowest
   , input       [REQ_WIDTH -1:0][USER_WIDTH -1:0]  iuser
   , input                          ready
   ,output       [REQ_WIDTH -1:0]   ack
   ,output       [BIN_WIDTH -1:0]   bin
   ,output                          valid
   ,output reg   [USER_WIDTH -1:0]  ouser
   ,output reg   [ COS_WIDTH -1:0]  ocos
);


reg  [COS_WIDTH -1:0]  max_cos;
reg  [REQ_WIDTH -1:0]  max_req;
reg  [REQ_WIDTH -1:0][USER_WIDTH + COS_WIDTH -1:0]  iuser_t;

always @* begin
    max_cos = {COS_WIDTH{1'b0}};
    for(int i=0; i<REQ_WIDTH; i++) begin
        if (req[i] && (icos[i]>max_cos) )
            max_cos = icos[i];
    end

    for(int i=0; i<REQ_WIDTH; i++) begin
        max_req[i] = req[i];
        if (icos[i]<max_cos)
            max_req[i] = 1'b0;
    end

    for(int i=0; i<REQ_WIDTH; i++) begin
        iuser_t[i] = {icos[i], iuser[i]};
    end
end


wire  [USER_WIDTH + COS_WIDTH -1:0]  ouser_t;

LDL_rr_v1 #(
        .BIN_WIDTH              ( BIN_WIDTH              ),
        .USER_WIDTH             ( USER_WIDTH + COS_WIDTH )
    )
    round (
        .clk                    ( clk                    ), // input
        .rst                    ( rst                    ), // input
        .req                    ( max_req                ), // input[REQ_WIDTH-1:0]
        .iuser                  ( iuser_t                ), // input[REQ_WIDTH-1:0][USER_WIDTH-1:0]
        .ready                  ( ready                  ), // input
        .ack                    ( ack                    ), //output[REQ_WIDTH-1:0]
        .bin                    ( bin                    ), //output[BIN_WIDTH-1:0]
        .ouser                  ( ouser_t                ), //output[USER_WIDTH-1:0]
        .valid                  ( valid                  )  //output
    );

assign  {ocos, ouser} = ouser_t;

endmodule // LDL.

