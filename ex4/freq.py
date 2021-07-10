#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
import tikzplotlib

if(len(sys.argv) < 3):
    print("Usage python3 plot.py <file.csv> <y-name> <starttime> ")

fname = sys.argv[1]
yname = sys.argv[2]
start = float(sys.argv[3])
df = pd.read_csv(fname,header=4)

df = df[df["Time"] > start]
df.set_index("Time",inplace=True)

vmax = df[yname].max()
vmin = df[yname].min()
vth = (vmax  + vmin)/2
vhyst = vth*0.1

ser = df[yname]
state = ser[ser.index[0]] > vth
tlist = list()
prev = ser.index[0]
for i,v in ser.iteritems():
    if(state and v < (vth )):
        tdiff = i - prev
        tlist.append(tdiff)
        state = False
        prev = i
    elif( not state and  v > (vth )):
        tdiff = i - prev
        tlist.append(tdiff)
        state = True
        prev = i

#- Get rid of the first element
tlist.pop(0)

td = np.array(tlist)
f = 1/(2*td)
print("Max frequency: %g" % f.max())
print("Avg frequency: %g" % f.mean())
print("Min frequency: %g" % f.min())
