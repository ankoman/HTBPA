`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/07 19:05:41
// Design Name: 
// Module Name: postadder
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

module postadder(
    input clk,
    input rstn,
    input redundant_poly_L1 in_L1,
    input [2:0] mode1, mode2, mode3,
    input [1:0] outsel, addr2, addr3, 
    output redundant_poly_L3 dout
    );

    redundant_poly_L3 in;
    assign in = L1toL3(in_L1);

    redundant_poly_L3 reg1;
    redundant_poly_L3[2:0] reg2, reg3;
    redundant_poly_L3 acc1_out, acc2_out, acc3_out;
    redundant_poly_L3 reg1_wire, reg2_wire, reg3_wire, dly_reg1, dly_reg2, dly_reg3;
    assign reg1_wire = reg1;
    assign reg2_wire = reg2[addr2];
    assign reg3_wire = reg3[addr3];

    redundant_poly_L3 poly_p;
    assign poly_p = inttoL3(CURVE_PARAMS::Mod);

    //// ACC1
    wire sel_b1 = ((mode1 == 3'b001) || (mode1 == 3'b100));
    redundant_poly_L3 add1_ain;
    assign add1_ain = (mode1[2:1]==2'b00)? 0:(mode1==3'b010)?in:(mode1==3'b011)?in:(mode1==3'b100)?reg1_wire:(mode1==3'b101)?poly_p:in;
    redundant_poly_L3 add1_bin;
    assign add1_bin = sel_b1? in: reg1_wire;
    wire add1_sel_sub = (mode1==3'b011)?1'b1:(mode1==3'b100)?1'b1:(mode1==3'b101)?1'b1:1'b0;
    poly_adder_L3_L3 acc1(.sub(add1_sel_sub), .X(add1_ain), .Y(add1_bin), .Z(acc1_out));

    //// ACC2
    wire sel_b2 = ((mode2 == 3'b001) || (mode2 == 3'b100));

    redundant_poly_L3 add2_ain;
    assign add2_ain = (mode2[2:1]==2'b00)? 0:(mode2==3'b010)?in:(mode2==3'b011)?in:(mode2==3'b100)?reg2_wire:(mode2==3'b101)?poly_p:in;
    redundant_poly_L3 add2_bin;
    assign add2_bin = sel_b2? in: reg2_wire;
    wire add2_sel_sub = (mode2==3'b011)?1'b1:(mode2==3'b100)?1'b1:(mode2==3'b101)?1'b1:1'b0;
    poly_adder_L3_L3 acc2(.sub(add2_sel_sub), .X(add2_ain), .Y(add2_bin), .Z(acc2_out));

    //// ACC2
    wire sel_b3 = ((mode3 == 3'b001) || (mode3 == 3'b100));
    redundant_poly_L3 add3_ain;
    assign add3_ain = (mode3[2:1]==2'b00)? 0:(mode3==3'b010)?in:(mode3==3'b011)?in:(mode3==3'b100)?reg3_wire:(mode3==3'b101)?poly_p:in;
    redundant_poly_L3 add3_bin;
    assign add3_bin = sel_b3? in: reg3_wire;
    wire add3_sel_sub = (mode3==3'b011)?1'b1:(mode3==3'b100)?1'b1:(mode3==3'b101)?1'b1:1'b0;
    poly_adder_L3_L3 acc3(.sub(add3_sel_sub), .X(add3_ain), .Y(add3_bin), .Z(acc3_out));


    always @(posedge clk) begin
        if(!rstn)begin
            reg1[0] <= '0;
            reg1[1] <= '0;
            reg1[2] <= '0;
            reg1[3] <= '0;
            dout <= '0;
            for(integer i = 0; i < 3; i = i + 1) begin
                reg2[0][i] <= '0;
                reg3[0][i] <= '0;
                reg2[1][i] <= '0;
                reg3[1][i] <= '0;    
                reg2[2][i] <= '0;
                reg3[2][i] <= '0;                
                reg2[3][i] <= '0;
                reg3[3][i] <= '0;
            end
            dly_reg1 <= '0;
            dly_reg2 <= '0;
            dly_reg3 <= '0;
        end else begin
            reg1 <= acc1_out;
            reg2[addr2] <= acc2_out;
            reg3[addr3] <= acc3_out;
            dly_reg1 <= acc1_out;
            dly_reg2 <= acc2_out;
            dly_reg3 <= acc3_out;
            //dout <= (outsel==2'b00)?dly_reg1:(outsel==2'b01)?dly_reg2:(outsel==2'b10)?dly_reg3:'x;
            dout <= (outsel==2'b00)?reg1_wire:(outsel==2'b01)?reg2_wire:(outsel==2'b10)?reg3_wire:'x;

        end
    end

    function redundant_poly_L3 L1toL3;
        input redundant_poly_L1 in_L1;
        L1toL3 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            L1toL3[i].carry = 8'(in_L1[i].carry);
            L1toL3[i].val = in_L1[i].val;
        end
    endfunction
    function redundant_poly_L3 inttoL3;
        input uint_fp_t in_int;
        fp_div4_t[ADD_DIV-1:0] poly;
        poly = in_int;
        inttoL3 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            inttoL3[i].carry = '0;
            inttoL3[i].val = poly[i];
        end
    endfunction
endmodule

module postadder_Nthread(
    input clk,
    input rstn,
    input redundant_poly_L1 in_L1,
    input [2:0] mode1, mode2, mode3,
    input [1:0] outsel, 
    output redundant_poly_L3 dout
    );

    redundant_poly_L3 in;
    assign in = L1toL3(in_L1);

    redundant_poly_L3[N_THREADS-1:0] reg1, reg2, reg3;
    redundant_poly_L3 acc1_out, acc2_out, acc3_out;
    redundant_poly_L3 reg1_wire, reg2_wire, reg3_wire;
    assign reg1_wire = reg1[N_THREADS-2];
    assign reg2_wire = reg2[N_THREADS-2];
    assign reg3_wire = reg3[N_THREADS-2];

    ACC acc1 (clk, in, reg1_wire, mode1, acc1_out);
    ACC acc2 (clk, in, reg2_wire, mode2, acc2_out);
    ACC acc3 (clk, in, reg3_wire, mode3, acc3_out);


    always @(posedge clk) begin
        if(!rstn)begin
            dout <= '0;
            for(integer i = 0; i < N_THREADS; i = i + 1) begin
                reg1[i] <= '0;
                reg2[i] <= '0;
                reg3[i] <= '0;
            end
        end else begin
            reg1 <= {reg1[N_THREADS-2:0], acc1_out};
            reg2 <= {reg2[N_THREADS-2:0], acc2_out};
            reg3 <= {reg3[N_THREADS-2:0], acc3_out};
            dout <= (outsel==2'b00)?reg1[0]:(outsel==2'b01)?reg2[0]:(outsel==2'b10)?reg3[0]:'x;
        end
    end

    function redundant_poly_L3 L1toL3;
        input redundant_poly_L1 in_L1;
        L1toL3 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            L1toL3[i].carry = 8'(in_L1[i].carry);
            L1toL3[i].val = in_L1[i].val;
        end
    endfunction
    function redundant_poly_L3 inttoL3;
        input uint_fp_t in_int;
        fp_div4_t[ADD_DIV-1:0] poly;
        poly = in_int;
        inttoL3 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            inttoL3[i].carry = '0;
            inttoL3[i].val = poly[i];
        end
    endfunction
endmodule

module ACC(
    input clk,
    input redundant_poly_L3 din,
    input redundant_poly_L3 regin,
    input [2:0] mode,
    output redundant_poly_L3 dout
    );

    localparam LATENCY = 1;

    redundant_poly_L3 ain, bin, _acc, _din;
    logic sub;

    assign _acc = ~regin;
    assign _din = ~din;
    if (LATENCY) begin
        always @(posedge clk) begin
            ain <= sel_a(mode, din, regin);
            bin <= sel_b(mode, din, regin);
            sub <= sel_sub(mode);
        end
    end else begin
        assign ain = sel_a(mode, din, regin);
        assign bin = sel_b(mode, din, regin);
        assign sub = sel_sub(mode);
    end
    poly_addsub_L3_L3 simd_adder (.sub, .X(ain), .Y(bin), .Z(dout));

    function redundant_poly_L3 sel_a;
        input [2:0] mode;
        input redundant_poly_L3 din;
        input redundant_poly_L3 acc;
        begin
            case(mode)
                'b000 : sel_a = '0;
                'b001 : sel_a = '0;
                'b010 : sel_a = din;
                'b011 : sel_a = din;
                'b100 : sel_a = acc;
                'b101 : sel_a = '0;
                'b110 : sel_a = '0;
                'b111 : sel_a = acc;
            endcase
        end
    endfunction

    function redundant_poly_L3 sel_b;
        input [2:0] mode;
        input redundant_poly_L3 din;
        input redundant_poly_L3 acc;
        begin
            case(mode)
                'b001 : sel_b = din;
                'b011 : sel_b = _acc;
                'b100 : sel_b = _din;
                'b101 : sel_b = _acc;
                'b110 : sel_b = _din;
                default: sel_b = acc;
            endcase
        end
    endfunction

    function sel_sub;
        input [2:0] mode;
        begin
            case(mode)
                'b011 : sel_sub = 1'b1; //acc
                'b100 : sel_sub = 1'b1; //din
                'b101 : sel_sub = 1'b1; //acc
                'b110 : sel_sub = 1'b1; //din
                default: sel_sub = 1'b0;
            endcase
        end
    endfunction
endmodule

// module postadder_4thread(
//     input clk,
//     input rstn,
//     input redundant_poly_L1 in_L1,
//     input [2:0] mode1, mode2, mode3,
//     input [1:0] outsel, raddr2, raddr3, waddr2, waddr3, rthread, wthread, 
//     output redundant_poly_L3 dout
//     );

//     redundant_poly_L3 in;
//     assign in = L1toL3(in_L1);

//     redundant_poly_L3[3:0] reg1, reg2_buf, reg3_buf;
//     redundant_poly_L3[3:0][2:0] reg2, reg3;
//     redundant_poly_L3 acc1_out, acc2_out, acc3_out;
//     redundant_poly_L3 reg1_wire, reg2_wire, reg3_wire, reg_acc2_out, reg_acc3_out;
//     assign reg1_wire = reg1[3];
//     assign reg2_wire = reg2_buf[1];
//     assign reg3_wire = reg3_buf[1];

//     redundant_poly_L3 poly_p;
//     assign poly_p = inttoL3(CURVE_PARAMS::Mod);

//     //// ACC1
//     wire sel_b1 = ((mode1 == 3'b001) || (mode1 == 3'b100));
//     redundant_poly_L3 add1_ain;
//     assign add1_ain = (mode1[2:1]==2'b00)? 0:(mode1==3'b010)?in:(mode1==3'b011)?in:(mode1==3'b100)?reg1_wire:(mode1==3'b101)?poly_p:in;
//     redundant_poly_L3 add1_bin;
//     assign add1_bin = sel_b1? in: reg1_wire;
//     wire add1_sel_sub = (mode1==3'b011)?1'b1:(mode1==3'b100)?1'b1:(mode1==3'b101)?1'b1:1'b0;
//     poly_adder_L3_L3 acc1(.sub(add1_sel_sub), .X(add1_ain), .Y(add1_bin), .Z(acc1_out));

//     //// ACC2
//     wire sel_b2 = ((mode2 == 3'b001) || (mode2 == 3'b100));
//     redundant_poly_L3 add2_ain;
//     assign add2_ain = (mode2[2:1]==2'b00)? 0:(mode2==3'b010)?in:(mode2==3'b011)?in:(mode2==3'b100)?reg2_wire:(mode2==3'b101)?poly_p:in;
//     redundant_poly_L3 add2_bin;
//     assign add2_bin = sel_b2? in: reg2_wire;
//     wire add2_sel_sub = (mode2==3'b011)?1'b1:(mode2==3'b100)?1'b1:(mode2==3'b101)?1'b1:1'b0;
//     poly_adder_L3_L3 acc2(.sub(add2_sel_sub), .X(add2_ain), .Y(add2_bin), .Z(acc2_out));

//     //// ACC2
//     wire sel_b3 = ((mode3 == 3'b001) || (mode3 == 3'b100));
//     redundant_poly_L3 add3_ain;
//     assign add3_ain = (mode3[2:1]==2'b00)? 0:(mode3==3'b010)?in:(mode3==3'b011)?in:(mode3==3'b100)?reg3_wire:(mode3==3'b101)?poly_p:in;
//     redundant_poly_L3 add3_bin;
//     assign add3_bin = sel_b3? in: reg3_wire;
//     wire add3_sel_sub = (mode3==3'b011)?1'b1:(mode3==3'b100)?1'b1:(mode3==3'b101)?1'b1:1'b0;
//     poly_adder_L3_L3 acc3(.sub(add3_sel_sub), .X(add3_ain), .Y(add3_bin), .Z(acc3_out));


//     always @(posedge clk) begin
//         if(!rstn)begin
//             reg1[0] <= '0;
//             reg1[1] <= '0;
//             reg1[2] <= '0;
//             reg1[3] <= '0;
//             dout <= '0;
//             for(integer i = 0; i < 3; i = i + 1) begin
//                 reg2[0][i] <= '0;
//                 reg3[0][i] <= '0;
//                 reg2[1][i] <= '0;
//                 reg3[1][i] <= '0;    
//                 reg2[2][i] <= '0;
//                 reg3[2][i] <= '0;                
//                 reg2[3][i] <= '0;
//                 reg3[3][i] <= '0;
//             end
//             reg_acc2_out <= '0;
//             reg_acc3_out <= '0;
//         end else begin
//             reg1[0] <= acc1_out;
//             reg1[1] <= reg1[0];
//             reg1[2] <= reg1[1];
//             reg1[3] <= reg1[2];

//             reg2_buf[0] <= reg2[rthread][raddr2];
//             reg2_buf[1] <= reg2_buf[0];
//             reg3_buf[0] <= reg3[rthread][raddr3];
//             reg3_buf[1] <= reg3_buf[0];

//             reg2[wthread][waddr2] <= reg_acc2_out;
//             reg3[wthread][waddr3] <= reg_acc3_out;
//             reg_acc2_out <= acc2_out;
//             reg_acc3_out <= acc3_out;
//             dout <= (outsel==2'b00)?reg1[0]:(outsel==2'b01)?reg_acc2_out:(outsel==2'b10)?reg_acc3_out:'x;
//         end
//     end

//     function redundant_poly_L3 L1toL3;
//         input redundant_poly_L1 in_L1;
//         L1toL3 = 0;
//         for(integer i = 0; i < ADD_DIV; i = i + 1) begin
//             L1toL3[i].carry = 8'(in_L1[i].carry);
//             L1toL3[i].val = in_L1[i].val;
//         end
//     endfunction
//     function redundant_poly_L3 inttoL3;
//         input uint_fp_t in_int;
//         fp_div4_t[ADD_DIV-1:0] poly;
//         poly = in_int;
//         inttoL3 = 0;
//         for(integer i = 0; i < ADD_DIV; i = i + 1) begin
//             inttoL3[i].carry = '0;
//             inttoL3[i].val = poly[i];
//         end
//     endfunction
// endmodule
