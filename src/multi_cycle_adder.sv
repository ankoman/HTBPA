`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/09/30 11:54:29
// Design Name: 
// Module Name: multi_cycle_adder
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
localparam HALF_FP = $bits(uint_fp_t) / 2;  // uint_fp_t must be even

module multi_cycle_adder #(
    parameter latency = -1
    )(
    input clk,
    input uint_fp_t X, Y,
    output uint_fp_t Z
    );

    if (latency == 0) begin
        assign Z = X + Y;
    end
    else if (latency == 1)begin
        always @(posedge clk) begin
            Z <= X + Y;
        end
    end
    else if (latency == 2)begin
        reg [HALF_FP:0] buf_L;
        reg [HALF_FP-1:0] buf_H;
        always @(posedge clk) begin
            buf_L <= X[HALF_FP-1:0] + Y[HALF_FP-1:0];
            buf_H <= X[$bits(X)-1:HALF_FP] + Y[$bits(Y)-1:HALF_FP];
            Z <= {buf_H + buf_L[HALF_FP], buf_L[HALF_FP-1:0]};
        end
    end


endmodule
