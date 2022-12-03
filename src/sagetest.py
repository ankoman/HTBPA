from sage.all import *

u = -0b100000010000000000000000000000000000000000000000000000000000001
p = 0x2523648240000001ba344d80000000086121000000000013a700000000000013
r = 36*u**4 + 36*u**3 + 18*u**2 + 6*u + 1

h0_0 = 0xff0867617670fb54ea91aa95b0f8575c46f421bb3756cab1b85e132e654318
h0_1 = 0x1622b283d40f6812b14231492cc59f22004878f89053710ec7f52dc4fb0f3d78
h1_0 = 0x1f9be60a07963c70dcc90c2a178a23fd3c1404e8beb17f74d98a5c5d4856b65c
h1_1 = 0x20659581563a8dd75fa100ef26d50f3d6f1cbf2c689925c111823cebc42378b1
h2_0 = 0x23869ae728edfc20f0d3d871d31520b91106322ac1f4b3371aa7e142e8d56b61
h2_1 = 0x1da26ab5b6ea3431e86d4bbe0b1bd4f296fad33bd8eb8dcd112ffa34ef7ccf23
h3_0 = 0x11c574784081b6898ec1627806725a214cd886106f3c2dac564939e8cdc1272d
h3_1 = 0x1a28277d8a50220c8e23cae015ad253439993ebb332bbec25a09dafbb3662624
h4_0 = 0x728f753f8c5a38cfc06163a5ba02fb8b6db6ecf3a802f60201649ee2f0f7b16
h4_1 = 0x91b6ce3bf7c720e283ee9b5bf38ac2756b207fb51f9524775d49864365ad7f5
h5_0 = 0x13f36f4df1707abdc90a4e2393d6651af701212ee6680b7d7f637d0f533f9122
h5_1 = 0x189fbd51b477e1a8ef963c1aa4524a6a485ee8e87093c6fbc61f4b0f7e1303b3

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

t0 = f**-u
tt = t0**2
t1 = tt**2
t0 = tt*t1
t1 = Fp12_conj(f)
tt = t0*t1
t2 = tt**p

t1 = tt**2
tt = t1*t2

t2 = t0**-u
t0 = t2**2
t0 = t0**p
t1 = tt*t0

tt = t2*f
t0 = tt**(p**2)
t2 = t0*t1

t0 = tt**(-6*u-5)
t1 = t2*t0

tt = t0**p
t2 = t1*tt

t0 = f**2
tt = t0**2
t1 = f*tt
tt = t1*t2

t2 = t1*t0
t2 = t2**p
t1 = t2*tt

t2 = f**(p**3)
z = t2*t1

print_hex12(z)