module 	:=  	\
		crc32_d8_check		\
		crc32_dn_check_1	\
		crc32_dn_check_4


SRC_crc32_d8_check    =  \
		../source/LDL_crc32_d8.sv        	\
		../source/LDL_crc32_d8_check.sv     \
	    ./tb/LDL_crc32_dn_check_tb.sv

SRC_crc32_dn_check_1  =  \
		../source/LDL_crc32_d8.sv        	\
		../source/LDL_crc32_dn.sv        	\
		../source/LDL_crc32_dn_check.sv     \
	    ./tb/LDL_crc32_dn_check_tb.sv

SRC_crc32_dn_check_4  =  $(SRC_crc32_dn_check_1)

include ../../../make.sim

