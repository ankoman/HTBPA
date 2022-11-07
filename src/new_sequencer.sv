`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/11/03 23:30:13
// Design Name: 
// Module Name: new_sequencer
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
localparam FIRST_PC_ADDR = 10'h000;
localparam ROM_DEPTH = 10;
localparam LEN_MOP_CNT = 7;

localparam BIT_INSTRUCTION_TYPE = 33;
localparam ctrl_sig_offset_t NOP = 'b0_xx_xxx_xxx_xxx_xx_0_xxx;
localparam noaddr = 9'hx;
localparam operation_t op_JMP  = 'bxxx0000;
localparam operation_t op_CALL = 'bxxx0001;
localparam operation_t op_RET  = 'bxxx0010;
localparam operation_t op_WAIT = 'bxxx0011;

localparam operation_t op_Fp2_mul = 'b0100010;
localparam operation_t op_Fp2_sqr = 'b0100011;

module new_sequencer(
    input clk, rstn, run,
    input [3:0] n_func,
    output busy,
    output micro_ops_t mops
    );

    logic [ROM_DEPTH-1:0] pc, pc_d; // program counter
    logic [ROM_DEPTH-1:0] ret_addr; // return address
    logic change_pc, change_pc_d, change_pc_dd;
    assign change_pc = (pc != pc_d);
    logic [LEN_MOP_CNT-1:0] mop_cnt, end_mop_cnt; // micro operation counter
    logic [LEN_MOP_CNT+1:0] cnt_to_fetch; // cycles to fetch
    logic [1:0] thread_cnt, thread_cnt_d; // thread counter
    logic [3:0] cnt_4clk;
    instruction_t rom_out, rom_out_d; // Latency 3;
    ctrl_sig_offset_t csig_Fp2_mul, csig_Fp2_sqr;
    wire ctrl_instruction = rom_out[BIT_INSTRUCTION_TYPE];
    logic ctrl_instruction_d;
    wire fetch_next = (cnt_to_fetch == {end_mop_cnt, 2'b00});
    wire is_4clks = cnt_4clk[3];
    wire inc_thread = (mop_cnt == end_mop_cnt) & busy;
    wire reset_mop_cnt = change_pc_dd | inc_thread;

    assign busy = (pc != FIRST_PC_ADDR) ^ run;
    new_microcode_rom rom(clk, pc, rom_out);            

    always_ff @(posedge clk) begin : misc
        ctrl_instruction_d <= ctrl_instruction;
        rom_out_d <= rom_out;
        pc_d <= pc;
        change_pc_d <= change_pc;
        change_pc_dd <= change_pc_d;
        thread_cnt_d <= thread_cnt;
        if (is_4clks)
            if (ctrl_instruction)
                if(rom_out.opcode.op === op_CALL)
                    ret_addr <= pc + 1;
    end


    //////////////////////////////////////
    //// Counters
    //////////////////////////////////////
    always_ff @(posedge clk) begin
        if(!rstn)
            cnt_4clk <= '0;
        else if(run)  
            cnt_4clk <= 4'd1; //cnt start
        else 
            cnt_4clk <= {cnt_4clk[2:0], cnt_4clk[3]}; // left rotate
    end

    always_ff @(posedge clk) begin
        if(!rstn) 
            mop_cnt <= '0;
        else if(reset_mop_cnt)
            mop_cnt <= '0;
        else
            mop_cnt <= mop_cnt + 1'b1;
    end

    always_ff @(posedge clk) begin
        if(!rstn) 
            thread_cnt <= '0;
        else if(inc_thread)
            thread_cnt <= thread_cnt;
    end

    always_ff @(posedge clk) begin
        if(!rstn) 
            cnt_to_fetch <= '0;
        else if(change_pc_dd)
            cnt_to_fetch <= '0;
        else 
            cnt_to_fetch <= cnt_to_fetch + 1'b1;
    end


    //////////////////////////////////////
    //// Counters
    //////////////////////////////////////
    always_ff @(posedge clk) begin : rom_addressing
        if(!rstn) 
            pc <= FIRST_PC_ADDR;
        else begin
            if(run)  
                pc <= 1;
            else if(is_4clks) begin
                if(ctrl_instruction) begin
                    case(rom_out.opcode.op)
                        op_JMP  : pc <= {rom_out.src0, rom_out.src1};
                        op_CALL : pc <= {rom_out.src0, rom_out.src1};
                        op_RET  : pc <= ret_addr;
                        default : pc <= 'x;
                    endcase
                end
                else if(fetch_next)
                    pc <= pc + 1;
            end
        end
    end

    //変化する部分だけをswitchした方がいい気がする
    always @(posedge clk) begin : inst_decoder
        if(!rstn) 
            mops <= '0;
        else begin
            //csig
            case(rom_out_d.opcode.op)
                op_Fp2_mul: mops <= {func_demode_csig(csig_Fp2_mul, rom_out_d.opcode.sub_op.cm), 
                                    {thread_cnt_d, rom_out_d.dst + csig_Fp2_mul.offset_dst},
                                    {thread_cnt_d, rom_out_d.src0 + csig_Fp2_mul.offset_src0},
                                    {thread_cnt_d, rom_out_d.src1 + csig_Fp2_mul.offset_src1}};
                op_Fp2_sqr: mops <= {func_demode_csig(csig_Fp2_sqr, rom_out_d.opcode.sub_op.cm),
                                    {thread_cnt_d, rom_out_d.dst + csig_Fp2_sqr.offset_dst},
                                    {thread_cnt_d, rom_out_d.src0 + csig_Fp2_sqr.offset_src0},
                                    {thread_cnt_d, rom_out_d.src1 + csig_Fp2_sqr.offset_src1}};
                default: mops <= {NOP, noaddr, noaddr, noaddr};
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if(!rstn)
            end_mop_cnt <= '1;
        else begin
            case(rom_out.opcode.op) // the number of mops - 1
                op_Fp2_mul: end_mop_cnt <= 'd2;
                op_Fp2_sqr: end_mop_cnt <= 'd1;
                default: end_mop_cnt <= '1;
            endcase
        end
    end


    //////////////////////////////////////
    //// Micro code sequencer
    //////////////////////////////////////
    always_ff @(posedge clk) begin : seq_Fp2_mul
        if(!rstn)
            csig_Fp2_mul <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_Fp2_mul <= 'b0_xx_xxx_001_001_00_0_000;
                6'd1: csig_Fp2_mul <= 'b0_00_xxx_010_100_00_1_111;
                6'd2: csig_Fp2_mul <= 'b0_01_xxx_011_xxx_01_1_0xx;
                default: csig_Fp2_mul <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_Fp2_sqr
        if(!rstn)
            csig_Fp2_sqr <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_Fp2_sqr <= 'b0_00_xxx_xxx_001_00_1_100;
                6'd1: csig_Fp2_sqr <= 'b0_00_xxx_xxx_001_10_1_0xx;
                default: csig_Fp2_sqr <= NOP;
            endcase
        end
    end
    

    //////////////////////////////////////
    //// Functions
    //////////////////////////////////////
    function ctrl_sig_t func_demode_csig;
        input ctrl_sig_offset_t csigin;
        input [2:0] cmul;
        func_demode_csig.inve = csigin.inve;
        func_demode_csig.pos = csigin.pos;
        func_demode_csig.pom3 = csigin.pom3;
        func_demode_csig.pom2 = csigin.pom2;
        func_demode_csig.pom1 = csigin.pom1;
        func_demode_csig.cm = cmul;
        func_demode_csig.pm = csigin.pm;
        func_demode_csig.me = csigin.me;
    endfunction
endmodule

module rising_edge(
    input clk, rstn, din,
    output rising_edge
    );  

    logic[2:0] rising;
    assign rising_edge = (rising[1:0] == 2'b01) ;
    always@(posedge clk) begin
        if(!rstn)
            rising <= 3'b000;
        else
            rising <= {rising[1:0], din};
    end
endmodule

module falling_edge(
    input clk, rstn, din,
    output falling_edge
    );  

    logic[2:0] falling;
    assign falling_edge = (falling[1:0] == 2'b10) ;
    always@(posedge clk) begin
        if(!rstn)
            falling <= 3'b111;
        else
            falling <= {falling[1:0], din};
    end
endmodule

module function_decode(
    input [3:0] n_func,
    output logic[ROM_DEPTH-1:0] addr_start, addr_end
    );

    always_comb begin
        case(n_func)
            4'd0: begin //pairing
                addr_start = 0;
                addr_end = 9'd283;
            end
            4'd1: begin //ML
                addr_start = 0;
                addr_end = 9'd10;
            end
            4'd2: begin //FE
                addr_start = 9'd63;
                addr_end = 9'd283;
            end
            default: begin
                addr_start = 0;
                addr_end = 9'h3f;
            end
        endcase
    end
endmodule