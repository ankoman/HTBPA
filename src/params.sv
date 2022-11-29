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
        Mod = 384'h1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab, //The BLS12381 prime
        M_tilde = 397'h1a00c3e703c13a1a974cc6634c28e2f45df11e1f10f638302ef29d0e7ece12113c3fa3fab157ec03b9ffd202ffffaaabffff; // 397 bits
    localparam
        K = 17,
        L = 26,
        C = L - K,
        D = 0,
        _Mpp = 384'hd0061f381e09d0d4ba66331a614717a2ef88f0f887b1c1817794e873f6709089e1fd1fd58abf601dcffe9017fffd556, //k=17
        R = 425 - 1,
        R_INV = 'h5d0b6a95f0f140c9be94886e201ff4e1d3e75366d5014ac26f9e99e3ac1a0d2797922988d180e68f014e4fe540686ac, //r=425
        N = 25, // R/K + 1, at K = 17
        M = 16, // R/L +1
        HALF_S = (M+D+1)/2, // must be even
//        S_1_3 = (M+D+1)/3,  // 1/3
        S_1_3 = 6,
        //S_1_4 = (M+D-1)/4;  // 1/4
        S_1_4 = 4,//(M+D)/4,
        ADD_DIV = 4,
        L3_CARRY = 8,
        LEN_12M_TILDE = 404,
        LEN_1024M_TILDE = 407,  // Must be divided by ADD_DIV
        N_THREADS = 6,
        BRAM_DEPTH = 9;  

    typedef logic[$bits(M_tilde):0] uint_Mtilde2_t;
    typedef logic[M:0][47:0] qpmm_S_t;
    typedef logic[M-2:0][L-1:0] poly_Mpp_t;
    typedef logic[K*N-1:0] uint_fp_t;
    typedef logic[L*M-1:0] uint_fpa_t;
    typedef logic[M-1:0][L-1:0] poly_a_t; //288
    typedef logic[N-1:0][K-1:0] poly_b_t; //272
    typedef logic[(HALF_S-1)*L+48-1:0] qpmm_S_half;
    typedef logic[(S_1_3-1)*L+48-1:0] qpmm_S_1_3;
    typedef logic[(S_1_4-1)*L+48-1:0] qpmm_S_1_4;
    typedef logic[LEN_12M_TILDE/ADD_DIV-1:0] fp_div4_t; // uint divided by 4. Lack of 1 bit for 289
    // Struct
    typedef struct packed {
            logic carry;
            fp_div4_t val;
    } redundant_term_L1;
    typedef redundant_term_L1[ADD_DIV-1:0] redundant_poly_L1;
    typedef struct packed {
            logic [1:0] carry;
            fp_div4_t val;
    } redundant_term_L2;
    typedef redundant_term_L2[ADD_DIV-1:0] redundant_poly_L2;
    typedef struct packed {
            logic [L3_CARRY-1:0] carry;
            fp_div4_t val;
    } redundant_term_L3;
    typedef redundant_term_L3[ADD_DIV-1:0] redundant_poly_L3;
    // Union
    typedef union packed {
        logic[LEN_12M_TILDE-1:0] uint; // 272
        fp_div4_t[ADD_DIV-1:0] poly;
    } M_tilde12_t;
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
    function qpmm_fp_t rand_288();
        // N must be less than 320 bits
        rand_288 = {$urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom()};
    endfunction
endpackage
`endif 

// `ifndef PARAMS_BN254_d0
// `define PARAMS_BN254_d0
// package PARAMS_BN254_d0;
//     localparam
//         Mod = 256'h2523648240000001ba344d80000000086121000000000013a700000000000013, //The BN254 prime
//         M_tilde = 267'h7d18c77dfc340005d1864d4d3800001c39ab785000000042327630000000003ffff; // 267 bits
//     // localparam
//     //     K = 16,
//     //     L = 24,
//     //     C = L - K,
//     //     D = 0,
//     //     _Mpp = 256'h7d18c77dfc340005d1864d4d3800001c39ab785000000042327630000000004, //k=16
//     //     R = 272 - 1,
//     //     R_INV = 'h131822b9f3de491ff4d85504410ed56c72e68c1f514017577c489d762ae9cf77, //r=272
//     //     N = R/K + 1, // 17 at k=16
//     //     M = R/L + 1, //12 at L=24
//     //     HALF_S = (M+D+1)/2, // must be even
//     //     S_1_3 = (M+D+1)/3,  // 1/3
//     //     //S_1_4 = (M+D-1)/4;  // 1/4
//     //     S_1_4 = (M+D)/4,
//     //     ADD_DIV = 4,
//     //     L3_CARRY = 8;  // 1/4
//     localparam
//         K = 17,
//         L = 26,
//         C = L - K,
//         D = 0,
//         _Mpp = 256'h3e8c63befe1a0002e8c326a69c00000e1cd5bc2800000021193b18000000002, //k=17
//         R = 289 - 1,
//         RmodM = 'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d,
//         R2modM = 'h1e3ad4f19ece02905cd917dec0178837a70990ae5b87678a825bfd79f8a881b8,
//         R_INV = 'h4183ffd639e59ef555105a592c220885737a65cc60fa8a23659c0a44ebb1577, //r=289
//         N = R/K + 1, //17
//         M = 11,
//         HALF_S = (M+D+1)/2, // must be even
//         S_1_3 = (M+D+1)/3,  // 1/3
//         //S_1_4 = (M+D-1)/4;  // 1/4
//         S_1_4 = 3,//(M+D)/4,
//         ADD_DIV = 4,
//         L3_CARRY = 8,
//         LEN_12M_TILDE = 272,
//         LEN_1024M_TILDE = 277, // Must be divided by ADD_DIV
//         N_THREADS = 4,
//         BRAM_DEPTH = 9;  
    
