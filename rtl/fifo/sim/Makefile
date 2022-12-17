case  :=  sfifo_v1  sfifo_v1_no_ahead  afifo_v1  afifo_v1_no_ahead

SRC_sfifo_v1  =  ../source/LDL_sfifo_v1.sv  \
	          ../source/LDL_fifo_ws_v1.sv   \
	          ../source/LDL_fifo_rs_v1.sv   \
	          ../../../custom/memory/source/LDL_p2ram_rs_v1.sv \
	          ./tb/LDL_sfifo_v1_tb.sv

SRC_sfifo_v1_no_ahead  =  $(SRC_sfifo_v1)

SRC_afifo_v1  =  ../source/LDL_afifo_v1.sv  \
	          ../source/LDL_fifo_ws_v1.sv   \
	          ../source/LDL_fifo_rs_v1.sv   \
	          ../../../rtl/base/source/LDL_dff_array_v1.sv \
	          ../../../custom/cdc/source/LDL_cdc_buff_v1.sv \
	          ../../../custom/cdc/source/LDL_cdc_ring_v1.sv \
	          ../../../custom/memory/source/LDL_p2ram_ra_v1.sv \
	          ./tb/LDL_afifo_v1_tb.sv

SRC_afifo_v1_no_ahead  =  $(SRC_afifo_v1)

include ../../../script/sim.make

