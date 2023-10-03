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

import CURVE_PARAMS::*;
module test_eeinv();
    localparam 
        CYCLE = 10,
        DELAY = 2;
               
    reg clk, rstn, run, swrst, extin_en;
    M_tilde12_t wdata;
    wire busy;
    reg [8:0] waddr;

    always begin
        #(CYCLE/2) clk <= ~clk;
    end
    
    Mont_inv_multi DUT (.clk, .rstn, .I_START(run), .I_DATA_N(M_tilde12_t'(CURVE_PARAMS::Mod)), .I_WADDR(waddr), .I_WDATA(wdata), .O_BUSY(busy));

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
        waddr <= 'h11;
        wdata <= 'h1e15c648984f3a227733779e1b48ad802c2434dbe4e0dce273a446b73fc5b629;
        run <= 1;
        #(CYCLE);
        waddr <= 'h12;
        wdata <= 'h99ac9110cbcdf1924248781ca049785e49e45f9c9b24c70f9fc7db57b20c5d8ad2a;
        #(CYCLE);
        waddr <= 'h13;
        wdata <= 'hb5238fca47627bc91c70d407c6f6df185747a803032e7f19fd10a1fc1e531bd2bc7;
        #(CYCLE);
        waddr <= 'h15;
        wdata <= 'hf3bb376c204c9720510d2e534b7105c628c4db5f20123d4c29aee190c73433f4062;
        #(CYCLE);
        waddr <= 'h16;
        wdata <= 'h1e15c648984f3a227733779e1b48ad802c2434dbe4e0dce273a446b73fc5b629;
        #(CYCLE);
        waddr <= 'h17;
        wdata <= 'h99ac9110cbcdf1924248781ca049785e49e45f9c9b24c70f9fc7db57b20c5d8ad2a;
        #(CYCLE);

        run <= 0;
        #1000;
        wait(!busy);
        #1000
        run <= 1;
        waddr <= 'h22;
        wdata <= 'h111111111111124248781ca049785e49e45f9c9b24c70f9fc7db57b20c5d8ad2a;
        #(CYCLE);
        waddr <= 'h23;
        wdata <= 'hba1237bc91c70d407c6f6df185747a803032e7f19fd10a1fc1e531bd2bc7;
        #(3*CYCLE);
        run <= 0;
        #1000;
        wait(!busy);
        #100
        $finish;
    end
endmodule
