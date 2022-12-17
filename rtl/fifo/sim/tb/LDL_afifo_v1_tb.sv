// https://github.com/balanx/LogicDesignLib

`timescale  1ns/1ns

module  LDL_afifo_v1_tb;

`ifdef AFIFO_V1_NO_AHEAD
parameter
    AHEAD = 0;
`else
parameter
    AHEAD = 1;
`endif

parameter
    DW = 8,
    AW = 4;

reg                      w_clk = 0;
reg                      w_rst = 1;
reg                      r_clk = 0;
reg                      r_rst = 1;

reg                      we    = 0;
reg                      re    = 0;
reg        [DW -1:0]     din   = 'ha0;
wire                     empty;
wire                     full;
wire       [DW -1:0]     dout;
wire       [AW -1:0]     wcnt, rcnt;

always #5  w_clk = ~w_clk;
always #15 r_clk = ~r_clk;

LDL_afifo_v1 #(
        .DW                     ( DW                     ),
        .AW                     ( AW                     ),
        .AHEAD                  ( AHEAD                  ) 
    )
    dut (
        .w_clk                  ( w_clk                  ), //I
        .w_rst                  ( w_rst                  ), //I
        .r_clk                  ( r_clk                  ), //I
        .r_rst                  ( r_rst                  ), //I
        .we                     ( we                     ), //I
        .re                     ( re                     ), //I
        .din                    ( din                    ), //I [DW-1:0]
        .empty                  ( empty                  ), //O
        .full                   ( full                   ), //O
        .dout                   ( dout                   ), //O [DW-1:0]
        .wcnt                   ( wcnt                   ), //O [AW-1:0]
        .rcnt                   ( rcnt                   )  //O [AW-1:0]
    );


initial begin
    $dumpvars(0);
    #20  w_rst   = 0; r_rst   = 0;

    repeat(20) STREAM_SEND (din, we, ~full);
    STREAM_STOP (we);  re = 1;
    repeat(20) @(negedge w_clk);

    repeat(20) STREAM_SEND (din, we, ~full);
    STREAM_STOP (we);
    repeat(40) @(negedge w_clk);
    #20 $finish;
end

`ifdef AFIFO_V1_NO_AHEAD
reg   dv = 0;

always @(posedge r_clk) dv <= (re && ~empty);
`endif

reg  [7:0]  gold = 'ha0;

initial begin
    $display("     time : re  dout empty full wcnt  rcnt");
    $monitor("%9d : %b    %h    %b    %b    %2d    %2d", $time, re, dout, empty, full, wcnt, rcnt);

`ifdef AFIFO_V1_NO_AHEAD
    forever STREAM_RECV (gold, dout, dv, 1);
`else
    forever STREAM_RECV (gold, dout, ~empty, re);
`endif
end

task  STREAM_SEND (inout [7:0] data, output valid, input ready);

begin
    @(negedge w_clk) valid = 1; if (ready) data = data + 1;
end
endtask

task  STREAM_STOP (inout valid);

begin
    @(negedge w_clk) valid = 0;
end
endtask

task  STREAM_RECV (inout [7:0] gold, input [7:0] data, input valid, input ready);

begin
    @(negedge r_clk) if (ready && valid) begin
        gold = gold + 1;
        if (gold != data) begin
            gold = data;
            $display("Error at %9t", $time);
        end
    end
end
endtask


endmodule // Logic Design Lib.

