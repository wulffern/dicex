#!/usr/bin/env python3
######################################################################
##        Copyright (c) 2021 Carsten Wulff Software, Norway
## ###################################################################
## Created       : wulff at 2021-8-10
## ###################################################################
##  The MIT License (MIT)
##
##  Permission is hereby granted, free of charge, to any person obtaining a copy
##  of this software and associated documentation files (the "Software"), to deal
##  in the Software without restriction, including without limitation the rights
##  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
##  copies of the Software, and to permit persons to whom the Software is
##  furnished to do so, subject to the following conditions:
##
##  The above copyright notice and this permission notice shall be included in all
##  copies or substantial portions of the Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
##  SOFTWARE.
##
######################################################################

import os
import yaml
import re
import random
import numpy as np

runs=5
data = dict()
best = 1e6;
worst = 0;

random.seed(a=None)




os.system(" date > run.log && make clean 2>> run.log 1>> run.log")
for r in range(0,runs):
    seed = int(random.random()*np.power(2,17))
    status = os.system(f"make mazev solve SEED={seed} 2>> run.log 1>> run.log")

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

        with open("turtle.txt","r") as fi:
            obj["turtle"] = fi.read()

        with open("path.txt","r") as fi:
            obj["path"] = fi.read()

results = dict()
results["c_best"] = best
results["c_worst"] = worst
results["runs"] = runs
results["data"] = data

with open("allresults.yaml","w") as fo:
    fo.write(yaml.dump(results))
