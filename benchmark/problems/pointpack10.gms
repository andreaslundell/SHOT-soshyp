$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         55        0        0       55        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         21       21        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        245       65      180        0
*
*  Solve m using NLP maximizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,x20,objvar;

Positive Variables  x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45,e46,e47,e48,e49,e50,e51,e52,e53
          ,e54,e55;


e1.. 2*x1*x2 - x1*x1 - x2*x2 - x11*x11 + 2*x11*x12 - x12*x12 + objvar =L= 0;

e2.. 2*x1*x3 - x1*x1 - x3*x3 - x11*x11 + 2*x11*x13 - x13*x13 + objvar =L= 0;

e3.. 2*x1*x4 - x1*x1 - x4*x4 - x11*x11 + 2*x11*x14 - x14*x14 + objvar =L= 0;

e4.. 2*x1*x5 - x1*x1 - x5*x5 - x11*x11 + 2*x11*x15 - x15*x15 + objvar =L= 0;

e5.. 2*x1*x6 - x1*x1 - x6*x6 - x11*x11 + 2*x11*x16 - x16*x16 + objvar =L= 0;

e6.. 2*x1*x7 - x1*x1 - x7*x7 - x11*x11 + 2*x11*x17 - x17*x17 + objvar =L= 0;

e7.. 2*x1*x8 - x1*x1 - x8*x8 - x11*x11 + 2*x11*x18 - x18*x18 + objvar =L= 0;

e8.. 2*x1*x9 - x1*x1 - x9*x9 - x11*x11 + 2*x11*x19 - x19*x19 + objvar =L= 0;

e9.. 2*x1*x10 - x1*x1 - x10*x10 - x11*x11 + 2*x11*x20 - x20*x20 + objvar =L= 0;

e10.. 2*x2*x3 - x2*x2 - x3*x3 - x12*x12 + 2*x12*x13 - x13*x13 + objvar =L= 0;

e11.. 2*x2*x4 - x2*x2 - x4*x4 - x12*x12 + 2*x12*x14 - x14*x14 + objvar =L= 0;

e12.. 2*x2*x5 - x2*x2 - x5*x5 - x12*x12 + 2*x12*x15 - x15*x15 + objvar =L= 0;

e13.. 2*x2*x6 - x2*x2 - x6*x6 - x12*x12 + 2*x12*x16 - x16*x16 + objvar =L= 0;

e14.. 2*x2*x7 - x2*x2 - x7*x7 - x12*x12 + 2*x12*x17 - x17*x17 + objvar =L= 0;

e15.. 2*x2*x8 - x2*x2 - x8*x8 - x12*x12 + 2*x12*x18 - x18*x18 + objvar =L= 0;

e16.. 2*x2*x9 - x2*x2 - x9*x9 - x12*x12 + 2*x12*x19 - x19*x19 + objvar =L= 0;

e17.. 2*x2*x10 - x2*x2 - x10*x10 - x12*x12 + 2*x12*x20 - x20*x20 + objvar =L= 0
      ;

e18.. 2*x3*x4 - x3*x3 - x4*x4 - x13*x13 + 2*x13*x14 - x14*x14 + objvar =L= 0;

e19.. 2*x3*x5 - x3*x3 - x5*x5 - x13*x13 + 2*x13*x15 - x15*x15 + objvar =L= 0;

e20.. 2*x3*x6 - x3*x3 - x6*x6 - x13*x13 + 2*x13*x16 - x16*x16 + objvar =L= 0;

e21.. 2*x3*x7 - x3*x3 - x7*x7 - x13*x13 + 2*x13*x17 - x17*x17 + objvar =L= 0;

e22.. 2*x3*x8 - x3*x3 - x8*x8 - x13*x13 + 2*x13*x18 - x18*x18 + objvar =L= 0;

e23.. 2*x3*x9 - x3*x3 - x9*x9 - x13*x13 + 2*x13*x19 - x19*x19 + objvar =L= 0;

e24.. 2*x3*x10 - x3*x3 - x10*x10 - x13*x13 + 2*x13*x20 - x20*x20 + objvar =L= 0
      ;

