$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         62       17        5       40        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         25       25        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        526       58      468        0
*
*  Solve m using NLP minimizing objvar;


Variables  objvar,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18
          ,x19,x20,x21,x22,x23,x24,x25;

Positive Variables  x20,x21,x22,x23,x24,x25;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46,e47,e48,e49,e50,e51,e52,e53
          ,e54,e55,e56,e57,e58,e59,e60,e61,e62;


e1..    x2 =E= 1;

e2..    x3 =E= 0;

e3..    x4 =E= 0;

e4..    x5 =E= 0;

e5..    x6 =G= 0;

e6..    x7 - x8 =G= 0;

e7..    x8 - x9 =G= 0;

e8..    x9 - x10 =G= 0;

e9..    x10 =G= 0;

e10.. sqr(x2) + sqr(x3) + sqr(x4) =E= 1;

e11.. sqr(x6) + sqr(x11) + sqr(x5) =E= 1;

e12.. sqr(x7) + sqr(x12) + sqr(x13) =E= 1;

e13.. sqr(x8) + sqr(x14) + sqr(x15) =E= 1;

e14.. sqr(x9) + sqr(x16) + sqr(x17) =E= 1;

e15.. sqr(x10) + sqr(x18) + sqr(x19) =E= 1;

e16.. sqr(x2)*x20 + sqr(x6)*x21 + sqr(x7)*x22 + sqr(x8)*x23 + sqr(x9)*x24 + 
      sqr(x10)*x25 =E= 1;

e17.. x20*x2*x3 + x21*x6*x11 + x22*x7*x12 + x23*x8*x14 + x24*x9*x16 + x25*x10*
      x18 =E= 0;

e18.. x20*x2*x4 + x21*x6*x5 + x22*x7*x13 + x23*x8*x15 + x24*x9*x17 + x25*x10*
      x19 =E= 0;

e19.. sqr(x3)*x20 + sqr(x11)*x21 + sqr(x12)*x22 + sqr(x14)*x23 + sqr(x16)*x24
       + sqr(x18)*x25 =E= 1;

e20.. x20*x3*x4 + x21*x11*x5 + x22*x12*x13 + x23*x14*x15 + x24*x16*x17 + x25*
      x18*x19 =E= 0;

e21.. sqr(x4)*x20 + sqr(x5)*x21 + sqr(x13)*x22 + sqr(x15)*x23 + sqr(x17)*x24 + 
      sqr(x19)*x25 =E= 1;

e22..    x20 + x21 + x22 + x23 + x24 + x25 =E= 3;

e23.. x6*x12*x4 - x7*x11*x4 + x7*x3*x5 - x2*x12*x5 - x6*x3*x13 + x2*x11*x13
       - objvar =L= 0;

e24.. x7*x11*x4 - x6*x12*x4 - x7*x3*x5 + x2*x12*x5 + x6*x3*x13 - x2*x11*x13
       - objvar =L= 0;

e25.. x6*x14*x4 - x8*x11*x4 + x8*x3*x5 - x2*x14*x5 - x6*x3*x15 + x2*x11*x15
       - objvar =L= 0;

e26.. x8*x11*x4 - x6*x14*x4 - x8*x3*x5 + x2*x14*x5 + x6*x3*x15 - x2*x11*x15
       - objvar =L= 0;

e27.. x6*x16*x4 - x9*x11*x4 + x9*x3*x5 - x2*x16*x5 - x6*x3*x17 + x2*x11*x17
       - objvar =L= 0;

e28.. x9*x11*x4 - x6*x16*x4 - x9*x3*x5 + x2*x16*x5 + x6*x3*x17 - x2*x11*x17
       - objvar =L= 0;

e29.. x6*x18*x4 - x10*x11*x4 + x10*x3*x5 - x2*x18*x5 - x6*x3*x19 + x2*x11*x19
       - objvar =L= 0;

e30.. x10*x11*x4 - x6*x18*x4 - x10*x3*x5 + x2*x18*x5 + x6*x3*x19 - x2*x11*x19
       - objvar =L= 0;

e31.. x7*x14*x4 - x8*x12*x4 + x8*x3*x13 - x2*x14*x13 - x7*x3*x15 + x2*x12*x15
       - objvar =L= 0;

e32.. x8*x12*x4 - x7*x14*x4 - x8*x3*x13 + x2*x14*x13 + x7*x3*x15 - x2*x12*x15
       - objvar =L= 0;

e33.. x7*x16*x4 - x9*x12*x4 + x9*x3*x13 - x2*x16*x13 - x7*x3*x17 + x2*x12*x17
       - objvar =L= 0;

e34.. x9*x12*x4 - x7*x16*x4 - x9*x3*x13 + x2*x16*x13 + x7*x3*x17 - x2*x12*x17
       - objvar =L= 0;

e35.. x7*x18*x4 - x10*x12*x4 + x10*x3*x13 - x2*x18*x13 - x7*x3*x19 + x2*x12*x19
       - objvar =L= 0;

e36.. x10*x12*x4 - x7*x18*x4 - x10*x3*x13 + x2*x18*x13 + x7*x3*x19 - x2*x12*x19
       - objvar =L= 0;

e37.. x8*x16*x4 - x9*x14*x4 + x9*x3*x15 - x2*x16*x15 - x8*x3*x17 + x2*x14*x17
       - objvar =L= 0;

e38.. x9*x14*x4 - x8*x16*x4 - x9*x3*x15 + x2*x16*x15 + x8*x3*x17 - x2*x14*x17
       - objvar =L= 0;

