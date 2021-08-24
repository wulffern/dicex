# Maze generator and solver
To learn a programming language it won't help to sit down and just read a
manual. You have to have a problem that you want to solve, and then you use a
programming language to solve it.

In this folder you'll find verilog code for a maze generator, and a maze solver.

The solver (mazeEscaper.v) is intentionally bad, but the algorithm (keep one
hand on the wall) is sound. 

The generator is based on what I found when I googled "Maze generator algorithm"
and found the wikipedia page. It's an implementation of [Iterative Implementation](https://en.wikipedia.org/wiki/Maze_generation_algorithm)

If you make a better one, try to send it to carstenw@ntnu.no with the subject
"[TFE4152-Comp-Maze]" and see what happens (it will take about 5-10 minutes
before you get a response) ;-)

<img src="maze.gif" width="400" height="400">

# Files

```
├── lfsr.v              # Linear feedback shift register (see wikipedia)
├── Makefile            # How to run
├── mazeEscaper.v       # Verilog to escape the maze 
├── maze.fl             # File list for maze solver testbench
├── mazegen_tb.fl       # File list for maze generator testbench
├── mazegen_tb.v        # Maze generator testbench
├── mazegen.v           # Maze generator
├── maze_tb.v           # Maze solver testbench
├── maze.txt            # (Generated) The maze. write 'cat maze.txt' to see
├── path.txt            # (Generated) The path that the solver took
├── plotmaze.py         # Python script to animate the maze solving, requires maze.txt and turtle.txt
├── run.py              # Python script to run the maze, and collate results
└── turtle.txt          # (Generated) dump of x, and y coordinates that the maze solver followed
```

# Generate a maze

```sh
make mazev
```

# Solve the maze

```sh
make solve
```

# Run with random seed
```sh
make run
```

# See results after solving

```sh
cat results.yaml
```

# Show animation
This requires that pygame works

```sh
make plot
```




# The problem you should solve

Figure out how to improve the maze solver. How can you make it faster? Remember
to try different seeds, for example

```sh
make mazev solve SEED=21
```

# Known issues

- Above MSIZE=31 the generator fails, have not spent time figuring out why. The
  solver also fails
- The "bad" algorithm does really badly with MSIZE=31 and SEED=29. Nice to use
  for testing


