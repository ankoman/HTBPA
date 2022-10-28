`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/14 15:49:28
// Design Name: 
// Module Name: cmul
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

module cmul #(
    parameter LATENCY = 0
    )(
    input clk,
    input [2:0] mode,
    input uint_Mtilde2_t din,
    output redundant_poly_L1 dout
    );

    wire[9:0] shift1 = (mode == 3'd2 || mode == 3'd3)? 0:
                     (mode == 3'd6)? 1: 1000;
                
    wire[9:0] shift2 = (mode == 3'd1 || mode == 3'd2)? 0:
                     (mode == 3'd3)? 1: 2;

    fp_div4_t[ADD_DIV-1:0] add1, add2;
    assign add1 = din << shift1;
    assign add2 = din << shift2;

    for(genvar i = 0; i < ADD_DIV; i = i+1) begin
        if(LATENCY == 0)
            assign dout[i] = add1[i] + add2[i];
        else if(LATENCY == 1) begin
            always @(posedge clk) begin
                dout[i] <= add1[i] + add2[i];
            end
        end
    end

endmodule
