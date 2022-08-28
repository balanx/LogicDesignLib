//-----------------------------------------------------------------------------
// Copyright (C) 2009 OutputLogic.com
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//-----------------------------------------------------------------------------
// CRC module for data[7:0] ,   crc[31:0]=1+x^1+x^2+x^4+x^5+x^7+x^8+x^10+x^11+x^12+x^16+x^22+x^23+x^26+x^32;
//-----------------------------------------------------------------------------

module LDL_crc32_d8 (
  input      [ 7:0] data,
  input      [31:0] crc_in,
  output reg [31:0] crc_out
);


always @(*) begin
    crc_out[0] = crc_in[24] ^ crc_in[30] ^ data[0] ^ data[6];
    crc_out[1] = crc_in[24] ^ crc_in[25] ^ crc_in[30] ^ crc_in[31] ^ data[0] ^ data[1] ^ data[6] ^ data[7];
    crc_out[2] = crc_in[24] ^ crc_in[25] ^ crc_in[26] ^ crc_in[30] ^ crc_in[31] ^ data[0] ^ data[1] ^ data[2] ^ data[6] ^ data[7];
    crc_out[3] = crc_in[25] ^ crc_in[26] ^ crc_in[27] ^ crc_in[31] ^ data[1] ^ data[2] ^ data[3] ^ data[7];
    crc_out[4] = crc_in[24] ^ crc_in[26] ^ crc_in[27] ^ crc_in[28] ^ crc_in[30] ^ data[0] ^ data[2] ^ data[3] ^ data[4] ^ data[6];
    crc_out[5] = crc_in[24] ^ crc_in[25] ^ crc_in[27] ^ crc_in[28] ^ crc_in[29] ^ crc_in[30] ^ crc_in[31] ^ data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7];
    crc_out[6] = crc_in[25] ^ crc_in[26] ^ crc_in[28] ^ crc_in[29] ^ crc_in[30] ^ crc_in[31] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[6] ^ data[7];
    crc_out[7] = crc_in[24] ^ crc_in[26] ^ crc_in[27] ^ crc_in[29] ^ crc_in[31] ^ data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[7];
    crc_out[8] = crc_in[0] ^ crc_in[24] ^ crc_in[25] ^ crc_in[27] ^ crc_in[28] ^ data[0] ^ data[1] ^ data[3] ^ data[4];
    crc_out[9] = crc_in[1] ^ crc_in[25] ^ crc_in[26] ^ crc_in[28] ^ crc_in[29] ^ data[1] ^ data[2] ^ data[4] ^ data[5];
    crc_out[10] = crc_in[2] ^ crc_in[24] ^ crc_in[26] ^ crc_in[27] ^ crc_in[29] ^ data[0] ^ data[2] ^ data[3] ^ data[5];
    crc_out[11] = crc_in[3] ^ crc_in[24] ^ crc_in[25] ^ crc_in[27] ^ crc_in[28] ^ data[0] ^ data[1] ^ data[3] ^ data[4];
    crc_out[12] = crc_in[4] ^ crc_in[24] ^ crc_in[25] ^ crc_in[26] ^ crc_in[28] ^ crc_in[29] ^ crc_in[30] ^ data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[6];
    crc_out[13] = crc_in[5] ^ crc_in[25] ^ crc_in[26] ^ crc_in[27] ^ crc_in[29] ^ crc_in[30] ^ crc_in[31] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[7];
    crc_out[14] = crc_in[6] ^ crc_in[26] ^ crc_in[27] ^ crc_in[28] ^ crc_in[30] ^ crc_in[31] ^ data[2] ^ data[3] ^ data[4] ^ data[6] ^ data[7];
    crc_out[15] = crc_in[7] ^ crc_in[27] ^ crc_in[28] ^ crc_in[29] ^ crc_in[31] ^ data[3] ^ data[4] ^ data[5] ^ data[7];
    crc_out[16] = crc_in[8] ^ crc_in[24] ^ crc_in[28] ^ crc_in[29] ^ data[0] ^ data[4] ^ data[5];
    crc_out[17] = crc_in[9] ^ crc_in[25] ^ crc_in[29] ^ crc_in[30] ^ data[1] ^ data[5] ^ data[6];
    crc_out[18] = crc_in[10] ^ crc_in[26] ^ crc_in[30] ^ crc_in[31] ^ data[2] ^ data[6] ^ data[7];
    crc_out[19] = crc_in[11] ^ crc_in[27] ^ crc_in[31] ^ data[3] ^ data[7];
    crc_out[20] = crc_in[12] ^ crc_in[28] ^ data[4];
    crc_out[21] = crc_in[13] ^ crc_in[29] ^ data[5];
    crc_out[22] = crc_in[14] ^ crc_in[24] ^ data[0];
    crc_out[23] = crc_in[15] ^ crc_in[24] ^ crc_in[25] ^ crc_in[30] ^ data[0] ^ data[1] ^ data[6];
    crc_out[24] = crc_in[16] ^ crc_in[25] ^ crc_in[26] ^ crc_in[31] ^ data[1] ^ data[2] ^ data[7];
    crc_out[25] = crc_in[17] ^ crc_in[26] ^ crc_in[27] ^ data[2] ^ data[3];
    crc_out[26] = crc_in[18] ^ crc_in[24] ^ crc_in[27] ^ crc_in[28] ^ crc_in[30] ^ data[0] ^ data[3] ^ data[4] ^ data[6];
    crc_out[27] = crc_in[19] ^ crc_in[25] ^ crc_in[28] ^ crc_in[29] ^ crc_in[31] ^ data[1] ^ data[4] ^ data[5] ^ data[7];
    crc_out[28] = crc_in[20] ^ crc_in[26] ^ crc_in[29] ^ crc_in[30] ^ data[2] ^ data[5] ^ data[6];
    crc_out[29] = crc_in[21] ^ crc_in[27] ^ crc_in[30] ^ crc_in[31] ^ data[3] ^ data[6] ^ data[7];
    crc_out[30] = crc_in[22] ^ crc_in[28] ^ crc_in[31] ^ data[4] ^ data[7];
    crc_out[31] = crc_in[23] ^ crc_in[29] ^ data[5];

end // always

endmodule // crc

