# Comparator does not work

## Problem 

    make sim wrongplot


The problem with this circuit was that the wrong node was plotted (v(vp)). That
is the diode connected node on the pmos. It is not the output

## Solution
Plot the output node (v(vo))

    make sim plot


