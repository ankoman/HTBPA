`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/14 15:49:28
// Design Name: 
// Module Name: cmul
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

module cmul #(
    parameter LATENCY = 0
    )(
    input clk, rstn,
    input [2:0] mode,
    input uint_Mtilde2_t din,
    output redundant_poly_L1 dout
    );

    wire[9:0] shift1 = (mode == 3'd2 || mode == 3'd3)? 0:
                     (mode == 3'd6)? 1: 1000;
                
    wire[1:0] shift2 = (mode == 3'd1 || mode == 3'd2)? 0:
                     (mode == 3'd3)? 1: 2;

    M_tilde12_t add1, add2;


    if(LATENCY == 2) begin
        always @(posedge clk) begin
            add1 <= din << shift1;
            add2 <= din << shift2;
        end
    end
    else begin
        assign add1 = din << shift1;
        assign add2 = din << shift2;
    end

    for(genvar i = 0; i < ADD_DIV; i = i+1) begin
        if(LATENCY == 0)
            assign dout[i] = add1.poly[i] + add2.poly[i];
        else if(LATENCY > 0) begin
            always @(posedge clk) begin
                dout[i] <= add1.poly[i] + add2.poly[i];
            end
        end
    end

    // assign add1 = sel_op1(mode, din);
    // assign add2 = sel_op2(mode, din);
    // function M_tilde12_t sel_op1;
    //     input [2:0] mode;
    //     input uint_Mtilde2_t din;
    //     begin
    //         case(mode)
    //             'b010 : sel_op1 = {din, 1'b0};
    //             'b011 : sel_op1 = {din, 1'b0};
    //             'b110 : sel_op1 = {din, 1'b0};
    //             default: sel_op1 = '0;
    //         endcase
    //     end
    // endfunction
    
    // function M_tilde12_t sel_op2;
    //     input [2:0] mode;
    //     input uint_Mtilde2_t din;
    //     begin
    //         case(mode)
    //             'b001 : sel_op2 = din;
    //             'b011 : sel_op2 = din;
    //             'b100 : sel_op2 = {din, 2'b00};
    //             'b110 : sel_op2 = {din, 2'b00};
    //             default: sel_op2 = '0;
    //         endcase
    //     end
    // endfunction
endmodule
