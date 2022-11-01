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
import PARAMS_BN254_d0::*;

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
    else if (latency == 4) begin
        xbip_dsp48_macro_ab_3 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [26 : 0] A
        .B(18'(in_b)),          // input wire [17 : 0] B
        .PCOUT(w_pc),  // output wire [47 : 0] PCOUT
        .P()          // output wire [47 : 0] P
        );
        xbip_dsp48_macro_ab_c_pcin_4 mul_qm (
        .CLK(clk),    // input wire CLK
        .PCIN(w_pc),  // input wire [47 : 0] PCIN
        .A(27'(in_m)),        // input wire [26 : 0] A
        .B(18'(in_q)),        // input wire [17 : 0] B
        .C(in_s),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end
endmodule

module DSP_muladd
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
    else if (latency == 4) begin
        xbip_dsp48_macro_ab_c_4 mul_qm (
        .CLK(clk),    // input wire CLK
        .A(27'(in_a)),        // input wire [26 : 0] A
        .B(18'(in_b)),        // input wire [17 : 0] B
        .C(in_s),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end
endmodule

module DSP_mul
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
    else if (latency == 4) begin
        xbip_dsp48_macro_ab_4 mul_ab (
        .CLK(clk),      // input wire CLK
        .A(27'(in_a)),          // input wire [16 : 0] A
        .B(18'(in_b)),          // input wire [16 : 0] B
        .PCOUT(),  // output wire [47 : 0] PCOUT
        .P(out_s)          // output wire [33 : 0] P
        );
    end
endmodule



module PE
    #(
    parameter latency = 0
    )(
    input clk,
    input [K-1:0] in_b, in_q,
    input [L-1:0] in_a, in_m,
    input [2*K-1:0] in_sl,
    input [48-2*K-1:0] in_su,
    output [47:0] out_s
    );

    wire [47:0] w_pc;
    if (latency == 1) begin
        xbip_dsp48_macro_ab_c_1 mul_ab (.CLK(clk), .A(27'(in_a)), .B(18'(in_b)), .C(48'(in_su << K)), .PCOUT(w_pc), .P());
        xbip_dsp48_macro_ab_c_pcin_1 mul_qm (.CLK(clk), .PCIN(w_pc), .A(27'(in_m)), .B(18'(in_q)), .C(48'(in_sl << C)), .P(out_s));
    end
    else if (latency == 2) begin
        xbip_dsp48_macro_ab_c_1 mul_ab (
        .CLK(clk),    // input wire CLK
        .A(27'(in_a)),        // input wire [26 : 0] A
        .B(18'(in_b)),        // input wire [17 : 0] B
        .C(48'(in_su << K)),    // input wire [47 : 0] C
        .PCOUT(w_pc),  // output wire [47 : 0] PCOUT
        .P()        // output wire [47 : 0] P
        );
        xbip_dsp48_macro_ab_c_pcin_2 mul_qm (
        .CLK(clk),    // input wire CLK
        .PCIN(w_pc),  // input wire [47 : 0] PCIN
        .A(27'(in_m)),        // input wire [26 : 0] A
        .B(18'(in_q)),        // input wire [17 : 0] B
        .C(48'(in_sl << C)),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end 
    else if (latency == 3) begin
        xbip_dsp48_macro_ab_c_2 mul_ab (
        .CLK(clk),    // input wire CLK
        .A(27'(in_a)),        // input wire [26 : 0] A
        .B(18'(in_b)),        // input wire [17 : 0] B
        .C(48'(in_su << K)),    // input wire [47 : 0] C
        .PCOUT(w_pc),  // output wire [47 : 0] PCOUT
        .P()        // output wire [47 : 0] P
        );
        xbip_dsp48_macro_ab_c_pcin_3 mul_qm (
        .CLK(clk),    // input wire CLK
        .PCIN(w_pc),  // input wire [47 : 0] PCIN
        .A(27'(in_m)),        // input wire [26 : 0] A
        .B(18'(in_q)),        // input wire [17 : 0] B
        .C(48'(in_sl << C)),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
        // logic [26:0] reg_a, reg_m;
        // logic [17:0] reg_b, reg_q;
        // logic [47:0] reg_su, reg_sl, reg_sl_, reg_pcout, reg_prod, reg_p;
        // assign out_s = reg_p;
        // always @(posedge clk) begin
        //     reg_a <= 27'(in_a);
        //     reg_b <= 18'(in_b);
        //     reg_su <= 48'(in_su << K);
        //     reg_pcout <= reg_a * reg_b + reg_su;
        //     reg_m <= 27'(in_m);
        //     reg_q <= 18'(in_q);
        //     reg_sl_ <= 48'(in_sl << C);
        //     reg_sl <= reg_sl_;
        //     reg_prod <= reg_m * reg_q;
        //     reg_p <= reg_prod + reg_sl + reg_pcout;
        // end
    end
    else if (latency == 4) begin
        xbip_dsp48_macro_ab_c_3 mul_ab (
        .CLK(clk),    // input wire CLK
        .A(27'(in_a)),        // input wire [26 : 0] A
        .B(18'(in_b)),        // input wire [17 : 0] B
        .C(48'(in_su << K)),    // input wire [47 : 0] C
        .PCOUT(w_pc),  // output wire [47 : 0] PCOUT
        .P()        // output wire [47 : 0] P
        );
        xbip_dsp48_macro_ab_c_pcin_4 mul_qm (
        .CLK(clk),    // input wire CLK
        .PCIN(w_pc),  // input wire [47 : 0] PCIN
        .A(27'(in_m)),        // input wire [26 : 0] A
        .B(18'(in_q)),        // input wire [17 : 0] B
        .C(48'(in_sl << C)),        // input wire [47 : 0] C
        .P(out_s)        // output wire [47 : 0] P
        );
    end  
endmodule
