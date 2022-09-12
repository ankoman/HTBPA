`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 09/06/2022 09:51:27 AM
// Design Name: 
// Module Name: DSP_mul
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


module PE_16_16
    #(
    parameter latency = 0
    )(
    input clk,
    input [K-1:0] in_b, in_q,
    input [L-1:0] in_a, in_m,
    input [47:0] in_s,
    output [47:0] out_s
    );

    wire [47:0] w_pc;

    if(latency == 1) begin
        xbip_dsp48_macro_ab_1 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [26 : 0] A
        .B(18'(in_b)),          // input wire [17 : 0] B
        .PCOUT(w_pc),  // output wire [47 : 0] PCOUT
        .P()          // output wire [47 : 0] P
        );

        xbip_dsp48_macro_ab_c_pcin_1 mul_qm (
        .CLK(clk),    // input wire CLK
        .PCIN(w_pc),  // input wire [47 : 0] PCIN
        .A(27'(in_m)),        // input wire [26 : 0] A
        .B(18'(in_q)),        // input wire [17 : 0] B
        .C(in_s),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end
    else if (latency == 2) begin
        xbip_dsp48_macro_ab_1 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [26 : 0] A
        .B(18'(in_b)),          // input wire [17 : 0] B
        .PCOUT(w_pc),  // output wire [47 : 0] PCOUT
        .P()          // output wire [47 : 0] P
        );

        xbip_dsp48_macro_ab_c_pcin_2 mul_qm (
        .CLK(clk),    // input wire CLK
        .PCIN(w_pc),  // input wire [47 : 0] PCIN
        .A(27'(in_m)),        // input wire [26 : 0] A
        .B(18'(in_q)),        // input wire [17 : 0] B
        .C(in_s),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end
    else if (latency == 3) begin
        xbip_dsp48_macro_ab_2 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [26 : 0] A
        .B(18'(in_b)),          // input wire [17 : 0] B
        .PCOUT(w_pc),  // output wire [47 : 0] PCOUT
        .P()          // output wire [47 : 0] P
        );

        xbip_dsp48_macro_ab_c_pcin_3 mul_qm (
        .CLK(clk),    // input wire CLK
        .PCIN(w_pc),  // input wire [47 : 0] PCIN
        .A(27'(in_m)),        // input wire [26 : 0] A
        .B(18'(in_q)),        // input wire [17 : 0] B
        .C(in_s),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end
endmodule

module DSP_muladd_16_16
    #(
    parameter latency = 0
    )(
    input clk,
    input [K-1:0] in_a, 
    input [L-1:0] in_b,
    input [47:0] in_s,
    output [47:0] out_s
    );

    if (latency == 1) begin
    xbip_dsp48_macro_ab_c_1 mul_qm (
    .CLK(clk),    // input wire CLK
    .A(27'(in_a)),        // input wire [26 : 0] A
    .B(18'(in_b)),        // input wire [17 : 0] B
    .C(in_s),        // input wire [47 : 0] C
    .P(out_s)        // output wire [47 : 0] P
    );
    end
    else if (latency == 2) begin
        xbip_dsp48_macro_ab_c_2 mul_qm (
        .CLK(clk),    // input wire CLK
        .A(27'(in_a)),        // input wire [26 : 0] A
        .B(18'(in_b)),        // input wire [17 : 0] B
        .C(in_s),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end
    else if (latency == 3) begin
        xbip_dsp48_macro_ab_c_3 mul_qm (
        .CLK(clk),    // input wire CLK
        .A(27'(in_a)),        // input wire [26 : 0] A
        .B(18'(in_b)),        // input wire [17 : 0] B
        .C(in_s),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end
endmodule

module DSP_mul_16_16
    #(
    parameter latency = 0
    )(
    input clk,
    input [L-1:0] in_a,
    input [K-1:0] in_b,
    output [47:0] out_s
    );

    if (latency == 1) begin
        xbip_dsp48_macro_ab_1 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [26 : 0] A
        .B(18'(in_b)),          // input wire [17 : 0] B
        .PCOUT(),  // output wire [47 : 0] PCOUT
        .P(out_s)          // output wire [33 : 0] P
        );
    end
    else if (latency == 2) begin
        xbip_dsp48_macro_ab_2 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [16 : 0] A
        .B(18'(in_b)),          // input wire [16 : 0] B
        .PCOUT(),  // output wire [47 : 0] PCOUT
        .P(out_s)          // output wire [33 : 0] P
        );
    end
    else if (latency == 3) begin
        xbip_dsp48_macro_ab_3 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [16 : 0] A
        .B(18'(in_b)),          // input wire [16 : 0] B
        .PCOUT(),  // output wire [47 : 0] PCOUT
        .P(out_s)          // output wire [33 : 0] P
        );
    end
endmodule