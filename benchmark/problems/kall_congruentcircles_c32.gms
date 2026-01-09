$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         16        2        3       11        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         10       10        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         37       23       14        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,objvar;

Positive Variables  x8,x9;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16;


e1..  - x1 + objvar =E= -2.35619449019234;

e2.. -x8*x9 + x1 =E= 0;

e3.. (x2 - x4)*(x2 - x4) + (x3 - x5)*(x3 - x5) =G= 1;

e4.. (x2 - x6)*(x2 - x6) + (x3 - x7)*(x3 - x7) =G= 1;

e5.. (x4 - x6)*(x4 - x6) + (x5 - x7)*(x5 - x7) =G= 1;

e6..    x2 - x8 =L= -0.5;

e7..    x3 - x9 =L= -0.5;

e8..    x4 - x8 =L= -0.5;

e9..    x5 - x9 =L= -0.5;

e10..    x6 - x8 =L= -0.5;

e11..    x7 - x9 =L= -0.5;

e12..    x2 =L= 1.25;

e13..    x3 =L= 1;

e14..    x2 - x4 =L= 0;

e15..    x2 - x6 =L= 0;

e16..    x4 - x6 =L= 0;

* set non-default bounds
x1.lo = 0.25; x1.up = 5;
x2.lo = 0.5; x2.up = 2;
x3.lo = 0.5; x3.up = 1.5;
x4.lo = 0.5; x4.up = 2;
x5.lo = 0.5; x5.up = 1.5;
x6.lo = 0.5; x6.up = 2;
x7.lo = 0.5; x7.up = 1.5;
x8.up = 2.5;
x9.up = 2;
objvar.lo = 0; objvar.up = 5;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
