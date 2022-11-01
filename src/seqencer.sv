`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/21 10:53:29
// Design Name: 
// Module Name: sequencer
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

import CONTROL::*;

module sequencer(
    input clk, rstn, run, swrst, invresult,
    input [3:0] n_func,
    output reg opstart, endflag, busy,
    output ctrl_sig c_sig
    );


reg [15:0] cnt;  //?v???O?????J?E???^
reg [15:0] debug_ccnt;  
reg [15:0] ocnt;  //?v???O?????J?E???^
reg [8:0] opcnt;    //何回目の関数呼び出しか
reg [8:0] opcnt_start;
reg [8:0] opcnt_end;

wire [4:0] opnum;
wire [4:0] oopnum;
reg [8:0] oopcnt;
reg [1:0] cnt_4clk;
wire cnt_en = (cnt_4clk == 2'b11);

wire [7:0] addra0_wire;
wire [7:0] addra1_wire;
wire [7:0] addrb0_wire;
wire [7:0] addrb1_wire;


wire [17:0] compress_mul_addr_wire;
wire [7:0] compress_mul_addra;
wire [7:0] compress_mul_addrb;
wire [17:0] FP12square_wire;
wire [26:0] FP12_frob_addr_wire;
wire [26:0] FP12_mul_addr_wire;
wire [26:0] FP12_comul_addr_wire;

wire [58:0] rom_out;
assign c_sig.opcode = rom_out[58:32]; //2サイクル送れるか�?
//assign c_sig.opcode = (cnt_4clk == 2'b10) ? rom_out[58:32] : {rom_out[58:53], 11'b11111111111, rom_out[41:32]}; //2サイクル送れるか�?

assign c_sig.waddr0 = (oopnum == 9'd10)?addra0_wire + compress_mul_addra:(oopnum == 9'd11)?addra0_wire + FP12square_wire[8:0]:(oopnum == 9'd14)?addra0_wire + FP12_comul_addr_wire[8:0]:
                (oopnum == 9'd15)?addra0_wire + FP12_mul_addr_wire[8:0]:(oopnum == 9'd17)?addra0_wire + FP12_frob_addr_wire[8:0]:addra0_wire;
assign c_sig.waddr1 = (oopnum == 9'd10)?addra1_wire + compress_mul_addra:(oopnum == 9'd11)?addra1_wire + FP12square_wire[8:0]:(oopnum == 9'd14)?addra1_wire + FP12_comul_addr_wire[8:0]:
                (oopnum == 9'd15)?addra1_wire + FP12_mul_addr_wire[8:0]:(oopnum == 9'd17)?addra1_wire + FP12_frob_addr_wire[8:0]:addra1_wire;
assign c_sig.raddr0 = (oopnum == 9'd10)?addrb0_wire + compress_mul_addrb:(oopnum == 9'd11)?addrb0_wire + FP12square_wire[17:9]: (oopnum == 9'd14)?addrb0_wire + FP12_comul_addr_wire[26:18]:
                (oopnum == 9'd15)?addrb0_wire + FP12_mul_addr_wire[26:18]:(oopnum == 9'd17)?addrb0_wire + FP12_frob_addr_wire[26:18]:addrb0_wire;
assign c_sig.raddr1 = (oopnum == 9'd11)?addrb1_wire + FP12square_wire[17:9]: (oopnum == 9'd14)?addrb1_wire + FP12_comul_addr_wire[17:9]:
                (oopnum == 9'd15)?addrb1_wire + FP12_mul_addr_wire[17:9]:(oopnum == 9'd17)?((cnt == 16'd1)?addrb1_wire:addrb1_wire + FP12_frob_addr_wire[17:9]):addrb1_wire;
assign c_sig.thread = cnt_4clk + 1; //2サイクル送れるか�?

assign addra0_wire = rom_out[31:24];
assign addra1_wire = rom_out[23:16];
assign addrb0_wire = rom_out[16:8]; //////////////////////
assign addrb1_wire = rom_out[7:0];
assign compress_mul_addra = (ocnt > 16'd117)?compress_mul_addr_wire[8:0]:8'b0;
assign compress_mul_addrb = (ocnt < 16'd108)?compress_mul_addr_wire[17:9]:8'b0;



wire [11:0] rom_addr_offset = (opnum == 5'd0)? 0:(opnum == 5'd1)?16'd277:(opnum == 5'd2)? 16'd421:(opnum == 5'd3)? 16'd663:
                  (opnum == 5'd4)? 16'd989: (opnum == 5'd5)? 16'd1340: (opnum == 5'd6)? 16'd1368:
                  (opnum == 5'd7)? 16'd1396: (opnum == 5'd8)? 16'd1429: (opnum == 5'd9)? 16'd1457:
                  (opnum == 5'd10)? 16'd1467: (opnum == 5'd11)? 16'd1695: (opnum == 5'd12)? 16'd1752:
                  (opnum == 5'd13)? + 16'd1862: (opnum == 5'd14)? + 16'd1919: (opnum == 5'd15)? + 16'd2027:
                  (opnum == 5'd16)? 16'd2135: (opnum == 5'd17)? 16'd2145: 16'd2157;
wire [11:0] rom_addr = rom_addr_offset + cnt;
microcode_rom rom(clk, !endflag, rom_addr, rom_out);            

assign opnum = func_opnum(opcnt);
assign oopnum = func_opnum(oopcnt);

wire [8:0] debug = oopnum - opnum;

assign compress_mul_addr_wire = func_compress_mul_addr(oopcnt[7:6]);
assign FP12square_wire = func_FP12square(oopcnt[0]);

assign FP12_frob_addr_wire = func_FP12_frob_addr(oopcnt[1]);
assign FP12_mul_addr_wire = func_FP12_mul_addr(oopcnt[3:0]);
assign FP12_comul_addr_wire = func_FP12_comul_addr(oopcnt[1:0]);



//????J?E???^?iopcnt?j??????s??????iopnum?j???o??p???
function [4:0] func_opnum;
    input [8:0] opcnt;
    begin
    case(opcnt)
        9'd0   :func_opnum = 5'd0 ;
        9'd1   :func_opnum = 5'd1 ;
        9'd2   :func_opnum = 5'd1 ;
        9'd3   :func_opnum = 5'd1 ;
        9'd4   :func_opnum = 5'd1 ;
        9'd5   :func_opnum = 5'd2 ;
        9'd6   :func_opnum = 5'd2 ;
        9'd7   :func_opnum = 5'd1 ;
        9'd8   :func_opnum = 5'd1 ;
        9'd9   :func_opnum = 5'd1 ;
        9'd10  :func_opnum = 5'd1 ;
        9'd11  :func_opnum = 5'd1 ;
        9'd12  :func_opnum = 5'd1 ;
        9'd13  :func_opnum = 5'd1 ;
        9'd14  :func_opnum = 5'd1 ;
        9'd15  :func_opnum = 5'd1 ;
        9'd16  :func_opnum = 5'd1 ;
        9'd17  :func_opnum = 5'd1 ;
        9'd18  :func_opnum = 5'd1 ;
        9'd19  :func_opnum = 5'd1 ;
        9'd20  :func_opnum = 5'd1 ;
        9'd21  :func_opnum = 5'd1 ;
        9'd22  :func_opnum = 5'd1 ;
        9'd23  :func_opnum = 5'd1 ;
        9'd24  :func_opnum = 5'd1 ;
        9'd25  :func_opnum = 5'd1 ;
        9'd26  :func_opnum = 5'd1 ;
        9'd27  :func_opnum = 5'd1 ;
        9'd28  :func_opnum = 5'd1 ;
        9'd29  :func_opnum = 5'd1 ;
        9'd30  :func_opnum = 5'd1 ;
        9'd31  :func_opnum = 5'd1 ;
        9'd32  :func_opnum = 5'd1 ;
        9'd33  :func_opnum = 5'd1 ;
        9'd34  :func_opnum = 5'd1 ;
        9'd35  :func_opnum = 5'd1 ;
        9'd36  :func_opnum = 5'd1 ;
        9'd37  :func_opnum = 5'd1 ;
        9'd38  :func_opnum = 5'd1 ;
        9'd39  :func_opnum = 5'd1 ;
        9'd40  :func_opnum = 5'd1 ;
        9'd41  :func_opnum = 5'd1 ;
        9'd42  :func_opnum = 5'd1 ;
        9'd43  :func_opnum = 5'd1 ;
        9'd44  :func_opnum = 5'd1 ;
        9'd45  :func_opnum = 5'd1 ;
        9'd46  :func_opnum = 5'd1 ;
        9'd47  :func_opnum = 5'd1 ;
        9'd48  :func_opnum = 5'd1 ;
        9'd49  :func_opnum = 5'd1 ;
        9'd50  :func_opnum = 5'd1 ;
        9'd51  :func_opnum = 5'd1 ;
        9'd52  :func_opnum = 5'd1 ;
        9'd53  :func_opnum = 5'd1 ;
        9'd54  :func_opnum = 5'd1 ;
        9'd55  :func_opnum = 5'd1 ;
        9'd56  :func_opnum = 5'd1 ;
        9'd57  :func_opnum = 5'd1 ;
        9'd58  :func_opnum = 5'd1 ;
        9'd59  :func_opnum = 5'd1 ;
        9'd60  :func_opnum = 5'd2 ;
        9'd61  :func_opnum = 5'd1 ;
        9'd62  :func_opnum = 5'd3 ;
        9'd63  :func_opnum = 5'd4 ;
        9'd64  :func_opnum = 5'd5 ;
        9'd65  :func_opnum = 5'd6 ;
        9'd66  :func_opnum = 5'd5 ;
        9'd67  :func_opnum = 5'd6 ;
        9'd68  :func_opnum = 5'd5 ;
        9'd69  :func_opnum = 5'd6 ;
        9'd70  :func_opnum = 5'd5 ;
        9'd71  :func_opnum = 5'd6 ;
        9'd72  :func_opnum = 5'd5 ;
        9'd73  :func_opnum = 5'd6 ;
        9'd74  :func_opnum = 5'd5 ;
        9'd75  :func_opnum = 5'd6 ;
        9'd76  :func_opnum = 5'd5 ;
        9'd77  :func_opnum = 5'd6 ;
        9'd78  :func_opnum = 5'd5 ;
        9'd79  :func_opnum = 5'd6 ;
        9'd80  :func_opnum = 5'd5 ;
        9'd81  :func_opnum = 5'd6 ;
        9'd82  :func_opnum = 5'd5 ;
        9'd83  :func_opnum = 5'd6 ;
        9'd84  :func_opnum = 5'd5 ;
        9'd85  :func_opnum = 5'd6 ;
        9'd86  :func_opnum = 5'd5 ;
        9'd87  :func_opnum = 5'd6 ;
        9'd88  :func_opnum = 5'd5 ;
        9'd89  :func_opnum = 5'd6 ;
        9'd90  :func_opnum = 5'd5 ;
        9'd91  :func_opnum = 5'd6 ;
        9'd92  :func_opnum = 5'd5 ;
        9'd93  :func_opnum = 5'd6 ;
        9'd94  :func_opnum = 5'd5 ;
        9'd95  :func_opnum = 5'd6 ;
        9'd96  :func_opnum = 5'd5 ;
        9'd97  :func_opnum = 5'd6 ;
        9'd98  :func_opnum = 5'd5 ;
        9'd99  :func_opnum = 5'd6 ;
        9'd100 :func_opnum = 5'd5 ;
        9'd101 :func_opnum = 5'd6 ;
        9'd102 :func_opnum = 5'd5 ;
        9'd103 :func_opnum = 5'd6 ;
        9'd104 :func_opnum = 5'd5 ;
        9'd105 :func_opnum = 5'd6 ;
        9'd106 :func_opnum = 5'd5 ;
        9'd107 :func_opnum = 5'd6 ;
        9'd108 :func_opnum = 5'd5 ;
        9'd109 :func_opnum = 5'd6 ;
        9'd110 :func_opnum = 5'd5 ;
        9'd111 :func_opnum = 5'd6 ;
        9'd112 :func_opnum = 5'd5 ;
        9'd113 :func_opnum = 5'd6 ;
        9'd114 :func_opnum = 5'd5 ;
        9'd115 :func_opnum = 5'd6 ;
        9'd116 :func_opnum = 5'd5 ;
        9'd117 :func_opnum = 5'd6 ;
        9'd118 :func_opnum = 5'd7 ;
        9'd119 :func_opnum = 5'd8 ;
        9'd120 :func_opnum = 5'd9 ;
        9'd121 :func_opnum = 5'd5 ;
        9'd122 :func_opnum = 5'd6 ;
        9'd123 :func_opnum = 5'd5 ;
        9'd124 :func_opnum = 5'd6 ;
        9'd125 :func_opnum = 5'd5 ;
        9'd126 :func_opnum = 5'd8 ;
        9'd127 :func_opnum = 5'd10;
        9'd128 :func_opnum = 5'd11;
        9'd129 :func_opnum = 5'd11;
        9'd130 :func_opnum = 5'd12;
        9'd131 :func_opnum = 5'd5 ;
        9'd132 :func_opnum = 5'd6 ;
        9'd133 :func_opnum = 5'd5 ;
        9'd134 :func_opnum = 5'd6 ;
        9'd135 :func_opnum = 5'd5 ;
        9'd136 :func_opnum = 5'd6 ;
        9'd137 :func_opnum = 5'd5 ;
        9'd138 :func_opnum = 5'd6 ;
        9'd139 :func_opnum = 5'd5 ;
        9'd140 :func_opnum = 5'd6 ;
        9'd141 :func_opnum = 5'd5 ;
        9'd142 :func_opnum = 5'd6 ;
        9'd143 :func_opnum = 5'd5 ;
        9'd144 :func_opnum = 5'd6 ;
        9'd145 :func_opnum = 5'd5 ;
        9'd146 :func_opnum = 5'd6 ;
        9'd147 :func_opnum = 5'd5 ;
        9'd148 :func_opnum = 5'd6 ;
        9'd149 :func_opnum = 5'd5 ;
        9'd150 :func_opnum = 5'd6 ;
        9'd151 :func_opnum = 5'd5 ;
        9'd152 :func_opnum = 5'd6 ;
        9'd153 :func_opnum = 5'd5 ;
        9'd154 :func_opnum = 5'd6 ;
        9'd155 :func_opnum = 5'd5 ;
        9'd156 :func_opnum = 5'd6 ;
        9'd157 :func_opnum = 5'd5 ;
        9'd158 :func_opnum = 5'd6 ;
        9'd159 :func_opnum = 5'd5 ;
        9'd160 :func_opnum = 5'd6 ;
        9'd161 :func_opnum = 5'd5 ;
        9'd162 :func_opnum = 5'd6 ;
        9'd163 :func_opnum = 5'd5 ;
        9'd164 :func_opnum = 5'd6 ;
        9'd165 :func_opnum = 5'd5 ;
        9'd166 :func_opnum = 5'd6 ;
        9'd167 :func_opnum = 5'd5 ;
        9'd168 :func_opnum = 5'd6 ;
        9'd169 :func_opnum = 5'd5 ;
        9'd170 :func_opnum = 5'd6 ;
        9'd171 :func_opnum = 5'd5 ;
        9'd172 :func_opnum = 5'd6 ;
        9'd173 :func_opnum = 5'd5 ;
        9'd174 :func_opnum = 5'd6 ;
        9'd175 :func_opnum = 5'd5 ;
        9'd176 :func_opnum = 5'd6 ;
        9'd177 :func_opnum = 5'd5 ;
        9'd178 :func_opnum = 5'd6 ;
        9'd179 :func_opnum = 5'd5 ;
        9'd180 :func_opnum = 5'd6 ;
        9'd181 :func_opnum = 5'd5 ;
        9'd182 :func_opnum = 5'd6 ;
        9'd183 :func_opnum = 5'd5 ;
        9'd184 :func_opnum = 5'd6 ;
        9'd185 :func_opnum = 5'd7 ;
        9'd186 :func_opnum = 5'd8 ;
        9'd187 :func_opnum = 5'd9 ;
        9'd188 :func_opnum = 5'd5 ;
        9'd189 :func_opnum = 5'd6 ;
        9'd190 :func_opnum = 5'd5 ;
        9'd191 :func_opnum = 5'd6 ;
        9'd192 :func_opnum = 5'd5 ;
        9'd193 :func_opnum = 5'd8 ;
        9'd194 :func_opnum = 5'd10;
        9'd195 :func_opnum = 5'd13;
        9'd196 :func_opnum = 5'd5 ;
        9'd197 :func_opnum = 5'd6 ;
        9'd198 :func_opnum = 5'd5 ;
        9'd199 :func_opnum = 5'd6 ;
        9'd200 :func_opnum = 5'd5 ;
        9'd201 :func_opnum = 5'd6 ;
        9'd202 :func_opnum = 5'd5 ;
        9'd203 :func_opnum = 5'd6 ;
        9'd204 :func_opnum = 5'd5 ;
        9'd205 :func_opnum = 5'd6 ;
        9'd206 :func_opnum = 5'd5 ;
        9'd207 :func_opnum = 5'd6 ;
        9'd208 :func_opnum = 5'd5 ;
        9'd209 :func_opnum = 5'd6 ;
        9'd210 :func_opnum = 5'd5 ;
        9'd211 :func_opnum = 5'd6 ;
        9'd212 :func_opnum = 5'd5 ;
        9'd213 :func_opnum = 5'd6 ;
        9'd214 :func_opnum = 5'd5 ;
        9'd215 :func_opnum = 5'd6 ;
        9'd216 :func_opnum = 5'd5 ;
        9'd217 :func_opnum = 5'd6 ;
        9'd218 :func_opnum = 5'd5 ;
        9'd219 :func_opnum = 5'd6 ;
        9'd220 :func_opnum = 5'd5 ;
        9'd221 :func_opnum = 5'd6 ;
        9'd222 :func_opnum = 5'd5 ;
        9'd223 :func_opnum = 5'd6 ;
        9'd224 :func_opnum = 5'd5 ;
        9'd225 :func_opnum = 5'd6 ;
        9'd226 :func_opnum = 5'd5 ;
        9'd227 :func_opnum = 5'd6 ;
        9'd228 :func_opnum = 5'd5 ;
        9'd229 :func_opnum = 5'd6 ;
        9'd230 :func_opnum = 5'd5 ;
        9'd231 :func_opnum = 5'd6 ;
        9'd232 :func_opnum = 5'd5 ;
        9'd233 :func_opnum = 5'd6 ;
        9'd234 :func_opnum = 5'd5 ;
        9'd235 :func_opnum = 5'd6 ;
        9'd236 :func_opnum = 5'd5 ;
        9'd237 :func_opnum = 5'd6 ;
        9'd238 :func_opnum = 5'd5 ;
        9'd239 :func_opnum = 5'd6 ;
        9'd240 :func_opnum = 5'd5 ;
        9'd241 :func_opnum = 5'd6 ;
        9'd242 :func_opnum = 5'd5 ;
        9'd243 :func_opnum = 5'd6 ;
        9'd244 :func_opnum = 5'd5 ;
        9'd245 :func_opnum = 5'd6 ;
        9'd246 :func_opnum = 5'd5 ;
        9'd247 :func_opnum = 5'd6 ;
        9'd248 :func_opnum = 5'd5 ;
        9'd249 :func_opnum = 5'd6 ;
        9'd250 :func_opnum = 5'd7 ;
        9'd251 :func_opnum = 5'd8 ;
        9'd252 :func_opnum = 5'd9 ;
        9'd253 :func_opnum = 5'd5 ;
        9'd254 :func_opnum = 5'd6 ;
        9'd255 :func_opnum = 5'd5 ;
        9'd256 :func_opnum = 5'd6 ;
        9'd257 :func_opnum = 5'd5 ;
        9'd258 :func_opnum = 5'd8 ;
        9'd259 :func_opnum = 5'd10;
        9'd260 :func_opnum = 5'd14;
        9'd261 :func_opnum = 5'd15;
        9'd262 :func_opnum = 5'd14;
        9'd263 :func_opnum = 5'd18;
        9'd264 :func_opnum = 5'd15;
        9'd265 :func_opnum = 5'd15;
        9'd266 :func_opnum = 5'd16;
        9'd267 :func_opnum = 5'd14;
        9'd268 :func_opnum = 5'd17;
        9'd269 :func_opnum = 5'd15;
        9'd270 :func_opnum = 5'd17;
        9'd271 :func_opnum = 5'd15;
        9'd272 :func_opnum = 5'd18;
        9'd273 :func_opnum = 5'd15;

        9'd274 :func_opnum = 5'd18;
        9'd275 :func_opnum = 5'd18;
        9'd276 :func_opnum = 5'd18;
        9'd277 :func_opnum = 5'd18;
        9'd278 :func_opnum = 5'd18;
        9'd279 :func_opnum = 5'd18;
        9'd280 :func_opnum = 5'd18;
        9'd281 :func_opnum = 5'd18;
        
        9'd282 :func_opnum = 5'd19;
        9'd283 :func_opnum = 5'd20;
        default func_opnum = 5'd31;
    endcase
    end
endfunction

function [17:0] func_compress_mul_addr;
    input[1:0] opnum;
    begin
        case(opnum)
            2'b01: func_compress_mul_addr = 18'b000010000001010000;
            2'b11: func_compress_mul_addr = 18'b000110000001010000;
            2'b00: func_compress_mul_addr = 18'b001000000001000000;
        endcase
    end
endfunction


function [17:0] func_FP12square;
    input opnum;
    begin
        case(opnum)
            1'b0: func_FP12square = 18'b001010000000100000;
            1'b1: func_FP12square = 18'b000100000001010000;
        endcase
    end
endfunction

function [26:0] func_FP12_comul_addr;
    input[1:0] opnum;
    begin
        case(opnum)
            2'b00: func_FP12_comul_addr = 27'b001010000000110000001100000;
            2'b10: func_FP12_comul_addr = 27'b001100000001000000001010000;
            2'b11: func_FP12_comul_addr = 27'b001000000000010000000110000;
            2'b01: func_FP12_comul_addr = 27'b0;
        endcase
    end
endfunction

function [26:0] func_FP12_mul_addr;
    input[3:0] opnum;
    begin
        case(opnum)
            4'b0101: func_FP12_mul_addr = 27'b000010000001010000000110000;
            4'b1000: func_FP12_mul_addr = 27'b000100000001010000001000000;
            4'b1001: func_FP12_mul_addr = 27'b000110000001010000000100000;
            4'b1101: func_FP12_mul_addr = 27'b000100000001010000000010000;
            4'b1111: func_FP12_mul_addr = 27'b001000000000010000000100000;
            4'b0001: func_FP12_mul_addr = 27'b000110000000100000000010000;
            default: func_FP12_mul_addr = 27'b0;
        endcase
    end
endfunction


function [26:0] func_FP12_frob_addr;
    input opnum;
    begin
        case(opnum)
            1'b0: func_FP12_frob_addr = 27'b001000000010000000001000000;
            1'b1: func_FP12_frob_addr = 27'b000110000001111000000110000;
        endcase
    end
endfunction

reg [1:0] init_cnt;

always@ (posedge clk )begin
    if(!rstn)begin
        cnt <= 2159;
        debug_ccnt <= '0;
        cnt_4clk <= '0;
        opcnt <= 0;
        oopcnt <= 0;
        init_cnt <= 0;
        opstart <= 0;
        endflag <= 0;
        busy <= 0;
    end else if(swrst) begin

    end else if(run) begin : INIT_BRAM //init BRAM??
        cnt <= 0;
        debug_ccnt <= '0;
        cnt_4clk <= '0;
        opcnt <= 0;
        oopcnt <= 0;
        init_cnt <= 0;
        opstart <= 0;
        endflag <= 0;
        
        init_cnt <= 1;
        busy <= 1;
        
        //どの?��?囲の関数を実行するか endは+1する
        case(n_func)
            4'd0: begin //pairing
                opcnt_start <= 0;
                opcnt_end <= 9'd283;
            end
            4'd1: begin //ML
                opcnt_start <= 0;
                opcnt_end <= 9'd10;
            end
            4'd2: begin //FE
                opcnt_start <= 9'd63;
                opcnt_end <= 9'd283;
            end
            default: begin
                opcnt_start <= 0;
                opcnt_end <= 9'h3f;
            end
        endcase
        
    end
//     else if(|init_cnt) begin
//         //外部?��?ータ書き込み??��?
//         //fの初期化�?
//         init_cnt <= init_cnt + 1;
//         case (init_cnt)
//             16'd3  :begin
//                 opstart <= 1;
//             end
//         endcase
//    end 
    else if(busy) begin
            debug_ccnt <= debug_ccnt + 1;
            oopcnt <= opcnt;
            ocnt <= cnt;
            //        opstartset <= 1;
    
            //opnumによって何�??��関数を実行するか?��??��?
            //cnt = 関数?��?の命令数
            //関数が最後まで行ったらopcnt +=1してcntリセ?��??��?
            
            if(opcnt == opcnt_end) begin
                endflag <= 1;
                busy <= 0;
            end
            else begin
                cnt_4clk <= cnt_4clk + 1'b1;
                if (cnt_en) begin
                    cnt <= cnt + 1;
                    case(opnum)
                        6'd0 :begin
                            if(cnt == 16'd276)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd1 :begin
                            if(cnt == 16'd143)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd2 :begin
                            if(cnt == 16'd241)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd3 :begin
                            if(cnt == 16'd325)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd4 :begin
                            // if(invresult)begin
                            //     cnt <= cnt + 1;
                            // end
                            // if(16'd152 <= cnt && cnt <= 16'd178 )begin
                            //     cnt <= cnt + 1;
                            // end
                            if(cnt == 16'd350)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd5 :begin
                            if(cnt == 16'd27)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd6 :begin
                            if(cnt == 16'd27)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd7 :begin
                            if(cnt == 16'd32)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd8 :begin
                            if(cnt == 16'd27)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd9 :begin
                            if(cnt == 16'd9)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd10 :begin
                            if(cnt == 16'd227)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd11 :begin
                            if(cnt == 16'd56)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd12 :begin
                            if(cnt == 16'd109)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd13 :begin
                            if(cnt == 16'd56)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd14 :begin
                            if(cnt == 16'd107)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd15 :begin
                            if(cnt == 16'd107)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd16 :begin
                            if(cnt == 16'd9)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd17 :begin
                            if(cnt == 16'd11)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd18 :begin
                            if(cnt == 16'd1)begin
                                opcnt <= opcnt + 1;
                                cnt <= 0;
                            end
                        end
                        6'd19 :begin
                            opcnt <= opcnt + 1;
                        end
                    endcase
                end
            end
        end
    end

endmodule