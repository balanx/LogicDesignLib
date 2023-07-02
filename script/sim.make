## https://github.com/balanx/LogicDesignLib

.PHONY: clean wave diff sim all help $(case)

IVL  =  iverilog -g2012 -I ../../../include

SRC = $(SRC_$(basename $1))

help:
	@echo "Make Target Lists:"
	@echo "  all            run all"
	@echo "  case-name      i.e. {$(case)}"
	@echo "  sim            vvp running"
	@echo "  wave           gtkwave dump.vcd"
	@echo "  diff           compare *.log with log/*"
	@echo "  clean          delete working files"
	@echo
	@echo "Pls. visit https://github.com/balanx/LogicDesignLib"


all : $(case)

$(case) : % : %.log

%.out : clean
	$(IVL)  -D $(shell echo $(basename $@) | tr a-z A-Z)  -o $@  $(call SRC,$@)

%.log : %.out
	vvp  -l $@  ./$(basename $@).out

diff :
	@for i in `ls *.log` ; do diff -Zsq $$i ./log/$$i ; done

wave :
	gtkwave  *.vcd &

clean:
	rm -rf *.out  *.vcd  *.log

