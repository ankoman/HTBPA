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


`ifndef PARAMS_BN254_16_16
`define PARAMS_BN254_16_16
package PARAMS_BN254_16_16;
    localparam
        K = 16,
        L = 16,
        D = 0,
        Mod = 256'h2523648240000001ba344d80000000086121000000000013a700000000000013, //The BN254 prime
        _Mpp = 256'h7d18c77dfc340005d1864d4d3800001c39ab785000000042327630000000004,
        M_tilda = 272'h0x7d18c77dfc340005d1864d4d3800001c39ab785000000042327630000000003ffff,
        N = 17,
        M = 17,
        HALF_S = (M+D+1)/2; // must be even
    
    typedef logic[M:0][47:0] qpmm_S_t;
    typedef logic[M-2:0][L-1:0] poly_Mpp_t;
    typedef logic[K*N-1:0] uint_fp_t;
    typedef logic[M-1:0][L-1:0] poly_a_t;
    typedef logic[N-1:0][K-1:0] poly_b_t;
    typedef logic[(HALF_S-1)*L+48-1:0] qpmm_S_half;

    typedef union packed {
        uint_fp_t uint;
        poly_a_t poly_a;
        poly_b_t poly_b;
    } qpmm_fp_t;

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
