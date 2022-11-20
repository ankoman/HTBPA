`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/20 20:30:33
// Design Name: 
// Module Name: test_eeinv
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

module test_eeinv();
    localparam 
        CYCLE = 10,
        DELAY = 2;
               
    reg clk, rstn, run, swrst, extin_en;
    M_tilde12_t wdata;
    wire busy;

    always begin
        #(CYCLE/2) clk <= ~clk;
    end
    
    inv DUT (.clk, .rstn, .I_START(run), .I_DATA_N(M_tilde12_t'(PARAMS_BN254_d0::Mod)), .I_WDATA(wdata), .O_BUSY(busy));

    /*-------------------------------------------
    Test
    -------------------------------------------*/
    initial begin
        clk <= 1;
        rstn <= 1;
        run <= 0;
        #1000
        rstn <= 0;
        #100
        rstn <= 1;
        #1000;
        wdata <= 'h99ac9110cbcdf1924248781ca049785e49e45f9c9b24c70f9fc7db57b20c5d8ad2a;
        run <= 1;
        #(CYCLE);
        // wdata <= 'h99ac9110cbcdf1924248781ca049785e49e45f9c9b24c70f9fc7db57b20c5d8ad2a;
        // #(CYCLE);
        // wdata <= 'hb5238fca47627bc91c70d407c6f6df185747a803032e7f19fd10a1fc1e531bd2bc7;
        // #(CYCLE);
        // wdata <= 'hf3bb376c204c9720510d2e534b7105c628c4db5f20123d4c29aee190c73433f4062;
        // #(CYCLE);
        run <= 0;
        #1000;
        wait(!busy);
        #100
        run <= 1;
        #(CYCLE);
        run <= 0;
        #1000;
        wait(!busy);
        #100
        $finish;
    end
endmodule
