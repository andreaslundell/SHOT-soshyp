$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         10        0        0       10        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*          9        9        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         38       14       24        0
*
*  Solve m using NLP maximizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,objvar;

Positive Variables  x3,x4,x5,x6,x7,x8;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10;


e1.. 2*x1*x2 - x1*x1 - x2*x2 - x5*x5 + 2*x5*x6 - x6*x6 + objvar =L= 0;

e2.. 2*x1*x3 - x1*x1 - x3*x3 - x5*x5 + 2*x5*x7 - x7*x7 + objvar =L= 0;

e3.. 2*x1*x4 - x1*x1 - x4*x4 - x5*x5 + 2*x5*x8 - x8*x8 + objvar =L= 0;

e4.. 2*x2*x3 - x2*x2 - x3*x3 - x6*x6 + 2*x6*x7 - x7*x7 + objvar =L= 0;

e5.. 2*x2*x4 - x2*x2 - x4*x4 - x6*x6 + 2*x6*x8 - x8*x8 + objvar =L= 0;

e6.. 2*x3*x4 - x3*x3 - x4*x4 - x7*x7 + 2*x7*x8 - x8*x8 + objvar =L= 0;

e7..  - x5 + x6 =L= 0;

e8..  - x1 + x2 =L= 0;

e9..  - x2 + x3 =L= 0;

e10..  - x3 + x4 =L= 0;

* set non-default bounds
x1.lo = 0.5; x1.up = 1;
x2.lo = 0.5; x2.up = 1;
x3.up = 1;
x4.up = 1;
x5.up = 1;
x6.up = 1;
x7.up = 1;
x8.up = 1;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% maximizing objvar;
