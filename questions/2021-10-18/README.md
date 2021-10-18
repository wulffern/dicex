
# Question

The comparator works when I simulate it alone, but fails with convergence error
when I simulate in the full circuit

# Answer

## Step 1: reproduce statement

First, check that the comparator works by simplifying the problem. I made a
testbench
that only includes the comparator, and not much else

    ngspice -a comp.cir
    
And indeed, in this testbench the comparator works. However, the polarity seems
wrong, the comparator should start high, and go low.

**Fix 1: flip the polarity**


## Step 2: Include slightly more circuits

In comp_sensor_tb.cir I've included the sensor circuit also

    ngspice -a comp_sensor_tb.cir
    
Now, the comparator no longer switches. Since the only thing we've changed is
adding the sensor, then something on VSTORE must be affecting our comparator
circuit


If we plot the vo node it seems reasonable
If we plot the vo2 node, we can see it does not switch, that must mean the PMOS
is too weak. However, if we flip the polarity it seems to work
If we plot the vp node, it's very low. That must mean the PMOS have too high
current.

**Fix 2: Make mp1 and mp2 larger**
**Fix 3: Fix the polarity in the comparator, and not the TB**

## Step 3: Try a fix

First, replace the VS current source with a current mirror, and change mn3 in
the comparator to a constant current source. Then, make sure the pmos is strong
enough to pull vo2 to vdd. Make the mp1 and mp2 bigger.

    pixelSensor_fix.cir
    ngspice -a comp_sensor_fix_tb.cir


## Step 3: Try the full TB with fixed comparato

ngspice still freaks out, so something else is wrong. The main problem now is
is that it can't make the operational point analysis converge.

**Fix 4: Try relaxed tolerance by commenting out this line**
    *.option TNOM=27 GMIN=1e-15 reltol=1e-6 abstol=1e-6
    
And voila, it works.

If we wanted to, we could introduce one and one parameter to see which one makes
ngspice freak out.
