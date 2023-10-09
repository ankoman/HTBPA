# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Name:        bee_inv.py
# Purpose:
#
# Author:      junichi sakamoto
#
# Created:     18/11/2022
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
### For DSP48E2
k = 17
d = 0
l = 26
## For BN254
M = 0x2523648240000001ba344d80000000086121000000000013a700000000000013
r_power = 289
r = 2**r_power  # > 269 bits

MM_init(M, k, d, r)
M_pp = get_Mpp()
M_tilda = get_M_tilda()

def BEE_inv(y):
    a = y
    u = 1
    b = M
    v = 0
    i = 0;
    while a:
        print(i)
        i = i + 1
        print(f'{a=:x}')
        print(f'{b=:x}')
        print(f'{u=:x}')
        print(f'{v=:x}')

        # 1st stage
        a_is_odd = a & 1
        a1 = a
        b1 = b*a_is_odd
        u1 = u
        v1 = -v*a_is_odd

        # 2nd stage
        a2 = a1
        u2 = u1
        sub1 = a1 - b1
        sub2 = b1 - a1
        sum1_is_odd = 
        sum1 u1 + v1 

        if not a & 1:
            a = a >> 1;
            u = (u + M) >> 1 if (u & 1) else u >> 1;
        else:
            # if a < b:
            #     (a, u, b, v) = (b, v, a, u)
            #     print(f'\t{a=:x}')
            #     print(f'\t{b=:x}')
            #     print(f'\t{u=:x}')
            #     print(f'\t{v=:x}')
            a_ = (a - b) >> 1
            u_ = (u - v + M) >> 1 if ((u - v ) & 1) else (u - v) >> 1
            if a_ < 0:
                a_ = abs(a_)
                u_ = abs(u_) if ((u - v ) & 1) else u_
                b = a
                v = u
            
            a = a_
            u = u_    
                
        #input()

    if b != 1:
        return 0
    else:
        return v


def test_BEE(HW=0):
    #random.seed(1)

    for i in range(1):
        A = random.randint(M_tilda, 2*M_tilda - 1)
        a = MR(A)

        inv = BEE_inv(a)
        print(f'{inv=:x}')
        print(hex(a))
        print(hex(a*inv%M))
        # assert ans == MR(S), f'\n{ans=  :x}\n{MR(S)=:x}\n{S=:x}'
        # assert S < 2*M_tilda, f"{S=:x}: {len(bin(S))-4} bits"


if __name__ == '__main__':
    args = sys.argv

    test_BEE()
