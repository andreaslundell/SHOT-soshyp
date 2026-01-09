$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         31        2       15       14        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         16       16        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         91       29       62        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,objvar;

Positive Variables  x14,x15;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31;


e1..  - x1 + objvar =E= -22.8393785915978;

e2.. -x14*x15 + x1 =E= 0;

e3.. (x2 - x4)*(x2 - x4) + (x3 - x5)*(x3 - x5) =G= 3.24;

e4.. (x2 - x6)*(x2 - x6) + (x3 - x7)*(x3 - x7) =G= 4;

e5.. (x2 - x8)*(x2 - x8) + (x3 - x9)*(x3 - x9) =G= 8.41;

e6.. (x2 - x10)*(x2 - x10) + (x3 - x11)*(x3 - x11) =G= 2.89;

e7.. (x2 - x12)*(x2 - x12) + (x3 - x13)*(x3 - x13) =G= 6.25;

e8.. (x4 - x6)*(x4 - x6) + (x5 - x7)*(x5 - x7) =G= 1.96;

e9.. (x4 - x8)*(x4 - x8) + (x5 - x9)*(x5 - x9) =G= 5.29;

e10.. (x4 - x10)*(x4 - x10) + (x5 - x11)*(x5 - x11) =G= 1.21;

e11.. (x4 - x12)*(x4 - x12) + (x5 - x13)*(x5 - x13) =G= 3.61;

e12.. (x6 - x8)*(x6 - x8) + (x7 - x9)*(x7 - x9) =G= 6.25;

e13.. (x6 - x10)*(x6 - x10) + (x7 - x11)*(x7 - x11) =G= 1.69;

e14.. (x6 - x12)*(x6 - x12) + (x7 - x13)*(x7 - x13) =G= 4.41;

e15.. (x8 - x10)*(x8 - x10) + (x9 - x11)*(x9 - x11) =G= 4.84;

e16.. (x8 - x12)*(x8 - x12) + (x9 - x13)*(x9 - x13) =G= 9;

e17.. (x10 - x12)*(x10 - x12) + (x11 - x13)*(x11 - x13) =G= 3.24;

e18..    x2 - x14 =L= -1.2;

e19..    x3 - x15 =L= -1.2;

e20..    x4 - x14 =L= -0.6;

e21..    x5 - x15 =L= -0.6;

e22..    x6 - x14 =L= -0.8;

e23..    x7 - x15 =L= -0.8;

e24..    x8 - x14 =L= -1.7;

e25..    x9 - x15 =L= -1.7;

e26..    x10 - x14 =L= -0.5;

e27..    x11 - x15 =L= -0.5;

e28..    x12 - x14 =L= -1.3;

e29..    x13 - x15 =L= -1.3;

e30..    x2 =L= 4;

e31..    x3 =L= 2;

* set non-default bounds
x1.lo = 2.89; x1.up = 32;
x2.lo = 1.2; x2.up = 6.8;
x3.lo = 1.2; x3.up = 2.8;
x4.lo = 0.6; x4.up = 7.4;
x5.lo = 0.6; x5.up = 3.4;
x6.lo = 0.8; x6.up = 7.2;
x7.lo = 0.8; x7.up = 3.2;
x8.lo = 1.7; x8.up = 6.3;
x9.lo = 1.7; x9.up = 2.3;
x10.lo = 0.5; x10.up = 7.5;
x11.lo = 0.5; x11.up = 3.5;
x12.lo = 1.3; x12.up = 6.7;
x13.lo = 1.3; x13.up = 2.7;
x14.up = 8;
x15.up = 4;
objvar.lo = 0; objvar.up = 32;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
