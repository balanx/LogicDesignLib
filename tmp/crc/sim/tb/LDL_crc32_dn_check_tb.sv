// https://github.com/balanx/LogicDesignLib

`timescale 1ns/1ns

module LDL_crc32_dn_check_tb;

`ifdef CRC32_DN_CHECK_4
parameter NUM = 4;
`else
parameter NUM = 1;
`endif

reg  [ 7:0] mem [0:255];
reg  [ 7:0] i = 0;

reg  [8*NUM -1:0] data = 0;
reg  [$clog2(NUM) -1:0] bnum  = 0;
reg         valid = 0;
reg         eof   = 0;
reg         rst_n = 0;
reg         clk   = 0;
wire        err  ;

//reg  [8*NUM -1:0] debug = 0;

always #5 clk = ~clk;

`ifdef CRC32_D8_CHECK
LDL_crc32_d8_check  dut (
        .data                   ( data                   ), // input[7:0]
        .valid                  ( valid                  ), // input
        .eof                    ( eof                    ), // input
        .err                    ( err                    ), //output
        .rst_n                  ( rst_n                  ), // input
        .clk                    ( clk                    )  // input
    );
`else
LDL_crc32_dn_check #(
        .NUM  ( NUM )
    )
    dut (
        .data                   ( data                   ), // input[7:0]
        .bnum                   ( bnum                   ), // input
        .valid                  ( valid                  ), // input
        .eof                    ( eof                    ), // input
        .err                    ( err                    ), //output
        .rst_n                  ( rst_n                  ), // input
        .clk                    ( clk                    )  // input
    );
`endif

initial begin
    $monitor("%d : %h %b %b %b", $time, dut.data, valid, eof, err);
    $readmemh("./tb/LDL_eth.dat", mem);
    $dumpvars();
    #20 rst_n = 1;

    SEND(0, 88, 0);
    SEND(0, 88, 1);
    SEND(0, 88, 0);
    SEND('h80, 83, 0);

    #20 $finish;
end

task  SEND;
input [15:0] start;
input [15:0] length;
input        err;

begin
    //head
    @(negedge clk) valid = 1;
    i = start;
    bnum = 0;

    //body
    while(length > NUM) begin
        repeat(NUM) begin
            data = data << 8;
            data[7:0] = mem[i];
            i = i + 1;
        end
        length = length - NUM;
        @(negedge clk);
    end

    //tail
    eof = 1;
    repeat(length) begin
        data = data << 8;
        data[7:0] = mem[i];
        i = i + 1;
    end
    data = data << ((NUM - length)*8); //MSB first
    bnum = length;

    if (err) data = ~data; //debug error

    @(negedge clk) eof = 0; valid = 0;
end
endtask

endmodule // Logic Design Lib.

