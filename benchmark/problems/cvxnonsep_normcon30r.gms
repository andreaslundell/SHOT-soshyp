$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         32        1        0       31        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         61       46        0       15        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        121       91       30        0
*
*  Solve m using MINLP minimizing objvar;


Variables  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,x16,x17,x18,x19
          ,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,objvar,x32,x33,x34,x35
          ,x36,x37,x38,x39,x40,x41,x42,x43,x44,x45,x46,x47,x48,x49,x50,x51,x52
          ,x53,x54,x55,x56,x57,x58,x59,x60,x61;

Positive Variables  x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29
          ,x30;

Integer Variables  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32;


e1..    x32 + x33 + x34 + x35 + x36 + x37 + x38 + x39 + x40 + x41 + x42 + x43
      + x44 + x45 + x46 + x47 + x48 + x49 + x50 + x51 + x52 + x53 + x54 + x55
      + x56 + x57 + x58 + x59 + x60 + x61 =L= 99.9999;

e2..  - 0.95*i1 - 0.92*i2 - 0.055*i3 - 0.74*i4 - 0.27*i5 - 0.42*i6 - 0.55*i7
      - 0.945*i8 - 0.42*i9 - 0.985*i10 - 0.3*i11 - 0.7*i12 - 0.665*i13
      - 0.54*i14 - 0.7*i15 - 0.665*x16 - 0.18*x17 - 0.13*x18 - x19 - 0.17*x20
      - 0.035*x21 - 0.56*x22 - 0.88*x23 - 0.67*x24 - 0.19*x25 - 0.37*x26
      - 0.46*x27 - 0.98*x28 - 0.155*x29 - 0.855*x30 - objvar =E= 0;

e3.. sqr(i1) - x32 =L= 0;

e4.. sqr(i2) - x33 =L= 0;

e5.. sqr(i3) - x34 =L= 0;

e6.. sqr(i4) - x35 =L= 0;

e7.. sqr(i5) - x36 =L= 0;

e8.. sqr(i6) - x37 =L= 0;

e9.. sqr(i7) - x38 =L= 0;

e10.. sqr(i8) - x39 =L= 0;

e11.. sqr(i9) - x40 =L= 0;

e12.. sqr(i10) - x41 =L= 0;

e13.. sqr(i11) - x42 =L= 0;

e14.. sqr(i12) - x43 =L= 0;

e15.. sqr(i13) - x44 =L= 0;

e16.. sqr(i14) - x45 =L= 0;

e17.. sqr(i15) - x46 =L= 0;

e18.. sqr(x16) - x47 =L= 0;

e19.. sqr(x17) - x48 =L= 0;

e20.. sqr(x18) - x49 =L= 0;

e21.. sqr(x19) - x50 =L= 0;

e22.. sqr(x20) - x51 =L= 0;

e23.. sqr(x21) - x52 =L= 0;

e24.. sqr(x22) - x53 =L= 0;

e25.. sqr(x23) - x54 =L= 0;

e26.. sqr(x24) - x55 =L= 0;

e27.. sqr(x25) - x56 =L= 0;

e28.. sqr(x26) - x57 =L= 0;

e29.. sqr(x27) - x58 =L= 0;

e30.. sqr(x28) - x59 =L= 0;

e31.. sqr(x29) - x60 =L= 0;

e32.. sqr(x30) - x61 =L= 0;

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
i11.up = 5;
i12.up = 5;
i13.up = 5;
i14.up = 5;
i15.up = 5;
x16.up = 5;
x17.up = 5;
x18.up = 5;
x19.up = 5;
x20.up = 5;
x21.up = 5;
x22.up = 5;
x23.up = 5;
x24.up = 5;
x25.up = 5;
x26.up = 5;
x27.up = 5;
x28.up = 5;
x29.up = 5;
x30.up = 5;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
