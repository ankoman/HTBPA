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
import QPMM_d0

Inst = collections.namedtuple('Inst', ('exit', 'me0', 'me1', 'preadd_mode0', 'preadd_mode1', 
'cmul_mode', 'postadd_mode0', 'postadd_mode1', 'postadd_mode2', 'postadd_sel', 'postadd_addr1', 'postadd_addr2',
'eeinv', 'waddr0', 'waddr1', 'raddr0', 'raddr1'))

#######################################################################################
###################################Global Params#######################################
#######################################################################################
M = 0x2523648240000001ba344d80000000086121000000000013a700000000000013
M_tilde = 0x7d18c77dfc340005d1864d4d3800001c39ab785000000042327630000000003ffff
LAT_READ = 1
LAT_PREADD = 1
LAT_QPMM = 13
LAT_CMUL = 1
LAT_POSTADD = 1
MR = QPMM_d0.MR

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

def reg_init():
    preadder.dly_x = 0
    preadder.dly_y = 0
    preadder.z0 = 0
    preadder.z1 = 0

    qpmm.buf = [0] * (LAT_QPMM+1)
    cmul.buf = [0] * (LAT_CMUL+1)

    postadder.reg1 = 0
    postadder.reg2 = [0, 0, 0]
    postadder.reg3 = [0, 0, 0]
    postadder.dout = 0

def preadder(x, y, mode1, mode2):
    add_buf_0 = preadder.dly_x + x
    add_buf_1 = x + y
    add_buf_2 = x - y
    add_buf_3 = x + preadder.dly_y

    z0 = preadder.z0
    z1 = preadder.z1
    preadder.dly_x = x
    preadder.dly_y = y
    preadder.z0 = add_buf_0 if (mode1 == 1) else add_buf_1 if (mode1 == 2) else x
    preadder.z1 = add_buf_2 if (mode2 == 1) else add_buf_3 if (mode2 == 2) else y

    return z0, z1

def qpmm(x, y):
    z = QPMM_d0.QPMM(x, y)
    qpmm.buf = [z] + qpmm.buf[:-1]  # rshift
    return qpmm.buf[LAT_QPMM]

def cmul(din, mode):
    dout = din if (mode == 1) else 2*din if (mode == 2) else 3*din if (mode == 3) else 4*din if (mode == 4) else 6*din if (mode == 6) else None
    cmul.buf = [dout] + cmul.buf[:-1]  # rshift
    return cmul.buf[LAT_CMUL]

def acc(din, regin, mode):
    sel_b = 1 if (mode == 1 or mode == 4) else 0
    add_ain = 0 if (mode == 0 or mode == 1) else din if (mode == 2 or mode == 3) else regin if (mode == 4) else QPMM_d0.M if (mode == 5) else None
    add_bin = din if sel_b else regin
    add_sel_sub = 1 if (mode == 3 or mode == 4 or mode == 5) else 0
    dout = add_ain - add_bin if add_sel_sub else add_ain + add_bin
    return dout

def postadder(din_L1, mode1, mode2, mode3, outsel, addr2, addr3):
    acc1_out = acc(din_L1, postadder.reg1, mode1)
    acc2_out = acc(din_L1, postadder.reg2[addr2], mode2)
    acc3_out = acc(din_L1, postadder.reg3[addr3], mode3)

    postadder.dout = postadder.reg1 if (outsel == 0) else postadder.reg2[addr2] if (outsel == 1) else postadder.reg3[addr3]
    postadder.reg1 = acc1_out
    postadder.reg2[addr2] = acc2_out
    postadder.reg3[addr3] = acc3_out

    return postadder.dout

def ram_to_mont(ram):
    for i in range(0x0b):
        ram[i] = (ram[i] * QPMM_d0.r) % QPMM_d0.M
        print(f'{ram[i]=:064x}')