e25.. 2*x4*x5 - x4*x4 - x5*x5 - x14*x14 + 2*x14*x15 - x15*x15 + objvar =L= 0;

e26.. 2*x4*x6 - x4*x4 - x6*x6 - x14*x14 + 2*x14*x16 - x16*x16 + objvar =L= 0;

e27.. 2*x4*x7 - x4*x4 - x7*x7 - x14*x14 + 2*x14*x17 - x17*x17 + objvar =L= 0;

e28.. 2*x4*x8 - x4*x4 - x8*x8 - x14*x14 + 2*x14*x18 - x18*x18 + objvar =L= 0;

e29.. 2*x4*x9 - x4*x4 - x9*x9 - x14*x14 + 2*x14*x19 - x19*x19 + objvar =L= 0;

e30.. 2*x4*x10 - x4*x4 - x10*x10 - x14*x14 + 2*x14*x20 - x20*x20 + objvar =L= 0
      ;

e31.. 2*x5*x6 - x5*x5 - x6*x6 - x15*x15 + 2*x15*x16 - x16*x16 + objvar =L= 0;

e32.. 2*x5*x7 - x5*x5 - x7*x7 - x15*x15 + 2*x15*x17 - x17*x17 + objvar =L= 0;

e33.. 2*x5*x8 - x5*x5 - x8*x8 - x15*x15 + 2*x15*x18 - x18*x18 + objvar =L= 0;

e34.. 2*x5*x9 - x5*x5 - x9*x9 - x15*x15 + 2*x15*x19 - x19*x19 + objvar =L= 0;

e35.. 2*x5*x10 - x5*x5 - x10*x10 - x15*x15 + 2*x15*x20 - x20*x20 + objvar =L= 0
      ;

e36.. 2*x6*x7 - x6*x6 - x7*x7 - x16*x16 + 2*x16*x17 - x17*x17 + objvar =L= 0;

e37.. 2*x6*x8 - x6*x6 - x8*x8 - x16*x16 + 2*x16*x18 - x18*x18 + objvar =L= 0;

e38.. 2*x6*x9 - x6*x6 - x9*x9 - x16*x16 + 2*x16*x19 - x19*x19 + objvar =L= 0;

e39.. 2*x6*x10 - x6*x6 - x10*x10 - x16*x16 + 2*x16*x20 - x20*x20 + objvar =L= 0
      ;

e40.. 2*x7*x8 - x7*x7 - x8*x8 - x17*x17 + 2*x17*x18 - x18*x18 + objvar =L= 0;

e41.. 2*x7*x9 - x7*x7 - x9*x9 - x17*x17 + 2*x17*x19 - x19*x19 + objvar =L= 0;

e42.. 2*x7*x10 - x7*x7 - x10*x10 - x17*x17 + 2*x17*x20 - x20*x20 + objvar =L= 0
      ;

e43.. 2*x8*x9 - x8*x8 - x9*x9 - x18*x18 + 2*x18*x19 - x19*x19 + objvar =L= 0;

e44.. 2*x8*x10 - x8*x8 - x10*x10 - x18*x18 + 2*x18*x20 - x20*x20 + objvar =L= 0
      ;

e45.. 2*x9*x10 - x9*x9 - x10*x10 - x19*x19 + 2*x19*x20 - x20*x20 + objvar =L= 0
      ;

e46..  - x11 + x12 =L= 0;

e47..  - x1 + x2 =L= 0;

e48..  - x2 + x3 =L= 0;

e49..  - x3 + x4 =L= 0;

e50..  - x4 + x5 =L= 0;

e51..  - x5 + x6 =L= 0;

e52..  - x6 + x7 =L= 0;

e53..  - x7 + x8 =L= 0;

e54..  - x8 + x9 =L= 0;

e55..  - x9 + x10 =L= 0;

* set non-default bounds
x1.lo = 0.5; x1.up = 1;
x2.lo = 0.5; x2.up = 1;
x3.lo = 0.5; x3.up = 1;
x4.lo = 0.5; x4.up = 1;
x5.lo = 0.5; x5.up = 1;
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
x19.up = 1;
x20.up = 1;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% maximizing objvar;
