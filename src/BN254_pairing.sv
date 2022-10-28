`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/21 17:32:01
// Design Name: 
// Module Name: BN254_pairing
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
import CONTROL::*;
// Latencies
localparam LAT_READ = 2;
localparam LAT_PREADD = 1;
localparam LAT_UINT = 4;
localparam LAT_QPMM = 58;
localparam LAT_CMUL = 1;
localparam LAT_POSTADD = 2;
localparam LAT_WRITE = 1;
localparam PIPELINE_STAGES = LAT_READ + LAT_PREADD + LAT_UINT + LAT_QPMM + LAT_CMUL + LAT_POSTADD + LAT_WRITE;


module BN254_pairing(
    input clk, rstn, swrst, run, extin_en,
    input [3:0] n_func,
    input redundant_poly_L3 extin_data,
    input [8:0] extin_addr, extout_addr,
    output endflag, opstart, busy,
    output redundant_poly_L3 extout_data
    );


    // Decralation
    wire result_flag;
    reg [23:0] cycle_cnt;
    wire [2:0] invcnt = 3'b0;
    ctrl_sig c_sig;
    ctrl_sig [PIPELINE_STAGES - 1:0] c_sig_buf;
    redundant_poly_L3 memin, memout0, memout1, preadd_out0, preadd_out1, postadd_out;
    logic [LEN_1024M_TILDE-1:0] red_out0, red_out1;
    uint_Mtilde2_t qpmm_out;
    redundant_poly_L1 cmul_out;

    ctrl_sig ctrl_preadd, ctrl_cmul, ctrl_postadd, ctrl_postadd2, ctrl_write;
    assign ctrl_preadd = c_sig_buf[LAT_READ];
    assign ctrl_cmul = c_sig_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM];
    assign ctrl_postadd = c_sig_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM+LAT_CMUL];
    assign ctrl_postadd2 = c_sig_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM+LAT_CMUL+1];
    assign ctrl_write = c_sig_buf[PIPELINE_STAGES - LAT_WRITE];
    
    wire me0 = (~busy) ? extin_en : (ctrl_write.opcode[1] & (ctrl_write.thread == 2'b00));
    wire me1 = (~busy) ? extin_en : (ctrl_write.opcode[2] & (ctrl_write.thread == 2'b00));
    wire [8:0] waddr0 = ~busy ? extin_addr : ctrl_write.waddr0;
    wire [8:0] waddr1 = ~busy ? extin_addr : ctrl_write.waddr1;
    wire [8:0] addrb1_sakamoto = ~busy ? extout_addr : c_sig.raddr1;

    //assign dataout1 = (ctrl[26])?{65'b0,eeinvd}:postaddrd;
    assign memin = ~busy ? extin_data : postadd_out;
    assign extout_data = postadd_out;

    sequencer seq (.clk,.rstn,.c_sig(c_sig), .invresult(result_flag),.endflag(endflag),
                .run(run), .busy(busy), .n_func(n_func), .opstart(opstart), .swrst(swrst));

    blk_mem_gen_304 RAM0 (.wea(me0),.addra(waddr0),.dina(memin),.clka(clk),.addrb(c_sig.raddr0),.doutb(memout0),.clkb(clk));
    blk_mem_gen_304 RAM1 (.wea(me1),.addra(waddr1),.dina(memin),.clka(clk),.addrb(addrb1_sakamoto),.doutb(memout1),.clkb(clk));

    preadder preadder (
        .clk,
        .rstn,
        .X(memout0), 
        .Y(memout1),
        .thread(ctrl_preadd.thread),
        .mode1(ctrl_preadd.opcode[4:3]), 
        .mode2(ctrl_preadd.opcode[6:5]),
        .Z0(preadd_out0), 
        .Z1(preadd_out1)
    );

    L3touint reduction1 (.clk, .din(preadd_out0), .dout(red_out0));
    L3touint reduction2 (.clk, .din(preadd_out1), .dout(red_out1));

    QPMM_d0 qpmm_inst(
        .A(red_out0),
        .B(red_out1),
        .Z(qpmm_out),
        .clk,
        .rstn
    );

    cmul #(.LATENCY(1)) cmul (.clk, .mode(ctrl_cmul.opcode[9:7]), .din(qpmm_out), .dout(cmul_out));

    postadder postadder(
    .clk,
    .rstn,
    .in_L1(cmul_out),
    .thread(ctrl_postadd.thread),
    .mode1(ctrl_postadd.opcode[12:10]),
    .mode2(ctrl_postadd.opcode[15:13]),
    .mode3(ctrl_postadd.opcode[18:16]),
    .outsel(ctrl_postadd2.opcode[20:19]),
    .addr2(ctrl_postadd.opcode[22:21]),
    .addr3(ctrl_postadd.opcode[24:23]),
    .dout(postadd_out)
    );


    // wire [prime_width-1:0] eeinvd;
    // extendedEuclidean5 eeinv(.a({3'b0, data0[317:0]}),.p(prime),.a_inv(eeinvd),.result_flag(result_flag),.startflag(ctrl[25]),.clk(clk),.rst(!resetn),.invcnt(invcnt));

    wire ctrl_rst = ~rstn | c_sig.opcode[0] | c_sig.opcode[26];
    always @(posedge clk)begin
        if(ctrl_rst)begin
            c_sig_buf <= '0;
            if (!busy)
                cycle_cnt <= 0;
            
        end else begin
            if (busy)
                cycle_cnt <= cycle_cnt + 1'b1;
            c_sig_buf <= {c_sig_buf[PIPELINE_STAGES - 2:0], c_sig};
        end
    end
    
    
    
endmodule
