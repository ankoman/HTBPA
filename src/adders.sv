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
import PARAMS_BN254_d0::*;
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


module poly_adder_L3_L3(
    input sub,
    input redundant_poly_L3 X, Y,
    output redundant_poly_L3 Z
    );

    for(genvar i = 0; i < 4; i = i+1) begin
        assign Z[i] = X[i] + (sub ? ~Y[i] : Y[i]) + sub;
    end

endmodule

