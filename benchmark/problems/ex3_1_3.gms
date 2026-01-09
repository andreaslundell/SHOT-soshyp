$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*          7        1        3        3        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*          7        7        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         19       11        8        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,objvar;

Positive Variables  x1,x2,x4,x6;

Equations  e1,e2,e3,e4,e5,e6,e7;


e1.. -(-25*sqr((-2) + x1) - sqr((-2) + x2) - sqr((-1) + x3) - sqr((-4) + x4) - 
     sqr((-1) + x5) - sqr((-4) + x6)) + objvar =E= 0;

e2.. sqr((-3) + x3) + x4 =G= 4;

e3.. sqr((-3) + x5) + x6 =G= 4;

e4..    x1 - 3*x2 =L= 2;

e5..  - x1 + x2 =L= 2;

e6..    x1 + x2 =L= 6;

e7..    x1 + x2 =G= 2;

* set non-default bounds
x3.lo = 1; x3.up = 5;
x4.up = 6;
x5.lo = 1; x5.up = 5;
x6.up = 10;

* set non-default levels
x1.l = 5;
x2.l = 1;
x3.l = 5;
x5.l = 5;
x6.l = 10;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