def main():
    # Init
    reg_inst = [decode('00000000000000000001000000000000000000000000000000000000000')] * 20
    reg_init()
    ### Not Montgomery representation
    ram0 = [0] * 256
    ram0[0x00] = 0x115f6879d11e64eb6b454c4355c8070d23495140d6c0aa008ed3091379e08f1c # Qx0 = 0x115f6879d11e64eb6b454c4355c8070d23495140d6c0aa008ed3091379e08f1c
    ram0[0x01] = 0xd571e533a64272092790168e7561326764146ec48dd977b3b212bdcb5e92b03 # Qx1 = 0xd571e533a64272092790168e7561326764146ec48dd977b3b212bdcb5e92b03
    # ram0[0x02] = 0xbc9a802bfe83440104d9bc9f0d4ffafc19d114c8f47b8f3e0a3e979d6c3012a # Qy0 = 0xbc9a802bfe83440104d9bc9f0d4ffafc19d114c8f47b8f3e0a3e979d6c3012a
    # ram0[0x03] = 0x1b35419758c62bbcb75f33ca54b21fe5ea859e303fb0f1e47e5bcc7538d3cb4c # Qy1 = 0x1b35419758c62bbcb75f33ca54b21fe5ea859e303fb0f1e47e5bcc7538d3cb4c
    ram0[0x02] = 0x0b69136889b5b368df14c6125f58d5b56f790959a3e04b3b756b0715e7180322
    ram0[0x03] = 0x115e2eac26a974652371ea2c0247145f4a814d53964ddb776025f0ae35354579

    ram0[0x04] = 0x1 # Qz0
    ram0[0x05] = 0x0 # Qz1
    ram0[0x06] = 0x1d8b58a5aee6422aa87af5823a11244eb0c74e459f31787ab3cbd7f42d729c4d  # Px = 0x1d8b58a5aee6422aa87af5823a11244eb0c74e459f31787ab3cbd7f42d729c4d
    ram0[0x07] = 0x233fb028224a5a3f72d95aaeb9b40e393d6f66591b664fc4d74b1ca4746fd6b  # Py = 0x233fb028224a5a3f72d95aaeb9b40e393d6f66591b664fc4d74b1ca4746fd6b
    ram0[0x08] = 0x1 # Pz unneccesary
    ram0[0x09] = 0x1 # r2
    ram0[0x0a] = 0x1 # ri
    ram0[0x0b] = 0x1
    ram_to_mont(ram0)

    # T = Q
    ram0[0x20] = ram0[0x00] # 32
    ram0[0x21] = ram0[0x01] # 33
    ram0[0x22] = ram0[0x02] # 34
    ram0[0x23] = ram0[0x03] # 35
    ram0[0x24] = ram0[0x04] # 36
    ram0[0x25] = ram0[0x05] # 37

# 1291992088000000138403ad00000000060c0c000000000000c6cc0000000000000b,
# 11efb2745473e4db8634da1ea10914a07553998e838c5ae8cbf258da3ba9cb1681c5,
# 11efb2745473e4db8634da1ea10914a07553998e838c5ae8cbf258da3ba9cb1681c5,
# 24d998900000000022484800000000000666c00000000000007,

    rom = load_rom()

    # Calculation cycle by cycle
    cycle_cnt = 3
    pc = 0
    rdat0 = 0
    rdat1 = 0

    while True:
        pc += 1
        cycle_cnt += 1
        print(f'CCNT: {cycle_cnt}')
        inst = decode(rom[pc])
        #print(inst)

        reg_inst = [inst] + reg_inst[:-1]  # rshift
        buf_rdat0, buf_rdat1 = rdat0, rdat1
        rdat0, rdat1 = ram0[inst.raddr0], ram0[inst.raddr1]
        print(f'{MR(buf_rdat0)=:x}, {MR(buf_rdat1)=:x}')
        ins_preadd, ins_cmul, ins_postadd, inst_wram = reg_inst[LAT_READ], reg_inst[LAT_READ+LAT_PREADD+LAT_QPMM], reg_inst[LAT_READ+LAT_PREADD+LAT_QPMM+LAT_CMUL], reg_inst[18]

        preadd_out0, preadd_out1 = preadder(buf_rdat0, buf_rdat1, ins_preadd.preadd_mode0, ins_preadd.preadd_mode1)
        print(f'Preadder: {MR(preadd_out0)=:x}, {MR(preadd_out1)=:x}')

        qpmm_dout = qpmm(preadd_out0, preadd_out1)
        print(f'QPMM: {MR(qpmm_dout)=:x}')

        cmul_dout = cmul(qpmm_dout, ins_cmul.cmul_mode)
        print(f'Cmul: {MR(cmul_dout)=:x}')

        print(ins_postadd)
        postadd_dout = postadder(cmul_dout, ins_postadd.postadd_mode0, ins_postadd.postadd_mode1, ins_postadd.postadd_mode2, ins_postadd.postadd_sel, ins_postadd.postadd_addr1, ins_postadd.postadd_addr2)
        print(f'Postadder: {MR(postadd_dout)=:#x}')

        input()
        if inst.exit or cycle_cnt > 100:
            print('End')
            break

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
    list_freq = []
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
        print(waddr0)
        list_freq.append(int(raddr0, 2))
        list_freq.append(int(raddr1, 2))

    list_freq = list(set(list_freq) & set(list(range(141))))
    list_freq = list( set(list(range(141))) - set(list_freq))
    list_freq.sort()

    print(list_freq)
    print(list(map(hex, list_freq)))


    print(collections.Counter((list_freq)))

def test_red():

    for i in range(10000):
        A = random.randint(0, M_tilde - 1)
        B = random.randint(0, M_tilde - 1)
        Ax = int2poly(A)
        Bx = int2poly(B)

        res = poly2int_hw(Ax)
        ans = A

        assert res == ans, f'\n{res=  :x}\n{ans=:x}'


if __name__ == '__main__':
    args = sys.argv
    random.seed(0)

    test_red()
    #main()
    #parse_rom()
