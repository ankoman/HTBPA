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
localparam ROM_DEPTH = 11;
localparam ctrl_sig_t NOP = 'b0_xx_xxx_xxx_xxx_xxx_xx_0;
localparam noaddr = 9'hx;
localparam operation_t op_JMP  = 'b000;
localparam operation_t op_CALL = 'b001;
localparam operation_t op_RET  = 'b010;
localparam operation_t op_WAITINV = 'b011;

module new_sequencer(
    input clk, rstn, run, inv_rdy,
    input [3:0] n_func,
    output busy,
    output micro_ops_t mops
    );

    logic [ROM_DEPTH-1:0] pc; // program counter
    logic [ROM_DEPTH-1:0] ret_addr; // return address
    logic [N_THREADS-1:0] cnt_Nclk;
    raw_rom_t rom_out; // Latency 2;
    wire ctrl_instruction = rom_out.opc;
    wire is_Nclks = cnt_Nclk[N_THREADS-1];
    logic waitinv;

    assign busy = (pc != FIRST_PC_ADDR) ^ run;
    csig_rom rom(clk, pc, rom_out);            


    //////////////////////////////////////
    //// Counters
    //////////////////////////////////////
    always_ff @(posedge clk) begin
        if(!rstn)
            cnt_Nclk <= '0;
        else if(run)  
            cnt_Nclk <= 'd1; //cnt start
        else 
            cnt_Nclk <= {cnt_Nclk[N_THREADS-2:0], cnt_Nclk[N_THREADS-1]}; // left rotate
    end

    always_ff @(posedge clk) begin
        if(~rstn | inv_rdy)
            waitinv <= 'b0;
        else begin
            if(is_Nclks) begin
                if(ctrl_instruction) begin
                    if (rom_out.cm == op_WAITINV)
                        waitinv <= 'b1;
                end
            end
        end
    end

    //////////////////////////////////////
    //// Decoders
    //////////////////////////////////////
    wire [ROM_DEPTH-1:0] jmp_addr = {rom_out.pos, rom_out.pom3, rom_out.pom2, rom_out.pom1};
    always_ff @(posedge clk) begin : rom_addressing
        if(!rstn) 
            pc <= FIRST_PC_ADDR;
        else begin
            if(run)  
                pc <= 'b1;
            else if(is_Nclks) begin
                if (inv_rdy)
                    pc <= pc + 1;
                else if(ctrl_instruction) begin
                    case(rom_out.cm)
                        op_JMP  : pc <= jmp_addr;
                        op_CALL : pc <= jmp_addr;
                        op_RET  : pc <= ret_addr;
                        op_WAITINV  : pc <= pc;
                        default : pc <= 'x;
                    endcase
                    if(rom_out.cm == op_CALL)
                        ret_addr <= pc + 1;
                end
                else if (~waitinv)
                    pc <= pc + 1;
            end
        end
    end

    logic [BRAM_DEPTH-1:0] dst, src0, src1, offset_dst, offset_src0, offset_src1;
    assign dst = {func_decode_thread(cnt_Nclk), 7'(rom_out.waddr0 + offset_dst)};
    assign src0 = {func_decode_thread(cnt_Nclk), 7'(rom_out.raddr0 + offset_src0)};
    assign src1 = {func_decode_thread(cnt_Nclk), 7'(rom_out.raddr1 + offset_src1)};

    always_ff @(posedge clk) begin : set_offset
        if(!rstn) begin
            offset_dst <= '0;
            offset_src0 <= '0;
            offset_src1 <= '0;
        end
        else begin
            if(is_Nclks && ctrl_instruction) begin
                if(rom_out.cm == op_CALL) begin
                    offset_dst <= rom_out.waddr0;
                    offset_src0 <= rom_out.raddr0;
                    offset_src1 <= rom_out.raddr1;
                end
            end
        end
    end

    always @(posedge clk) begin : address_decoder
        mops.csig <= (ctrl_instruction) ? NOP : func_raw2csig(rom_out);
        mops.dst <= dst;
        mops.src0 <= src0;
        mops.src1 <= src1;
    end


    //////////////////////////////////////
    //// Functions
    //////////////////////////////////////
    function ctrl_sig_t func_raw2csig;
        input raw_rom_t raw;
        func_raw2csig.inve = raw.inve;
        func_raw2csig.pos = raw.pos;
        func_raw2csig.pom3 = raw.pom3;
        func_raw2csig.pom2 = raw.pom2;
        func_raw2csig.pom1 = raw.pom1;
        func_raw2csig.cm = raw.cm;
        func_raw2csig.pm = raw.pm1;
        func_raw2csig.me1 = raw.me1;
        func_raw2csig.me0 = raw.me0;
    endfunction


    function [$clog2(N_THREADS)-1:0] func_decode_thread;
        input[N_THREADS-1:0] cnt_Nclk;
        begin
            case(cnt_Nclk)
                'b0001 : func_decode_thread = 'b01;
                'b0010 : func_decode_thread = 'b10;
                'b0100 : func_decode_thread = 'b11;
                'b1000 : func_decode_thread = 'b00;
            endcase
        end
    endfunction

    // function [$clog2(N_THREADS)-1:0] func_decode_thread;
    //     input[N_THREADS-1:0] cnt_Nclk;
    //     begin
    //         case(cnt_Nclk)
    //             'b000001 : func_decode_thread = 'b011;
    //             'b000010 : func_decode_thread = 'b100;
    //             'b000100 : func_decode_thread = 'b101;
    //             'b001000 : func_decode_thread = 'b000;
    //             'b010000 : func_decode_thread = 'b001;
    //             'b100000 : func_decode_thread = 'b010;
    //         endcase
    //     end
    // endfunction

endmodule



module new_sequencer_mop(
    input clk, rstn, run,
    input [3:0] n_func,
    output busy,
    output micro_ops_t mops
    );

    localparam ROM_DEPTH = 10;
    localparam LEN_MOP_CNT = 4;

    localparam BIT_INSTRUCTION_TYPE = 33;
    localparam ctrl_sig_offset_t NOP = 'b0_xx_xxx_xxx_xxx_xxx_xx_0_xxx;
    localparam noaddr = 9'hx;
    localparam operation_t op_JMP  = 'bxxx0000;
    localparam operation_t op_CALL = 'bxxx0001;
    localparam operation_t op_RET  = 'bxxx0010;
    localparam operation_t op_WAIT = 'bxxx0011;

    localparam operation_t op_Fp2_mul       = 'b0000010;
    localparam operation_t op_Fp2_sqr       = 'b0000011;
    localparam operation_t op_Fp2_sqr_ix    = 'b0000100;
    localparam operation_t op_Fp2_sqr_xi    = 'b0000101;
    localparam operation_t op_Fp2_mul_xi    = 'b0000110;

    localparam operation_t op_Fp2_mul_acc       = 'b0100010;
    localparam operation_t op_Fp2_sqr_acc   = 'b0100011;
    localparam operation_t op_Fp2_mul_xi_acc= 'b0100110;

    localparam operation_t op_ACC1_add      = 'b1100000;
    localparam operation_t op_ACC1_sub      = 'b1100001;

    logic [ROM_DEPTH-1:0] pc, pc_d; // program counter
    logic [ROM_DEPTH-1:0] ret_addr; // return address
    logic change_pc, change_pc_d, change_pc_dd;
    assign change_pc = (pc != pc_d);
    logic [LEN_MOP_CNT-1:0] mop_cnt, end_mop_cnt; // micro operation counter
    logic [LEN_MOP_CNT+1:0] cnt_to_fetch; // cycles to fetch
    logic [1:0] thread_cnt, thread_cnt_d, thread_cnt_dd, thread_cnt_ddd; // thread counter
    logic [3:0] cnt_4clk;
    instruction_t rom_out, rom_out_d, rom_out_dd; // Latency 3;
    wire ctrl_instruction = rom_out[BIT_INSTRUCTION_TYPE];
    wire fetch_next = (cnt_to_fetch == {end_mop_cnt, 2'b00});
    wire is_4clks = cnt_4clk[3];
    wire thread_cnt_en = ~&end_mop_cnt;
    wire is_end_mop_cnt = (mop_cnt == end_mop_cnt);
    wire reset_mop_cnt = change_pc_dd | is_end_mop_cnt;


    assign busy = (pc != FIRST_PC_ADDR) ^ run;
    new_microcode_rom rom(clk, pc, rom_out);            

    always_ff @(posedge clk) begin : misc
        rom_out_d <= rom_out;
        rom_out_dd <= rom_out_d;
        pc_d <= pc;
        change_pc_d <= change_pc;
        change_pc_dd <= change_pc_d;
        thread_cnt_d <= thread_cnt;
        thread_cnt_dd <= thread_cnt_d;
        thread_cnt_ddd <= thread_cnt_dd;
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
            mop_cnt <= '1;
        else if(reset_mop_cnt)
            mop_cnt <= '0;
        else if (busy)
            mop_cnt <= mop_cnt + 1'b1;
    end

    always_ff @(posedge clk) begin
        if(!rstn) 
            thread_cnt <= '0;
        else if(thread_cnt_en) begin
            if(is_end_mop_cnt)
                thread_cnt <= thread_cnt + 1'b1;
        end
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
    //// Decoders
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
                    if(rom_out.opcode.op === op_CALL)
                        ret_addr <= pc + 1;
                end
                else if(fetch_next)
                    pc <= pc + 1;
            end
        end
    end

    logic [8:0] dst, src0, src1, src1_wo;
    assign dst = {thread_cnt_dd, 7'(rom_out_dd.dst + decoded.offset_dst)};
    assign src0 = {thread_cnt_dd, 7'(rom_out_dd.src0 + decoded.offset_src0)};
    assign src1_wo = {thread_cnt_dd, 7'(rom_out_dd.src1)};
    assign src1 = {thread_cnt_dd, 7'(rom_out_dd.src1 + decoded.offset_src1)};


    always @(posedge clk) begin : address_decoder
        mops.csig <= func_decode_me(decoded, rom_out_dd.opcode.sub_op.me);
        mops.dst <= dst;
        mops.src0 <= ((rom_out_dd.opcode.op.field == 2'b11) && decoded.offset_src0) ? src1_wo : src0;
        mops.src1 <= ((rom_out_dd.opcode.op.field == 2'b11) && decoded.offset_src1) ? 9'h0d : src1;
    end

    ctrl_sig_offset_t decoded, csig_Fp2_mul, csig_2Fp2_mul, csig_Fp2_sqr, csig_3Fp2_sqr, csig_3Fp2_sqr_ix, csig_Fp2_sqr_xi,
                    csig_2Fp2_mul_xi, csig_ACC1_sub, csig_3ACC1_sub, csig_2Fp2_mul_xi_acc, csig_Fp2_sqr_acc, csig_2Fp2_mul_acc;
    always @(posedge clk) begin : inst_decoder
        if(!rstn) 
            decoded <= '0;
        else begin
            case({rom_out_d.opcode.sub_op.cm, rom_out_d.opcode.op})
                //Fp2
                {'b001, op_Fp2_mul}: decoded <= csig_Fp2_mul;
                {'b010, op_Fp2_mul}: decoded <= csig_2Fp2_mul;

                {'b010, op_Fp2_mul_xi}: decoded <= csig_2Fp2_mul_xi;

                {'b001, op_Fp2_sqr}: decoded <= csig_Fp2_sqr;
                {'b011, op_Fp2_sqr}: decoded <= csig_3Fp2_sqr;

                {'b001, op_Fp2_sqr_xi}: decoded <= csig_Fp2_sqr_xi;

                {'b011, op_Fp2_sqr_ix}: decoded <= csig_3Fp2_sqr_ix;
                //Fp2_acc
                {'b010, op_Fp2_mul_acc}: decoded <= csig_2Fp2_mul_acc;
                {'b001, op_Fp2_sqr_acc}: decoded <= csig_Fp2_sqr_acc;
                {'b010, op_Fp2_mul_xi_acc}: decoded <= csig_2Fp2_mul_xi_acc;
                //ACC
                {'b001, op_ACC1_sub}: decoded <= csig_ACC1_sub;
                {'b011, op_ACC1_sub}: decoded <= csig_3ACC1_sub;

                default: decoded <= NOP;
            endcase
        end
    end


    assign end_mop_cnt = rom_out.opcode.sub_op.end_mop_cnt;

    //////////////////////////////////////
    //// Micro code sequencer
    //////////////////////////////////////

    
    always_ff @(posedge clk) begin : seq_Fp2_mul
        if(!rstn)
            csig_Fp2_mul <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_Fp2_mul <= 'b0_xx_xxx_001_001_001_00_x00; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                6'd1: csig_Fp2_mul <= 'b0_00_xxx_010_100_001_00_011;
                6'd2: csig_Fp2_mul <= 'b0_01_xxx_011_000_001_10_1xx;
                default: csig_Fp2_mul <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_2Fp2_mul
        if(!rstn)
            csig_2Fp2_mul <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_2Fp2_mul <= 'b0_xx_xxx_001_001_010_00_x00; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                6'd1: csig_2Fp2_mul <= 'b0_00_xxx_010_100_010_00_011;
                6'd2: csig_2Fp2_mul <= 'b0_01_xxx_011_000_010_10_1xx;
                default: csig_2Fp2_mul <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_2Fp2_mul_acc
        if(!rstn)
            csig_2Fp2_mul_acc <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_2Fp2_mul_acc <= 'b0_xx_xxx_100_010_010_00_x00; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                6'd1: csig_2Fp2_mul_acc <= 'b0_00_xxx_100_100_010_00_011;
                6'd2: csig_2Fp2_mul_acc <= 'b0_01_xxx_010_000_010_10_1xx;
                default: csig_2Fp2_mul_acc <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_2Fp2_mul_xi
        if(!rstn)
            csig_2Fp2_mul_xi <= NOP;
        else begin
            case(mop_cnt)
                // 6'd0: csig_2Fp2_mul_xi <= 'b0_xx_xxx_000_010_100_00_x00; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                // 6'd1: csig_2Fp2_mul_xi <= 'b0_00_xxx_100_000_100_00_011;
                // 6'd2: csig_2Fp2_mul_xi <= 'b0_01_xxx_010_100_010_10_1xx;
                default: csig_2Fp2_mul_xi <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_2Fp2_mul_xi_acc
        if(!rstn)
            csig_2Fp2_mul_xi_acc <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_2Fp2_mul_xi_acc <= 'b0_xx_xxx_000_010_100_00_x00; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                6'd1: csig_2Fp2_mul_xi_acc <= 'b0_00_xxx_100_000_100_00_011;
                6'd2: csig_2Fp2_mul_xi_acc <= 'b0_01_xxx_010_100_010_10_1xx;
                default: csig_2Fp2_mul_xi_acc <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_Fp2_sqr_acc
        if(!rstn)
            csig_Fp2_sqr_acc <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_Fp2_sqr_acc <= 'b0_01_xxx_010_000_010_00_100;
                6'd1: csig_Fp2_sqr_acc <= 'b0_00_xxx_000_010_001_01_0xx;
                default: csig_Fp2_sqr_acc <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_Fp2_sqr
        if(!rstn)
            csig_Fp2_sqr <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_Fp2_sqr <= 'b0_01_xxx_001_xxx_010_00_100;
                6'd1: csig_Fp2_sqr <= 'b0_00_xxx_000_001_001_01_0xx;
                default: csig_Fp2_sqr <= NOP;
            endcase
        end
    end
    
    always_ff @(posedge clk) begin : seq_3Fp2_sqr
        if(!rstn)
            csig_3Fp2_sqr <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_3Fp2_sqr <= 'b0_01_xxx_001_xxx_110_00_100;
                6'd1: csig_3Fp2_sqr <= 'b0_00_xxx_000_001_011_01_0xx;
                default: csig_3Fp2_sqr <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_3Fp2_sqr_ix
        if(!rstn)
            csig_3Fp2_sqr_ix <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_3Fp2_sqr_ix <= 'b0_xx_xxx_001_001_110_00_x00;
                6'd1: csig_3Fp2_sqr_ix <= 'b0_00_xxx_100_010_011_01_0xx;
                6'd2: csig_3Fp2_sqr_ix <= 'b0_01_xxx_000_001_xxx_xx_1xx;
                default: csig_3Fp2_sqr_ix <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_Fp2_sqr_xi
        if(!rstn)
            csig_Fp2_sqr_xi <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_Fp2_sqr_xi <= 'b0_xx_xxx_001_001_010_00_x00;
                6'd1: csig_Fp2_sqr_xi <= 'b0_00_xxx_010_011_001_01_0xx;
                6'd2: csig_Fp2_sqr_xi <= 'b0_01_xxx_000_000_xxx_xx_1xx;
                default: csig_Fp2_sqr_xi <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_ACC1_sub
        if(!rstn)
            csig_ACC1_sub <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_ACC1_sub <= 'b0_xx_xxx_xxx_001_001_00_001; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                6'd1: csig_ACC1_sub <= 'b0_00_xxx_xxx_100_001_00_011; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                default: csig_ACC1_sub <= NOP;
            endcase
        end
    end

    always_ff @(posedge clk) begin : seq_3ACC1_sub
        if(!rstn)
            csig_3ACC1_sub <= NOP;
        else begin
            case(mop_cnt)
                6'd0: csig_3ACC1_sub <= 'b0_xx_xxx_xxx_001_001_00_001; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                6'd1: csig_3ACC1_sub <= 'b0_00_xxx_xxx_100_011_00_011; //inve_pos_pom3_pom2_pom1_cm_pm_offset
                default: csig_3ACC1_sub <= NOP;
            endcase
        end
    end


    //////////////////////////////////////
    //// Functions
    //////////////////////////////////////
    function ctrl_sig_t func_decode_me;
        input ctrl_sig_offset_t csigin;
        input me;
        func_decode_me.inve = csigin.inve;
        func_decode_me.pos = csigin.pos;
        func_decode_me.pom3 = csigin.pom3;
        func_decode_me.pom2 = csigin.pom2;
        func_decode_me.pom1 = csigin.pom1;
        func_decode_me.cm = csigin.cm;
        func_decode_me.pm = csigin.pm;
        func_decode_me.me = me;
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