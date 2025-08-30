$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*          3        1        0        2        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*          3        3        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*          7        4        3        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,objvar;

Positive Variables  x2;

Equations  e1,e2,e3;


e1..  - x1 + x2 =L= 8;

e2.. (-sqr(x1)) - 2*x1 + x2 =L= -2;

e3.. -(POWER(x1,4) - 14*sqr(x1) + 24*x1 - sqr(x2)) + objvar =E= 0;

* set non-default bounds
x1.lo = -8; x1.up = 10;
x2.up = 10;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
