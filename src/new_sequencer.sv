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
localparam LEN_FUNC_CNT = 7;
localparam LEN_MOP_CNT = 7;

localparam BIT_INSTRUCTION_TYPE = 33;
localparam NOP = 27'hz;
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
    logic change_pc, change_pc_d, change_pc_dd;
    assign change_pc = (pc != pc_d);
    logic [LEN_MOP_CNT-1:0] mop_cnt, end_mop_cnt; // micro operation counter
    logic [LEN_MOP_CNT+1:0] cnt_to_fetch; // cycles to fetch
    logic [1:0] thread_cnt; // thread counter
    logic [ROM_DEPTH-1:0] ret_addr; // return address
    logic [3:0] cnt_4clk;
    instruction_t rom_out, rom_out_d; // Latency 3;
    ctrl_sig_t csig_Fp2_mul, csig_Fp2_sqr;
    wire ctrl_instruction = rom_out[BIT_INSTRUCTION_TYPE];
    logic ctrl_instruction_d;
    wire fetch_next = (cnt_to_fetch == {end_mop_cnt, 2'b00});
    wire is_4clks = cnt_4clk[3];
    wire inc_thread = (mop_cnt == end_mop_cnt);
    wire reset_mop_cnt = change_pc_dd | inc_thread;

    assign busy = (pc != FIRST_PC_ADDR);
    new_microcode_rom rom(clk, pc, rom_out);            

    always_ff @(posedge clk) begin : misc
        ctrl_instruction_d <= ctrl_instruction;
        rom_out_d <= rom_out;
        pc_d <= pc;
        change_pc_d <= change_pc;
        change_pc_dd <= change_pc_d;
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
            thread_cnt <= thread_cnt + 1'b1;
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
    always_ff @(posedge clk) begin
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

    always @(posedge clk) begin : inst_decoder
        if(!rstn) 
            mops.csig <= '0;
        else begin
            case(rom_out_d.opcode.op)
                op_Fp2_mul: mops.csig <= csig_Fp2_mul;
                op_Fp2_sqr: mops.csig <= csig_Fp2_sqr;
                default: mops.csig <= NOP;
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
                6'd0: csig_Fp2_mul <= 'b00000000000001001110000000;
                6'd1: csig_Fp2_mul <= 'b00000000000100010011011011;
                6'd2: csig_Fp2_mul <= 'b00000001001000001010000011;
                default: csig_Fp2_mul <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_Fp2_sqr
        if(!rstn)
            csig_Fp2_sqr <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_Fp2_sqr <= 'b00100000001000001010000011;
                6'd1: csig_Fp2_sqr <= 'b00010000001000001001011011;
                default: csig_Fp2_sqr <= NOP;
            endcase
        end
    end
    

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