//     typedef logic[$bits(M_tilde):0] uint_Mtilde2_t;
//     typedef logic[M:0][47:0] qpmm_S_t;
//     typedef logic[M-2:0][L-1:0] poly_Mpp_t;
//     typedef logic[K*N-1:0] uint_fp_t;
//     typedef logic[L*M-1:0] uint_fpa_t;
//     typedef logic[M-1:0][L-1:0] poly_a_t; //288
//     typedef logic[N-1:0][K-1:0] poly_b_t; //272
//     typedef logic[(HALF_S-1)*L+48-1:0] qpmm_S_half;
//     typedef logic[(S_1_3-1)*L+48-1:0] qpmm_S_1_3;
//     typedef logic[(S_1_4-1)*L+48-1:0] qpmm_S_1_4;
//     typedef logic[LEN_12M_TILDE/ADD_DIV-1:0] fp_div4_t; // uint divided by 4. Lack of 1 bit for 289

//     // Struct
//     typedef struct packed {
//             logic carry;
//             fp_div4_t val;
//     } redundant_term_L1;
//     typedef redundant_term_L1[ADD_DIV-1:0] redundant_poly_L1;

//     typedef struct packed {
//             logic [1:0] carry;
//             fp_div4_t val;
//     } redundant_term_L2;
//     typedef redundant_term_L2[ADD_DIV-1:0] redundant_poly_L2;

//     typedef struct packed {
//             logic [L3_CARRY-1:0] carry;
//             fp_div4_t val;
//     } redundant_term_L3;
//     typedef redundant_term_L3[ADD_DIV-1:0] redundant_poly_L3;


//     // Union
//     typedef union packed {
//         logic[LEN_12M_TILDE-1:0] uint; // 272
//         fp_div4_t[ADD_DIV-1:0] poly;
//     } M_tilde12_t;

//     typedef union packed {
//         uint_fp_t uint;
//         poly_b_t poly_b;
//     } qpmm_fp_t;

//     typedef union packed {
//         uint_fpa_t uint;
//         poly_a_t poly_a;
//     } qpmm_fpa_t;

//     typedef union packed {
//         uint_fp_t uint;
//         poly_b_t poly_b;
//     } qpmm_fpb_t;

//     function qpmm_fp_t rand_288();
//         // N must be less than 320 bits
//         rand_288 = {$urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom()};
//     endfunction

// endpackage
// `endif 


`ifndef CONTROL
`define CONTROL
package CONTROL;

    // Struct
    typedef struct packed {
        logic os;
        logic inve;
        logic [1:0] poa3;
        logic [1:0] poa2;
        logic [1:0] pos;
        logic [2:0] pom3;
        logic [2:0] pom2;
        logic [2:0] pom1;
        logic [2:0] cm; // Control instruction
        logic [1:0] pm2;
        logic [1:0] pm1;
        logic me1;
        logic me0;
        logic opc;
        logic [7:0] waddr0;
        logic [7:0] waddr1;
        logic [7:0] raddr0;
        logic [7:0] raddr1;
    } raw_rom_t;

    typedef struct packed {
        logic inve;
        logic [1:0] pos;
        logic [2:0] pom3;
        logic [2:0] pom2;
        logic [2:0] pom1;
        logic [2:0] cm;
        logic [1:0] pm;
        logic me1;
        logic me0;
    } ctrl_sig_t;

    typedef struct packed {
        logic inve;
        logic [1:0] pos;
        logic [2:0] pom3;
        logic [2:0] pom2;
        logic [2:0] pom1;
        logic [2:0] cm;
        logic [1:0] pm;
        logic offset_dst;
        logic offset_src0;
        logic offset_src1;
    } ctrl_sig_offset_t; // without cmul

    typedef struct packed {
        ctrl_sig_t csig;
        logic [8:0] dst;
        logic [8:0] src0;
        logic [8:0] src1;
    } micro_ops_t;

    typedef struct packed {
        logic [1:0] field;
        logic t;
        logic [3:0] arith;
    } operation_t; // 7 bits

    typedef struct packed {
        logic me;
        logic [2:0] cm;
        logic [3:0] end_mop_cnt;
    } sub_operation_t; // 8 bits

    typedef struct packed {
        operation_t op;
        sub_operation_t sub_op;
    } opcode_t; // 15 bits

    typedef struct packed {
        opcode_t opcode;
        logic [6:0] dst;
        logic [6:0] src0;
        logic [6:0] src1;
    } instruction_t;

endpackage
`endif 


`ifndef PARAM_UART
`define PARAM_UART
package PARAM_UART;

    parameter   UART_CLK_FREQ = 100000000,
                UART_BAUD_RATE = 460800;
endpackage
`endif 