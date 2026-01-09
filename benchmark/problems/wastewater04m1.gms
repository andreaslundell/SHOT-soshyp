$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         22       16        0        6        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         24       24        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         90       58       32        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,x20,x21,x22,x23,objvar;

Positive Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19,x20,x21,x22,x23;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22;


e1..  - x22 - x23 + objvar =E= 0;

e2..  - x13 - x17 - x18 =E= -40;

e3..  - x14 - x19 - x20 =E= -40;

e4..  - x9 - x11 - x17 - x19 + x22 =E= 0;

e5..  - x10 - x12 - x18 - x20 + x23 =E= 0;

e6..  - x9 - x10 - x15 + x22 =E= 0;

e7..  - x11 - x12 - x16 + x23 =E= 0;

e8..  - x13 - x14 - x15 - x16 + x21 =E= 0;

e9.. x9*x5 + x11*x7 - x22*x1 + 100*x17 + 15*x19 =E= 0;

e10.. x9*x6 + x11*x8 - x22*x2 + 20*x17 + 200*x19 =E= 0;

e11.. x10*x5 + x12*x7 - x23*x3 + 100*x18 + 15*x20 =E= 0;

e12.. x10*x6 + x12*x8 - x23*x4 + 20*x18 + 200*x20 =E= 0;

e13..    x1 =L= 200;

e14..    x2 =L= 200;

e15..    x3 =L= 200;

e16..    x4 =L= 200;

e17..  - 0.05*x1 + x5 =E= 0;

e18..  - x2 + x6 =E= 0;

e19..  - x3 + x7 =E= 0;

e20..  - 0.024*x4 + x8 =E= 0;

e21.. x15*x5 + x16*x7 + 100*x13 + 15*x14 - 10*x21 =L= 0;

e22.. x15*x6 + x16*x8 + 20*x13 + 200*x14 - 10*x21 =L= 0;

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
x20.up = 1000000;
x21.up = 1000000;
x22.up = 1000000;
x23.up = 1000000;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
