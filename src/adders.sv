`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/09/30 11:54:29
// Design Name: 
// Module Name: adders
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
import CURVE_PARAMS::*;

localparam HALF_FP = $bits(uint_fp_t) / 2;  // uint_fp_t must be even, 136 bits
localparam QUAT_FP = $bits(uint_fp_t) / 4;  // uint_fp_t must be multiple of 4, 68 bits


module multi_cycle_adder #(
    parameter latency = -1
    )(
    input clk,
    input uint_fp_t X, Y,
    output uint_fp_t Z,
    output reg carry
    );

    reg [HALF_FP:0] buf_L, buf_H;
    reg [QUAT_FP:0] buf_LL, buf_LH, buf_HL, buf_HH;

    if (latency == 0) begin
        assign Z = X + Y;
    end
    else if (latency == 1)begin
        always @(posedge clk) begin
            Z <= X + Y;
        end
    end
    else if (latency == 2)begin
        always @(posedge clk) begin
            buf_L <= X[HALF_FP-1:0] + Y[HALF_FP-1:0];
            buf_H <= X[$bits(X)-1:HALF_FP] + Y[$bits(Y)-1:HALF_FP];
            Z <= {buf_H + buf_L[HALF_FP], buf_L[HALF_FP-1:0]};
        end
    end
    else if (latency == 3)begin
        always @(posedge clk) begin
            buf_LL <= X[QUAT_FP-1:0] + Y[QUAT_FP-1:0];
            buf_LH <= X[2*QUAT_FP-1:QUAT_FP] + Y[2*QUAT_FP-1:QUAT_FP];
            buf_HL <= X[3*QUAT_FP-1:2*QUAT_FP] + Y[3*QUAT_FP-1:2*QUAT_FP];
            buf_HH <= X[4*QUAT_FP-1:3*QUAT_FP] + Y[4*QUAT_FP-1:3*QUAT_FP];
            buf_L <= {buf_LH + buf_LL[QUAT_FP], buf_LL[QUAT_FP-1:0]};
            buf_H <= {buf_HH + buf_HL[QUAT_FP], buf_HL[QUAT_FP-1:0]};
            {carry, Z} <= {buf_H + buf_L[HALF_FP], buf_L[HALF_FP-1:0]};
        end
    end

endmodule

module multi_cycle_subtractor #(
    parameter latency = -1
    )(
    input clk,
    input uint_fp_t X, Y_,
    output uint_fp_t Z,
    output reg carry
    );

    uint_fp_t Y;
    assign Y = ~Y_;
    reg [HALF_FP:0] buf_L, buf_H;
    reg [QUAT_FP:0] buf_LL, buf_LH, buf_HL, buf_HH;

    if (latency == 3)begin
        always @(posedge clk) begin
            buf_LL <= X[QUAT_FP-1:0] + Y[QUAT_FP-1:0] + 1'b1;
            buf_LH <= X[2*QUAT_FP-1:QUAT_FP] + Y[2*QUAT_FP-1:QUAT_FP];
            buf_HL <= X[3*QUAT_FP-1:2*QUAT_FP] + Y[3*QUAT_FP-1:2*QUAT_FP];
            buf_HH <= X[4*QUAT_FP-1:3*QUAT_FP] + Y[4*QUAT_FP-1:3*QUAT_FP];
            buf_L <= {buf_LH + buf_LL[QUAT_FP], buf_LL[QUAT_FP-1:0]};
            buf_H <= {buf_HH + buf_HL[QUAT_FP], buf_HL[QUAT_FP-1:0]};
            {carry, Z} <= {buf_H + buf_L[HALF_FP], buf_L[HALF_FP-1:0]};
        end
    end

endmodule


module poly_adder_L3_L3 #(
    parameter LATENCY = 0
    )(
    input sub, clk,
    input redundant_poly_L3 X, Y,
    output redundant_poly_L3 Z
    );

    for(genvar i = 0; i < ADD_DIV; i = i+1) begin
        if (LATENCY == 0) 
                assign Z[i] = X[i] + (sub ? ~Y[i] : Y[i]) + sub;
        else if (LATENCY == 1) begin
            always @(posedge clk) begin
                Z[i] <= X[i] + (sub ? ~Y[i] : Y[i]) + sub;
            end
        end
    end
endmodule

module poly_addsub_L3_L3 #(
    parameter LATENCY = 0
    )(
    input sub, clk,
    input redundant_poly_L3 X, Y,
    output redundant_poly_L3 Z
    );

    for(genvar i = 0; i < ADD_DIV; i = i+1) begin
        if (LATENCY == 0) 
                assign Z[i] = X[i] + Y[i] + sub;
        else if (LATENCY == 1) begin
            always @(posedge clk) begin
                Z[i] <= X[i] + Y[i] + sub;
            end
        end
    end
endmodule

module poly_adder_L3_L3_wo_sub #(
    parameter LATENCY = 0
    )(
    input clk,
    input redundant_poly_L3 X, Y,
    output redundant_poly_L3 Z
    );

    for(genvar i = 0; i < ADD_DIV; i = i+1) begin
        if (LATENCY == 0) 
                assign Z[i] = X[i] + Y[i];
        else if (LATENCY == 1) begin
            always @(posedge clk) begin
                Z[i] <= X[i] + Y[i];
            end
        end
    end
endmodule

module poly_sub_L3_L3 #(
    parameter LATENCY = 0
    )(
    input clk,
    input redundant_poly_L3 X, Y,
    output redundant_poly_L3 Z
    );

    for(genvar i = 0; i < ADD_DIV; i = i+1) begin
        if (LATENCY == 0) 
                assign Z[i] = X[i] + Y[i] + 1'b1;
        else if (LATENCY == 1) begin
            always @(posedge clk) begin
                Z[i] <= X[i] + Y[i] + 1'b1;
            end
        end
    end
endmodule

module L3toint(
    input redundant_poly_L3 din,
    output [LEN_12M_TILDE+L3_CARRY-1:0] dout
    );

    localparam LEN_COMP = $bits(fp_div4_t) - L3_CARRY;
    localparam PADD_1 = {LEN_COMP{1'b1}};
    localparam PADD_0 = {LEN_COMP{1'b0}};
    localparam PADD_11 = {(LEN_COMP+L3_CARRY){1'b1}};
    localparam PADD_00 = {(LEN_COMP+L3_CARRY){1'b0}};
    localparam PADD_111 = {(LEN_COMP+L3_CARRY+L3_CARRY){1'b1}};
    localparam PADD_000 = {(LEN_COMP+L3_CARRY+L3_CARRY){1'b0}};

    wire sign0 = din[0].carry[L3_CARRY-1];
    wire sign1 = din[1].carry[L3_CARRY-1];
    wire sign2 = din[2].carry[L3_CARRY-1];
    wire sign3 = din[3].carry[L3_CARRY-1];

    
    // First cycle
    wire[$bits(fp_div4_t)-1:0] add1_1, add2_1, add3_1;
    wire carry1_1, carry2_1;
    wire [L3_CARRY-1:0] carry3_1;
    assign {carry1_1, add1_1} = din[1].val + {sign0 ? PADD_1: PADD_0, din[0].carry};
    assign {carry2_1, add2_1} = din[2].val + {sign1 ? PADD_1: PADD_0, din[1].carry};
    assign {carry3_1, add3_1} = {din[3].carry, din[3].val} + {sign2 ? PADD_11: PADD_00, din[2].carry};

    // Second cycle
    wire[$bits(fp_div4_t)-1:0] add2_2, add3_2;
    wire carry2_2;
    wire [L3_CARRY-1:0] carry3_2;
    assign {carry2_2, add2_2} = add2_1 + carry1_1 + (sign0 ? PADD_11: PADD_00);
    assign {carry3_2, add3_2} = {carry3_1, add3_1} + carry2_1 + (sign1 ? PADD_111: PADD_000);

    // Third cycle
    wire[$bits(fp_div4_t)+L3_CARRY-1:0] add3_3 = {carry3_2, add3_2} + carry2_2 + (sign0 ? PADD_111: PADD_000);

    assign dout = {add3_3, add2_2, add1_1, din[0].val};

endmodule

module L3touint(
    input clk, rstn,
    input redundant_poly_L3 din,
    output [LEN_1024M_TILDE-1:0] dout
    );

    localparam LEN_COMP = $bits(fp_div4_t) - L3_CARRY;
    localparam PADD_1 = {LEN_COMP{1'b1}};
    localparam PADD_0 = {LEN_COMP{1'b0}};
    localparam PADD_11 = {(LEN_COMP+L3_CARRY){1'b1}};
    localparam PADD_00 = {(LEN_COMP+L3_CARRY){1'b0}};
    localparam PADD_111 = {(LEN_COMP+L3_CARRY+L3_CARRY){1'b1}};
    localparam PADD_000 = {(LEN_COMP+L3_CARRY+L3_CARRY){1'b0}};

    fp_div4_t[ADD_DIV:0] M_tilde512;
    assign M_tilde512 = {CURVE_PARAMS::M_tilde, 9'd0};
    wire sign0 = din[0].carry[L3_CARRY-1];
    wire sign1 = din[1].carry[L3_CARRY-1];
    wire sign2 = din[2].carry[L3_CARRY-1];
    wire sign3 = din[3].carry[L3_CARRY-1];
    reg sign0_1, sign1_1, sign0_2;

    // First cycle
    fp_div4_t add0_1, add1_1, add2_1, add3_1;
    logic carry0_1, carry1_1, carry2_1;
    logic [L3_CARRY-1:0] carry3_1;
    always @(posedge clk) begin
        {carry0_1, add0_1} <= din[0].val + M_tilde512[0];
        {carry1_1, add1_1} <= din[1].val + {sign0 ? PADD_1: PADD_0, din[0].carry};
        {carry2_1, add2_1} <= din[2].val + {sign1 ? PADD_1: PADD_0, din[1].carry};
        {carry3_1, add3_1} <= {din[3].carry, din[3].val} + {sign2 ? PADD_11: PADD_00, din[2].carry};
        sign0_1 <= sign0;
        sign1_1 <= sign1;
    end

    // Second cycle
    fp_div4_t add1_2, add2_2, add3_2, buf_din0_2;
    logic carry1_2, carry2_2;
    logic [L3_CARRY-1:0] carry3_2;
    always @(posedge clk) begin
        buf_din0_2 <= add0_1;
        {carry1_2, add1_2} <= add1_1 + M_tilde512[1] + carry0_1;
        {carry2_2, add2_2} <= add2_1 + carry1_1 + (sign0_1 ? PADD_11: PADD_00);
        {carry3_2, add3_2} <= {carry3_1, add3_1} + carry2_1 + (sign1_1 ? PADD_111: PADD_000);
        sign0_2 <= sign0_1;
    end

    // Third cycle
    fp_div4_t buf_din0_3, buf_add1_3, add2_3, add3_3;
    logic carry2_3;
    logic [L3_CARRY-1:0] carry3_3;
    always @(posedge clk) begin
        buf_din0_3 <= buf_din0_2;
        buf_add1_3 <= add1_2;
        {carry2_3, add2_3} <= add2_2 + M_tilde512[2] + carry1_2;
        {carry3_3, add3_3} <= {carry3_2, add3_2} + carry2_2 + (sign0_2 ? PADD_111: PADD_000);
    end

    // Fource cycle
    logic[$bits(fp_div4_t)+L3_CARRY-1:0] add3_4;
    fp_div4_t buf_din0_4, buf_add1_4, buf_add2_4;
    always @(posedge clk) begin
        buf_din0_4 <= buf_din0_3;
        buf_add1_4 <= buf_add1_3;
        buf_add2_4 <= add2_3;
        add3_4 <= {carry3_3, add3_3} + carry2_3 + {M_tilde512[4], M_tilde512[3]};
    end

    assign dout = {add3_4, buf_add2_4, buf_add1_4, buf_din0_4};

endmodule

module CSA #(
    parameter len = 0
    )(
    input [len-1:0] a, b, c,
    output [len-1:0] ps, cs
    );

    assign ps = a ^ b ^ c;
    assign sc = (a&b) | (a&c) | (b&c);

endmodule

// module L3toL1(
//     input clk,
//     input redundant_poly_L3 din,
//     output redundant_poly_L1 dout
//     );

//     always @(posedge clk) begin
//         for(integer i = 0; i < ADD_DIV; i = i + 1) begin
//             {dout[i].carry, dout[i].val} <= din[i]
//         end
//     end
// endmodule