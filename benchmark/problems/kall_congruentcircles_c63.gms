$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         46        2       15       29        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         16       16        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        121       59       62        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,objvar;

Positive Variables  x14,x15;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46;


e1..  - x1 + objvar =E= -4.71238898038469;

e2.. -x14*x15 + x1 =E= 0;

e3.. (x2 - x4)*(x2 - x4) + (x3 - x5)*(x3 - x5) =G= 1;

e4.. (x2 - x6)*(x2 - x6) + (x3 - x7)*(x3 - x7) =G= 1;

e5.. (x2 - x8)*(x2 - x8) + (x3 - x9)*(x3 - x9) =G= 1;

e6.. (x2 - x10)*(x2 - x10) + (x3 - x11)*(x3 - x11) =G= 1;

e7.. (x2 - x12)*(x2 - x12) + (x3 - x13)*(x3 - x13) =G= 1;

e8.. (x4 - x6)*(x4 - x6) + (x5 - x7)*(x5 - x7) =G= 1;

e9.. (x4 - x8)*(x4 - x8) + (x5 - x9)*(x5 - x9) =G= 1;

e10.. (x4 - x10)*(x4 - x10) + (x5 - x11)*(x5 - x11) =G= 1;

e11.. (x4 - x12)*(x4 - x12) + (x5 - x13)*(x5 - x13) =G= 1;

e12.. (x6 - x8)*(x6 - x8) + (x7 - x9)*(x7 - x9) =G= 1;

e13.. (x6 - x10)*(x6 - x10) + (x7 - x11)*(x7 - x11) =G= 1;

e14.. (x6 - x12)*(x6 - x12) + (x7 - x13)*(x7 - x13) =G= 1;

e15.. (x8 - x10)*(x8 - x10) + (x9 - x11)*(x9 - x11) =G= 1;

e16.. (x8 - x12)*(x8 - x12) + (x9 - x13)*(x9 - x13) =G= 1;

e17.. (x10 - x12)*(x10 - x12) + (x11 - x13)*(x11 - x13) =G= 1;

e18..    x2 - x14 =L= -0.5;

e19..    x3 - x15 =L= -0.5;

e20..    x4 - x14 =L= -0.5;

e21..    x5 - x15 =L= -0.5;

e22..    x6 - x14 =L= -0.5;

e23..    x7 - x15 =L= -0.5;

e24..    x8 - x14 =L= -0.5;

e25..    x9 - x15 =L= -0.5;

e26..    x10 - x14 =L= -0.5;

e27..    x11 - x15 =L= -0.5;

e28..    x12 - x14 =L= -0.5;

e29..    x13 - x15 =L= -0.5;

e30..    x2 =L= 4;

e31..    x3 =L= 0.95;

e32..    x2 - x4 =L= 0;

e33..    x2 - x6 =L= 0;

e34..    x2 - x8 =L= 0;

e35..    x2 - x10 =L= 0;

e36..    x2 - x12 =L= 0;

e37..    x4 - x6 =L= 0;

e38..    x4 - x8 =L= 0;

e39..    x4 - x10 =L= 0;

e40..    x4 - x12 =L= 0;

e41..    x6 - x8 =L= 0;

e42..    x6 - x10 =L= 0;

e43..    x6 - x12 =L= 0;

e44..    x8 - x10 =L= 0;

e45..    x8 - x12 =L= 0;

e46..    x10 - x12 =L= 0;

* set non-default bounds
x1.lo = 0.25; x1.up = 15.2;
x2.lo = 0.5; x2.up = 7.5;
x3.lo = 0.5; x3.up = 1.4;
x4.lo = 0.5; x4.up = 7.5;
x5.lo = 0.5; x5.up = 1.4;
x6.lo = 0.5; x6.up = 7.5;
x7.lo = 0.5; x7.up = 1.4;
x8.lo = 0.5; x8.up = 7.5;
x9.lo = 0.5; x9.up = 1.4;
x10.lo = 0.5; x10.up = 7.5;
x11.lo = 0.5; x11.up = 1.4;
x12.lo = 0.5; x12.up = 7.5;
x13.lo = 0.5; x13.up = 1.4;
x14.up = 8;
x15.up = 1.9;
objvar.lo = 0; objvar.up = 15.2;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
