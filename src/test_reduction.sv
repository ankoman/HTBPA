`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/17 00:18:33
// Design Name: 
// Module Name: test_reduction
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

module test_reduction;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 100000,
        N_PIPELINE_STAGES = 6;
               
    reg clk, rstn;
    uint_fp_t in;
    redundant_poly_L1 in_L1;
    redundant_poly_L3 postadd_out;
    wire [LEN_12M_TILDE+L3_CARRY-1:0] uint_ans, ans, res;
    reg [N_PIPELINE_STAGES:0][LEN_12M_TILDE+L3_CARRY-1:0] reg_ans;

    uint_fp_t acc_reg;
    reg [2:0] mode;

    assign in_L1 = int2L1(in);
    assign ans = acc(in, acc_reg, mode);
    assign uint_ans = ans + {M_tilde, 9'd0};

    postadder postadder (.clk, .rstn, .in_L1, .mode1(), .mode2(), .mode3(mode), .outsel(2'b10), .addr2(), .addr3(2'b00), .dout(postadd_out));   
    L3touint DUT (.clk, .din(postadd_out), .dout(res));

    always begin
        #(CYCLE/2) clk <= ~clk;
    end

    for(genvar i = 0; i < N_PIPELINE_STAGES; i++) begin
        always @(posedge clk) begin
            reg_ans[i+1] <= reg_ans[i];
        end
    end

    /*-------------------------------------------
    Test
    -------------------------------------------*/
    initial begin
        rstn <= 1'b1;
        clk <= 1'b1;
        acc_reg <= '0;
        mode <= 3'b000;
    #(CYCLE*10)
        rstn <= 1'b0;
    #(CYCLE*10)
        rstn <= 1'b1;
    #DELAY;

        for(integer i = 0; i < N_PIPELINE_STAGES; i = i + 1) begin
            in <= rand_288() % M_tilde;;
            #DELAY
            #(CYCLE-DELAY);
            acc_reg <= ans;
            reg_ans[0] <= uint_ans;
        end

        for(integer _mode = 3; _mode < 6; _mode = _mode + 1) begin
            mode <= _mode;
            $display("Test reduction start. Mode = %d\n", _mode);

            for(integer i = 0; i < N_DATA; i = i + 1) begin
                in <= rand_288() % M_tilde;;
                #DELAY
                reg_ans[0] <= uint_ans;

                if(res !== reg_ans[N_PIPELINE_STAGES]) begin
                    $display("#%d Failed: ans = %h, res = %h", i, reg_ans[N_PIPELINE_STAGES], res); $stop();
                end

                #(CYCLE-DELAY);
                acc_reg <= ans;

                 if(i % (2**(L3_CARRY-1)) === 127) begin
                     acc_reg <= '0;
                     postadder.reg3[0] <= '0;
                 end
                 else begin
                     acc_reg <= ans;
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
            3'b101: acc = Mod - regin;
            //3'b110: acc = Mod - din;
            default: acc = 'x;
        endcase
    endfunction

endmodule