$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*          3        0        0        3        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*          5        5        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*          9        5        4        0
*
*  Solve m using NLP maximizing objvar;


Variables  x1,x2,x3,x4,objvar;

Positive Variables  x2,x3,x4;

Equations  e1,e2,e3;


e1.. 2*x1*x2 - x1*x1 - x2*x2 - x3*x3 + 2*x3*x4 - x4*x4 + objvar =L= 0;

e2..  - x3 + x4 =L= 0;

e3..  - x1 + x2 =L= 0;

* set non-default bounds
x1.lo = 0.5; x1.up = 1;
x2.up = 1;
x3.up = 1;
x4.up = 1;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% maximizing objvar;
