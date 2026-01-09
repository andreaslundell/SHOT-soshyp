$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         15       12        0        3        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         20       20        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         61       45       16        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,objvar;

Positive Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15;


e1..  - x18 - x19 + objvar =E= 0;

e2..  - x9 - x13 - x14 =E= -60;

e3..  - x10 - x15 - x16 =E= -20;

e4..  - x5 - x7 - x13 - x15 + x18 =E= 0;

e5..  - x6 - x8 - x14 - x16 + x19 =E= 0;

e6..  - x5 - x6 - x11 + x18 =E= 0;

e7..  - x7 - x8 - x12 + x19 =E= 0;

e8..  - x9 - x10 - x11 - x12 + x17 =E= 0;

e9.. x5*x3 + x7*x4 - x18*x1 + 400*x13 + 800*x15 =E= 0;

e10.. x6*x3 + x8*x4 - x19*x2 + 400*x14 + 800*x16 =E= 0;

e11..    x1 =L= 200;

e12..    x2 =L= 1000;

e13..  - 0.01*x1 + x3 =E= 0;

e14..  - 0.2*x2 + x4 =E= 0;

e15.. x11*x3 + x12*x4 + 400*x9 + 800*x10 - 10*x17 =L= 0;

* set non-default bounds
x1.up = 1000000;
x2.up = 1000000;
x3.up = 1000000;
x4.up = 1000000;
x5.up = 1000000;
x6.up = 1000000;
x7.up = 1000000;
x8.up = 1000000;
x9.up = 1000000;
x10.up = 1000000;
x11.up = 1000000;
x12.up = 1000000;
x13.up = 1000000;
x14.up = 1000000;
x15.up = 1000000;
x16.up = 1000000;
x17.up = 1000000;
x18.up = 1000000;
x19.up = 1000000;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
