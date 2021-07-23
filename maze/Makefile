
W=17
H=9
.PHONY:maze
maze:

	python3 maze.py ${W} ${H} > maze.txt

ps:
	iverilog -g2012 -o maze -c maze.fl -DMAZE_SEED=34 -DMAZE_WIDTH=${W} -DMAZE_HEIGHT=${H}
	vvp -n maze
