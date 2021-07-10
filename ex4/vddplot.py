#!/usr/bin/env python3

import yaml
import matplotlib.pyplot as plt


with open("rosc_vdd.yaml") as fi:
    obj = yaml.safe_load(fi)

x = list()
y = list()
for k in obj:
    x.append(k)
    v = obj[k]

    y.append(obj[k]["f_mean"])


plt.subplot(2,1,1)
plt.plot(x,y)
plt.subplot(2,1,2)
plt.semilogy(x,y)
plt.show()
