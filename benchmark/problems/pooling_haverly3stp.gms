$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         19       11        0        8        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         15       15        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         57       41       16        0
*
*  Solve m using NLP minimizing objvar;


Variables  objvar,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15;

Positive Variables  x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19;


e1..    objvar - x4 + 5*x5 + 3*x12 + 9*x13 - 4*x14 + 2*x15 =E= 0;

e2..    x12 + x13 =L= 300;

e3..    x14 + x15 =L= 300;

e4..    x4 + x5 =L= 300;

e5..    x12 + x13 + x14 + x15 =L= 300;

e6..    x4 + x12 + x14 =L= 100;

e7..    x5 + x13 + x15 =L= 200;

e8..  - 0.5*x4 + 0.5*x12 - 1.5*x14 =L= 0;

e9..    0.5*x5 + 1.5*x13 - 0.5*x15 =L= 0;

e10..    x8 + x9 =E= 1;

e11..    x10 + x11 =E= 1;

e12.. -x8*x6 + x12 =E= 0;

e13.. -x8*x7 + x13 =E= 0;

e14.. -x9*x6 + x14 =E= 0;

e15.. -x9*x7 + x15 =E= 0;

e16.. -x10*x2 + x12 =E= 0;

e17.. -x11*x2 + x13 =E= 0;

e18.. -x10*x3 + x14 =E= 0;

e19.. -x11*x3 + x15 =E= 0;

* set non-default bounds
x2.up = 300;
x3.up = 300;
x4.up = 100;
x5.up = 200;
x6.up = 100;
x7.up = 200;
x8.up = 1;
x9.up = 1;
x10.up = 1;
x11.up = 1;
x12.up = 100;
x13.up = 200;
x14.up = 100;
x15.up = 200;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
