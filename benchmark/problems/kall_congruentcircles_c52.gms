$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         34        2       10       22        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         14       14        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         87       45       42        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,objvar;

Positive Variables  x12,x13;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34;


e1..  - x1 + objvar =E= -3.92699081698724;

e2.. -x12*x13 + x1 =E= 0;

e3.. (x2 - x4)*(x2 - x4) + (x3 - x5)*(x3 - x5) =G= 1;

e4.. (x2 - x6)*(x2 - x6) + (x3 - x7)*(x3 - x7) =G= 1;

e5.. (x2 - x8)*(x2 - x8) + (x3 - x9)*(x3 - x9) =G= 1;

e6.. (x2 - x10)*(x2 - x10) + (x3 - x11)*(x3 - x11) =G= 1;

e7.. (x4 - x6)*(x4 - x6) + (x5 - x7)*(x5 - x7) =G= 1;

e8.. (x4 - x8)*(x4 - x8) + (x5 - x9)*(x5 - x9) =G= 1;

e9.. (x4 - x10)*(x4 - x10) + (x5 - x11)*(x5 - x11) =G= 1;

e10.. (x6 - x8)*(x6 - x8) + (x7 - x9)*(x7 - x9) =G= 1;

e11.. (x6 - x10)*(x6 - x10) + (x7 - x11)*(x7 - x11) =G= 1;

e12.. (x8 - x10)*(x8 - x10) + (x9 - x11)*(x9 - x11) =G= 1;

e13..    x2 - x12 =L= -0.5;

e14..    x3 - x13 =L= -0.5;

e15..    x4 - x12 =L= -0.5;

e16..    x5 - x13 =L= -0.5;

e17..    x6 - x12 =L= -0.5;

e18..    x7 - x13 =L= -0.5;

e19..    x8 - x12 =L= -0.5;

e20..    x9 - x13 =L= -0.5;

e21..    x10 - x12 =L= -0.5;

e22..    x11 - x13 =L= -0.5;

e23..    x2 =L= 2;

e24..    x3 =L= 1;

e25..    x2 - x4 =L= 0;

e26..    x2 - x6 =L= 0;

e27..    x2 - x8 =L= 0;

e28..    x2 - x10 =L= 0;

e29..    x4 - x6 =L= 0;

e30..    x4 - x8 =L= 0;

e31..    x4 - x10 =L= 0;

e32..    x6 - x8 =L= 0;

e33..    x6 - x10 =L= 0;

e34..    x8 - x10 =L= 0;

* set non-default bounds
x1.lo = 0.25; x1.up = 8;
x2.lo = 0.5; x2.up = 3.5;
x3.lo = 0.5; x3.up = 1.5;
x4.lo = 0.5; x4.up = 3.5;
x5.lo = 0.5; x5.up = 1.5;
x6.lo = 0.5; x6.up = 3.5;
x7.lo = 0.5; x7.up = 1.5;
x8.lo = 0.5; x8.up = 3.5;
x9.lo = 0.5; x9.up = 1.5;
x10.lo = 0.5; x10.up = 3.5;
x11.lo = 0.5; x11.up = 1.5;
x12.up = 4;
x13.up = 2;
objvar.lo = 0; objvar.up = 8;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
