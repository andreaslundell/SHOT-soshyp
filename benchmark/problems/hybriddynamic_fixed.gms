$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         80       60       10       10        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         72       62       10        0        0        0        0        0
*  FX      2
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        190      179       11        0
*
*  Solve m using MINLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,b11,b12,b13,b14,b15,b16,b17,b18,b19
          ,b20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36
          ,x37,x38,x39,x40,x41,x42,x43,x44,x45,x46,x47,x48,x49,x50,x51,x52,x53
          ,x54,x55,x56,x57,x58,x59,x60,x61,x62,x63,x64,x65,x66,x67,x68,x69,x70
          ,x71,objvar;

Binary Variables  b11,b12,b13,b14,b15,b16,b17,b18,b19,b20;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46,e47,e48,e49,e50,e51,e52,e53
          ,e54,e55,e56,e57,e58,e59,e60,e61,e62,e63,e64,e65,e66,e67,e68,e69,e70
          ,e71,e72,e73,e74,e75,e76,e77,e78,e79,e80;


e1.. -(sqr((-1.66666666666667) + x71) + 0.2*sqr(x51) + 0.2*sqr(x52) + 0.2*sqr(
     x53) + 0.2*sqr(x54) + 0.2*sqr(x55) + 0.2*sqr(x56) + 0.2*sqr(x57) + 0.2*
     sqr(x58) + 0.2*sqr(x59) + 0.2*sqr(x60)) + objvar =E= 0;

e2..  - x31 + x41 =E= 0.2;

e3..  - x32 + x42 =E= 0.2;

e4..  - x33 + x43 =E= 0.2;

e5..  - x34 + x44 =E= 0.2;

e6..  - x35 + x45 =E= 0.2;

e7..  - x36 + x46 =E= 0.2;

e8..  - x37 + x47 =E= 0.2;

e9..  - x38 + x48 =E= 0.2;

e10..  - x39 + x49 =E= 0.2;

e11..  - x40 + x50 =E= 0.2;

e12..  - x21 + x51 - 0.2*x61 =E= 0;

e13..  - x22 + x52 - 0.2*x62 =E= 0;

e14..  - x23 + x53 - 0.2*x63 =E= 0;

e15..  - x24 + x54 - 0.2*x64 =E= 0;

e16..  - x25 + x55 - 0.2*x65 =E= 0;

e17..  - x26 + x56 - 0.2*x66 =E= 0;

e18..  - x27 + x57 - 0.2*x67 =E= 0;

e19..  - x28 + x58 - 0.2*x68 =E= 0;

e20..  - x29 + x59 - 0.2*x69 =E= 0;

e21..  - x30 + x60 - 0.2*x70 =E= 0;

e22..    x1 - 2*b11 =E= -1;

e23..    x2 - 2*b12 =E= -1;

e24..    x3 - 2*b13 =E= -1;

e25..    x4 - 2*b14 =E= -1;

e26..    x5 - 2*b15 =E= -1;

e27..    x6 - 2*b16 =E= -1;

e28..    x7 - 2*b17 =E= -1;

e29..    x8 - 2*b18 =E= -1;

e30..    x9 - 2*b19 =E= -1;

e31..    x10 - 2*b20 =E= -1;

e32..    2*b11 - x51 =L= 2;

e33..    2*b12 - x52 =L= 2;

e34..    2*b13 - x53 =L= 2;

e35..    2*b14 - x54 =L= 2;

e36..    2*b15 - x55 =L= 2;

e37..    2*b16 - x56 =L= 2;

e38..    2*b17 - x57 =L= 2;

e39..    2*b18 - x58 =L= 2;

e40..    2*b19 - x59 =L= 2;

e41..    2*b20 - x60 =L= 2;

e42..    2*b11 - x51 =G= 0;

e43..    2*b12 - x52 =G= 0;

e44..    2*b13 - x53 =G= 0;

e45..    2*b14 - x54 =G= 0;

e46..    2*b15 - x55 =G= 0;

