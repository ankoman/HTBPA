`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/21 10:53:29
// Design Name: 
// Module Name: TOP_pairing
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


localparam USE_BRAM_IP = 1;

module TOP_pairing(
    input   default_sysclk1_300_clk_n,
            default_sysclk1_300_clk_p,
            CPU_RESET,  //Active high
            USB_UART_TX,
input [7:0] addr,
    output  USB_UART_RX
    );

    wire [288:0]Net, Net1, Net2;
    wire [288:0]blk_mem_gen_0_doutb;
    wire [288:0]blk_mem_gen_1_doutb;
    wire clk_wiz_0_clk_out1, clk_100M;
    wire [0:0]xlconstant_0_dout = '1;
    wire [8:0]xlconstant_1_dout = '0;
    wire [8:0]xlconstant_2_dout = '1;


    Pairing_UART u0(
            .clk_uart(clk_100M),
            .clk(clk_wiz_0_clk_out1),
            .addr(addr),
            .rstn(!CPU_RESET),
            .uart_tx(USB_UART_TX),
            .uart_rx(USB_UART_RX)
    );

    // QPMM_d0 qpmm_inst
    //     (.A(blk_mem_gen_0_doutb),
    //     .B(blk_mem_gen_1_doutb),
    //     .Z(Net),
    //     .clk(clk_wiz_0_clk_out1),
    //     .rstn(xlconstant_0_dout));

    // cmul #(.LATENCY(1)) cmul (.clk(clk_wiz_0_clk_out1), .mode(blk_mem_gen_1_doutb), .din(blk_mem_gen_0_doutb), .dout(Net));

    // poly_adder_L3_L3 adder
    //     (.sub(blk_mem_gen_0_doutb[0]),
    //     .X(blk_mem_gen_0_doutb),
    //     .Y(blk_mem_gen_1_doutb),
    //     .Z(Net));

    // postadder postadder(
    // .clk(clk_wiz_0_clk_out1),
    // .rstn(blk_mem_gen_1_doutb[0]),
    // .in_L1(blk_mem_gen_0_doutb),
    // .thread(blk_mem_gen_1_doutb[5:4]),
    // .mode1(blk_mem_gen_1_doutb[3:1]),
    // .mode2(blk_mem_gen_1_doutb[6:4]),
    // .mode3(blk_mem_gen_1_doutb[9:7]),
    // .outsel(blk_mem_gen_1_doutb[11:10]),
    // .addr2(blk_mem_gen_1_doutb[13:12]),
    // .addr3(blk_mem_gen_1_doutb[15:14]),
    // .dout(Net)
    // );

    // preadder preadder (
    // .clk(clk_wiz_0_clk_out1),
    // .rstn(),
    // .X(blk_mem_gen_0_doutb), 
    // .Y(blk_mem_gen_1_doutb),
    // .thread(blk_mem_gen_1_doutb[5:4]),
    // .mode1(blk_mem_gen_1_doutb[3:1]), 
    // .mode2(blk_mem_gen_1_doutb[3:1]),
    // .Z0(Net1), 
    // .Z1(Net2)
    // );
    // assign Net = Net1 ^ Net2;

    // L3touint reduction (.clk(clk_wiz_0_clk_out1), .din(blk_mem_gen_0_doutb), .dout(Net));


    // if (USE_BRAM_IP) begin
    //     blk_mem_gen_272 RAM0
    //         (.addra(xlconstant_1_dout),
    //         .addrb(xlconstant_1_dout),
    //         .clka(clk_wiz_0_clk_out1),
    //         .clkb(clk_wiz_0_clk_out1),
    //         .dina(Net),
    //         .doutb(blk_mem_gen_0_doutb),
    //         .wea(xlconstant_0_dout));

    //     blk_mem_gen_272 RAM1
    //         (.addra(xlconstant_1_dout),
    //         .addrb(xlconstant_1_dout),
    //         .clka(clk_wiz_0_clk_out1),
    //         .clkb(clk_wiz_0_clk_out1),
    //         .dina(Net),
    //         .doutb(blk_mem_gen_1_doutb),
    //         .wea(xlconstant_0_dout));
    // end
    // else begin
    //     HDL_RAM RAM0
    //         (.addra(xlconstant_1_dout),
    //         .addrb(xlconstant_1_dout),
    //         .clk(clk_wiz_0_clk_out1),
    //         .dina(Net),
    //         .doutb(blk_mem_gen_0_doutb),
    //         .wea(xlconstant_0_dout));

    //     HDL_RAM RAM1
    //         (.addra(xlconstant_1_dout),
    //         .addrb(xlconstant_2_dout),
    //         .clk(clk_wiz_0_clk_out1),
    //         .dina(Net),
    //         .doutb(blk_mem_gen_1_doutb),
    //         .wea(xlconstant_0_dout));
    // end

    // assign USB_UART_RX = Net[271];
    // //extendedEuclidean5 dut (.a(blk_mem_gen_1_doutb), .p(PARAMS_BN254_d0::Mod), .a_inv (Net), .startflag(blk_mem_gen_0_doutb[0]), .clk(clk_wiz_0_clk_out1), .rstn(CPU_RESET));
    // Mont_inv_multi DUT (.clk(clk_wiz_0_clk_out1), .rstn(CPU_RESET), .I_START(blk_mem_gen_0_doutb[0]), .I_DATA_N(257'(PARAMS_BN254_d0::Mod)), .I_WDATA(blk_mem_gen_1_doutb), .O_RDATA(Net));

    clk_wiz_600 clk_wiz
        (.clk_in1_n(default_sysclk1_300_clk_n),
        .clk_in1_p(default_sysclk1_300_clk_p),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_100M));

endmodule

module HDL_RAM(
    input clk,
    input [7:0] addra, addrb,
    input wea,
    input [271:0] dina,
    output reg[271:0] doutb
    );

    //(*rw_addr_collision = "no" *) reg [271:0] ram [140:0];
    reg [271:0] ram [140:0];
    reg [271:0] buf_ram1, buf_ram2;
    
    always @(posedge clk) begin
        buf_ram1 <= ram[addrb];
        buf_ram2 <= buf_ram1;
        doutb <= buf_ram2;
        if(wea)
            ram[addra] <= dina;
    end

endmodule

module Pairing_UART(
    input   clk_uart,
            clk,
            rstn,
            uart_tx,
input [7:0] addr,
    output uart_rx
    );
    
        wire [304-1:0] extout_data;
        logic [304-1:0] reg_extout_data;
        assign uart_rx = reg_extout_data[200];


    BN254_pairing DUT(.clk, .rstn, .run(uart_tx), .n_func(4'd0), .extin_addr(), .extout_addr(addr), .extin_data(), .extin_en(), .extout_data);

    always @(posedge clk) begin
        if(!rstn)
                reg_extout_data <= '0;
        else begin
                if (addr[7])
                        reg_extout_data <= extout_data;
                else
                        reg_extout_data <= {reg_extout_data[302:0], 1'b0};
        end
    end

endmodule