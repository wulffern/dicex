
dirs = ex1 ex2 ex3 ex4 maze  project/verilog sim/verilog/counter_sv

cwd = ${shell pwd}

test:
	${foreach d, ${dirs}, cd ${cwd}; cd ${d} && make test OPT=",pdf";}
