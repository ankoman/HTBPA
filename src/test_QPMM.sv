`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 08/16/2022 11:50:10 AM
// Design Name: 
// Module Name: test_QPMM
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

`ifdef BLS12_381
    localparam bit_width = 381;
`else
    localparam bit_width = 254;
`endif 
localparam N_PIPELINE_STAGES = LAT_QPMM;

module test_QPMM;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 1000000;
               
    reg clk, rstn;
    qpmm_fp_t A, B;
    uint_Mtilde2_t Z;
    wire [999:0] tmp_ans = MR(A) * MR(B);
    wire [bit_width-1:0] ans = tmp_ans % CURVE_PARAMS::Mod;
    wire [bit_width-1:0] res = MR(Z);
    reg [N_PIPELINE_STAGES:0][bit_width-1:0] reg_ans;

    QPMM_d0 DUT(.clk, .rstn, .A, .B, .Z);
    
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
        $display("Test QPMM start\n");
        for(integer i = 0; i < N_PIPELINE_STAGES; i = i + 1) begin
            A <= rand_288() % (1024*CURVE_PARAMS::M_tilde);
            B <= rand_288() % (1024*CURVE_PARAMS::M_tilde);
//            A <= 272'h9d289143693cedb99a3634824056732c6ab659f650c97a3a07de4a3de195611861a;
//            B <= 272'hcfc83b144a374cedb4ebb176cd5f622edee5ea20fbe8dcd1b6cec23632499a3cc0a1;
            #DELAY
            reg_ans[0] <= ans;
            #(CYCLE-DELAY);
        end

        for(integer i = N_PIPELINE_STAGES; i < N_DATA; i = i + 1) begin
            A <= rand_288() % (1024*CURVE_PARAMS::M_tilde);
            B <= rand_288() % (1024*CURVE_PARAMS::M_tilde);
            
            #DELAY
            reg_ans[0] <= ans;
            //$display("%d: x = %h, y = %h", i, A, B);
            if(res !== reg_ans[N_PIPELINE_STAGES]) begin
                $display("#%d Failed: ans = %h, res = %h", i, reg_ans[N_PIPELINE_STAGES], res);
                //$display("x = %h, y = %h", x, y);
                $stop();
            end
            #(CYCLE-DELAY);
        end
        $display("#%d Test end\n", N_DATA);
        $finish;
    end


    function [bit_width-1:0] MR;
        input qpmm_fp_t A;
        logic [999:0] tmp_ans = (CURVE_PARAMS::R_INV*A);
        MR = tmp_ans % CURVE_PARAMS::Mod;
    endfunction

endmodule
