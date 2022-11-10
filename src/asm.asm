//Init f
//Init T
//Init ~P

Fp2_sqr r32, r12, r13             // A = y^2
3Fp2_sqr_ix r34, r14, r15         // B = 3b'z^2
2Fp2_mul r36, r10, r12            // C = 2xy
3Fp2_sqr r38, r10, r11            // D = 3x^2
2Fp2_mul r40, r12, r14            // E = 2yz

//f0&2
Fp2_sqr_xi_wome r80, r22, r23   // acc = f3^2(1+i)
2Fp2_mul_xi_acc r80, r24, r20   // acc = 2f4f2(1+i)
2Fp2_mul_xi_acc r80, r26, r18   // acc = 2f5f1(1+i)
Fp2_sqr_acc r80, r16, r17       // ff0 = f0^2 + acc

//f1^2
2Fp2_mul_xi_wome r82, r26, r20       // 2f5f2(1+i)
2Fp2_mul_xi_acc r82, r24, r22  // 2f4f3(1+i)
2Fp2_mul_acc r82, r16, r18       // ff1 = 2f1f0+acc

ACC1_sub r28, r32, r34          // l30 = A0 - B0
3ACC1_sub r16, r32, r34         // Tx0 = A0 - 3B0
ACC1_sub r29, r33, r35          // l31 = A1 - B1
3ACC1_sub r17, r33, r35         // Tx1 = A1 - 3B1

//f2^2
Fp2_sqr_xi_wome r80, r24, r25   // acc = f4^2(1+i)
2Fp2_mul_xi_acc r80, r26, r22   // acc = 2f5f3(1+i) + acc
2Fp2_mul_acc r80, r20, r16      // acc = 2f2f0 + acc
Fp2_sqr r80, r18, r19           // ff0 = f1^2 + acc

