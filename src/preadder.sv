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
    input [1:0] mode,
    output redundant_poly_L3 Z0, Z1
    );

    redundant_poly_L3 dly_x, dly_y;
    redundant_poly_L3 add_buf_0, add_buf_1, add_buf_2, add_buf_3;

    poly_adder_L3_L3 #(.LATENCY(1)) adder0 (.clk, .X(dly_x), .Y(X), .Z(add_buf_0), .sub(1'b0));
    poly_adder_L3_L3 #(.LATENCY(1)) adder1 (.clk, .X, .Y, .Z(add_buf_1), .sub(1'b0));
    poly_adder_L3_L3 #(.LATENCY(1)) subtractor0 (.clk, .X, .Y, .Z(add_buf_2), .sub(1'b1));
    poly_adder_L3_L3 #(.LATENCY(1)) adder2 (.clk, .X(Y), .Y(dly_y), .Z(add_buf_3), .sub(1'b0));

    always @(posedge clk)begin
            dly_x <= X;
            dly_y <= Y;
            Z0 <= (mode==2'b01)? add_buf_1 : (mode==2'b10)? add_buf_0: X;
            Z1 <= (mode==2'b01)? add_buf_2 : (mode==2'b10)? add_buf_3: Y;
    end
endmodule

module preadder_4thread(
    input clk,
    input rstn,
    input redundant_poly_L3 X, Y,
    input [1:0] mode,
    output redundant_poly_L3 Z0, Z1
    );

    redundant_poly_L3[3:0] dly_x, dly_y;
    redundant_poly_L3[3:0] add_buf_0, add_buf_1, add_buf_2, add_buf_3;
    redundant_poly_L3 add_buf_0_wire, add_buf_1_wire, add_buf_2_wire, add_buf_3_wire;

    poly_adder_L3_L3 #(.LATENCY(0)) adder0 (.clk, .X(dly_x[3]), .Y(X), .Z(add_buf_0_wire), .sub(1'b0));
    poly_adder_L3_L3 #(.LATENCY(0)) adder1 (.clk, .X, .Y, .Z(add_buf_1_wire), .sub(1'b0));
    poly_adder_L3_L3 #(.LATENCY(0)) subtractor0 (.clk, .X, .Y, .Z(add_buf_2_wire), .sub(1'b1));
    poly_adder_L3_L3 #(.LATENCY(0)) adder2 (.clk, .X(Y), .Y(dly_y[3]), .Z(add_buf_3_wire), .sub(1'b0));

    always @(posedge clk)begin
            dly_x <= {dly_x[2:0], X};
            dly_y <= {dly_y[2:0], Y};
            add_buf_0 <= {add_buf_0[2:0], add_buf_0_wire};
            add_buf_1 <= {add_buf_1[2:0], add_buf_1_wire};
            add_buf_2 <= {add_buf_2[2:0], add_buf_2_wire};
            add_buf_3 <= {add_buf_3[2:0], add_buf_3_wire};
            Z0 <= (mode==2'b01)? add_buf_0[3] : (mode==2'b10)? add_buf_1[3]: X;
            Z1 <= (mode==2'b01)? add_buf_3[3] : (mode==2'b10)? add_buf_2[3]: Y;
    end
endmodule