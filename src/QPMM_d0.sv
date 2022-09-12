`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 09/5/2022 10:40:18 AM
// Design Name: 
// Module Name: QPMM_d0
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

import PARAMS_BN254_d0::*;
localparam latency = 1;
localparam latency_FA = 4;

module QPMM_d0_16_16(
    input clk, rstn,
    input qpmm_fp_t A, B,
    output qpmm_fp_t Z
    );

    ///////////////////////////////////////////////
    // Declaration
    //////////////////////////////////////////////
    qpmm_fp_t[N+D-1:0] reg_A, reg_B;
    qpmm_fp_t[N+D-1:0] buf_A, buf_B;
    qpmm_fp_t[N+D-1:0] buf_A2, buf_B2;
    qpmm_fp_t[N+D-1:0] buf_A3, buf_B3;


    qpmm_fp_t Mpp = _Mpp;
    logic[N+D:0][K-1:0] wire_q;
    qpmm_S_t[N+D+1:0] reg_S;
    qpmm_S_t buf_S;

    ///////////////////////////////////////////////
    // Initilization
    //////////////////////////////////////////////
    assign reg_A[0] = A;
    assign reg_B[0] = B;
    assign reg_S[0] = {default: '0};
    assign wire_q[0] = '0;

    ///////////////////////////////////////////////
    // Final Addition
    //////////////////////////////////////////////
    if (latency_FA == 2) begin
        qpmm_S_half Z_L, Z_H;
        always @(posedge clk) begin
            buf_S <= reg_S[N+D+1];
            Z_L <= poly2int_half(buf_S[HALF_S-1:1]) + buf_S[0][47:K];
            Z_H <= poly2int_half(buf_S[M+D:HALF_S]);
            Z <=  (Z_H << (HALF_S-1)*L) + Z_L;
        end
    end
    else if (latency_FA == 3) begin
        qpmm_S_1_3 Z_L, Z_M, Z_H, Z_H2;
        logic [(S_1_3*2-1)*L+48-1:0] Z_ML;
        always @(posedge clk) begin
            buf_S <= reg_S[N+D+1];
            Z_L <= poly2int_1_3(buf_S[S_1_3-1:1]) + buf_S[0][47:K];
            Z_M <= poly2int_1_3(buf_S[(2*S_1_3)-1:S_1_3]);
            Z_H <= poly2int_half(buf_S[M+D:(2*S_1_3)]);
            Z_ML <= (Z_M << (S_1_3-1)*L) + Z_L;
            Z_H2 <= Z_H;
            Z <= (Z_H2 << (2*S_1_3-1)*L) + Z_ML;
        end
    end
    else if (latency_FA == 4) begin
        qpmm_S_1_4 Z_LL, Z_LH, Z_HL, Z_HH;
        qpmm_S_half Z_L, Z_H;
        always @(posedge clk) begin
            buf_S <= reg_S[N+D+1];
            Z_LL <= poly2int_1_4(buf_S[S_1_4:1]) + buf_S[0][47:K];
            Z_LH <= poly2int_1_4(buf_S[2*S_1_4:S_1_4+1]);
            Z_HL <= poly2int_1_4(buf_S[3*S_1_4:2*S_1_4+1]);
            Z_HH <= poly2int_1_4(buf_S[4*S_1_4:3*S_1_4+1]);
            Z_L <= (Z_LH << (S_1_4*L)) + Z_LL;
            Z_H <= (Z_HH << (S_1_4*L)) + Z_HL;
            Z <= (Z_H << (2*S_1_4*L)) + Z_L;
        end
    end
    ///////////////////////////////////////////////
    // Body
    //////////////////////////////////////////////
    for(genvar i = 0; i < N + D + 1; i = i + 1) begin : QPMM
        for(genvar j = 0; j < M + D; j = j + 1) begin : for_1
            if(i == 0)
                DSP_mul #(.latency(latency)) mul_ab (.clk(clk), .in_a(reg_A[i].poly_a[j]), .in_b(reg_B[i].poly_b[i]), .out_s(reg_S[i+1][j+1]));
            else if(i == N + D) begin
                if(j == M - 1)
                    assign reg_S[i+1][j+1] = '0;
                else
                    DSP_muladd #(.latency(latency)) qm_S (.clk(clk), .in_a(Mpp.poly_a[j]), .in_b(wire_q[i]), .in_s(reg_S[i][j+2]), .out_s(reg_S[i+1][j+1]));
            end
            else begin
                if(j == M - 1)
                    DSP_mul #(.latency(latency)) mul_ab (.clk(clk), .in_a(reg_A[i].poly_a[j]), .in_b(reg_B[i].poly_b[i]), .out_s(reg_S[i+1][j+1]));
                else 
                    PE #(.latency(latency)) pe(.clk(clk), .in_a(reg_A[i].poly_a[j]), .in_b(reg_B[i].poly_b[i]), .in_m(Mpp.poly_a[j]), .in_q(wire_q[i]), .in_s(reg_S[i][j+2]), .out_s(reg_S[i+1][j+1])); 
            end
        end
        wire [47:0] buf_q = reg_S[i][0][47:K] + reg_S[i][1];
        assign wire_q[i] = buf_q[K-1:0];

        if (latency == 1) begin
            always_ff @(posedge clk) begin : ff_ab_q
                if(i < N + D) begin
                    reg_A[i+1] <= reg_A[i];
                    reg_B[i+1] <= reg_B[i];
                end
                reg_S[i+1][0] <= buf_q;
            end
        end
        else if (latency == 2) begin
            logic [47:0] buf_s0;
            always_ff @(posedge clk) begin : ff_ab_q
                if(i < N + D) begin
                    buf_A[i] <= reg_A[i];
                    buf_B[i] <= reg_B[i];
                    reg_A[i+1] <= buf_A[i];
                    reg_B[i+1] <= buf_B[i];
                end
                buf_s0 <= buf_q;
                reg_S[i+1][0] <= buf_s0;
            end
        end
        else if (latency == 3) begin
            logic [47:0] buf_s0_0, buf_s0_1;
            always_ff @(posedge clk) begin : ff_ab_q
                if(i < N + D) begin
                    buf_A[i] <= reg_A[i];
                    buf_B[i] <= reg_B[i];
                    buf_A2[i] <= buf_A[i];
                    buf_B2[i] <= buf_B[i];
                    reg_A[i+1] <= buf_A2[i];
                    reg_B[i+1] <= buf_B2[i];
                end
                buf_s0_0 <= buf_q;
                buf_s0_1 <= buf_s0_0;
                reg_S[i+1][0] <= buf_s0_1;
            end
        end
        else if (latency == 4) begin
            logic [47:0] buf_s0_0, buf_s0_1, buf_s0_2;
            always_ff @(posedge clk) begin : ff_ab_q
                if(i < N + D) begin
                    buf_A[i] <= reg_A[i];
                    buf_B[i] <= reg_B[i];
                    buf_A2[i] <= buf_A[i];
                    buf_B2[i] <= buf_B[i];
                    buf_A3[i] <= buf_A2[i];
                    buf_B3[i] <= buf_B2[i];
                    reg_A[i+1] <= buf_A3[i];
                    reg_B[i+1] <= buf_B3[i];
                end
                buf_s0_0 <= buf_q;
                buf_s0_1 <= buf_s0_0;
                buf_s0_2 <= buf_s0_1;
                reg_S[i+1][0] <= buf_s0_2;
            end
        end
    end

    function qpmm_S_half poly2int_1_4;
        input [S_1_4-1:0][47:0] A;

            poly2int_1_4 = 0;
            for(integer i = 0; i < S_1_4; i = i + 1) begin
                poly2int_1_4 = poly2int_1_4 + (A[i] << (L*i));
            end
    endfunction

    function qpmm_S_half poly2int_1_3;
        input [S_1_3-1:0][47:0] A;

            poly2int_1_3 = 0;
            for(integer i = 0; i < S_1_3; i = i + 1) begin
                poly2int_1_3 = poly2int_1_3 + (A[i] << (L*i));
            end
    endfunction

    function qpmm_S_half poly2int_half;
        input [HALF_S-1:0][47:0] A;

            poly2int_half = 0;
            for(integer i = 0; i < HALF_S; i = i + 1) begin
                poly2int_half = poly2int_half + (A[i] << (L*i));
            end
    endfunction

    function qpmm_fp_t poly2int;
        input qpmm_S_t A;

            poly2int = 0;
            for(integer i = 0; i <= M+D+1; i = i + 1) begin
                poly2int = poly2int + (A[i] << (L*i));
            end
    endfunction

endmodule
