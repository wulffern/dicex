
MSIZE=17
.PHONY:maze
maze:

	python3 maze.py ${MSIZE} ${MSIZE} > maze.txt

solve:
	iverilog -g2012 -o maze -c maze.fl -DMAZE_SEED=34 -DMAZE_SIZE=${MSIZE}
	vvp -n maze


run:
	python3 run.py

clean:
	-rm *.vcd
	-rm *.log
	-rm *.txt
	-rm result.yaml
	-rm maze
