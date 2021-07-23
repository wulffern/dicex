#!/usr/bin/env python3

import os
import yaml
import re

runs=5
data = dict()
best = 1e6;
worst = 0;
for r in range(0,runs):
    status = os.system("make maze solve > run.log")

    if(status):
        pass
    else:
        with open("result.yaml","r") as fi:
            obj = yaml.safe_load(fi)

        data[r] = obj

        if( obj["done_cycles"] > worst):
            worst = obj["done_cycles"]

        if( obj["done_cycles"] < best):
            best = obj["done_cycles"]

results = dict()
results["c_best"] = best
results["c_worst"] = worst
results["data"] = data

with open("allresults.yaml","w") as fo:
    fo.write(yaml.dump(results))
