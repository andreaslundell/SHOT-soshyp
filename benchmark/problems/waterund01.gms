$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         39       21        2       16        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         41       41        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        153       75       78        0
*
*  Solve m using NLP minimizing objvar;


Variables  objvar,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18
          ,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35
          ,x36,x37,x38,x39,x40,x41;

Positive Variables  x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34
          ,x35,x36,x37,x38,x39,x40,x41;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39;


e1..    objvar - x2 - x3 - x4 - x5 =E= 0;

e2..  - x2 + x6 - x14 - x18 - x22 - x26 =E= 0;

e3..  - x3 + x7 - x15 - x19 - x23 - x27 =E= 0;

e4..  - x4 + x8 - x16 - x20 - x24 - x28 =E= 0;

e5..  - x5 - x17 - x21 - x25 - x29 =E= -70;

e6..    x6 - x10 - x14 - x15 - x16 - x17 =E= 0;

e7..    x7 - x11 - x18 - x19 - x20 - x21 =E= 0;

e8..    x8 - x12 - x22 - x23 - x24 - x25 =E= 0;

e9..  - x13 - x26 - x27 - x28 - x29 =E= -60;

e10.. x6*x30 - (x14*x36 + x18*x38 + x22*x40) - 250*x26 =E= 0;

e11.. x6*x31 - (x14*x37 + x18*x39 + x22*x41) - 100*x26 =E= 0;

e12.. x7*x32 - (x15*x36 + x19*x38 + x23*x40) - 250*x27 =E= 0;

e13.. x7*x33 - (x15*x37 + x19*x39 + x23*x41) - 100*x27 =E= 0;

e14.. x8*x34 - (x16*x36 + x20*x38 + x24*x40) - 250*x28 =E= 0;

e15.. x8*x35 - (x16*x37 + x20*x39 + x24*x41) - 100*x28 =E= 0;

e16.. -x6*(x36 - x30) =E= -690;

e17.. -x6*(x37 - x31) =E= -1380;

e18.. -x7*(x38 - x32) =E= -2350;

e19.. -x7*(x39 - x33) =E= -2820;

e20.. -x8*(x40 - x34) =E= -6150;

e21.. -x8*(x41 - x35) =E= -18450;

e22..    x30 =L= 20;

e23..    x31 =L= 60;

e24..    x32 =L= 50;

e25..    x33 =L= 20;

e26..    x34 =L= 100;

e27..    x35 =L= 150;

e28..    x36 =L= 50;

e29..    x37 =L= 120;

e30..    x38 =L= 100;

e31..    x39 =L= 80;

e32..    x40 =L= 150;

e33..    x41 =L= 300;

e34.. -(x17*x36 + x21*x38 + x25*x40) - 250*x29 =G= -14000;

e35.. -(x17*x37 + x21*x39 + x25*x41) - 100*x29 =G= -5600;

e36..    x6 =L= 23;

e37..    x7 =L= 47;

e38..    x8 =L= 123;

e39..    x9 =L= 0;

* set non-default bounds
x2.up = 100000;
x3.up = 100000;
x4.up = 100000;
x5.up = 100000;
x6.up = 100000;
x7.up = 100000;
x8.up = 100000;
x9.up = 100000;
x10.up = 100000;
x11.up = 100000;
x12.up = 100000;
x13.up = 100000;
x14.up = 100000;
x15.up = 100000;
x16.up = 100000;
x17.up = 100000;
x18.up = 100000;
x19.up = 100000;
x20.up = 100000;
x21.up = 100000;
x22.up = 100000;
x23.up = 100000;
x24.up = 100000;
x25.up = 100000;
x26.up = 100000;
x27.up = 100000;
x28.up = 100000;
x29.up = 100000;
x30.up = 100000;
x31.up = 100000;
x32.up = 100000;
x33.up = 100000;
x34.up = 100000;
x35.up = 100000;
x36.up = 100000;
x37.up = 100000;
x38.up = 100000;
x39.up = 100000;
x40.up = 100000;
x41.up = 100000;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
