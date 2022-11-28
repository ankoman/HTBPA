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
import raw_csig

filepath = r'./raw_asm.asm'

list_INS_CTRL = ['jmp', 'call', 'ret', 'wait', 'exit']
list_INS_Fp2 = ['Fp2_add', 'Fp2_sub', 'Fp2_mul', 'Fp2_sqr', 'Fp2_sqr_ix', 'Fp2_sqr_xi', 'Fp2_mul_xi']
list_INS_Fp2_acc = ['Fp2_add_acc', 'Fp2_sub_acc', 'Fp2_mul_acc', 'Fp2_sqr_acc', 'Fp2_sqr_ix_acc', 'Fp2_sqr_xi_acc', 'Fp2_mul_xi_acc']
list_INS_Fp12 = ['Fp12_add', 'Fp12_sub', 'Fp12_mul', 'Fp12_sqr', 'Fp12_inv']
list_INS_ACC = ['ACC1_add', 'ACC1_sub']
list_SUFFIX = ['wome']

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

    ins = ins.rstrip('_')
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

    if regnum > 127:
        print(f'Error regnum: {regnum}')
        exit(1)

    if regSymbol == 'r':
        regnum = format(regnum, '07b')
    else:
        print('No register: ', reg)
        exit(1)

    return regnum


def genBinMain(ins, args, suffix):

    ins, prefix = getPrefix(ins)
    ins, suffix = getSuffix(ins)
    print(prefix, end='')
    print(ins, end='')
    print(suffix)

    list_bin = []
    if ins in list_INS_CTRL:
        list_bin.append('001')
        list_bin.append(format(list_INS_CTRL.index(ins), '04b'))
    elif ins in list_INS_Fp2:
        list_bin.append('000')
        list_bin.append(format(list_INS_Fp2.index(ins), '04b'))
    elif ins in list_INS_Fp2_acc:
        list_bin.append('010')
        list_bin.append(format(list_INS_Fp2_acc.index(ins), '04b'))
    elif ins in list_INS_Fp12:
        list_bin.append('100')
        list_bin.append(format(list_INS_Fp12.index(ins), '04b'))
    elif ins in list_INS_ACC:
        list_bin.append('110')
        list_bin.append(format(list_INS_ACC.index(ins), '04b'))
    else:
        print(f"No defined ins: {ins}")
        exit(-1)
        
    ### subfunc
    ### me
    if 'wome' in suffix:
        list_bin.append('0')
    else:
        list_bin.append('1')

    ### cmul
    list_bin.append(format(prefix, '03b'))

    ### end_mop_cnt
    if ins in ['Fp2_mul', 'Fp2_mul_acc']:
        end_mop_cnt = 2
    elif ins in ['Fp2_sqr', 'Fp2_sqr_acc']:
        end_mop_cnt = 1
    elif ins == 'Fp2_sqr_ix':
        end_mop_cnt = 2
    elif ins == 'Fp2_sqr_xi':
        if 'wome' in suffix:
            end_mop_cnt = 1
    elif ins == 'Fp2_mul_xi':
        if 'wome' in suffix:
            end_mop_cnt = 2
    elif ins == 'Fp2_mul_xi_acc':
        end_mop_cnt = 2
    elif ins in list_INS_ACC:
        end_mop_cnt = 1
    else:
        print(f"No defined ins(suffix): {ins}")
        exit(-1)  
    list_bin.append(format(end_mop_cnt, '04b'))

    #Reg
    list_bin.append(encodeReg(args[0])) # dst
    list_bin.append(encodeReg(args[1])) # src0
    list_bin.append(encodeReg(args[2])) # src1

    print(list_bin)
    return ''.join(list_bin)



def assemble_mop(list_asm):

    list_coe = ['memory_initialization_radix=2;\nmemory_initialization_vector=\n001000000001111000000000000000000000\n']
    for i, line in enumerate(list_asm):
        ins, args = getInsArgs(line)
        #ins, suffix = getSuffix(ins)
        bincode = genBinMain(ins, args, None)

        #print(hex(int(bincode, 2)), bincode, line)
        #list_coe.append(''.join(['out_b <= 32\'h', hex(int(bincode, 2))[2:], ';    //', bincode, ' ',line, '\n']))
        list_coe.append(''.join([bincode, ',\n']))
    list_coe.append(';')

    return list_coe

