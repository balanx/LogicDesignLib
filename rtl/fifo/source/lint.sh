#!/bin/bash
echo  LDL_sfifo_v1
verilator --cc  --timescale 1ns/1ns \
+incdir+../../../include    \
LDL_sfifo_v1.sv     \
LDL_fifo_rs_v1.sv   \
LDL_fifo_ws_v1.sv   \
../../../custom/memory/source/LDL_p2ram_rs_v1.sv

echo  LDL_afifo_v1
verilator --cc  --timescale 1ns/1ns \
+incdir+../../../include    \
LDL_afifo_v1.sv     \
LDL_fifo_rs_v1.sv   \
LDL_fifo_ws_v1.sv   \
../../../custom/memory/source/LDL_p2ram_ra_v1.sv  \
../../../custom/cdc/source/LDL_cdc_ring_v1.sv     \
../../../custom/cdc/source/LDL_cdc_buff_v1.sv     \
../../../rtl/base/source/LDL_dff_array_v1.sv


echo  LDL_afifo_hand_v1
verilator --cc  --timescale 1ns/1ns \
+incdir+../../../include    \
LDL_afifo_hand_v1.sv    \
LDL_fifo_rs_v1.sv   \
LDL_fifo_ws_v1.sv   \
../../../custom/memory/source/LDL_p2ram_ra_v1.sv  \
../../../custom/cdc/source/LDL_cdc_hand_v1.sv     \
../../../custom/cdc/source/LDL_cdc_buff_v1.sv     \
../../../rtl/base/source/LDL_count_v1.sv          \
../../../rtl/base/source/LDL_dff_array_v1.sv
