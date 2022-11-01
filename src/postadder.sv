`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/07 19:05:41
// Design Name: 
// Module Name: postadder
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

module postadder(
    input clk,
    input rstn,
    input redundant_poly_L1 in_L1,
    input [2:0] mode1, mode2, mode3,
    input [1:0] outsel, addr2, addr3, thread, 
    output redundant_poly_L3 dout
    );

    redundant_poly_L3 in;
    assign in = L1toL3(in_L1);

    redundant_poly_L3[3:0] reg1;
    redundant_poly_L3[3:0][2:0] reg2, reg3;
    redundant_poly_L3 acc1_out, acc2_out, acc3_out;
    redundant_poly_L3 reg1_wire, reg2_wire, reg3_wire, dly_reg1, dly_reg2, dly_reg3;
    assign reg1_wire = reg1[thread];
    assign reg2_wire = reg2[thread][addr2];
    assign reg3_wire = reg3[thread][addr3];

    redundant_poly_L3 poly_p;
    assign poly_p = inttoL3(PARAMS_BN254_d0::Mod);

    //// ACC1
    wire sel_b1 = ((mode1 == 3'b001) || (mode1 == 3'b100));
    redundant_poly_L3 add1_ain;
    assign add1_ain = (mode1[2:1]==2'b00)? 0:(mode1==3'b010)?in:(mode1==3'b011)?in:(mode1==3'b100)?reg1_wire:(mode1==3'b101)?poly_p:in;
    redundant_poly_L3 add1_bin;
    assign add1_bin = sel_b1? in: reg1_wire;
    wire add1_sel_sub = (mode1==3'b011)?1'b1:(mode1==3'b100)?1'b1:(mode1==3'b101)?1'b1:1'b0;
    poly_adder_L3_L3 acc1(.sub(add1_sel_sub), .X(add1_ain), .Y(add1_bin), .Z(acc1_out));

    //// ACC2
    wire sel_b2 = ((mode2 == 3'b001) || (mode2 == 3'b100));
    // logic[$bits(uint_fp_t)/4-1:0] reg2_reg_wire_buf_0 = (reg_addr2[0] == 2'b00)? reg2[0][0] : (reg_addr2[0] == 2'b01)? reg2[1][0]: (reg_addr2[0] == 2'b10)? reg2[2][0]:'x;
    // logic[$bits(uint_fp_t)/4-1:0] reg2_reg_wire_buf_1 = (reg_addr2[1] == 2'b00)? reg2[0][1] : (reg_addr2[1] == 2'b01)? reg2[1][1]: (reg_addr2[1] == 2'b10)? reg2[2][1]:'x;
    // logic[$bits(uint_fp_t)/4-1:0] reg2_reg_wire_buf_2 = (reg_addr2[2] == 2'b00)? reg2[0][2] : (reg_addr2[2] == 2'b01)? reg2[1][2]: (reg_addr2[2] == 2'b10)? reg2[2][2]:'x;
    // logic[$bits(uint_fp_t)/4-1:0] reg2_reg_wire_buf_3 = (reg_addr2[3] == 2'b00)? reg2[0][3] : (reg_addr2[3] == 2'b01)? reg2[1][3]: (reg_addr2[3] == 2'b10)? reg2[2][3]:'x;
    //assign reg2_reg_wire = {reg2_reg_wire_buf_3, reg2_reg_wire_buf_2, reg2_reg_wire_buf_1, reg2_reg_wire_buf_0};
    redundant_poly_L3 add2_ain;
    assign add2_ain = (mode2[2:1]==2'b00)? 0:(mode2==3'b010)?in:(mode2==3'b011)?in:(mode2==3'b100)?reg2_wire:(mode2==3'b101)?poly_p:in;
    redundant_poly_L3 add2_bin;
    assign add2_bin = sel_b2? in: reg2_wire;
    wire add2_sel_sub = (mode2==3'b011)?1'b1:(mode2==3'b100)?1'b1:(mode2==3'b101)?1'b1:1'b0;
    poly_adder_L3_L3 acc2(.sub(add2_sel_sub), .X(add2_ain), .Y(add2_bin), .Z(acc2_out));

    //// ACC2
    wire sel_b3 = ((mode3 == 3'b001) || (mode3 == 3'b100));
    // logic[$bits(uint_fp_t)/4-1:0] reg3_reg_wire_buf_0 = (reg_addr2[0] == 2'b00)? reg3[0][0] : (reg_addr2[0] == 2'b01)? reg3[1][0]: (reg_addr2[0] == 2'b10)? reg3[2][0]:'x;
    // logic[$bits(uint_fp_t)/4-1:0] reg3_reg_wire_buf_1 = (reg_addr2[1] == 2'b00)? reg3[0][1] : (reg_addr2[1] == 2'b01)? reg3[1][1]: (reg_addr2[1] == 2'b10)? reg3[2][1]:'x;
    // logic[$bits(uint_fp_t)/4-1:0] reg3_reg_wire_buf_2 = (reg_addr2[2] == 2'b00)? reg3[0][2] : (reg_addr2[2] == 2'b01)? reg3[1][2]: (reg_addr2[2] == 2'b10)? reg3[2][2]:'x;
    // logic[$bits(uint_fp_t)/4-1:0] reg3_reg_wire_buf_3 = (reg_addr2[3] == 2'b00)? reg3[0][3] : (reg_addr2[3] == 2'b01)? reg3[1][3]: (reg_addr2[3] == 2'b10)? reg3[2][3]:'x;
    //assign reg3_reg_wire = {reg3_reg_wire_buf_3, reg3_reg_wire_buf_2, reg3_reg_wire_buf_1, reg3_reg_wire_buf_0};
    redundant_poly_L3 add3_ain;
    assign add3_ain = (mode3[2:1]==2'b00)? 0:(mode3==3'b010)?in:(mode3==3'b011)?in:(mode3==3'b100)?reg3_wire:(mode3==3'b101)?poly_p:in;
    redundant_poly_L3 add3_bin;
    assign add3_bin = sel_b3? in: reg3_wire;
    wire add3_sel_sub = (mode3==3'b011)?1'b1:(mode3==3'b100)?1'b1:(mode3==3'b101)?1'b1:1'b0;
    poly_adder_L3_L3 acc3(.sub(add3_sel_sub), .X(add3_ain), .Y(add3_bin), .Z(acc3_out));


    always @(posedge clk) begin
        if(!rstn)begin
            reg1[0] <= '0;
            reg1[1] <= '0;
            reg1[2] <= '0;
            reg1[3] <= '0;
            dout <= '0;
            for(integer i = 0; i < 3; i = i + 1) begin
                reg2[0][i] <= '0;
                reg3[0][i] <= '0;
                reg2[1][i] <= '0;
                reg3[1][i] <= '0;    
                reg2[2][i] <= '0;
                reg3[2][i] <= '0;                
                reg2[3][i] <= '0;
                reg3[3][i] <= '0;
            end
            dly_reg1 <= '0;
            dly_reg2 <= '0;
            dly_reg3 <= '0;
        end else begin
            reg1[thread] <= acc1_out;
            reg2[thread][addr2] <= acc2_out;
            reg3[thread][addr3] <= acc3_out;
            dly_reg1 <= acc1_out;
            dly_reg2 <= acc2_out;
            dly_reg3 <= acc3_out;
            dout <= (outsel==2'b00)?dly_reg1:(outsel==2'b01)?dly_reg2:(outsel==2'b10)?dly_reg3:'x;
        end
    end

    function redundant_poly_L3 L1toL3;
        input redundant_poly_L1 in_L1;
        L1toL3 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            L1toL3[i].carry = 8'(in_L1[i].carry);
            L1toL3[i].val = in_L1[i].val;
        end
    endfunction
    function redundant_poly_L3 inttoL3;
        input uint_fp_t in_int;
        fp_div4_t[ADD_DIV-1:0] poly;
        poly = in_int;
        inttoL3 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            inttoL3[i].carry = '0;
            inttoL3[i].val = poly[i];
        end
    endfunction
endmodule
