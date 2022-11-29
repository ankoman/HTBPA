
call ML_1
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_1
call ML_1
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_0
call ML_1
call ML_0
call ML_0FA
call EasyPart

call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_copy 0x50, 0x70, 0x70 // Delayed execution
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_decomp 0x50, 0x50, 0x50
call Fp12_decomp 0x60, 0x60, 0x60
call Fp12_mul 0x70, 0x10, 0x50  // t5 = f*t55
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x20, 0x70, 0x60  // t0 = f^-u
exit