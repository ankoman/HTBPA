`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/14 20:16:59
// Design Name: 
// Module Name: test_cmul
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

module test_cmul;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 1000000;
               
    reg clk, rstn;
    M_tilde12_t din;
    redundant_poly_L1 dout;
    M_tilde12_t ans, res;
    reg [2:0] mode;

    assign ans = din * mode;
    assign res = L1toint(dout);

    cmul  #(.LATENCY(0)) DUT (.clk, .mode, .din, .dout);
    
    always begin
        #(CYCLE/2) clk <= ~clk;
    end
    
    /*-------------------------------------------
    Test
    -------------------------------------------*/
    initial begin
        rstn <= 1'b1;
        clk <= 1'b1;
        mode <= 3'b000;

    #(CYCLE*10)
        rstn <= 1'b0;
    #(CYCLE*10)
        rstn <= 1'b1;
    #DELAY;

        for(integer _mode = 5; _mode < 7; _mode = _mode + 1) begin
            #DELAY;
            mode <= _mode;
            if (mode != 5) begin
                $display("Test cmul start. Mode = %d\n", mode);
                for(integer i = 0; i < N_DATA; i = i + 1) begin
                    din <= rand_288() % PARAMS_BN254_d0::M_tilde*2;
                    #DELAY
                    if(res !== ans) begin
                        $display("#%d Failed: ans = %h, res = %h", i, ans, res); $stop();
                    end
                    #(CYCLE-DELAY-DELAY);
                end
            end
        end
        
        $display("#%d Test end\n", N_DATA);
        $finish;
    end

    function M_tilde12_t L1toint;
        input redundant_poly_L1 din;

        L1toint = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            L1toint = L1toint + (din[i] << i *$bits(fp_div4_t));
        end
    endfunction

endmodule
