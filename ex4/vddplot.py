#!/usr/bin/env python3

import yaml
import matplotlib.pyplot as plt
import tikzplotlib

fname = "rosc_vdd"
with open(f"{fname}.yaml") as fi:
    obj = yaml.safe_load(fi)

x = list()
y = list()
for k in obj:
    x.append(k)
    v = obj[k]

    y.append(obj[k]["f_mean"])


plt.subplot(2,1,1)
plt.plot(x,y)
plt.ylabel("Frequency [Hz]")
#plt.xlabel("VDD [V]")
plt.grid()
plt.subplot(2,1,2)
plt.semilogy(x,y)
plt.ylabel("Frequency [Hz]")
plt.xlabel("VDD [V]")
plt.grid()

tikzplotlib.save(fname+".pgf")

plt.show()
