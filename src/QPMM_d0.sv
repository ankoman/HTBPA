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

import PARAMS_BN254_16_16::*;
localparam latency = 3;

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

    qpmm_fp_t Mpp = _Mpp;
    logic[N+D:0][K-1:0] wire_q;
    qpmm_S_t[N+D+1:0] reg_S;
    qpmm_S_t buf_S;
    qpmm_S_half Z_L, Z_H;

    ///////////////////////////////////////////////
    // Initilization
    //////////////////////////////////////////////
    assign reg_A[0] = A;
    assign reg_B[0] = B;
    assign reg_S[0] = {default: '0};
    assign wire_q[0] = '0;

    ///////////////////////////////////////////////
    // Body
    //////////////////////////////////////////////
    always @(posedge clk) begin
        buf_S <= reg_S[N+D+1];
        Z_L <= poly2int_half(buf_S[HALF_S-1:1]) + buf_S[0][47:K];
        Z_H <= poly2int_half(buf_S[M+D:HALF_S]);
        Z <=  (Z_H << (HALF_S-1)*L) + Z_L;
        //Z <= poly2int(buf_S);
    end

    for(genvar i = 0; i < N + D + 1; i = i + 1) begin : QPMM
        for(genvar j = 0; j < M + D; j = j + 1) begin : for_1
            if(i == 0)
                DSP_mul_16_16 #(.latency(latency)) mul_ab (.clk(clk), .in_a(reg_A[i].poly_a[j]), .in_b(reg_B[i].poly_b[i]), .out_s(reg_S[i+1][j+1]));
            else if(i == N + D) begin
                if(j == M - 1)
                    assign reg_S[i+1][j+1] = '0;
                else
                    DSP_muladd_16_16 #(.latency(latency)) qm_S (.clk(clk), .in_a(Mpp.poly_a[j]), .in_b(wire_q[i]), .in_s(reg_S[i][j+2]), .out_s(reg_S[i+1][j+1]));
            end
            else begin
                if(j == M - 1)
                    DSP_mul_16_16 #(.latency(latency)) mul_ab (.clk(clk), .in_a(reg_A[i].poly_a[j]), .in_b(reg_B[i].poly_b[i]), .out_s(reg_S[i+1][j+1]));
                else 
                    PE_16_16 #(.latency(latency)) pe(.clk(clk), .in_a(reg_A[i].poly_a[j]), .in_b(reg_B[i].poly_b[i]), .in_m(Mpp.poly_a[j]), .in_q(wire_q[i]), .in_s(reg_S[i][j+2]), .out_s(reg_S[i+1][j+1])); 
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
    end

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
