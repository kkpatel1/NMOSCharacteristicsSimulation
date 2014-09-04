NMOSCharacteristicsSimulation
=============================

MATLAB Simulation of variation of Depletion Width of MOS when MOS is insantly switched on

An NMOS capacitor's gate voltage has been switched instantaneously at t=0 from a voltage V<sub>g</sub> < V<sub>th</sub> to a voltage larger than V<sub>th</sub>. We need to find time in which the inversion charge reaches 98% of its steady state value.

At `t=0+`, the depletion region becomes large and the entire gate charge is supported by depletion charge. As time progresses, thermally generated EHPs result into an inversion channel being formed and thus the depletion region also slowly acquires its steady state value.

Assume the depletion region width to be constan in a small time interval `dt` and estimate increase in inversion charge at the end of this time interval. In the next time interval `t+dt`, the depletion region becomes smaller to account for the increase in inversion charge.

Repeat such iterations till the inversion charge is acquires the 98% of its steady stage value. Repeat this for dt=T<sub>n</sub>/10, T<sub>n</sub>, 10T<sub>n</sub>.
