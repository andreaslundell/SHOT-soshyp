$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*          7        1        0        6        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*          9        9        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         21       13        8        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,objvar;

Equations  e1,e2,e3,e4,e5,e6,e7;


e1..  - x1 - x2 - x3 + objvar =E= 0;

e2..    0.0025*x4 + 0.0025*x6 =L= 1;

e3..  - 0.0025*x4 + 0.0025*x5 + 0.0025*x7 =L= 1;

e4..  - 0.01*x5 + 0.01*x8 =L= 1;

e5.. 100*x1 - x1*x6 + 833.33252*x4 =L= 83333.333;

e6.. x2*x4 - x2*x7 - 1250*x4 + 1250*x5 =L= 0;

e7.. x3*x5 - x3*x8 - 2500*x5 =L= -1250000;

* set non-default bounds
x1.lo = 100; x1.up = 10000;
x2.lo = 1000; x2.up = 10000;
x3.lo = 1000; x3.up = 10000;
x4.lo = 10; x4.up = 1000;
x5.lo = 10; x5.up = 1000;
x6.lo = 10; x6.up = 1000;
x7.lo = 10; x7.up = 1000;
x8.lo = 10; x8.up = 1000;

* set non-default levels
x1.l = 579.19;
x2.l = 1360.13;
x3.l = 5109.92;
x4.l = 182.01;
x5.l = 295.6;
x6.l = 217.99;
x7.l = 286.4;
x8.l = 395.6;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
