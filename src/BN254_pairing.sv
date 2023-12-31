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

import CURVE_PARAMS::*;
import CONTROL::*;
// Latencies
localparam LAT_READ = 2;
localparam LAT_PREADD = 1;
localparam LAT_UINT = 4;
localparam LAT_CMUL = 1;
localparam LAT_POSTADD = 3;
localparam LAT_WRITE = 2;
localparam PIPELINE_STAGES = LAT_READ + LAT_PREADD + LAT_UINT + LAT_QPMM + LAT_CMUL + LAT_POSTADD + LAT_WRITE;
// 13 + \lambda_{dsp}
// 1: 18, 2: 36, 3: 54, 4: 72, 5: 90, 6: 108, 7: 126, 8: 144

module BN254_pairing(
    input clk, rstn, run, extin_en,
    input [3:0] n_func,
    input redundant_poly_L3 extin_data,
    input [BRAM_DEPTH:0] extin_addr, extout_addr,
    output endflag, opstart, busy,
    output redundant_poly_L3 extout_data
    );


    // Decralation
    wire result_flag;
    micro_ops_t mops, ctrl_preadd, ctrl_cmul, ctrl_postadd, ctrl_postadd2, ctrl_write, ctrl_inv;
    micro_ops_t [PIPELINE_STAGES - 1:0] mops_buf;
    redundant_poly_L3 memin, memout0, memout1, preadd_out0, preadd_out1, postadd_out, inv_out;
    logic [LEN_1024M_TILDE-1:0] red_out0, red_out1;
    uint_Mtilde2_t qpmm_out;
    redundant_poly_L1 cmul_out;
 
    assign ctrl_preadd = mops_buf[LAT_READ];
    assign ctrl_cmul = mops_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM];
    assign ctrl_postadd = mops_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM+LAT_CMUL];
    assign ctrl_postadd2 = mops_buf[LAT_READ+LAT_PREADD+LAT_UINT+LAT_QPMM+LAT_CMUL+2];
    assign ctrl_inv = mops_buf[LAT_READ];
    assign ctrl_write = mops_buf[PIPELINE_STAGES - LAT_WRITE];
    
    logic me0, me1;
    logic [BRAM_DEPTH-1:0] waddr0;
    //wire [8:0] waddr1 = (~busy) ? extin_addr : (inv_rdy)? inv_waddr : ctrl_write.dst;
    wire [BRAM_DEPTH-1:0] addrb1_sakamoto = ~busy ? extout_addr : mops.src1;
    assign extout_data = memout1;
    if(LAT_WRITE == 1) begin
        assign me0 = (~busy) ? extin_en : (inv_rdy)? inv_rdy : ctrl_write.csig.me0;
        assign me1 = (~busy) ? extin_en : (inv_rdy)? inv_rdy : ctrl_write.csig.me1;
        assign waddr0 = (~busy) ? extin_addr : (inv_rdy)? inv_waddr : ctrl_write.dst;
        assign memin = (~busy)? extin_data : (inv_rdy)? inv_out : postadd_out;
    end
    else if (LAT_WRITE == 2) begin
        always @(posedge clk) begin
            me0 <= (~busy) ? extin_en : (inv_rdy)? inv_rdy : ctrl_write.csig.me0;
            me1 <= (~busy) ? extin_en : (inv_rdy)? inv_rdy : ctrl_write.csig.me1;
            waddr0 <= (~busy) ? extin_addr : (inv_rdy)? inv_waddr : ctrl_write.dst;
            memin <= (~busy)? extin_data : (inv_rdy)? inv_out : postadd_out;
        end
    end
    new_sequencer #(._N_THREADS(N_THREADS))seq (.clk, .rstn, .run, .n_func, .busy, .mops, .inv_rdy);

    `ifdef BLS12_381
        if (N_THREADS > 5) begin // up to 1024 entry
            blk_mem_gen_436_896 RAM0 (.wea(me0),.addra(waddr0),.dina(memin),.clka(clk),.addrb(mops.src0),.doutb(memout0),.clkb(clk));
            blk_mem_gen_436_896 RAM1 (.wea(me1),.addra(waddr0),.dina(memin),.clka(clk),.addrb(addrb1_sakamoto),.doutb(memout1),.clkb(clk));
        end 
        else begin
            blk_mem_gen_436_512 RAM0 (.wea(me0),.addra(waddr0),.dina(memin),.clka(clk),.addrb(mops.src0),.doutb(memout0),.clkb(clk));
            blk_mem_gen_436_512 RAM1 (.wea(me1),.addra(waddr0),.dina(memin),.clka(clk),.addrb(addrb1_sakamoto),.doutb(memout1),.clkb(clk));
        end
    `elsif BN254
        if (N_THREADS > 4) begin // up to 1024 entry
            blk_mem_gen_304_640 RAM0 (.wea(me0),.addra(waddr0),.dina(memin),.clka(clk),.addrb(mops.src0),.doutb(memout0),.clkb(clk));
            blk_mem_gen_304_640 RAM1 (.wea(me1),.addra(waddr0),.dina(memin),.clka(clk),.addrb(addrb1_sakamoto),.doutb(memout1),.clkb(clk));
        end 
        else begin
            blk_mem_gen_304_512 RAM0 (.wea(me0),.addra(waddr0),.dina(memin),.clka(clk),.addrb(mops.src0),.doutb(memout0),.clkb(clk));
            blk_mem_gen_304_512 RAM1 (.wea(me1),.addra(waddr0),.dina(memin),.clka(clk),.addrb(addrb1_sakamoto),.doutb(memout1),.clkb(clk));
        end
    `endif 
    
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

    cmul #(.LATENCY(LAT_CMUL)) cmul (.clk, .rstn, .mode(ctrl_cmul.csig.cm), .din(qpmm_out), .dout(cmul_out));

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
    Mont_inv_multi eeinv (.clk, .rstn, .I_START(ctrl_inv.csig.inve), .I_DATA_N(M_tilde12_t'(CURVE_PARAMS::Mod)), .I_WADDR(ctrl_inv.dst),
        .I_WDATA({memout0[3].val, memout0[2].val, memout0[1].val, memout0[0].val}), .O_RDATA(inv_out), .O_DRDY(inv_rdy), .O_WADDR(inv_waddr));


    always @(posedge clk)begin
        if(!rstn)begin
            mops_buf <= '0;
            
        end else begin
            mops_buf <= {mops_buf[PIPELINE_STAGES - 2:0], mops};
        end
    end
    
    
endmodule
