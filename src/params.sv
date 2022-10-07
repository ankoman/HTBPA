`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 08/16/2022 10:49:29 AM
// Design Name: 
// Module Name: params
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`ifndef PARAMS_BN254_d0
`define PARAMS_BN254_d0
package PARAMS_BN254_d0;
    localparam
        K = 16,
        L = 24,
        C = L - K,
        D = 0,
        Mod = 256'h2523648240000001ba344d80000000086121000000000013a700000000000013, //The BN254 prime
        _Mpp = 256'h7d18c77dfc340005d1864d4d3800001c39ab785000000042327630000000004,
        M_tilda = 272'h0x7d18c77dfc340005d1864d4d3800001c39ab785000000042327630000000003ffff, // 268 bits
        r = 272 - 1,
        N = r/K + 1, // 17 at k=16
        M = r/L + 1, //12 at L=24
        HALF_S = (M+D+1)/2, // must be even
        S_1_3 = (M+D+1)/3,  // 1/3
        //S_1_4 = (M+D-1)/4;  // 1/4
        S_1_4 = (M+D)/4;  // 1/4

    
    typedef logic[M:0][47:0] qpmm_S_t;
    typedef logic[M-2:0][L-1:0] poly_Mpp_t;
    typedef logic[K*N-1:0] uint_fp_t;
    typedef logic[L*M-1:0] uint_fpa_t;
    typedef logic[M-1:0][L-1:0] poly_a_t; //288
    typedef logic[N-1:0][K-1:0] poly_b_t; //272
    typedef logic[(HALF_S-1)*L+48-1:0] qpmm_S_half;
    typedef logic[(S_1_3-1)*L+48-1:0] qpmm_S_1_3;
    typedef logic[(S_1_4-1)*L+48-1:0] qpmm_S_1_4;
    typedef logic[$bits(uint_fp_t)/4-1:0] fp_div4_t; // uint divided by 4.

   typedef struct packed {
        logic carry;
        fp_div4_t val;
    } redundant_term_L1;
    typedef redundant_term_L1[3:0] redundant_poly_L1;

   typedef struct packed {
        logic [1:0] carry;
        fp_div4_t val;
    } redundant_term_L2;
    typedef redundant_term_L2[3:0] redundant_poly_L2;

   typedef struct packed {
        logic [7:0] carry;
        fp_div4_t val;
    } redundant_term_L3;
    typedef redundant_term_L3[3:0] redundant_poly_L3;

    typedef union packed {
        uint_fp_t uint;
        poly_b_t poly_b;
    } qpmm_fp_t;

    typedef union packed {
        uint_fpa_t uint;
        poly_a_t poly_a;
    } qpmm_fpa_t;

    typedef union packed {
        uint_fp_t uint;
        poly_b_t poly_b;
    } qpmm_fpb_t;

    function qpmm_fp_t rand_280();
        // N must be less than 320 bits
        logic [287:0] tmp;
        assign tmp = {$urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom()};
        rand_280 = {10'd0, tmp[269:0]};
    endfunction

endpackage
`endif 

// package Utility_function;

//     function [Parameters::N+Parameters::D-1:0] randN();
//         // N must be less than 320 bits
//         randN = {$urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom()};
//     endfunction

//     function [Parameters::K:0][Parameters::D:0] int2poly;
//         input [(Parameters::K+1)*(Parameters::D+1)-1:0] A;

//         for(integer i = 0; i <= Parameters::K; i = i + 1) begin
//             int2poly[i] = {1'b0, A[i*Parameters::D +:Parameters::D]};
//         end
//     endfunction
    
//     function [2*(Parameters::N+Parameters::D)-1:0] poly2int_2ND;
//         input [2*Parameters::K+2:0][Parameters::D:0] A;

//             poly2int_2ND = 0;
//             for(integer i = 0; i <= 2*Parameters::K+2; i = i + 1) begin
//                 poly2int_2ND = poly2int_2ND + (A[i] << (Parameters::D*i));
//             end
//     endfunction

//     function [Parameters::N+Parameters::D-1:0] poly2int_ND;
//         input [Parameters::K:0][Parameters::D:0] A;

//             poly2int_ND = 0;
//             for(integer i = 0; i <= Parameters::K; i = i + 1) begin
//                 poly2int_ND = poly2int_ND + (A[i] << (Parameters::D*i));
//             end
//     endfunction

// endpackage
