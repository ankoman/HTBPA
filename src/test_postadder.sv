`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/09/30 13:50:06
// Design Name: 
// Module Name: test_MCA
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
module test_postadder;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 100000;
               
    reg clk, rstn;
    uint_fp_t in;
    redundant_poly_L1 in_L1;
    wire [LEN_12M_TILDE+L3_CARRY-1:0] ans1, ans2, ans3, res1, res2, res3;
    uint_fp_t reg1;
    uint_fp_t [2:0] reg2, reg3;
    reg [2:0] mode1, mode2, mode3;
    reg [1:0] addr2, addr3;

    assign in_L1 = int2L1(in);
    assign ans1 = acc(in, reg1, mode1);
    assign ans2 = acc(in, reg2[addr2], mode2);
    assign ans3 = acc(in, reg3[addr3], mode3);
    assign res1 = func_L3toint(DUT.acc1_out);
    assign res2 = func_L3toint(DUT.acc2_out);
    assign res3 = func_L3toint(DUT.acc3_out);
    // L3toint red1 (DUT.acc1_out, res1);
    // L3toint red2 (DUT.acc2_out, res2);
    // L3toint red3 (DUT.acc3_out, res3);


    postadder DUT(.clk, .rstn, .in_L1, .mode1, .mode2, .mode3, .outsel(2'b00), .addr2, .addr3);
    
    always begin
        #(CYCLE/2) clk <= ~clk;
    end
    
    /*-------------------------------------------
    Test
    -------------------------------------------*/
    initial begin
        rstn <= 1'b1;
        clk <= 1'b1;
        addr2 <= 2'b01;
        addr3 <= 2'b10;
        reg1 <= '0;
        reg2[1] <= '0;
        reg3[2] <= '0;
        mode1 <= 3'b000;
        mode2 <= 3'b000;
        mode3 <= 3'b000;
    #(CYCLE*10)
        rstn <= 1'b0;
    #(CYCLE*10)
        rstn <= 1'b1;
    #DELAY;

        for(integer mode = 2; mode < 6; mode = mode + 1) begin
            mode1 <= mode;
            mode2 <= mode;
            mode3 <= mode;
            $display("Test postadder start. Mode = %d\n", mode);
            for(integer i = 0; i < N_DATA; i = i + 1) begin
                in <= rand_288() % CURVE_PARAMS::M_tilde;;
                #DELAY
                if(res1 !== ans1) begin
                    $display("#%d Failed: ans1 = %h, res = %h", i, ans1, res1); $stop();
                end
                if(res2 !== ans2) begin
                    $display("#%d Failed: ans2 = %h, res = %h", i, ans2, res2); $stop();
                end
                if(res3 !== ans3) begin
                    $display("#%d Failed: ans3 = %h, res = %h", i, ans3, res3); $stop();
                end

                #(CYCLE-DELAY);
                if(i % (2**(L3_CARRY-1)) === 127) begin
                    reg1 <= '0;
                    reg2[1] <= '0;
                    reg3[2] <= '0;
                    DUT.reg1 <= '0;
                    DUT.reg2[1] <= '0;
                    DUT.reg3[2] <= '0;
                end
                else begin
                    reg1 <= ans1;
                    reg2[1] <= ans2;
                    reg3[2] <= ans3;
                end
            end
        end
        
        $display("#%d Test end\n", N_DATA);
        $finish;
    end

    function redundant_poly_L1 int2L1;
        input uint_fp_t in_int;
        fp_div4_t[ADD_DIV-1:0] poly;
        poly = in_int;
        int2L1 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            int2L1[i].carry = '0;
            int2L1[i].val = poly[i];
        end
    endfunction

    function redundant_poly_L3 acc;
        input uint_fp_t din, regin;
        input [2:0] mode;
        case(mode)
            3'b000: acc = 0 + regin;
            3'b001: acc = 0 + din;
            3'b010: acc = din + regin;
            3'b011: acc = din - regin;
            3'b100: acc = regin - din;
            3'b101: acc = CURVE_PARAMS::Mod - regin;
            //3'b110: acc = CURVE_PARAMS::Mod - din;
            default: acc = 'x;
        endcase
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

    function uint_fp_t func_L3toint;
        input redundant_poly_L3 din;

        func_L3toint = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            func_L3toint = func_L3toint + ({din[i].carry[L3_CARRY-1] ? 320'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff : '0, din[i]} << ($bits(fp_div4_t)*i));
        end
    endfunction
endmodule