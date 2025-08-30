$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*          8        1        0        7        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*          5        5        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         17       14        3        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,objvar;

Equations  e1,e2,e3,e4,e5,e6,e7,e8;


e1..  - x4 + objvar =E= 0;

e2.. POWER(x1,4)*POWER(x2,4) - POWER(x1,4) - POWER(x2,4)*x3 =L= 0;

e3..  - x1 - 0.25*x4 =L= -1.4;

e4..    x1 - 0.25*x4 =L= 1.4;

e5..  - x2 - 0.2*x4 =L= -1.5;

e6..    x2 - 0.2*x4 =L= 1.5;

e7..  - x3 - 0.2*x4 =L= -0.8;

e8..    x3 - 0.2*x4 =L= 0.8;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
