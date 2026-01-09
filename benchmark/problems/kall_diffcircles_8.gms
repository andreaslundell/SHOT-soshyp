$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         49        2       28       19        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         20       20        0        0        0        0        0        0
*  FX      1
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        153       39      114        0
*
*  Solve m using NLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,objvar;

Positive Variables  x18,x19;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46,e47,e48,e49;


e1..  - x1 + objvar =E= -40.7150407905237;

e2.. -x18*x19 + x1 =E= 0;

e3.. (x2 - x4)*(x2 - x4) + (x3 - x5)*(x3 - x5) =G= 3.24;

e4.. (x2 - x6)*(x2 - x6) + (x3 - x7)*(x3 - x7) =G= 4;

e5.. (x2 - x8)*(x2 - x8) + (x3 - x9)*(x3 - x9) =G= 8.41;

e6.. (x2 - x10)*(x2 - x10) + (x3 - x11)*(x3 - x11) =G= 2.89;

e7.. (x2 - x12)*(x2 - x12) + (x3 - x13)*(x3 - x13) =G= 6.25;

e8.. (x2 - x14)*(x2 - x14) + (x3 - x15)*(x3 - x15) =G= 10.24;

e9.. (x2 - x16)*(x2 - x16) + (x3 - x17)*(x3 - x17) =G= 6.25;

e10.. (x4 - x6)*(x4 - x6) + (x5 - x7)*(x5 - x7) =G= 1.96;

e11.. (x4 - x8)*(x4 - x8) + (x5 - x9)*(x5 - x9) =G= 5.29;

e12.. (x4 - x10)*(x4 - x10) + (x5 - x11)*(x5 - x11) =G= 1.21;

e13.. (x4 - x12)*(x4 - x12) + (x5 - x13)*(x5 - x13) =G= 3.61;

e14.. (x4 - x14)*(x4 - x14) + (x5 - x15)*(x5 - x15) =G= 6.76;

e15.. (x4 - x16)*(x4 - x16) + (x5 - x17)*(x5 - x17) =G= 3.61;

e16.. (x6 - x8)*(x6 - x8) + (x7 - x9)*(x7 - x9) =G= 6.25;

e17.. (x6 - x10)*(x6 - x10) + (x7 - x11)*(x7 - x11) =G= 1.69;

e18.. (x6 - x12)*(x6 - x12) + (x7 - x13)*(x7 - x13) =G= 4.41;

e19.. (x6 - x14)*(x6 - x14) + (x7 - x15)*(x7 - x15) =G= 7.84;

e20.. (x6 - x16)*(x6 - x16) + (x7 - x17)*(x7 - x17) =G= 4.41;

e21.. (x8 - x10)*(x8 - x10) + (x9 - x11)*(x9 - x11) =G= 4.84;

e22.. (x8 - x12)*(x8 - x12) + (x9 - x13)*(x9 - x13) =G= 9;

e23.. (x8 - x14)*(x8 - x14) + (x9 - x15)*(x9 - x15) =G= 13.69;

e24.. (x8 - x16)*(x8 - x16) + (x9 - x17)*(x9 - x17) =G= 9;

e25.. (x10 - x12)*(x10 - x12) + (x11 - x13)*(x11 - x13) =G= 3.24;

e26.. (x10 - x14)*(x10 - x14) + (x11 - x15)*(x11 - x15) =G= 6.25;

e27.. (x10 - x16)*(x10 - x16) + (x11 - x17)*(x11 - x17) =G= 3.24;

e28.. (x12 - x14)*(x12 - x14) + (x13 - x15)*(x13 - x15) =G= 10.89;

e29.. (x12 - x16)*(x12 - x16) + (x13 - x17)*(x13 - x17) =G= 6.76;

e30.. (x14 - x16)*(x14 - x16) + (x15 - x17)*(x15 - x17) =G= 10.89;

e31..    x2 - x18 =L= -1.2;

e32..    x3 - x19 =L= -1.2;

e33..    x4 - x18 =L= -0.6;

e34..    x5 - x19 =L= -0.6;

e35..    x6 - x18 =L= -0.8;

e36..    x7 - x19 =L= -0.8;

e37..    x8 - x18 =L= -1.7;

e38..    x9 - x19 =L= -1.7;

e39..    x10 - x18 =L= -0.5;

e40..    x11 - x19 =L= -0.5;

e41..    x12 - x18 =L= -1.3;

e42..    x13 - x19 =L= -1.3;

e43..    x14 - x18 =L= -2;

e44..    x15 - x19 =L= -2;

e45..    x16 - x18 =L= -1.3;

e46..    x17 - x19 =L= -1.3;

e47..    x2 =L= 9;

e48..    x3 =L= 2;

e49..    x12 - x16 =L= 0;

* set non-default bounds
x1.lo = 4; x1.up = 72;
x2.lo = 1.2; x2.up = 16.8;
x3.lo = 1.2; x3.up = 2.8;
x4.lo = 0.6; x4.up = 17.4;
x5.lo = 0.6; x5.up = 3.4;
x6.lo = 0.8; x6.up = 17.2;
x7.lo = 0.8; x7.up = 3.2;
x8.lo = 1.7; x8.up = 16.3;
x9.lo = 1.7; x9.up = 2.3;
x10.lo = 0.5; x10.up = 17.5;
x11.lo = 0.5; x11.up = 3.5;
x12.lo = 1.3; x12.up = 16.7;
x13.lo = 1.3; x13.up = 2.7;
x14.lo = 2; x14.up = 16;
x15.fx = 2;
x16.lo = 1.3; x16.up = 16.7;
x17.lo = 1.3; x17.up = 2.7;
x18.up = 18;
x19.up = 4;
objvar.lo = 0; objvar.up = 72;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
