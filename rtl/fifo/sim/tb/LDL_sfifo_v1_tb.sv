// https://github.com/balanx/LogicDesignLib

`timescale  1ns/1ns

module  LDL_sfifo_v1_tb;

`ifdef SFIFO_V1_NO_AHEAD
parameter
    AHEAD = 0;
`else
parameter
    AHEAD = 1;
`endif

parameter
    DW = 8,
    AW = 4;

reg                      clk   = 0;
reg                      rst   = 1;
reg                      we    = 0;
reg                      re    = 0;
reg        [DW -1:0]     din   = 'ha0;
wire                     empty;
wire                     full;
wire       [DW -1:0]     dout;
wire       [AW   :0]     wcnt, rcnt;

always #5 clk = ~clk;

LDL_sfifo_v1 #(
        .DW                     ( DW                     ),
        .AW                     ( AW                     ),
        .AHEAD                  ( AHEAD                  ) 
    )
    dut (
        .clk                    ( clk                    ), //I
        .rst                    ( rst                    ), //I
        .we                     ( we                     ), //I
        .re                     ( re                     ), //I
        .din                    ( din                    ), //I [DW-1:0]
        .empty                  ( empty                  ), //O
        .full                   ( full                   ), //O
        .dout                   ( dout                   ), //O [DW-1:0]
        .wcnt                   ( wcnt                   ), //O [AW  :0]
        .rcnt                   ( rcnt                   )  //O [AW  :0]
    );


initial begin
    $dumpvars(0);
    $monitor($time, " : %b  %b", empty, full);

    #20000 $display("All done!\n");
    $finish;
end

initial begin
    #20  rst = 0;
    forever SEND();
end

always RECV();

integer  seed = 0;
reg  [DW -1:0] sb[$] = {};

task SEND ();
    @(negedge clk) we = $random(seed) % 2;
        if (~full && we) begin
            din = din + 1;
            sb.push_back(din);
        end
endtask

reg  prev = 0;

task RECV ();
    @(negedge clk) re = $random(seed) % 2;
    @(posedge clk)
    if (AHEAD ? (~empty && re) : prev) begin
        if (dout != sb[0]) begin
            $error("dout(%h) != din(%h)", dout, sb[0]);
            #50 $finish;
        end
        sb.pop_front();
    end

    //if (!AHEAD)
        prev = ~empty && re;

endtask

endmodule // Logic Design Lib.

