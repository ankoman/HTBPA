call input_to_Mont
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles


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
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x20, 0x20  // Fp12_sqr(&tt, &t[0]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x0, 0x0 // Fp12_sqr(&t[1], &tt);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x20, 0x0, 0x30 // Fp12_mul(&t[0], &tt, &t[1]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_conj 0x30, 0x10, 0x10 // Fp12_conj(&t[1], f);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x20, 0x30 // Fp12_mul(&tt, &t[0], &t[1]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_frob_p 0x40, 0x00
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x00, 0x00 // Fp12_sqr(&t[1], &tt);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x30, 0x40 // Fp12_mul(&tt, &t[1], &t[2]);


//// Fp12_pow_minusU(&t[2], &t[0]);
call Fp12_comp 0x60, 0x20, 0x20
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
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
call Fp12_mul 0x70, 0x20, 0x50  // t5 = t0*t55
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x40, 0x70, 0x60  // t2 = t0^-u
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x20, 0x40, 0x40  // Fp12_sqr(&t[0], &t[2]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_frob_p 0x20, 0x20     // Fp12_frob_p(&t[0], &t[0]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x00, 0x20  // Fp12_mul(&t[1], &tt, &t[0]);

call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x40, 0x10  // Fp12_mul(&tt, &t[2], f);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_frob_p2 0x20, 0x00    // Fp12_frob_p2(&t[0], &tt);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x40, 0x20, 0x30  // Fp12_mul(&t[2], &t[0], &t[1]);

//// Fp12_pow_minus6U_5(&t[0], &tt);
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
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_decomp 0x60, 0x60, 0x60 // Delayed execution t56
call Fp12_decomp 0x70, 0x70, 0x70 // Delayed execution t57
call Fp12_mul 0x50, 0x00, 0x60  // t3 = tt*t56
call Fp12_comp 0x60, 0x60, 0x60
call Fp12_mul 0x20, 0x50, 0x70  // t0 = t3*t57
call Fp12_comp 0x70, 0x70, 0x70
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_comp_sqr 0x10, 0, 0
call Fp12_comp_sqr 0, 0x10, 0x10
call Fp12_decomp 0x70, 0x70, 0x70 // Delayed execution t63
call Fp12_decomp 0x60, 0x60, 0x60 // Delayed execution t64
call Fp12_mul 0x50, 0x20, 0x70  // t3 = t0*t63
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x20, 0x50, 0x60  // t0 = t3*t64 = tt^(-6u-5)
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x40, 0x20  // Fp12_mul(&t[1], &t[2], &t[0]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

call Fp12_frob_p 0x00, 0x20     // Fp12_frob_p(&tt, &t[0]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x40, 0x30, 0x00  // Fp12_mul(&t[2], &t[1], &tt);

call Fp12_mul 0x20, 0x10, 0x10  // Fp12_sqr(&t[0], f);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x20, 0x20  // Fp12_sqr(&tt, &t[0]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x10, 0x00  // Fp12_mul(&t[1], f, &tt);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x00, 0x30, 0x40  // Fp12_mul(&tt, &t[1], &t[2]);

call Fp12_mul 0x40, 0x30, 0x20  // Fp12_mul(&t[2], &t[1], &t[0]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_frob_p 0x40, 0x40     // Fp12_frob_p(&t[2], &t[2]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x30, 0x40, 0x00  // Fp12_mul(&t[1], &t[2], &tt);

call Fp12_frob_p3 0x40, 0x10     // Fp12_frob_p3(&t[2], f);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Fp12_mul 0x10, 0x40, 0x30  // Fp12_mul(z, &t[2], &t[1]);
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles
call Wait_2cycles

call res_from_Mont
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