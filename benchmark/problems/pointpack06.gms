$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         21        0        0       21        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         13       13        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         87       27       60        0
*
*  Solve m using NLP maximizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,objvar;

Positive Variables  x4,x5,x6,x7,x8,x9,x10,x11,x12;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21;


e1.. 2*x1*x2 - x1*x1 - x2*x2 - x7*x7 + 2*x7*x8 - x8*x8 + objvar =L= 0;

e2.. 2*x1*x3 - x1*x1 - x3*x3 - x7*x7 + 2*x7*x9 - x9*x9 + objvar =L= 0;

e3.. 2*x1*x4 - x1*x1 - x4*x4 - x7*x7 + 2*x7*x10 - x10*x10 + objvar =L= 0;

e4.. 2*x1*x5 - x1*x1 - x5*x5 - x7*x7 + 2*x7*x11 - x11*x11 + objvar =L= 0;

e5.. 2*x1*x6 - x1*x1 - x6*x6 - x7*x7 + 2*x7*x12 - x12*x12 + objvar =L= 0;

e6.. 2*x2*x3 - x2*x2 - x3*x3 - x8*x8 + 2*x8*x9 - x9*x9 + objvar =L= 0;

e7.. 2*x2*x4 - x2*x2 - x4*x4 - x8*x8 + 2*x8*x10 - x10*x10 + objvar =L= 0;

e8.. 2*x2*x5 - x2*x2 - x5*x5 - x8*x8 + 2*x8*x11 - x11*x11 + objvar =L= 0;

e9.. 2*x2*x6 - x2*x2 - x6*x6 - x8*x8 + 2*x8*x12 - x12*x12 + objvar =L= 0;

e10.. 2*x3*x4 - x3*x3 - x4*x4 - x9*x9 + 2*x9*x10 - x10*x10 + objvar =L= 0;

e11.. 2*x3*x5 - x3*x3 - x5*x5 - x9*x9 + 2*x9*x11 - x11*x11 + objvar =L= 0;

e12.. 2*x3*x6 - x3*x3 - x6*x6 - x9*x9 + 2*x9*x12 - x12*x12 + objvar =L= 0;

e13.. 2*x4*x5 - x4*x4 - x5*x5 - x10*x10 + 2*x10*x11 - x11*x11 + objvar =L= 0;

e14.. 2*x4*x6 - x4*x4 - x6*x6 - x10*x10 + 2*x10*x12 - x12*x12 + objvar =L= 0;

e15.. 2*x5*x6 - x5*x5 - x6*x6 - x11*x11 + 2*x11*x12 - x12*x12 + objvar =L= 0;

e16..  - x7 + x8 =L= 0;

e17..  - x1 + x2 =L= 0;

e18..  - x2 + x3 =L= 0;

e19..  - x3 + x4 =L= 0;

e20..  - x4 + x5 =L= 0;

e21..  - x5 + x6 =L= 0;

* set non-default bounds
x1.lo = 0.5; x1.up = 1;
x2.lo = 0.5; x2.up = 1;
x3.lo = 0.5; x3.up = 1;
x4.up = 1;
x5.up = 1;
x6.up = 1;
x7.up = 1;
x8.up = 1;
x9.up = 1;
x10.up = 1;
x11.up = 1;
x12.up = 1;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% maximizing objvar;
