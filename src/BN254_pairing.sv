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
//localparam LAT_QPMM = 58; // BN
localparam LAT_QPMM = 82; // BLS
localparam LAT_CMUL = 1;
localparam LAT_POSTADD = 2;
localparam LAT_WRITE = 1;
localparam PIPELINE_STAGES = LAT_READ + LAT_PREADD + LAT_UINT + LAT_QPMM + LAT_CMUL + LAT_POSTADD + LAT_WRITE;


module BN254_pairing(
    input clk, rstn, swrst, run, extin_en,
    input [3:0] n_func,
    input redundant_poly_L3 extin_data,
    input [BRAM_DEPTH:0] extin_addr, extout_addr,
    output endflag, opstart, busy,
    output redundant_poly_L3 extout_data
    );


    // Decralation
    wire result_flag;
    reg [23:0] cycle_cnt;
    micro_ops_t mops, ctrl_preadd, ctrl_cmul, ctrl_postadd, ctrl_postadd2, ctrl_write, ctrl_inv;
    micro_ops_t [PIPELINE_STAGES - 1:0] mops_buf;
    redundant_poly_L3 memin, memout0, memout1, preadd_out0, preadd_out1, postadd_out, inv_out;
    logic [LEN_1024M_TILDE-1:0] red_out0, red_out1;
    uint_Mtilde2_t qpmm_out;
    redundant_poly_L1 cmul_out;
 
    assign ctrl_preadd = mops_buf[LAT_READ];
    assign ctrl_cmul = mops_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM];
    assign ctrl_postadd = mops_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM+LAT_CMUL];
    assign ctrl_postadd2 = mops_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM+LAT_CMUL+1];
    assign ctrl_inv = mops_buf[LAT_READ];
    assign ctrl_write = mops_buf[PIPELINE_STAGES - LAT_WRITE];
    
    wire me0 = (~busy) ? extin_en : (inv_rdy)? inv_rdy : ctrl_write.csig.me0;
    wire me1 = (~busy) ? extin_en : (inv_rdy)? inv_rdy : ctrl_write.csig.me1;
    wire [BRAM_DEPTH-1:0] waddr0 = (~busy) ? extin_addr : (inv_rdy)? inv_waddr : ctrl_write.dst;
    //wire [8:0] waddr1 = (~busy) ? extin_addr : (inv_rdy)? inv_waddr : ctrl_write.dst;
    wire [BRAM_DEPTH-1:0] addrb1_sakamoto = ~busy ? extout_addr : mops.src1;

    assign memin = (~busy)? extin_data : (inv_rdy)? inv_out : postadd_out;
    assign extout_data = memout1;

    new_sequencer seq (.clk, .rstn, .run, .n_func, .busy, .mops, .inv_rdy);

    blk_mem_gen_436 RAM0 (.wea(me0),.addra(waddr0),.dina(memin),.clka(clk),.addrb(mops.src0),.doutb(memout0),.clkb(clk));
    blk_mem_gen_436 RAM1 (.wea(me1),.addra(waddr0),.dina(memin),.clka(clk),.addrb(addrb1_sakamoto),.doutb(memout1),.clkb(clk));

    preadder_Nthread preadder (
        .clk,
        .rstn,
        .X(memout0), 
        .Y(memout1),
        .mode(ctrl_preadd.csig.pm), 
        .Z0(preadd_out0), 
        .Z1(preadd_out1)
    );

    L3touint reduction1 (.clk, .rstn, .din(preadd_out0), .dout(red_out0));
    L3touint reduction2 (.clk, .rstn, .din(preadd_out1), .dout(red_out1));

    QPMM_d0 qpmm_inst(
        .A(red_out0),
        .B(red_out1),
        .Z(qpmm_out),
        .clk,
        .rstn
    );

    cmul #(.LATENCY(1)) cmul (.clk, .rstn, .mode(ctrl_cmul.csig.cm), .din(qpmm_out), .dout(cmul_out));

    postadder_Nthread postadder(
    .clk,
    .rstn,
    .in_L1(cmul_out),
    .mode1(ctrl_postadd.csig.pom1),
    .mode2(ctrl_postadd.csig.pom2),
    .mode3(ctrl_postadd.csig.pom3),
    .outsel(ctrl_postadd2.csig.pos),
    .dout(postadd_out)
    );

    wire inv_rdy;
    wire [BRAM_DEPTH-1:0] inv_waddr;
    Mont_inv_multi eeinv (.clk, .rstn, .I_START(ctrl_inv.csig.inve), .I_DATA_N(M_tilde12_t'(PARAMS_BN254_d0::Mod)), .I_WADDR(ctrl_inv.dst),
        .I_WDATA({memout0[3].val, memout0[2].val, memout0[1].val, memout0[0].val}), .O_RDATA(inv_out), .O_DRDY(inv_rdy), .O_WADDR(inv_waddr));


    always @(posedge clk)begin
        if(!rstn)begin
            mops_buf <= '0;
            if (!busy)
                cycle_cnt <= 0;
            
        end else begin
            if (busy)
                cycle_cnt <= cycle_cnt + 1'b1;
            mops_buf <= {mops_buf[PIPELINE_STAGES - 2:0], mops};
        end
    end
    
    
    
endmodule