def assemble_raw(list_asm):

    n_ins = len(list_asm)
    dict_funcs = {}
    for key, value in vars(raw_csig).items():
        if key.startswith('__'):
            continue
        dict_funcs[key] = value

    list_func_addr = [0]
    for key in dict_funcs.keys():
        list_func_addr.append(list_func_addr[-1] + len(dict_funcs[key]))

    list_coe = [
        'memory_initialization_radix=2;\nmemory_initialization_vector=\n00000000000000000000000000100000000000000000000000000000000,\n']
    for i, line in enumerate(list_asm):
        ins, args = getInsArgs(line)
        if not ins in list_INS_CTRL:
            print(f'Ins not found {ins}')
        
        list_bin = []
        if ins == 'call':
            jmp_addr = list_func_addr[list(dict_funcs.keys()).index(args[0])] + n_ins + 1
            # print(jmp_addr, end='')
            ### jmp_addr = {waddr0, waddr1}
            # list_bin.append('000000000000000000010000001')
            # list_bin.append(format(jmp_addr, '016b'))
            # list_bin.append('0000000000000000')
            ### jmp_addr = {pos, pom3, pom2, pom1} = 11 bits
            list_bin.append('000000')
            list_bin.append(format(jmp_addr, '011b'))
            list_bin.append('0010000001')
            if len(args) == 1:
                list_bin.append('00000000000000000000000000000000')
            elif len(args) == 4:
                list_bin.append(format(int(args[1], 10), '08b')) # waddr0
                list_bin.append(format(int(args[1], 10), '08b')) # waddr1
                list_bin.append(format(int(args[2], 10), '08b')) # raddr0
                list_bin.append(format(int(args[3], 10), '08b')) # raddr1

            else:
                print(f'Error: call is not recognised {ins}')

        elif ins == 'exit':
            list_bin.append('00000000000000000000000000100000000000000000000000000000000')  # EXIT

        # print(list_bin)
        bincode = ''.join(list_bin)
        list_coe.append(''.join([bincode, ',\n']))

    for val in dict_funcs.values():  
        ### Check
        for i, line in enumerate(val):
            line = ''.join(line.split())
            me0 = line[25:26]
            me1 = line[24:25]
            cm = line[17:20]
            poa2 = line[4:6]
            poa3 = line[2:4]
            waddr0 = line[27:35]
            waddr1 = line[35:43]
            raddr0 = line[43:51]
            raddr1 = line[51:59]
            # if me0 != me1:
            #     print(f'Error: me0 != me1: {i}')
            if cm not in ['001', '010', '011', '100', '110']:
                print(f'Error: cm: {i}')
            if int(poa2, 2) != 0:
                print(f'poa2 != 0: {i}')
            if int(poa3, 2) != 0:
                print(f'poa3 != 0: {i}')
            if waddr0 != waddr1:
                print(f'Error: waddr0 != waddr1: {i}, {waddr0}, {waddr1}')
            if int(waddr0, 2) in [0x4c, 0x4d, 0x4e, 0x4f, 0x5c, 0x5d, 0x5e, 0x5f, 0x6c, 0x6d, 0x6e, 0x6f]:
                print(f'Error: waddr0: {i}, {waddr0}')
            if int(raddr0, 2) in [0x4c, 0x4d, 0x4e, 0x4f, 0x5c, 0x5d, 0x5e, 0x5f, 0x6c, 0x6d, 0x6e, 0x6f]:
                print(f'Error: raddr0: {i}, {raddr0}')
            if int(raddr1, 2) in [0x4c, 0x4d, 0x4e, 0x4f, 0x5c, 0x5d, 0x5e, 0x5f, 0x6c, 0x6d, 0x6e, 0x6f]:
                print(f'Error: raddr0: {i}, {raddr1}')
            # Frobenius change
            if int(raddr0, 2) in [0x78, 0x79, 0x7c, 0x85]:
                line = line[:43] + f'{0x5e:08b}' + line[:51]
            if int(raddr1, 2) in [0x78, 0x79, 0x7c, 0x85]:
                line = line[:51] + f'{0x5e:08b}'
            if int(raddr0, 2) in [0x7a, 0x8a]:
                line = line[:43] + f'{0x5f:08b}' + line[:51]
            if int(raddr1, 2) in [0x7a, 0x8a]:
                line = line[:51] + f'{0x5f:08b}'
            if int(raddr0, 2) in [0x7b]:
                line = line[:43] + f'{0x6c:08b}' + line[:51]
            if int(raddr1, 2) in [0x7b]:
                line = line[:51] + f'{0x6c:08b}'
            if int(raddr0, 2) in [0x7d, 0x7e, 0x7f, 0x84]:
                line = line[:43] + f'{0x6d:08b}' + line[:51]
            if int(raddr1, 2) in [0x7d, 0x7e, 0x7f, 0x84]:
                line = line[:51] + f'{0x6d:08b}'
            if int(raddr0, 2) in [0x80, 0x81]:
                line = line[:43] + f'{0x6e:08b}' + line[:51]
            if int(raddr1, 2) in [0x80, 0x81]:
                line = line[:51] + f'{0x6e:08b}'
            if int(raddr0, 2) in [0x82, 0x8c]:
                line = line[:43] + f'{0x6f:08b}' + line[:51]
            if int(raddr1, 2) in [0x82, 0x8c]:
                line = line[:51] + f'{0x6f:08b}'
            if int(raddr0, 2) in [0x83, 0x8b]:
                line = line[:43] + f'{0x7c:08b}' + line[:51]
            if int(raddr1, 2) in [0x83, 0x8b]:
                line = line[:51] + f'{0x7c:08b}'
            if int(raddr0, 2) in [0x86, 0x87]:
                line = line[:43] + f'{0x7d:08b}' + line[:51]
            if int(raddr1, 2) in [0x86, 0x87]:
                line = line[:51] + f'{0x7d:08b}'
            if int(raddr0, 2) in [0x88]:
                line = line[:43] + f'{0x7e:08b}' + line[:51]
            if int(raddr1, 2) in [0x88]:
                line = line[:51] + f'{0x7e:08b}'
            if int(raddr0, 2) in [0x89]:
                line = line[:43] + f'{0x7f:08b}' + line[:51]
            if int(raddr1, 2) in [0x89]:
                line = line[:51] + f'{0x7f:08b}' 

            # if int(waddr0, 2) == 48:
            #     print(f'waddr = 48: L{i}')
            list_coe.append(line)
            list_coe.append(',\n')

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

    list_obj = assemble_raw(list_asm)

    with open('out_obj.txt', 'w') as f:
        f.writelines(list_obj)

def temp():
    with open('./microcode.coe', 'r') as f:
        for line in f:
            print('\'', end='')
            print(line.rstrip(',\n'), end = '')
            print('\',')

if __name__ == '__main__':
    main()
    #temp()