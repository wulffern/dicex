
plt=python3 ../../../py/plot.py
FILE=tb_nchio
PLOT="i(vcur)"
OPT=

run:
	${MAKE} aim TB=${FILE}
	${plt} ${FILE}.csv ${FILE} ${PLOT} ${OPT}

vds:
	${MAKE} run FILE=tb_vds

oplot:
	octave --persist tb_nchio.m

aim:
	-rm ${TB}.log
	-rm ${TB}.csv
	aimspice ${TB}.cir -o csv | tee ${TB}.sim
	@cat ${TB}.sim | perl -ne "if(m/error/i){system('cat ${TB}.log'); exit 1;}"
