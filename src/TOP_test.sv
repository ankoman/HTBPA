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

localparam USE_BRAM_IP = 1;

module TOP_test(
    Dout_0,
    default_sysclk1_300_clk_n,
    default_sysclk1_300_clk_p
    );

    output Dout_0;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk1_300 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_sysclk1_300, CAN_DEBUG false, FREQ_HZ 300000000" *) input default_sysclk1_300_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk1_300 CLK_P" *) input default_sysclk1_300_clk_p;

    wire [287:0]Net, Net1, Net2;
    wire [287:0]blk_mem_gen_0_doutb;
    wire [287:0]blk_mem_gen_1_doutb;
    wire clk_wiz_0_clk_out1;
    wire [0:0]xlconstant_0_dout = '1;
    wire [8:0]xlconstant_1_dout = '0;
    wire [8:0]xlconstant_2_dout = '1;


    assign Dout_0 = blk_mem_gen_1_doutb[271];

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


    wire [320:0] preadd_out1, preadd_out2, red_out1, red_out2, qpmm_out, cmul_out, Net;

    preadder preadder (
    .clk(clk_wiz_0_clk_out1),
    .rstn(),
    .X(blk_mem_gen_0_doutb), 
    .Y(blk_mem_gen_1_doutb),
    .mode1(blk_mem_gen_1_doutb[3:1]), 
    .mode2(blk_mem_gen_1_doutb[3:1]),
    .Z0(preadd_out1), 
    .Z1(preadd_out2)
    );

    L3touint reduction1 (.clk(clk_wiz_0_clk_out1), .din(preadd_out1), .dout(red_out1));
    L3touint reduction2 (.clk(clk_wiz_0_clk_out1), .din(preadd_out2), .dout(red_out2));

    QPMM_d0 qpmm_inst
        (.A(red_out1),
        .B(red_out2),
        .Z(qpmm_out),
        .clk(clk_wiz_0_clk_out1),
        .rstn(xlconstant_0_dout));

    cmul #(.LATENCY(1)) cmul (.clk(clk_wiz_0_clk_out1), .mode(blk_mem_gen_1_doutb[5:3]), .din(qpmm_out), .dout(cmul_out));

    postadder postadder(
    .clk(clk_wiz_0_clk_out1),
    .rstn(blk_mem_gen_1_doutb[0]),
    .in_L1(cmul_out),
    .mode1(blk_mem_gen_1_doutb[3:1]),
    .mode2(blk_mem_gen_1_doutb[6:4]),
    .mode3(blk_mem_gen_1_doutb[9:7]),
    .outsel(blk_mem_gen_1_doutb[11:10]),
    .addr2(blk_mem_gen_1_doutb[13:12]),
    .addr3(blk_mem_gen_1_doutb[15:14]),
    .dout(Net)
    );


    if (USE_BRAM_IP) begin
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
