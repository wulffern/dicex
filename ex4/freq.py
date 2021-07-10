#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
import tikzplotlib

#- Get the input parameters
if(len(sys.argv) < 3):
    print("Usage python3 plot.py <file.csv> <y-name> <starttime> ")

fname = sys.argv[1]
yname = sys.argv[2]
start = float(sys.argv[3])

#- Read the csv, exlude times before start
df = pd.read_csv(fname,header=4)
df = df[df["Time"] > start]
df.set_index("Time",inplace=True)

#- Get the properties of the waveform, assume a 50% threshold
vmax = df[yname].max()
vmin = df[yname].min()
vth = (vmax  + vmin)/2
vhyst = vth*0.1

#- Find the time difference between vth up crossings.
# Add a hysteresis, so it's a bit more tolerant towards
# non-monotonic voltage rise
ser = df[yname]
state = ser[ser.index[0]] > vth
tlist = list()
prev = ser.index[0]
for i,v in ser.iteritems():
    if(state and v < (vth -vhyst )):
        state = False
    elif( not state and  v > (vth )):
        tdiff = i - prev
        tlist.append(tdiff)
        prev = i
        state = True

#- Get rid of the first element, it's
# probably wrong since it depends on start time
tlist.pop(0)

#- Report results
td = np.array(tlist)
f = 1/(td)
print("  f_max: %g" % f.max())
print("  f_mean: %g" % f.mean())
print("  f_min: %g" % f.min())
print("  t_max: %g" % td.max())
print("  t_mean: %g" % td.mean())
print("  t min: %g" % td.min())
