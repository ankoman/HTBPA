`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/31 22:51:37
// Design Name: 
// Module Name: test_pairing_UART
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


module test_pairing_UART;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 1000000;

    reg clk, rstn, run;
    reg [8:0] addr_dout;
    wire dout;

    TOP_test DUT(.default_sysclk1_300_clk_n(!clk), .default_sysclk1_300_clk_p(clk), .CPU_RESET(!rstn), .USB_UART_TX(run), .addr(addr_dout), .USB_UART_RX(dout));

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
        addr_dout <= 0;
        #1000
        rstn <= 0;
        #100
        rstn <= 1;
        run <= 1;
        #(CYCLE);
        run <= 0;
        #10000;
        addr_dout <= 8'hf0;
        #100;
        addr_dout <= 8'h00;

    end
endmodule

