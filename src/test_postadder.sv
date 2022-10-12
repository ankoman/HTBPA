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

import PARAMS_BN254_d0::*;

module test_postadder;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 1000000;
               
    reg clk, rstn;
    uint_fp_t in;
    redundant_poly_L1 in_L1;
    uint_fp_t ans1, ans2, ans3, res1, res2, res3;
    uint_fp_t reg1;
    uint_fp_t [2:0] reg2, reg3;
    reg [2:0] mode1, mode2, mode3;
    reg [1:0] addr2, addr3;

    assign in_L1 = int2L1(in);
    assign ans1 = acc(in, reg1, mode1);
    assign ans2 = acc(in, reg2[addr2], mode2);
    assign ans3 = acc(in, reg3[addr3], mode3);
    // assign res1 = L3toint(DUT.acc1_out);
    // assign res2 = L3toint(DUT.acc2_out);
    // assign res3 = L3toint(DUT.acc3_out);
    L3toint red1 (DUT.acc1_out, res1);
    L3toint red2 (DUT.acc2_out, res2);
    L3toint red3 (DUT.acc3_out, res3);


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

        for(integer mode = 0; mode < 6; mode = mode + 1) begin
            mode1 <= mode;
            mode2 <= mode;
            mode3 <= mode;
            $display("Test postadder start. Mode = %d\n", mode);
            for(integer i = 0; i < N_DATA; i = i + 1) begin
                in <= rand_280();
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
            3'b101: acc = PARAMS_BN254_d0::Mod - regin;
            //3'b110: acc = PARAMS_BN254_d0::Mod - din;
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

    // function uint_fp_t L3toint;
    //     input redundant_poly_L3 din;

    //     automatic logic sign0 = din[0].carry[L3_CARRY-1];
    //     automatic logic sign1 = din[1].carry[L3_CARRY-1];
    //     automatic logic sign2 = din[2].carry[L3_CARRY-1];
    //     automatic logic sign3 = din[3].carry[L3_CARRY-1];

    //     L3toint = 0;
    //     for(integer i = 0; i <= ADD_DIV; i = i + 1) begin
    //         L3toint = L3toint + (din[i] << ($bits(uint_fp_t)/ADD_DIV*i));
    //     end
    // endfunction
endmodule

module L3toint(
    input redundant_poly_L3 din,
    output uint_fp_t dout
    );

    wire sign0 = din[0].carry[L3_CARRY-1];
    wire sign1 = din[1].carry[L3_CARRY-1];
    wire sign2 = din[2].carry[L3_CARRY-1];
    wire sign3 = din[3].carry[L3_CARRY-1];

    
    // First cycle
    wire[$bits(fp_div4_t)-1:0] add1_1, add2_1, add3_1;
    wire carry1_1, carry2_1, carry3_1;
    assign {carry1_1, add1_1} = din[1].val + {sign0 ? 60'hfffffffffffffff: 60'd0, din[0].carry};
    assign {carry2_1, add2_1} = din[2].val + {sign1 ? 60'hfffffffffffffff: 60'd0, din[1].carry};
    assign {carry3_1, add3_1} = din[3].val + {sign2 ? 60'hfffffffffffffff: 60'd0, din[2].carry};

    // Second cycle
    wire[$bits(fp_div4_t)-1:0] add2_2, add3_2;
    wire carry2_2, carry3_2;
    assign {carry2_2, add2_2} = add2_1 + carry1_1 + (sign0 ? 68'hfffffffffffffffff: 68'd0);
    assign {carry3_2, add3_2} = add3_1 + carry2_1 + (sign1 ? 68'hfffffffffffffffff: 68'd0);

    // Third cycle
    wire[$bits(fp_div4_t)-1:0] add3_3 = add3_2 + carry2_2 + (sign0 ? 68'hfffffffffffffffff: 68'd0);

    assign dout = {add3_3, add2_2, add1_1, din[0].val};

endmodule