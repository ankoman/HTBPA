`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/09/30 16:51:57
// Design Name: 
// Module Name: preadder
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

module preadder(
    input clk,
    input rstn,
    input redundant_poly_L3 X, Y,
    input [1:0] mode1, mode2,
    output redundant_poly_L3 Z0, Z1
    );

    redundant_poly_L3 dly_x, dly_y;
    redundant_poly_L3 add_buf_0, add_buf_1, add_buf_2, add_buf_3;

    poly_adder_L3_L3 adder0 (.X(dly_x), .Y(X), .Z(add_buf_0), .sub(1'b0));
    poly_adder_L3_L3 adder1 (.X, .Y(Y), .Z(add_buf_1), .sub(1'b0));
    poly_adder_L3_L3 subtractor0 (.X, .Y(Y), .Z(add_buf_2), .sub(1'b1));
    poly_adder_L3_L3 adder2 (.X(Y), .Y(dly_y), .Z(add_buf_3), .sub(1'b0));

    always @(posedge clk)begin
            dly_x <= X;
            dly_y <= Y;
            Z0 <= (mode1==2'b01)? add_buf_0 : (mode1==2'b10)? add_buf_1: X;
            Z1 <= (mode2==2'b01)? add_buf_2 : (mode2==2'b10)? add_buf_3: Y;
    end
endmodule