e39.. x8*x18*x4 - x10*x14*x4 + x10*x3*x15 - x2*x18*x15 - x8*x3*x19 + x2*x14*x19
       - objvar =L= 0;

e40.. x10*x14*x4 - x8*x18*x4 - x10*x3*x15 + x2*x18*x15 + x8*x3*x19 - x2*x14*x19
       - objvar =L= 0;

e41.. x9*x18*x4 - x10*x16*x4 + x10*x3*x17 - x2*x18*x17 - x9*x3*x19 + x2*x16*x19
       - objvar =L= 0;

e42.. x10*x16*x4 - x9*x18*x4 - x10*x3*x17 + x2*x18*x17 + x9*x3*x19 - x2*x16*x19
       - objvar =L= 0;

e43.. x7*x14*x5 - x8*x12*x5 + x8*x11*x13 - x6*x14*x13 - x7*x11*x15 + x6*x12*x15
       - objvar =L= 0;

e44.. x8*x12*x5 - x7*x14*x5 - x8*x11*x13 + x6*x14*x13 + x7*x11*x15 - x6*x12*x15
       - objvar =L= 0;

e45.. x7*x16*x5 - x9*x12*x5 + x9*x11*x13 - x6*x16*x13 - x7*x11*x17 + x6*x12*x17
       - objvar =L= 0;

e46.. x9*x12*x5 - x7*x16*x5 - x9*x11*x13 + x6*x16*x13 + x7*x11*x17 - x6*x12*x17
       - objvar =L= 0;

e47.. x7*x18*x5 - x10*x12*x5 + x10*x11*x13 - x6*x18*x13 - x7*x11*x19 + x6*x12*
      x19 - objvar =L= 0;

e48.. x10*x12*x5 - x7*x18*x5 - x10*x11*x13 + x6*x18*x13 + x7*x11*x19 - x6*x12*
      x19 - objvar =L= 0;

e49.. x8*x16*x5 - x9*x14*x5 + x9*x11*x15 - x6*x16*x15 - x8*x11*x17 + x6*x14*x17
       - objvar =L= 0;

e50.. x9*x14*x5 - x8*x16*x5 - x9*x11*x15 + x6*x16*x15 + x8*x11*x17 - x6*x14*x17
       - objvar =L= 0;

e51.. x8*x18*x5 - x10*x14*x5 + x10*x11*x15 - x6*x18*x15 - x8*x11*x19 + x6*x14*
      x19 - objvar =L= 0;

e52.. x10*x14*x5 - x8*x18*x5 - x10*x11*x15 + x6*x18*x15 + x8*x11*x19 - x6*x14*
      x19 - objvar =L= 0;

e53.. x9*x18*x5 - x10*x16*x5 + x10*x11*x17 - x6*x18*x17 - x9*x11*x19 + x6*x16*
      x19 - objvar =L= 0;

e54.. x10*x16*x5 - x9*x18*x5 - x10*x11*x17 + x6*x18*x17 + x9*x11*x19 - x6*x16*
      x19 - objvar =L= 0;

e55.. x8*x16*x13 - x9*x14*x13 + x9*x12*x15 - x7*x16*x15 - x8*x12*x17 + x7*x14*
      x17 - objvar =L= 0;

e56.. x9*x14*x13 - x8*x16*x13 - x9*x12*x15 + x7*x16*x15 + x8*x12*x17 - x7*x14*
      x17 - objvar =L= 0;

e57.. x8*x18*x13 - x10*x14*x13 + x10*x12*x15 - x7*x18*x15 - x8*x12*x19 + x7*x14
      *x19 - objvar =L= 0;

e58.. x10*x14*x13 - x8*x18*x13 - x10*x12*x15 + x7*x18*x15 + x8*x12*x19 - x7*x14
      *x19 - objvar =L= 0;

e59.. x9*x18*x13 - x10*x16*x13 + x10*x12*x17 - x7*x18*x17 - x9*x12*x19 + x7*x16
      *x19 - objvar =L= 0;

e60.. x10*x16*x13 - x9*x18*x13 - x10*x12*x17 + x7*x18*x17 + x9*x12*x19 - x7*x16
      *x19 - objvar =L= 0;

e61.. x9*x18*x15 - x10*x16*x15 + x10*x14*x17 - x8*x18*x17 - x9*x14*x19 + x8*x16
      *x19 - objvar =L= 0;

e62.. x10*x16*x15 - x9*x18*x15 - x10*x14*x17 + x8*x18*x17 + x9*x14*x19 - x8*x16
      *x19 - objvar =L= 0;

* set non-default bounds
objvar.lo = 0; objvar.up = 1;
x2.lo = -1; x2.up = 1;
x3.lo = -1; x3.up = 1;
x4.lo = -1; x4.up = 1;
x5.lo = -1; x5.up = 1;
x6.lo = -1; x6.up = 1;
x7.lo = -1; x7.up = 1;
x8.lo = -1; x8.up = 1;
x9.lo = -1; x9.up = 1;
x10.lo = -1; x10.up = 1;
x11.lo = -1; x11.up = 1;
x12.lo = -1; x12.up = 1;
x13.lo = -1; x13.up = 1;
x14.lo = -1; x14.up = 1;
x15.lo = -1; x15.up = 1;
x16.lo = -1; x16.up = 1;
x17.lo = -1; x17.up = 1;
x18.lo = -1; x18.up = 1;
x19.lo = -1; x19.up = 1;
x20.up = 1;
x21.up = 1;
x22.up = 1;
x23.up = 1;
x24.up = 1;
x25.up = 1;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
