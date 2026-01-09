$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         22        1        0       21        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         41       31        0       10        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         81       61       20        0
*
*  Solve m using MINLP minimizing objvar;


Variables  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,x20,objvar,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35
          ,x36,x37,x38,x39,x40,x41;

Positive Variables  x11,x12,x13,x14,x15,x16,x17,x18,x19,x20;

Integer Variables  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22;


e1..    x22 + x23 + x24 + x25 + x26 + x27 + x28 + x29 + x30 + x31 + x32 + x33
      + x34 + x35 + x36 + x37 + x38 + x39 + x40 + x41 =L= 99.9999;

e2..  - 0.175*i1 - 0.39*i2 - 0.83*i3 - 0.805*i4 - 0.06*i5 - 0.4*i6 - 0.52*i7
      - 0.415*i8 - 0.655*i9 - 0.63*i10 - 0.29*x11 - 0.43*x12 - 0.015*x13
      - 0.985*x14 - 0.165*x15 - 0.105*x16 - 0.37*x17 - 0.2*x18 - 0.49*x19
      - 0.34*x20 - objvar =E= 0;

e3.. sqr(i1) - x22 =L= 0;

e4.. sqr(i2) - x23 =L= 0;

e5.. sqr(i3) - x24 =L= 0;

e6.. sqr(i4) - x25 =L= 0;

e7.. sqr(i5) - x26 =L= 0;

e8.. sqr(i6) - x27 =L= 0;

e9.. sqr(i7) - x28 =L= 0;

e10.. sqr(i8) - x29 =L= 0;

e11.. sqr(i9) - x30 =L= 0;

e12.. sqr(i10) - x31 =L= 0;

e13.. sqr(x11) - x32 =L= 0;

e14.. sqr(x12) - x33 =L= 0;

e15.. sqr(x13) - x34 =L= 0;

e16.. sqr(x14) - x35 =L= 0;

e17.. sqr(x15) - x36 =L= 0;

e18.. sqr(x16) - x37 =L= 0;

e19.. sqr(x17) - x38 =L= 0;

e20.. sqr(x18) - x39 =L= 0;

e21.. sqr(x19) - x40 =L= 0;

e22.. sqr(x20) - x41 =L= 0;

* set non-default bounds
i1.up = 5;
i2.up = 5;
i3.up = 5;
i4.up = 5;
i5.up = 5;
i6.up = 5;
i7.up = 5;
i8.up = 5;
i9.up = 5;
i10.up = 5;
x11.up = 5;
x12.up = 5;
x13.up = 5;
x14.up = 5;
x15.up = 5;
x16.up = 5;
x17.up = 5;
x18.up = 5;
x19.up = 5;
x20.up = 5;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
