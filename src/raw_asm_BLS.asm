call ML_1
call ML_0
call ML_1
call ML_0
call ML_0
call ML_1
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
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

call EasyPart
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

call Fp12_mul 0x00, 0x10, 0x10  // Fp12_sqr(&tt, &f) step 1
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x20, 0x00, 0x10  // t0 = tt*f
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

call Fp12_comp 0x60, 0x00, 0x00
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t16
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_copy 0x50, 0x60 // t3 = t16
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t48
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // tt = t3*t48
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t57
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x50, 0x00, 0x70  // t3 = tt*t57
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t60
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // t0 = t3*t60
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t62
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t63
call Fp12_mul 0x50, 0x00, 0x60  // t3 = t0*t62
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x50, 0x70  // t1 = t3*t63 = tt**-u
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles


//t2 = t1**(-u//2)
call Fp12_comp 0x70, 0x30, 0x30
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t16
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_copy 0x50, 0x60 // t3 = t16
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t48
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // tt = t3*t48
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t57
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x50, 0x00, 0x70  // t3 = tt*t57
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t60
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // t0 = t3*t60
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t62
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t63
call Fp12_mul 0x50, 0x00, 0x60  // t3 = t0*t62
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x40, 0x50, 0x70  // t2 = t3*t63 = tt**-u//2
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

call Fp12_mul 0x50, 0x30, 0x40  // t3 = t1*t2
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x50, 0x10  // t1 = t3*f
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

//t2 = t1**-u
call Fp12_comp 0x60, 0x30, 0x30
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t16
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_copy 0x50, 0x60 // t3 = t16
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t48
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // tt = t3*t48
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t57
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x50, 0x00, 0x70  // t3 = tt*t57
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t60
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // t0 = t3*t60
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t62
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t63
call Fp12_mul 0x50, 0x00, 0x60  // t3 = t0*t62
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x40, 0x50, 0x70  // t2 = t3*t63 = tt**-u
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_conj 0x50, 0x40, 0x40 // t3 = t2**(p**12-2)
call Fp12_frob_p 0x00, 0x30 //tt = t1**p
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x00, 0x50  // t1 = tt*t3
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

//t2 = t1**-u
call Fp12_comp 0x60, 0x30, 0x30
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t16
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_copy 0x50, 0x60 // t3 = t16
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t48
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // tt = t3*t48
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t57
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x50, 0x00, 0x70  // t3 = tt*t57
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t60
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // t0 = t3*t60
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t62
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t63
call Fp12_mul 0x50, 0x00, 0x60  // t3 = t0*t62
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x40, 0x50, 0x70  // t2 = t3*t63 = tt**-u
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles


//tt = t2**-u
call Fp12_comp 0x60, 0x40, 0x40
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t16
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_copy 0x50, 0x60 // t3 = t16
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t48
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // tt = t3*t48
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t57
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x50, 0x00, 0x70  // t3 = tt*t57
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t60
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x60  // t0 = t3*t60
call Fp12_comp_sqr 0, 0x10, 0x10      //odd
call Fp12_comp_sqr 0x10, 0, 0  //even
call Fp12_decomp 0x60, 0x60, 0x60  // Delayed execution t62
call Fp12_decomp 0x70, 0x70, 0x70  // Delayed execution t63
call Fp12_mul 0x50, 0x00, 0x60  // t3 = t0*t62
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x50, 0x70  // tt = t3*t63 = tt**-u
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_conj 0x40, 0x30, 0x30 // t2 = t1**(p**12-2)
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x50, 0x40, 0x00  // t3 = t2*tt
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_frob_p 0x30, 0x30 //t1 = t1**(p**2)
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_frob_p 0x30, 0x30 //t1 = t1**(p**2)
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x40, 0x30, 0x50  // t2 = t1*t3
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x10, 0x40, 0x20  // f = t2*t0
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
exit