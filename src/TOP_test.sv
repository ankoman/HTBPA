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
`ifdef BLS12_381
    localparam bit_width = 381 + 17;
`else
    localparam bit_width = 254 + 17;
`endif 

module TOP_test(
    Dout_0,
    default_sysclk1_300_clk_n,
    default_sysclk1_300_clk_p
    );

    output Dout_0;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk1_300 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_sysclk1_300, CAN_DEBUG false, FREQ_HZ 300000000" *) input default_sysclk1_300_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk1_300 CLK_P" *) input default_sysclk1_300_clk_p;

    wire [bit_width:0]Net;
    wire [bit_width:0]blk_mem_gen_0_doutb;
    wire [bit_width:0]blk_mem_gen_1_doutb;
    wire clk_wiz_0_clk_out1;
    wire [0:0]xlconstant_0_dout = '1;
    wire [7:0]xlconstant_1_dout = '0;
    wire [7:0]xlconstant_2_dout = '1;


    assign Dout_0 = blk_mem_gen_1_doutb[bit_width];

     QPMM_d0 qpmm_inst
         (.A(blk_mem_gen_0_doutb),
         .B(blk_mem_gen_1_doutb),
         .Z(Net),
         .clk(clk_wiz_0_clk_out1),
         .rstn(xlconstant_0_dout));

    // poly_adder_L3_L3 adder
    //     (.sub(blk_mem_gen_0_doutb[0]),
    //     .X(blk_mem_gen_0_doutb),
    //     .Y(blk_mem_gen_1_doutb),
    //     .Z(Net));

//    postadder postadder(
//    .clk(clk_wiz_0_clk_out1),
//    .rstn(blk_mem_gen_1_doutb[0]),
//    .in_L1(blk_mem_gen_0_doutb),
//    .mode1(blk_mem_gen_1_doutb[3:1]),
//    .mode2(blk_mem_gen_1_doutb[6:4]),
//    .mode3(blk_mem_gen_1_doutb[9:7]),
//    .outsel(blk_mem_gen_1_doutb[11:10]),
//    .addr2(blk_mem_gen_1_doutb[13:12]),
//    .addr3(blk_mem_gen_1_doutb[15:14]),
//    .out(Net)
//    );

    if (USE_BRAM_IP) begin
        `ifdef BLS12_381
            blk_mem_gen_436 RAM0
        `else
            blk_mem_gen_304 RAM0
        `endif 
            (.addra(xlconstant_1_dout),
            .addrb(xlconstant_1_dout),
            .clka(clk_wiz_0_clk_out1),
            .clkb(clk_wiz_0_clk_out1),
            .dina(Net),
            .doutb(blk_mem_gen_0_doutb),
            .wea(xlconstant_0_dout));

        `ifdef BLS12_381
            blk_mem_gen_436 RAM1
        `else
            blk_mem_gen_304 RAM1
        `endif 
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
    input [bit_width:0] dina,
    output reg[bit_width:0] doutb
    );

    //(*rw_addr_collision = "no" *) reg [bit_width:0] ram [140:0];
    reg [bit_width:0] ram [140:0];
    reg [bit_width:0] buf_ram1, buf_ram2;
    
    always @(posedge clk) begin
        buf_ram1 <= ram[addrb];
        buf_ram2 <= buf_ram1;
        doutb <= buf_ram2;
        if(wea)
            ram[addra] <= dina;
    end

endmodule
