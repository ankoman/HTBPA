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

localparam LATENCY = 3;

module preadder(
    input clk,
    input rstn,
    input uint_fp_t X, Y,
    input [1:0] mode1, mode2,
    output uint_fp_t Z0, Z1
    );

    uint_fp_t dly_x, dly_y;
    uint_fp_t reg_p, add_buf_0, add_buf_1, add_buf_2, add_buf_3, out_NC_0, out_NC_1, out_reduc_0, out_reduc_1;
    wire carry0, carry1, carry2, carry3, sign0, sign1;
    
    multi_cycle_adder #(.latency(LATENCY)) adder0 (.clk, .X(dly_x), .Y(X), .Z(add_buf_0), .carry(carry0));
    multi_cycle_adder #(.latency(LATENCY)) adder1 (.clk, .X, .Y(Y), .Z(add_buf_1), .carry(carry1));
    multi_cycle_subtractor #(.latency(LATENCY)) subtractor0 (.clk, .X, .Y_(Y), .Z(add_buf_2), .carry(carry2));
    multi_cycle_adder #(.latency(LATENCY)) adder2 (.clk, .X(Y), .Y(dly_y), .Z(add_buf_3), .carry(carry3));

    assign {sign0, out_NC_0} = (mode1==2'b01)? {carry0, add_buf_0} : (mode1==2'b10)? {carry1, add_buf_1}: {1'b0, X};
    assign {sign1, out_NC_1} = (mode2==2'b01)? {carry2, add_buf_2} : (mode2==2'b10)? {carry3, add_buf_3}: {1'b0, Y};
    
    //reduction
    addsub_delay0  #(.bit_width(bit_width+1)) reduc_0 (.a(out_NC_0), .b(reg_p), .sub(1'b1), .s(out_reduc_0));
    addsub_delay0  #(.bit_width(bit_width+1)) reduc_1 (.a(out_NC_1), .b(reg_p), .sub((mode2==2'b01)? 1'b0 : 1'b1), .s(out_reduc_1));
    
    
    always @(posedge clk)begin
            dly_x <= X;
            dly_y <= Y;
            z0 <= (out_reduc_0[bit_width+1] == 1'b1) ? out_NC_0[bit_width-1:0] : out_reduc_0[bit_width-1:0];
            z1 <= ((mode2==2'b01 && out_NC_1[bit_width] == 1'b1) || (mode2==2'b10 && out_reduc_1[bit_width+1] == 1'b0)) ? out_reduc_1[bit_width-1:0] 
                        : out_NC_1[bit_width-1:0];
    end
endmodule