e47..    2*b16 - x56 =G= 0;

e48..    2*b17 - x57 =G= 0;

e49..    2*b18 - x58 =G= 0;

e50..    2*b19 - x59 =G= 0;

e51..    2*b20 - x60 =G= 0;

e52..  - x31 + x32 =E= 0.2;

e53..  - x32 + x33 =E= 0.2;

e54..  - x33 + x34 =E= 0.2;

e55..  - x34 + x35 =E= 0.2;

e56..  - x35 + x36 =E= 0.2;

e57..  - x36 + x37 =E= 0.2;

e58..  - x37 + x38 =E= 0.2;

e59..  - x38 + x39 =E= 0.2;

e60..  - x39 + x40 =E= 0.2;

e61..  - x21 + x22 - 0.2*x61 =E= 0;

e62..  - x22 + x23 - 0.2*x62 =E= 0;

e63..  - x23 + x24 - 0.2*x63 =E= 0;

e64..  - x24 + x25 - 0.2*x64 =E= 0;

e65..  - x25 + x26 - 0.2*x65 =E= 0;

e66..  - x26 + x27 - 0.2*x66 =E= 0;

e67..  - x27 + x28 - 0.2*x67 =E= 0;

e68..  - x28 + x29 - 0.2*x68 =E= 0;

e69..  - x29 + x30 - 0.2*x69 =E= 0;

e70..  - x30 - 0.2*x70 + x71 =E= 0;

e71..    x1 + x61 =E= 2;

e72..    x2 + x62 =E= 2;

e73..    x3 + x63 =E= 2;

e74..    x4 + x64 =E= 2;

e75..    x5 + x65 =E= 2;

e76..    x6 + x66 =E= 2;

e77..    x7 + x67 =E= 2;

e78..    x8 + x68 =E= 2;

e79..    x9 + x69 =E= 2;

e80..    x10 + x70 =E= 2;

* set non-default bounds
x1.lo = -1; x1.up = 1;
x2.lo = -1; x2.up = 1;
x3.lo = -1; x3.up = 1;
x4.lo = -1; x4.up = 1;
x5.lo = -1; x5.up = 1;
x6.lo = -1; x6.up = 1;
x7.lo = -1; x7.up = 1;
x8.lo = -1; x8.up = 1;
x9.lo = -1; x9.up = 1;
x10.lo = -1; x10.up = 1;
x21.fx = -2;
x31.fx = 0;
x51.lo = -2; x51.up = 2;
x52.lo = -2; x52.up = 2;
x53.lo = -2; x53.up = 2;
x54.lo = -2; x54.up = 2;
x55.lo = -2; x55.up = 2;
x56.lo = -2; x56.up = 2;
x57.lo = -2; x57.up = 2;
x58.lo = -2; x58.up = 2;
x59.lo = -2; x59.up = 2;
x60.lo = -2; x60.up = 2;

* set non-default levels
x1.l = -1;
x2.l = -1;
x3.l = -1;
x4.l = -1;
x5.l = -1;
x6.l = -1;
x7.l = -1;
x8.l = -1;
x9.l = -1;
x10.l = -1;
x22.l = -2;
x23.l = -2;
x24.l = -2;
x25.l = -2;
x26.l = -2;
x27.l = -2;
x28.l = -2;
x29.l = -2;
x30.l = -2;
x32.l = 1;
x33.l = 1;
x34.l = 1;
x35.l = 1;
x36.l = 1;
x37.l = 1;
x38.l = 1;
x39.l = 1;
x40.l = 1;
x41.l = 1;
x42.l = 1;
x43.l = 1;
x44.l = 1;
x45.l = 1;
x46.l = 1;
x47.l = 1;
x48.l = 1;
x49.l = 1;
x50.l = 1;
x51.l = -2;
x52.l = -2;
x53.l = -2;
x54.l = -2;
x55.l = -2;
x56.l = -2;
x57.l = -2;
x58.l = -2;
x59.l = -2;
x60.l = -2;
x71.l = 1;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
