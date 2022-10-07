# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Name:        hw_sim.py
# Purpose:
#
# Author:      junichi sakamoto
#
# Created:     3/10/2022
# Copyright:   (c) sakamoto 2022
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import random
import sys
import math
import collections
import numpy as no
Inst = collections.namedtuple('Inst', ('exit', 'me0', 'me1', 'preadd_mode0', 'preadd_mode1', 
'cmul_mode', 'postadd_mode0', 'postadd_mode1', 'postadd_mode2', 'postadd_sel', 'postadd_addr1', 'postadd_addr2',
'eeinv', 'waddr0', 'waddr1', 'raddr0', 'raddr1'))

#######################################################################################
###################################Global Params#######################################
#######################################################################################
M = 0x2523648240000001ba344d80000000086121000000000013a700000000000013

ram0 = [0] * 256
ram1 = [0] * 256
reg_inst = [0] * 10

#######################################################################################
###################################  Functions  #######################################
#######################################################################################
def decode(inst):
    decoded = Inst(
    exit = int(inst[0:1], 2),
    me0 = int(inst[25:26], 2),
    me1 = int(inst[24:25], 2),
    preadd_mode0 = int(inst[22:24], 2),
    preadd_mode1 = int(inst[20:22], 2),
    cmul_mode = int(inst[17:20], 2),
    postadd_mode0 = int(inst[14:17], 2),
    postadd_mode1 = int(inst[11:14], 2),
    postadd_mode2 = int(inst[8:11], 2),
    postadd_sel = int(inst[6:8], 2),
    postadd_addr1 = int(inst[4:6], 2),
    postadd_addr2 = int(inst[2:4], 2),
    eeinv = int(inst[1:2], 2),
    waddr0 = int(inst[27:35], 2),
    waddr1 = int(inst[35:43], 2),
    raddr0 = int(inst[43:51], 2),
    raddr1 = int(inst[51:59], 2),
    )
    return decoded

def load_rom():
    with open('rom', 'r') as f:
        raw_rom = f.readlines()

    rom = []
    for line in raw_rom:
        line = line[:59]
        # Below comment delete procedure is not complete
        if '//' in line:
            continue
        rom.append(line)
    return rom
    
def main():
    global reg_inst
    # Init
    ram0[0] = 0x1111
    ram1[0] = 0x12345

    rom = load_rom()

    # Calculation cycle by cycle
    cycle_cnt = 0
    pc = 0
    while True:
        inst = decode(rom[pc])
        reg_inst = [inst] + reg_inst[:-1]  # rshift
        print(inst.exit)

        if inst.exit or cycle_cnt > 1000000:
            print('End')
            break
        
        pc += 1
        cycle_cnt += 1

def int2poly(x):
    mask = 2 ** 64 - 1
    x = [(x >> i*64) & mask for i in range(4)]
    return x

def poly2int(poly_x):
    x = 0
    poly_x.reverse()
    for term in poly_x:
        x = x << 64
        x += term
    return x

def poly2int_2(poly_x):
    mask = 2 ** 64 - 1
    x = 0
    poly_x.reverse()
    for term in poly_x:
        sign = term >> 71
        if sign:
            term += 0xffffffffffffffffffffffffffffffffffffffffffffff000000000000000000
        x = (x << 64) 
        x += term
        x = x & (2**256-1)
    return x

def poly2int_hw(poly_x):
    mask = 2 ** 64 - 1
    
    sign0 = poly_x[0] >> 71
    sign1 = poly_x[1] >> 71
    sign2 = poly_x[2] >> 71
    sign3 = poly_x[3] >> 71
    carry0 = poly_x[0] >> 64
    carry1 = poly_x[1] >> 64
    carry2 = poly_x[2] >> 64
    carry3 = poly_x[3] >> 64
    val0 = poly_x[0] & mask
    val1 = poly_x[1] & mask
    val2 = poly_x[2] & mask
    val3 = poly_x[3] & mask

    # First cycle
    add1_1 = val1 + carry0 + (0xffffffffffffff00 if sign0 else 0)
    add2_1 = val2 + carry1 + (0xffffffffffffff00 if sign1 else 0)
    add3_1 = val3 + carry2 + (0xffffffffffffff00 if sign2 else 0)

    carry1_1 = add1_1 >> 64
    carry2_1 = add2_1 >> 64
    add1_1 &= mask
    add2_1 &= mask
    add3_1 &= mask

    # Second cycle
    add2_2 = add2_1 + carry1_1 + (0xffffffffffffffff if sign0 else 0)
    add3_2 = add3_1 + carry2_1 + (0xffffffffffffffff if sign1 else 0)

    carry2_2 = add2_2 >> 64
    add2_2 &= mask
    add3_2 &= mask

    # Third cycle
    add3_3 = add3_2 + carry2_2 + (0xffffffffffffffff if sign0 else 0)
    add3_3 &= mask

    return (add3_3 << 192) + (add2_2 << 128) + (add1_1 << 64) + val0

def poly_add(poly_x, poly_y):
    return [x + y for x, y in zip(poly_x, poly_y)]

def poly_sub(poly_x, poly_y):
    mask = 2**72 - 1
    return [(x + (0xffffffffffffffffff ^ y) + 1) & mask for x, y in zip(poly_x, poly_y)] # 72 bits for 64 bits

def print_poly(x):
    print(list(map(hex, x)))

def parse_rom():
    with open('rom', 'r') as f:
        rom = f.readlines()

    set_rom = set()
    list_cmul = []
    for i, inst in enumerate(rom):

        me0 = inst[25:26]
        me1 = inst[24:25]
        preadder_mode1 = inst[22:24]
        preadder_mode2 = inst[20:22]
        cmul_mode = inst[17:20]
        postadder_mode1 = inst[14:17]
        postadder_mode2 = inst[11:14]
        postadder_mode3 = inst[8:11]
        postadder_sel = inst[6:8]
        postadder_addr2 = inst[4:6]
        postadder_addr3 = inst[2:4]
        eeinv = inst[1:2]
        waddr0 = inst[27:35]
        waddr1 = inst[35:43]
        raddr0 = inst[43:51]
        raddr1 = inst[51:59]
        print(raddr1)
        list_cmul.append(cmul_mode)

    print(collections.Counter((list_cmul)))

if __name__ == '__main__':
    args = sys.argv
    random.seed(0)
    for i in range(1000000):
        x = random.randint(0, 2**256-1)
        y = random.randint(0, 2**250-1)
        poly_x = int2poly(x)
        poly_y = int2poly(y)
        poly_z = poly_sub(poly_x, poly_y)
        poly_z = poly_sub(poly_z, poly_y)
        poly_z = poly_sub(poly_z, poly_y)
        poly_z = poly_sub(poly_z, poly_y)
        poly_z = poly_sub(poly_z, poly_y)
        poly_z = poly_sub(poly_z, poly_y)


        # print_poly(poly_x)
        # print_poly(poly_y)
        # print_poly(poly_z)
        z = poly2int_hw(poly_z)
        #print(hex(z))
        ans = x - 6*y
        if ans < 0:
            ans = abs(ans)
            ans = ans ^ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            ans += 1
        assert z == ans, f'{z:#x} != {ans:#x}'

    #main()
    #parse_rom()
