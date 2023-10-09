from sage.all import *

u = -0b100000010000000000000000000000000000000000000000000000000000001
p = 0x2523648240000001ba344d80000000086121000000000013a700000000000013
r = 36*u**4 + 36*u**3 + 18*u**2 + 6*u + 1


h0_0 = 0x000000001522962cd2840cce085ba60e77f9ee2aefde17a8c58432c5c61b4c36280a9192
h0_1 = 0x0000000018b57635a879190412ae8652669a1e22e3ccd1bfae18b2296808508225fb4823
h1_0 = 0x000000001d65dd2bb6a916c34f8c2f5fbb122d15dadc50ce25786714a53c4ea38759bcc3
h1_1 = 0x000000000fd8a54405ac27c359eab84f12813366f6e392ee47c56efd8e48669d782f40e2
h2_0 = 0x00000000114b45d26e7558ab7d8455d04eff776a771fb58525de8ff2d8e40b03142b47e9
h2_1 = 0x00000000048d9e20b6c045298d9780d85e2e6d78980918230a9d74a78f435c0ecfc81d93
h3_0 = 0x000000001d668780f723c0e6b9f153cc38867111419aed26eb164f929f08809c6fbc6c98
h3_1 = 0x000000002041b120d62592645b892348fc3038bf73e2d9194919bd36701140a9f73fa89a
h4_0 = 0x00000000069da90405400fca977ace521fc5d98279ee076b223919bfa01c5e0fdce70893
h4_1 = 0x0000000024bbb6c41ba5e445a122eea517f7a0040177e130aeff5b815deed9f1b87103a0
h5_0 = 0x0000000019345c9aa53c012baeafb6990ab861b0a5735b223fe62bc3ef19607483d759ad
h5_1 = 0x00000000132d35a6ea2153f2572ddc838496d115db53bd6fb06942dab4092426633c02e2

# h0_0 = 0x0000000020ccb8ff2fb6d5fac4e71d9262ef794ff7144600a5f811b3ed954499d2e72f8b
# h0_1 = 0x00000000018333419e07986ba6afbbca3c83ba8ef14874a8fc738b95f55e9bb4cfda912c
# h1_0 = 0x000000001ae94503fd6606156b3392c5ac9a997820f0f5d26ea32bdac7dad06b6d8c5c6f
# h1_1 = 0x0000000005926891110b403eb33e7bc3a0d6c444511481328ad3b1509fbaed2f05a9d9f9
# h2_0 = 0x000000000259ef759471d782d9074c8248a3f3e3c7c04e52859e87b10b3929039165e08c
# h2_1 = 0x000000000274aea02bbb78fdccedb1865e51cf98dfba8e6bb9d3daec47214cd8839a6f59
# h3_0 = 0x0000000008b254283df593bcea3f69a31f3713f5a9b8708595e514d5409b2c3855954f91
# h3_1 = 0x00000000070e247e6966045276b6a06c9b8f690ea832c8855f51c8f663ed7a7127f04947
# h4_0 = 0x0000000008329cbb7c1c234fa1638d9c09f5394e8621b233a60ff9c74d59612b11112d79
# h4_1 = 0x000000000f33eeba50ee6ac7128d464f70d2675c16e3c5ff79c0c467711004986f39e878
# h5_0 = 0x000000000730341c9cb92284e9b68264793a860fb33d3e77cacd39a5307c707543401648
# h5_1 = 0x0000000003b65babd76f36342e2de5a8551ac7126abbcb19edeabf7d0ee46929da02b227

def print_hex12(f):
    for i in range(6):
        for j in range(2):
            print(hex(f[i][j])[2:])
    print('')

def print_hex2(f):
    for i in range(2):
        print(hex(f[i])[2:])
    print('')

def Fp12_conj(f):
    pp = Fp2(0 + 0*x)
    g = Fp12(f[0] + (pp-f[1])*w + f[2]*w**2 + (pp-f[3])*w**3 + f[4]*w**4 + (pp-f[5])*w**5)
    return g

def Fp12_frob_p(f):
    g = Fp12(f[0])
    return g

R = PolynomialRing(GF(p), 'x')
x = R.gen()
I = R.ideal(x**2+1)
Fp2 = R.quotient(I)


i = Fp2.gen()
xi = 1 + i

R = PolynomialRing(Fp2, 'w')
w = R.gen()
I = R.ideal(w**6-xi)
Fp12 = R.quotient(I)


f = Fp12((h0_0 + h0_1*x) + (h1_0 + h1_1*x) * w + 
    (h2_0 + h2_1*x)*w**2 + (h3_0 + h3_1*x)*w**3 + 
    (h4_0 + h4_1*x)*w**4 + (h5_0 + h5_1*x)*w**5)

# f = Fp12((h0_0 + h0_1*x) + (h2_0 + h2_1*x) * w + 
#     (h4_0 + h4_1*x)*w**2 + (h1_0 + h1_1*x)*w**3 + 
#     (h3_0 + h3_1*x)*w**4 + (h5_0 + h5_1*x)*w**5)

print_hex12(f**2)


# t0 = f**-u
# tt = t0**2
# t1 = tt**2
# t0 = tt*t1
# t1 = Fp12_conj(f)
# tt = t0*t1
# t2 = tt**p

# t1 = tt**2
# tt = t1*t2

# t2 = t0**-u
# t0 = t2**2
# t0 = t0**p
# t1 = tt*t0

# tt = t2*f
# t0 = tt**(p**2)
# t2 = t0*t1

# t0 = tt**(-6*u-5)
# t1 = t2*t0

# tt = t0**p
# t2 = t1*tt

# t0 = f**2
# tt = t0**2
# t1 = f*tt
# tt = t1*t2

# t2 = t1*t0
# t2 = t2**p
# t1 = t2*tt

# t2 = f**(p**3)
# z = t2*t1



