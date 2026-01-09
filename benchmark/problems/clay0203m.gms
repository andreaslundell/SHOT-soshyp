$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         55        7       12       36        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         31       13       18        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        169      121       48        0
*
*  Solve m using MINLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19
          ,b20,b21,b22,b23,b24,x25,x26,x27,x28,x29,x30,objvar;

Positive Variables  x25,x26,x27,x28,x29,x30;

Binary Variables  b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20,b21,b22
          ,b23,b24;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46,e47,e48,e49,e50,e51,e52,e53
          ,e54,e55;


e1..  - 300*x25 - 240*x26 - 100*x27 - 300*x28 - 240*x29 - 100*x30 + objvar
      =E= 0;

e2..  - x1 + x2 + x25 =G= 0;

e3..  - x1 + x3 + x26 =G= 0;

e4..  - x2 + x3 + x27 =G= 0;

e5..    x1 - x2 + x25 =G= 0;

e6..    x1 - x3 + x26 =G= 0;

e7..    x2 - x3 + x27 =G= 0;

e8..  - x4 + x5 + x28 =G= 0;

e9..  - x4 + x6 + x29 =G= 0;

e10..  - x5 + x6 + x30 =G= 0;

e11..    x4 - x5 + x28 =G= 0;

e12..    x4 - x6 + x29 =G= 0;

e13..    x5 - x6 + x30 =G= 0;

e14..    x1 - x2 + 46*b7 =L= 40;

e15..    x1 - x3 + 46*b8 =L= 42;

e16..    x2 - x3 + 46*b9 =L= 41;

e17..  - x1 + x2 + 46*b10 =L= 40;

e18..  - x1 + x3 + 46*b11 =L= 42;

e19..  - x2 + x3 + 46*b12 =L= 41;

e20..    x4 - x5 + 81*b13 =L= 75.5;

e21..    x4 - x6 + 81*b14 =L= 76.5;

e22..    x5 - x6 + 81*b15 =L= 77;

e23..  - x4 + x5 + 81*b16 =L= 75.5;

e24..  - x4 + x6 + 81*b17 =L= 76.5;

e25..  - x5 + x6 + 81*b18 =L= 77;

e26..    b7 + b10 + b13 + b16 =E= 1;

e27..    b8 + b11 + b14 + b17 =E= 1;

e28..    b9 + b12 + b15 + b18 =E= 1;

e29.. sqr((-17.5) + x1) + sqr((-7) + x4) + 6814*b19 =L= 6850;

e30.. sqr((-18.5) + x2) + sqr((-7.5) + x5) + 6678*b20 =L= 6714;

e31.. sqr((-16.5) + x3) + sqr((-8.5) + x6) + 6958*b21 =L= 6994;

e32.. sqr((-52.5) + x1) + sqr((-77) + x4) + 6556*b22 =L= 6581;

e33.. sqr((-53.5) + x2) + sqr((-77.5) + x5) + 6697*b23 =L= 6722;

e34.. sqr((-51.5) + x3) + sqr((-78.5) + x6) + 6985*b24 =L= 7010;

e35.. sqr((-17.5) + x1) + sqr((-13) + x4) + 5950*b19 =L= 5986;

e36.. sqr((-18.5) + x2) + sqr((-12.5) + x5) + 5953*b20 =L= 5989;

e37.. sqr((-16.5) + x3) + sqr((-11.5) + x6) + 6517*b21 =L= 6553;

e38.. sqr((-52.5) + x1) + sqr((-83) + x4) + 7432*b22 =L= 7457;

e39.. sqr((-53.5) + x2) + sqr((-82.5) + x5) + 7432*b23 =L= 7457;

e40.. sqr((-51.5) + x3) + sqr((-81.5) + x6) + 7432*b24 =L= 7457;

e41.. sqr((-12.5) + x1) + sqr((-7) + x4) + 7189*b19 =L= 7225;

e42.. sqr((-11.5) + x2) + sqr((-7.5) + x5) + 7189*b20 =L= 7225;

e43.. sqr((-13.5) + x3) + sqr((-8.5) + x6) + 7189*b21 =L= 7225;

e44.. sqr((-47.5) + x1) + sqr((-77) + x4) + 6171*b22 =L= 6196;

e45.. sqr((-46.5) + x2) + sqr((-77.5) + x5) + 6172*b23 =L= 6197;

e46.. sqr((-48.5) + x3) + sqr((-78.5) + x6) + 6748*b24 =L= 6773;

e47.. sqr((-12.5) + x1) + sqr((-13) + x4) + 6325*b19 =L= 6361;

e48.. sqr((-11.5) + x2) + sqr((-12.5) + x5) + 6464*b20 =L= 6500;

e49.. sqr((-13.5) + x3) + sqr((-11.5) + x6) + 6748*b21 =L= 6784;

e50.. sqr((-47.5) + x1) + sqr((-83) + x4) + 7047*b22 =L= 7072;

e51.. sqr((-46.5) + x2) + sqr((-82.5) + x5) + 6907*b23 =L= 6932;

e52.. sqr((-48.5) + x3) + sqr((-81.5) + x6) + 7195*b24 =L= 7220;

e53..    b19 + b22 =E= 1;

e54..    b20 + b23 =E= 1;

e55..    b21 + b24 =E= 1;

* set non-default bounds
x1.lo = 11.5; x1.up = 52.5;
x2.lo = 12.5; x2.up = 51.5;
x3.lo = 10.5; x3.up = 53.5;
x4.lo = 7; x4.up = 82;
x5.lo = 6.5; x5.up = 82.5;
x6.lo = 5.5; x6.up = 83.5;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
