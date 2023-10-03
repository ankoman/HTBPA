`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/07 03:20:42
// Design Name: 
// Module Name: test_sequencer
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

module test_sequencer;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 1000000;
               
    reg clk, rstn, run, swrst, extin_en;
    reg [3:0] n_func;
    reg [8:0] extin_addr, addr_dout;
    redundant_poly_L3 extin_data;
    wire [289-1:0] extout_data;
    wire busy;
    
    new_sequencer DUT(.clk, .rstn, .run, .n_func, .busy, .mops());

    always begin
        #(CYCLE/2) clk <= ~clk;
    end
    
    /*-------------------------------------------
    Test
    -------------------------------------------*/
    initial begin
        clk <= 1;
        rstn <= 1;
        run <= 0;
        swrst <= 0;
        addr_dout <= 0;
        n_func <= 3;
        extin_en <= 0;
        #1000
        rstn <= 0;
        #100
        rstn <= 1;
        #1000;
        swrst <= 1;
        #100;
        swrst <= 0;
        run <= 1;
        #(CYCLE);
        run <= 0;
        #1000;
        wait(!busy);
        #100
        
        for(integer i=0;i<12;i=i+1) begin
            addr_dout <= 8'h10 + i;
            #(CYCLE*100);
            $display("i = %d: %h", i, extout_data);
        end
    
    $finish;
    end

endmodule
