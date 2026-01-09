$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         53       37        0       16        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         49       49        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        216      152       64        0
*
*  Solve m using NLP minimizing objvar;


Variables  objvar,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18
          ,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35
          ,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45,x46,x47,x48,x49;

Positive Variables  x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34
          ,x35,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45,x46,x47,x48,x49;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46,e47,e48,e49,e50,e51,e52,e53;


e1..    objvar - x4 + 5*x5 - 4*x6 + 2*x7 + 2*x10 + 8*x11 - x12 + 5*x13 + 3*x34
      + 9*x35 + 6*x37 - 7*x38 - x39 - 10*x40 - 4*x41 + 6*x42 + 12*x43 + 3*x44
      + 9*x45 - 4*x46 + 2*x47 - 7*x48 - x49 =E= 0;

e2..    x34 + x35 + x36 + x37 =L= 600;

e3..    x38 + x39 + x40 + x41 =L= 600;

e4..    x4 + x5 + x6 + x7 =L= 600;

e5..    x42 + x43 + x44 + x45 =L= 600;

e6..    x46 + x47 + x48 + x49 =L= 600;

e7..    x10 + x11 + x12 + x13 =L= 600;

e8..    x34 + x35 + x36 + x37 + x38 + x39 + x40 + x41 =L= 600;

e9..    x42 + x43 + x44 + x45 + x46 + x47 + x48 + x49 =L= 600;

e10..    x4 + x10 + x34 + x38 + x42 + x46 =L= 100;

e11..    x5 + x11 + x35 + x39 + x43 + x47 =L= 200;

e12..    x6 + x12 + x36 + x40 + x44 + x48 =L= 100;

e13..    x7 + x13 + x37 + x41 + x45 + x49 =L= 200;

e14..  - 0.5*x4 + 0.5*x34 - 1.5*x38 + x42 - x46 =L= 0;

e15..    0.5*x5 + x11 + 1.5*x35 - 0.5*x39 + 2*x43 =L= 0;

e16..  - x6 - 0.5*x12 - 2*x40 + 0.5*x44 - 1.5*x48 =L= 0;

e17..    0.5*x13 + x37 - x41 + 1.5*x45 - 0.5*x49 =L= 0;

e18..    x22 + x23 =E= 1;

e19..    x24 + x25 =E= 1;

e20..    x26 + x27 + x28 + x29 =E= 1;

e21..    x30 + x31 + x32 + x33 =E= 1;

e22.. -x22*x14 + x34 =E= 0;

e23.. -x22*x15 + x35 =E= 0;

e24.. -x22*x16 + x36 =E= 0;

e25.. -x22*x17 + x37 =E= 0;

e26.. -x23*x14 + x38 =E= 0;

e27.. -x23*x15 + x39 =E= 0;

e28.. -x23*x16 + x40 =E= 0;

e29.. -x23*x17 + x41 =E= 0;

e30.. -x24*x18 + x42 =E= 0;

e31.. -x24*x19 + x43 =E= 0;

e32.. -x24*x20 + x44 =E= 0;

e33.. -x24*x21 + x45 =E= 0;

e34.. -x25*x18 + x46 =E= 0;

e35.. -x25*x19 + x47 =E= 0;

e36.. -x25*x20 + x48 =E= 0;

e37.. -x25*x21 + x49 =E= 0;

e38.. -x26*x2 + x34 =E= 0;

e39.. -x27*x2 + x35 =E= 0;

e40.. -x28*x2 + x36 =E= 0;

e41.. -x29*x2 + x37 =E= 0;

e42.. -x26*x3 + x38 =E= 0;

e43.. -x27*x3 + x39 =E= 0;

e44.. -x28*x3 + x40 =E= 0;

e45.. -x29*x3 + x41 =E= 0;

e46.. -x30*x8 + x42 =E= 0;

e47.. -x31*x8 + x43 =E= 0;

e48.. -x32*x8 + x44 =E= 0;

e49.. -x33*x8 + x45 =E= 0;

e50.. -x30*x9 + x46 =E= 0;

e51.. -x31*x9 + x47 =E= 0;

e52.. -x32*x9 + x48 =E= 0;

e53.. -x33*x9 + x49 =E= 0;

* set non-default bounds
x2.up = 600;
x3.up = 600;
x4.up = 100;
x5.up = 200;
x6.up = 100;
x7.up = 200;
x8.up = 600;
x9.up = 600;
x10.up = 100;
x11.up = 200;
x12.up = 100;
x13.up = 200;
x14.up = 100;
x15.up = 200;
x16.up = 100;
x17.up = 200;
x18.up = 100;
x19.up = 200;
x20.up = 100;
x21.up = 200;
x22.up = 1;
x23.up = 1;
x24.up = 1;
x25.up = 1;
x26.up = 1;
x27.up = 1;
x28.up = 1;
x29.up = 1;
x30.up = 1;
x31.up = 1;
x32.up = 1;
x33.up = 1;
x34.up = 100;
x35.up = 200;
x36.up = 100;
x37.up = 200;
x38.up = 100;
x39.up = 200;
x40.up = 100;
x41.up = 200;
x42.up = 100;
x43.up = 200;
x44.up = 100;
x45.up = 200;
x46.up = 100;
x47.up = 200;
x48.up = 100;
x49.up = 200;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
