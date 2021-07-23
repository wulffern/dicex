#!/usr/bin/env python3

import os
import yaml
import re

runs=5
data = dict()
best = 1e6;
worst = 0;

os.system(" date > run.log && make clean 2>> run.log 1>> run.log")
for r in range(0,runs):
    status = os.system("make maze solve 2>> run.log 1>> run.log")

    if(status):
        os.system("echo \"Note: no $ allowed in verilog file\" >> run.log")
        exit(status)
    else:
        with open("result.yaml","r") as fi:
            obj = yaml.safe_load(fi)

        data[r] = obj

        if( obj["done_cycles"] > worst):
            worst = obj["done_cycles"]

        if( obj["done_cycles"] < best):
            best = obj["done_cycles"]

        with open("maze.txt","r") as fi:
            obj["maze"] = fi.read()

        with open("path.txt","r") as fi:
            obj["path"] = fi.read()

results = dict()
results["c_best"] = best
results["c_worst"] = worst
results["runs"] = runs
results["data"] = data

with open("allresults.yaml","w") as fo:
    fo.write(yaml.dump(results))
