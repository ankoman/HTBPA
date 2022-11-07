#-------------------------------------------------------------------------------
# Name:        assemble.py
# Purpose:
#
# Author:      Junichi Sakamoto
#
# Created:     06/11/2022
# Copyright:   (c) M-2018-04 2020
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import re

filepath = r'./asm.asm'

list_INS_CTRL = ['jmp', 'call', 'ret', 'wait']
list_INS_Fp = ['Fp_add', 'Fp_sub', 'Fp_mul', 'Fp_sqr', 'Fp_inv']
list_INS_Fp2 = ['Fp2_add', 'Fp2_sub', 'Fp2_mul', 'Fp2_sqr', 'Fp2_inv']
list_INS_Fp12 = ['Fp12_add', 'Fp12_sub', 'Fp12_mul', 'Fp12_sqr', 'Fp12_inv']


def getInsArgs(line):
    ins = line.split(' ')[0]
    args = [x.strip() for x in line.split(',')]
    if len(args[0].split(' ')) < 2:
        args = []
    else:
        args[0] = args[0].split(' ')[1]

    return ins, args


def getSuffix(ins):
    list_suffix = []

    for suf in list_SUFFIX:
        if suf in ins:
            ins = ins.strip(suf)
            list_suffix.append(suf)

    return ins, list_suffix

def getPrefix(ins):
    tmp = ins[0]

    if tmp.isdecimal():
        prefix = int(ins[0], 10)
        ins = ins[1:]
    else:
        prefix = 1

    return ins, prefix

def encodeReg(reg):
    regSymbol = reg[0]
    if regSymbol in ['r']:
        regnum = int(re.search(r'\d+', reg).group())

    if regSymbol == 'r':
        regnum = format(regnum, '07b')
    else:
        print('No register: ', reg)
        exit(1)

    return regnum


def genBinMain(ins, args, suffix):

    ins, prefix = getPrefix(ins)
    print(prefix)

    list_bin = []
    if ins in list_INS_CTRL:
        list_bin.append('001')
        list_bin.append(format(list_INS_CTRL.index(ins), '04b'))
    elif ins in list_INS_Fp:
        list_bin.append('000')
        list_bin.append(format(list_INS_Fp.index(ins), '04b'))
    elif ins in list_INS_Fp2:
        list_bin.append('010')
        list_bin.append(format(list_INS_Fp2.index(ins), '04b'))
    elif ins in list_INS_Fp12:
        list_bin.append('100')
        list_bin.append(format(list_INS_Fp12.index(ins), '04b'))
    else:
        print("No defined ins")
        exit(-1)
        
    #subfunc
    if ins == 'Fp2_sqr':
        prefix *= 2
    list_bin.append(format(prefix, '03b'))
    list_bin.append('00000')

    #Reg
    list_bin.append(encodeReg(args[0])) # dst
    list_bin.append(encodeReg(args[1])) # src0
    list_bin.append(encodeReg(args[2])) # src1

    print(list_bin)
    return ''.join(list_bin)



def assemble(list_asm):

    list_coe = ['memory_initialization_radix=2;\nmemory_initialization_vector=\n001000000000000000000000000000000000\n']
    for i, line in enumerate(list_asm):
        ins, args = getInsArgs(line)
        #ins, suffix = getSuffix(ins)
        bincode = genBinMain(ins, args, None)

        #print(hex(int(bincode, 2)), bincode, line)
        #list_coe.append(''.join(['out_b <= 32\'h', hex(int(bincode, 2))[2:], ';    //', bincode, ' ',line, '\n']))
        list_coe.append(''.join([bincode, ',\n']))
    list_coe.append(';')

    return list_coe


def main():

    list_asm = []
    with open(filepath, 'r') as f:
        for line in f:
            #Skip comments and empty lines
            if line.startswith('//'): continue
            if not line.strip(): continue
            list_asm.append(line.strip())

    list_obj = assemble(list_asm)

    with open('out_obj.txt', 'w') as f:
        f.writelines(list_obj)


if __name__ == '__main__':
    main()