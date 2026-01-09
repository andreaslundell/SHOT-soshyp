$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         42        1        0       41        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         81       61        0       20        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        161      121       40        0
*
*  Solve m using MINLP minimizing objvar;


Variables  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19
          ,i20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36
          ,x37,x38,x39,x40,objvar,x42,x43,x44,x45,x46,x47,x48,x49,x50,x51,x52
          ,x53,x54,x55,x56,x57,x58,x59,x60,x61,x62,x63,x64,x65,x66,x67,x68,x69
          ,x70,x71,x72,x73,x74,x75,x76,x77,x78,x79,x80,x81;

Positive Variables  x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34
          ,x35,x36,x37,x38,x39,x40,x42,x43,x44,x45,x46,x47,x48,x49,x50,x51,x52
          ,x53,x54,x55,x56,x57,x58,x59,x60,x61,x62,x63,x64,x65,x66,x67,x68,x69
          ,x70,x71,x72,x73,x74,x75,x76,x77,x78,x79,x80,x81;

Integer Variables  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17
          ,i18,i19,i20;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42;


e1..    x42 + x43 + x44 + x45 + x46 + x47 + x48 + x49 + x50 + x51 + x52 + x53
      + x54 + x55 + x56 + x57 + x58 + x59 + x60 + x61 + x62 + x63 + x64 + x65
      + x66 + x67 + x68 + x69 + x70 + x71 + x72 + x73 + x74 + x75 + x76 + x77
      + x78 + x79 + x80 + x81 =L= 99.9999;

e2..  - 0.64*i1 - 0.38*i2 - 0.19*i3 - 0.43*i4 - 0.48*i5 - 0.12*i6 - 0.59*i7
      - 0.23*i8 - 0.38*i9 - 0.85*i10 - 0.25*i11 - 0.29*i12 - 0.62*i13
      - 0.82*i14 - 0.27*i15 - 0.98*i16 - 0.73*i17 - 0.34*i18 - 0.58*i19
      - 0.11*i20 - 0.91*x21 - 0.88*x22 - 0.82*x23 - 0.26*x24 - 0.02*x25
      - 0.43*x26 - 0.31*x27 - 0.59*x28 - 0.16*x29 - 0.18*x30 - 0.42*x31
      - 0.09*x32 - 0.6*x33 - 0.47*x34 - 0.7*x35 - 0.7*x36 - 0.64*x37 - 0.03*x38
      - 0.07*x39 - 0.32*x40 - objvar =E= 0;

e3.. sqr(i1) - x42 =L= 0;

e4.. sqr(i2) - x43 =L= 0;

e5.. sqr(i3) - x44 =L= 0;

e6.. sqr(i4) - x45 =L= 0;

e7.. sqr(i5) - x46 =L= 0;

e8.. sqr(i6) - x47 =L= 0;

e9.. sqr(i7) - x48 =L= 0;

e10.. sqr(i8) - x49 =L= 0;

e11.. sqr(i9) - x50 =L= 0;

e12.. sqr(i10) - x51 =L= 0;

e13.. sqr(i11) - x52 =L= 0;

e14.. sqr(i12) - x53 =L= 0;

e15.. sqr(i13) - x54 =L= 0;

e16.. sqr(i14) - x55 =L= 0;

e17.. sqr(i15) - x56 =L= 0;

e18.. sqr(i16) - x57 =L= 0;

e19.. sqr(i17) - x58 =L= 0;

e20.. sqr(i18) - x59 =L= 0;

e21.. sqr(i19) - x60 =L= 0;

e22.. sqr(i20) - x61 =L= 0;

e23.. sqr(x21) - x62 =L= 0;

e24.. sqr(x22) - x63 =L= 0;

e25.. sqr(x23) - x64 =L= 0;

e26.. sqr(x24) - x65 =L= 0;

e27.. sqr(x25) - x66 =L= 0;

e28.. sqr(x26) - x67 =L= 0;

e29.. sqr(x27) - x68 =L= 0;

e30.. sqr(x28) - x69 =L= 0;

e31.. sqr(x29) - x70 =L= 0;

e32.. sqr(x30) - x71 =L= 0;

e33.. sqr(x31) - x72 =L= 0;

e34.. sqr(x32) - x73 =L= 0;

e35.. sqr(x33) - x74 =L= 0;

e36.. sqr(x34) - x75 =L= 0;

e37.. sqr(x35) - x76 =L= 0;

e38.. sqr(x36) - x77 =L= 0;

e39.. sqr(x37) - x78 =L= 0;

e40.. sqr(x38) - x79 =L= 0;

e41.. sqr(x39) - x80 =L= 0;

e42.. sqr(x40) - x81 =L= 0;

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
i16.up = 5;
i17.up = 5;
i18.up = 5;
i19.up = 5;
i20.up = 5;
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
x31.up = 5;
x32.up = 5;
x33.up = 5;
x34.up = 5;
x35.up = 5;
x36.up = 5;
x37.up = 5;
x38.up = 5;
x39.up = 5;
x40.up = 5;

Model m / all /;

m.limrow=0; m.limcol=0;
m.tolproj=0.0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
