$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         17        8        0        9        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         14       14        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         58       46       12        0
*
*  Solve m using NLP minimizing objvar;


Variables  objvar,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14;

Positive Variables  x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17;


e1..    objvar + 3*x4 + 9*x5 - 6*x6 - 7*x8 - x9 - x13 + 5*x14 =E= 0;

e2..    x4 + x5 =L= 300;

e3..    x6 + x7 =L= 50;

e4..    x8 + x9 =L= 300;

e5..    x13 + x14 =L= 300;

e6..    x4 + x5 + x6 + x7 + x8 + x9 =L= 300;

e7..    x4 + x6 + x8 + x13 =L= 100;

e8..    x5 + x7 + x9 + x14 =L= 200;

e9..    0.5*x4 - 1.5*x6 - 1.5*x8 - 0.5*x13 =L= 0;

e10..    1.5*x5 - 0.5*x7 - 0.5*x9 + 0.5*x14 =L= 0;

e11..    x2 + x3 =E= 1;

e12.. -x2*x10 + x4 =E= 0;

e13.. -x3*x10 + x5 =E= 0;

e14.. -x2*x11 + x6 =E= 0;

e15.. -x3*x11 + x7 =E= 0;

e16.. -x2*x12 + x8 =E= 0;

e17.. -x3*x12 + x9 =E= 0;

* set non-default bounds
x2.up = 1;
x3.up = 1;
x4.up = 100;
x5.up = 200;
x6.up = 50;
x7.up = 50;
x8.up = 100;
x9.up = 200;
x10.up = 300;
x11.up = 50;
x12.up = 300;
x13.up = 100;
x14.up = 200;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
