$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         24       15        0        9        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         19       19        0        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         79       55       24        0
*
*  Solve m using NLP minimizing objvar;


Variables  objvar,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18
          ,x19;

Positive Variables  x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24;


e1..    objvar - x5 + 5*x6 + 3*x14 + 9*x15 - 6*x16 - 7*x18 - x19 =E= 0;

e2..    x14 + x15 =L= 300;

e3..    x16 + x17 =L= 50;

e4..    x18 + x19 =L= 300;

e5..    x5 + x6 =L= 300;

e6..    x14 + x15 + x16 + x17 + x18 + x19 =L= 300;

e7..    x5 + x14 + x16 + x18 =L= 100;

e8..    x6 + x15 + x17 + x19 =L= 200;

e9..  - 0.5*x5 + 0.5*x14 - 1.5*x16 - 1.5*x18 =L= 0;

e10..    0.5*x6 + 1.5*x15 - 0.5*x17 - 0.5*x19 =L= 0;

e11..    x9 + x10 + x11 =E= 1;

e12..    x12 + x13 =E= 1;

e13.. -x9*x7 + x14 =E= 0;

e14.. -x9*x8 + x15 =E= 0;

e15.. -x10*x7 + x16 =E= 0;

e16.. -x10*x8 + x17 =E= 0;

e17.. -x11*x7 + x18 =E= 0;

e18.. -x11*x8 + x19 =E= 0;

e19.. -x12*x2 + x14 =E= 0;

e20.. -x13*x2 + x15 =E= 0;

e21.. -x12*x3 + x16 =E= 0;

e22.. -x13*x3 + x17 =E= 0;

e23.. -x12*x4 + x18 =E= 0;

e24.. -x13*x4 + x19 =E= 0;

* set non-default bounds
x2.up = 300;
x3.up = 50;
x4.up = 300;
x5.up = 100;
x6.up = 200;
x7.up = 100;
x8.up = 200;
x9.up = 1;
x10.up = 1;
x11.up = 1;
x12.up = 1;
x13.up = 1;
x14.up = 100;
x15.up = 200;
x16.up = 50;
x17.up = 50;
x18.up = 100;
x19.up = 200;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
