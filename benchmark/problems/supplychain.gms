$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         31        7        0       24        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         28       25        3        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        124      118        6        0
*
*  Solve m using MINLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,x20,x21,x22,x23,x24,b25,b26,b27,objvar;

Positive Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19,x20,x21,x22,x23,x24;

Binary Variables  b25,b26,b27;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31;


e1..  - 66.5*x1 - 522.5*x2 - 750.5*x3 - 125.6*x4 - 612.3*x5 - 628*x6 - 69*x7
      - 32.2*x8 - 151.8*x9 - 655.2*x10 - 175.5*x11 - 468*x12 - 330*x13
      - 375*x14 - 75*x15 - 1728*x16 - 1190.4*x17 - 172.8*x18
      - 24.5108139399735*x19 - 24.5071418162135*x20 - 24.5120378589786*x21
      - 0.2352*x22 - 0.2352*x23 - 0.2352*x24 - 100*b25 - 100*b26 - 100*b27
      + objvar =E= 0;

e2..    x1 + x2 + x3 =E= 1;

e3..    x4 + x5 + x6 =E= 1;

e4..    x7 + x8 + x9 =E= 1;

e5..    x10 + x11 + x12 =E= 1;

e6..    x13 + x14 + x15 =E= 1;

e7..    x16 + x17 + x18 =E= 1;

e8..    x1 - b25 =L= 0;

e9..    x2 - b26 =L= 0;

e10..    x3 - b27 =L= 0;

e11..    x4 - b25 =L= 0;

e12..    x5 - b26 =L= 0;

e13..    x6 - b27 =L= 0;

e14..    x7 - b25 =L= 0;

e15..    x8 - b26 =L= 0;

e16..    x9 - b27 =L= 0;

e17..    x10 - b25 =L= 0;

e18..    x11 - b26 =L= 0;

e19..    x12 - b27 =L= 0;

e20..    x13 - b25 =L= 0;

e21..    x14 - b26 =L= 0;

e22..    x15 - b27 =L= 0;

e23..    x16 - b25 =L= 0;

e24..    x17 - b26 =L= 0;

e25..    x18 - b27 =L= 0;

e26.. -sqr(x19) + 95*x1 + 157*x4 + 46*x7 + 234*x10 + 75*x13 + 192*x16 =L= 0;

e27.. -sqr(x20) + 95*x2 + 157*x5 + 46*x8 + 234*x11 + 75*x14 + 192*x17 =L= 0;

e28.. -sqr(x21) + 95*x3 + 157*x6 + 46*x9 + 234*x12 + 75*x15 + 192*x18 =L= 0;

e29.. -sqr(x22) + 6300*x1 + 17500*x4 + 4375*x7 + 44800*x10 + 4375*x13
       + 44800*x16 =L= 0;

e30.. -sqr(x23) + 6300*x2 + 17500*x5 + 4375*x8 + 44800*x11 + 4375*x14
       + 44800*x17 =L= 0;

e31.. -sqr(x24) + 6300*x3 + 17500*x6 + 4375*x9 + 44800*x12 + 4375*x15
       + 44800*x18 =L= 0;

* set non-default bounds
x1.up = 1;
x2.up = 1;
x3.up = 1;
x4.up = 1;
x5.up = 1;
x6.up = 1;
x7.up = 1;
x8.up = 1;
x9.up = 1;
x10.up = 1;
x11.up = 1;
x12.up = 1;
x13.up = 1;
x14.up = 1;
x15.up = 1;
x16.up = 1;
x17.up = 1;
x18.up = 1;
x19.up = 28.2665880502051;
x20.up = 28.2665880502051;
x21.up = 28.2665880502051;
x22.up = 349.499642346026;
x23.up = 349.499642346026;
x24.up = 349.499642346026;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
