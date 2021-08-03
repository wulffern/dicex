
MSIZE=9
SEED=34
.PHONY:maze
maze:
	python3 maze.py ${MSIZE} ${MSIZE} > maze.txt

mazev:
	-rm maze.txt
	iverilog -g2012 -o mazegen_tb -c mazegen_tb.fl -DMAZE_SEED=${SEED} -DMAZE_SIZE=${MSIZE}
	vvp -n mazegen_tb

solve:
	iverilog -g2012 -o maze -c maze.fl -DMAZE_SEED=34 -DMAZE_SIZE=${MSIZE}
	vvp -n maze


run:
	python3 run.py

clean:
	-rm allresults.yaml
	-rm *.vcd
	-rm *.log
	-rm *.txt
	-rm result.yaml
	-rm maze
