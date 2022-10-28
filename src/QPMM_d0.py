# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Name:        AMAOD.py
# Purpose:
#
# Author:      junichi sakamoto
#
# Created:     26/08/2022
# Copyright:   (c) sakamoto 2022
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import random
import sys
import math
from MM_util import *


#######################################################################################
###################################Global Params#######################################
#######################################################################################
M = 0x2523648240000001ba344d80000000086121000000000013a700000000000013
k = 17
d = 0
r_power = 289
n = math.ceil(r_power/k)
r = 2**r_power  # > 269 bits
mask = 2**k - 1

l = 26
c = abs(l - k)
m = math.ceil(r_power/l) - 1
mask_a = 2**l - 1
mask_c = 2**c - 1
mask_2k = 2**(2*k) - 1
mask_dspout = 2**48 - 1

MM_init(M, k, d, r)
M_pp = get_Mpp()
M_tilda = get_M_tilda()

def QPMM(A, B):
    bi = [(B >> k*i) & mask for i in range(n + 1)]
    # print(hex(B))
    # print(hex(polytoint(bi)))

    S = 0
    for i in range(n + 1):
        qi = S & mask
        S = (S >> k) + qi * M_pp + bi[i]*A
        # print(hex(qi))
        # print(hex(S))

    return S

def polytoint(poly):
    val = 0
    for i, term in enumerate(poly):
        val += term << k*i
    return val

def polytoint_a(poly):
    val = 0
    for i in range(m-1):
        val += poly[i] << l*i
    return val

def DSP(A, B, C, PCIN):
    return A*B + C + PCIN

def PE(aj, bi, q, mppj, sij, su):
    ab = DSP(aj, bi, su, 0)
    s = DSP(q, mppj, sij, ab)
    return s & mask_dspout


def QPMM_HW(A, B):
    npp = 16
    aj = [(A >> k*i) & mask for i in range(n)]
    bi = [(B >> k*i) & mask for i in range(n)]
    mppj = [(M_pp >> k*i) & mask for i in range(npp)]
    PSs = [0]*(n + 1)

    buf_q = 0
    for i in range(n + 1):
        buf_q = PSs[0] + (buf_q >> k)
        qi = buf_q & mask

        for j in range(n):
            if i == 0:
                PSs[j] = aj[j]*bi[i]
            elif i == n:
                if j == n - 1:
                    PSs[j] = PSs[j+1]
                else:
                    PSs[j] = mppj[j]*qi + PSs[j+1]
            else:
                if j == n - 1:
                    PSs[j] = aj[j]*bi[i]
                else:
                    PSs[j] = PE(aj[j], bi[i], qi, mppj[j], PSs[j+1], 0)

        print(hex(qi))
        print(list(map(hex, PSs)))
        print(hex(buf_q))
        print(hex(polytoint_a(PSs) + (buf_q >> k)))

    return polytoint_a(PSs) + (buf_q >> k)


def QPMM_HW_asym(A, B):
    aj = [(A >> l*j) & mask_a for j in range(m)]
    bi = [(B >> k*i) & mask for i in range(n+1)]
    mppj = [(M_pp >> l*j) & mask_a for j in range(m)]  # m-1 = 0
    PSs = [0]*(m + 2)  # m+1 = 0

    if k <= l:
        for i in range(n + 1):
            PSs[0] = (PSs[1] & mask_2k) + (PSs[0] >> k)
            qi = PSs[0] & mask

            for j in range(m):
                su = PSs[j+1] >> 2*k
                sl = PSs[j+2] & mask_2k

                PSs[j+1] = PE(aj[j], bi[i], qi, mppj[j], sl << c, su << k)
    else:
        PSs = [0]*(m + 3)  # m+1 = 0
        buf_q = 0
        for i in range(n + 1):
            PSs[0] = PSs[1] + ((PSs[2] & mask_c) << l)
            buf_q = PSs[0] + (buf_q >> k)
            qi = buf_q & mask

            for j in range(m):
                su = PSs[j+2] >> c
                sl = PSs[j+3] & mask_c

                PSs[j+1] = PE(aj[j], bi[i], qi, mppj[j], sl << c, su)

            print(hex(qi))
            print(list(map(hex, PSs)))
            print(hex(polytoint_a(PSs[1:]) + (PSs[0] >> k) + (buf_q >> 2*k)))

    return polytoint_a(PSs[1:]) + (PSs[0] >> k)

def QPMM_HW_asym_optim(A, B):
    aj = [(A >> l*j) & mask_a for j in range(m)]
    bi = [(B >> k*i) & mask for i in range(n)]
    mppj = [(M_pp >> l*j) & mask_a for j in range(m-1)]
    PSs = [0]*(m + 1)

    for i in range(n + 1):
        PSs[0] = (PSs[1] & mask_2k) + (PSs[0] >> k)
        qi = PSs[0] & mask

        for j in range(m):
            su = PSs[j+1] >> 2*k
            if j < m - 1:
                sl = PSs[j+2] & mask_2k

            if i == 0:
                PSs[j+1] = aj[j]*bi[i] & mask_dspout
            elif i == n:
                if j == m - 1:
                    PSs[j+1] = 0
                else:
                    PSs[j+1] = (mppj[j]*qi + (sl << c) + (su << k)) & mask_dspout
            else:
                if j == m - 1:
                    PSs[j+1] = aj[j]*bi[i] & mask_dspout
                else:
                    # print(f"{i=}, {j=}")
                    # print(f"{qi=:x}, {mppj[j]=:x}, {sl=:x}, {su=}")
                    PSs[j+1] = PE(aj[j], bi[i], qi, mppj[j], sl << c, su << k)

        print(hex(qi))
        print(list(map(hex, PSs)))
        print(hex(polytoint_a(PSs[1:]) + (PSs[0] >> k)))
    return (polytoint_a(PSs[1:]) + (PSs[0] >> k)) & (2**(n*k) - 1)

def test_QPMM(HW = 0):
    random.seed(1)

    for i in range(1):
        A = random.randint(128*M_tilda, 1024*M_tilda - 1)
        B = random.randint(128*M_tilda, 1024*M_tilda - 1)
        A = 0x0fa31909cea51dc4a8113a05c3062235836fd10287cbc9f7b6362c82df0072dc7089cc
        B = 0x0fa318ff47385d034fb2fe45704017c5726176d5845a2241e84bd4e844813594cab125
        a = MR(A)
        b = MR(B)
        ans = a*b % M


        if HW == 1:
            S = QPMM_HW(A, B)
        elif HW == 2:
            S = QPMM_HW_asym(A, B)
        elif HW == 3:
            S = QPMM_HW_asym_optim(A, B)
        else:
            S = QPMM(A, B)

        print('QPMM:     ' + hex(S))
        print('MR(QPMM): ' + hex(MR(S)))
        print('ANS:      ' + hex(ans))

        assert ans == MR(S), f'\n{ans=  :x}\n{MR(S)=:x}\n{S=:x}'
        assert S < 2*M_tilda, f"{S=:x}: {len(bin(S))-4} bits"


if __name__ == '__main__':
    args = sys.argv

    test_QPMM(HW=int(args[1]))
