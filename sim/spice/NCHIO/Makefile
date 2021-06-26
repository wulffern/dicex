

run:
	${MAKE} aim TB=tb_nchio
	python3 plot.py tb_nchio.csv vgate "i(vcur)"

aim:
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/){system('cat ${TB}.log'); exit 1;}"
