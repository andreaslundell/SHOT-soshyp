$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         55        7       24       24        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         45       21       24        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        189      181        8        0
*
*  Solve m using MINLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19
          ,b20,b21,b22,b23,b24,b25,b26,b27,b28,b29,b30,b31,b32,x33,x34,x35,x36
          ,x37,x38,x39,x40,x41,x42,x43,x44,objvar;

Positive Variables  x33,x34,x35,x36,x37,x38,x39,x40,x41,x42,x43,x44;

Binary Variables  b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20,b21,b22,b23
          ,b24,b25,b26,b27,b28,b29,b30,b31,b32;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46,e47,e48,e49,e50,e51,e52,e53
          ,e54,e55;


e1.. -(150*(sqr((-4) + x1) + sqr((-10) + x5)) + 390*(sqr((-10) + x2) + sqr((-15
     ) + x6)) + 240*(sqr((-7) + x3) + sqr((-9) + x7)) + 70*(sqr((-3) + x4) + 
     sqr((-3) + x8))) - 300*x33 - 240*x34 - 210*x35 - 100*x36 - 150*x37
      - 120*x38 - 300*x39 - 240*x40 - 210*x41 - 100*x42 - 150*x43 - 120*x44
      + objvar =E= 0;

e2..  - x1 + x2 + x33 =G= 0;

e3..  - x1 + x3 + x34 =G= 0;

e4..  - x1 + x4 + x35 =G= 0;

e5..  - x2 + x3 + x36 =G= 0;

e6..  - x2 + x4 + x37 =G= 0;

e7..  - x3 + x4 + x38 =G= 0;

e8..    x1 - x2 + x33 =G= 0;

e9..    x1 - x3 + x34 =G= 0;

e10..    x1 - x4 + x35 =G= 0;

e11..    x2 - x3 + x36 =G= 0;

e12..    x2 - x4 + x37 =G= 0;

e13..    x3 - x4 + x38 =G= 0;

e14..  - x5 + x6 + x39 =G= 0;

e15..  - x5 + x7 + x40 =G= 0;

e16..  - x5 + x8 + x41 =G= 0;

e17..  - x6 + x7 + x42 =G= 0;

e18..  - x6 + x8 + x43 =G= 0;

e19..  - x7 + x8 + x44 =G= 0;

e20..    x5 - x6 + x39 =G= 0;

e21..    x5 - x7 + x40 =G= 0;

e22..    x5 - x8 + x41 =G= 0;

e23..    x6 - x7 + x42 =G= 0;

e24..    x6 - x8 + x43 =G= 0;

e25..    x7 - x8 + x44 =G= 0;

e26..    x1 - x2 + 30*b9 =L= 24;

e27..    x1 - x3 + 30*b10 =L= 26;

e28..    x1 - x4 + 30*b11 =L= 26.5;

e29..    x2 - x3 + 30*b12 =L= 25;

e30..    x2 - x4 + 30*b13 =L= 25.5;

e31..    x3 - x4 + 30*b14 =L= 27.5;

e32..  - x1 + x2 + 30*b15 =L= 24;

e33..  - x1 + x3 + 30*b16 =L= 26;

e34..  - x1 + x4 + 30*b17 =L= 26.5;

e35..  - x2 + x3 + 30*b18 =L= 25;

e36..  - x2 + x4 + 30*b19 =L= 25.5;

e37..  - x3 + x4 + 30*b20 =L= 27.5;

e38..    x5 - x6 + 30*b21 =L= 24.5;

e39..    x5 - x7 + 30*b22 =L= 25.5;

e40..    x5 - x8 + 30*b23 =L= 25.5;

e41..    x6 - x7 + 30*b24 =L= 26;

e42..    x6 - x8 + 30*b25 =L= 26;

e43..    x7 - x8 + 30*b26 =L= 27;

e44..  - x5 + x6 + 30*b27 =L= 24.5;

e45..  - x5 + x7 + 30*b28 =L= 25.5;

e46..  - x5 + x8 + 30*b29 =L= 25.5;

e47..  - x6 + x7 + 30*b30 =L= 26;

e48..  - x6 + x8 + 30*b31 =L= 26;

e49..  - x7 + x8 + 30*b32 =L= 27;

e50..    b9 + b15 + b21 + b27 =E= 1;

e51..    b10 + b16 + b22 + b28 =E= 1;

e52..    b11 + b17 + b23 + b29 =E= 1;

e53..    b12 + b18 + b24 + b30 =E= 1;

e54..    b13 + b19 + b25 + b31 =E= 1;

e55..    b14 + b20 + b26 + b32 =E= 1;

* set non-default bounds
x1.lo = 2.5; x1.up = 27.5;
x2.lo = 3.5; x2.up = 26.5;
x3.lo = 1.5; x3.up = 28.5;
x4.lo = 1; x4.up = 29;
x5.lo = 3; x5.up = 27;
x6.lo = 2.5; x6.up = 27.5;
x7.lo = 1.5; x7.up = 28.5;
x8.lo = 1.5; x8.up = 28.5;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
