`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 08/17/2022 11:03:20 AM
// Design Name: 
// Module Name: TOP_test
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

localparam USE_BRAM_MACRO = 1;

module TOP_test(
    Dout_0,
    default_sysclk1_300_clk_n,
    default_sysclk1_300_clk_p
    );

    output Dout_0;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk1_300 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_sysclk1_300, CAN_DEBUG false, FREQ_HZ 300000000" *) input default_sysclk1_300_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk1_300 CLK_P" *) input default_sysclk1_300_clk_p;

    wire [271:0]Net;
    wire [271:0]blk_mem_gen_0_doutb;
    wire [271:0]blk_mem_gen_1_doutb;
    wire clk_wiz_0_clk_out1;
    wire [0:0]xlconstant_0_dout = '1;
    wire [7:0]xlconstant_1_dout = '0;
    wire [7:0]xlconstant_2_dout = '1;


    assign Dout_0 = blk_mem_gen_1_doutb[0];

    // QPMM_d0_24_16 qpmm_inst
    //     (.A(blk_mem_gen_0_doutb),
    //     .B(blk_mem_gen_1_doutb),
    //     .Z(Net),
    //     .clk(clk_wiz_0_clk_out1),
    //     .rstn(xlconstant_0_dout));

    multi_cycle_adder #(.latency(2))MCA
        (.X(blk_mem_gen_0_doutb),
        .Y(blk_mem_gen_1_doutb),
        .Z(Net),
        .clk(clk_wiz_0_clk_out1));

    if (USE_BRAM_MACRO) begin
        blk_mem_gen_272 RAM0
            (.addra(xlconstant_1_dout),
            .addrb(xlconstant_1_dout),
            .clka(clk_wiz_0_clk_out1),
            .clkb(clk_wiz_0_clk_out1),
            .dina(Net),
            .doutb(blk_mem_gen_0_doutb),
            .wea(xlconstant_0_dout));

        blk_mem_gen_272 RAM1
            (.addra(xlconstant_1_dout),
            .addrb(xlconstant_1_dout),
            .clka(clk_wiz_0_clk_out1),
            .clkb(clk_wiz_0_clk_out1),
            .dina(Net),
            .doutb(blk_mem_gen_1_doutb),
            .wea(xlconstant_0_dout));
    end
    else begin
        HDL_RAM RAM0
            (.addra(xlconstant_1_dout),
            .addrb(xlconstant_1_dout),
            .clk(clk_wiz_0_clk_out1),
            .dina(Net),
            .doutb(blk_mem_gen_0_doutb),
            .wea(xlconstant_0_dout));

        HDL_RAM RAM1
            (.addra(xlconstant_1_dout),
            .addrb(xlconstant_2_dout),
            .clk(clk_wiz_0_clk_out1),
            .dina(Net),
            .doutb(blk_mem_gen_1_doutb),
            .wea(xlconstant_0_dout));
    end

    clk_wiz_600 clk_wiz
        (.clk_in1_n(default_sysclk1_300_clk_n),
        .clk_in1_p(default_sysclk1_300_clk_p),
        .clk_out1(clk_wiz_0_clk_out1));

endmodule

module HDL_RAM(
    input clk,
    input [7:0] addra, addrb,
    input wea,
    input [271:0] dina,
    output reg[271:0] doutb
    );

    reg [271:0] ram [140:0];
    always @(posedge clk) begin
        doutb <= ram[addrb];
        if(wea)
            ram[addra] <= dina;
    end

endmodule
