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

module test_MCA;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 10000,
        N_PIPELINE_STAGES = 2;
               
    reg clk, rstn;
    uint_fp_t X, Y, Z;
    uint_fp_t ans;
    assign ans = X + Y;
    uint_fp_t [N_PIPELINE_STAGES:0] reg_ans;

    multi_cycle_adder #(.latency(N_PIPELINE_STAGES)) DUT(.clk, .X, .Y, .Z);
    
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
    #(CYCLE*10)
        rstn <= 1'b0;
    #(CYCLE*10)
        rstn <= 1'b1;
    #DELAY;
        $display("Test MCA latency = 0 start\n");

        for(integer i = 0; i < N_DATA + N_PIPELINE_STAGES; i = i + 1) begin
            X <= rand_280();
            Y <= rand_280();
            
            #DELAY
            reg_ans[0] <= ans;
            #DELAY
            //$display("%d: x = %h, y = %h", i, A, B);
            if(i >= N_PIPELINE_STAGES) begin
                if(Z !== reg_ans[N_PIPELINE_STAGES]) begin
                    $display("#%d Failed: ans = %h, res = %h", i, reg_ans[N_PIPELINE_STAGES], Z);
                    //$display("x = %h, y = %h", x, y);
                    $stop();
                end
            end
            #(CYCLE-DELAY-DELAY);
        end
        $display("#%d Test end\n", N_DATA);
        $finish;
    end


endmodule
