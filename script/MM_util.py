# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Name:        MM_util.py
# Purpose:
#
# Author:      junichi sakamoto
#
# Created:     15/08/2022
# Copyright:   (c) sakamoto 2022
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import random

_M = 0
_k = 0
_d = 0
_R = 0
_R_inv = 0

def MM_init(M, k, d, R):
    global _M, _k, _d, _R, _R_inv
    _M = M
    _k = k
    _d = d
    _R = R
    _R_inv = get_R_inv()

def get_M_prime(): # M_bar
    return 2**(_k*(_d + 1)) - pow(_M, 2**(_k*(_d + 1)) - 1, 2**(_k*(_d + 1)))

def get_Mpp():
    return (get_M_tilda() + 1) // 2**(_k*(_d + 1))

def get_M_tilda():
    return get_M_prime() * _M

def get_R_inv():
    return pow(_R, _M-2, _M)

def MF(val):
    return (val * _R) % get_M_tilda()

def MR(val):
    return (val * _R_inv) % _M
