#!/usr/bin/env python3

import yaml
import matplotlib.pyplot as plt
import tikzplotlib
import numpy as np

fname = "rosc_vdd"
with open(f"{fname}.yaml") as fi:
    obj = yaml.safe_load(fi)

x = list()
y = list()
for k in obj:
    x.append(k)
    v = obj[k]

    y.append(obj[k]["f_mean"])

x = np.array(x)
y = np.array(y)

dy = np.gradient(y)
dx = np.gradient(x)
d = dy/dx

plt.figure(figsize=(10,8    ))
plt.subplot(3,1,1)
plt.plot(x,y)
plt.ylabel("Frequency [Hz]")
#plt.xlabel("VDD [V]")
plt.grid()
plt.subplot(3,1,2)
plt.semilogy(x,y)
plt.ylabel("Frequency [Hz]")
plt.grid()

plt.subplot(3,1,3)
plt.plot(x,d)
plt.grid()
plt.ylabel("dFrequency/dVDD [f/V]")
plt.xlabel("VDD [V]")


tikzplotlib.save(fname+".pgf")

plt.show()
