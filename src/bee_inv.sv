`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/11/18 00:13:43
// Design Name: 
// Module Name: bee_inv
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
localparam N_PIPELINE_STAGES = 6;

// module beeinv_4threads(
//   input clk, rstn, run,
//   input redundant_poly_L3 din,
//   input [8:0] addr_in,
//   output fin,
//   output [8:0] addr_out,
//   output redundant_poly_L3 dout
// );

//   always @(posedge clk) begin

//   end
// endmodule

module inv(
    input          clk, rstn,
    input          I_START,
    input M_tilde12_t  I_DATA_N,
    input M_tilde12_t  I_WDATA,
    output M_tilde12_t O_RDATA,
    output         O_BUSY
    );
    localparam MSB = $bits(M_tilde12_t) - 1;

    M_tilde12_t    U0; // 257 bit N
    M_tilde12_t    U1; // 257 bit dat
    M_tilde12_t   U2; // 257 bit 0
    M_tilde12_t   U3; // 257 bit R2

    assign O_RDATA = U3;


    // for calc inversion
    wire         invmode = '1;
    wire         U1_is_1 = (U1 == 'h1);
    wire inv_busy =  ~U1_is_1;
    assign O_BUSY = inv_busy;


    wire [1:0] sel_addr1_a;
    M_tilde12_t addr1_a;
    assign sel_addr1_a = {U1[MSB], U1[0]};
    assign addr1_a = f_addr1_a(sel_addr1_a, U1);
    function M_tilde12_t f_addr1_a;
      input [1:0] sel_addr1_a;
      input M_tilde12_t U1;
      begin
        casex(sel_addr1_a)
          2'b00   : f_addr1_a = {U1[MSB], U1[MSB:1]}; // U1 >>> 1 (= U1 >> 1)
          2'b01   : f_addr1_a = ~U1;
          2'b1x   : f_addr1_a = ~{U1[MSB], U1[MSB:1]};
          default : f_addr1_a = 'hx;
        endcase // casex ({U1[256], U1[0]})
      end
    endfunction // f_addr1_a


    // select A of addr1
    M_tilde12_t addr1_b;
    assign addr1_b = (~U1[MSB] & U1[0]) ? U0 : 257'h0;

    // select CI of addr1
    wire addr1_ci;
    assign addr1_ci = (U1[MSB] | U1[0]); // "U1 < 0" or "U1 is odd"

    wire [1:0] sel_addr2_a;
    M_tilde12_t addr2_a;
    assign sel_addr2_a = {U1[MSB], U1[0]};
    assign addr2_a = f_addr2_a(sel_addr2_a, U3);
    function M_tilde12_t f_addr2_a;
      input [1:0] sel_addr2_a;
      input M_tilde12_t U3;
      begin
        casex(sel_addr2_a)
          2'b00 : f_addr2_a = {U3[MSB], U3[MSB:1]};  // inv, U1>=0, U1=even
          2'b01 : f_addr2_a = ~U3;    // inv, U1>=0, U1=odd
          2'b1x : f_addr2_a = ~{U3[MSB], U3[MSB:1]}; // inv, U1<0
          default     : f_addr2_a = 'hx;
        endcase 
      end
    endfunction

    wire [1:0] sel_addr2_b_in;
    M_tilde12_t addr2_b;
    assign sel_addr2_b_in = {U1[MSB], U1[0]};
    assign addr2_b = f_addr2_b_in(sel_addr2_b_in, U2);
    function M_tilde12_t f_addr2_b_in;
      input [1:0]   sel_addr2_b_in;
      input M_tilde12_t U2;
      begin
        casex(sel_addr2_b_in)
          2'b00 : f_addr2_b_in = 'b0;    // inv, U1>=0, U1=even
          2'b01 : f_addr2_b_in = U2;        // inv, U1>=0, U1=odd
          2'b1x : f_addr2_b_in = 'b0;    // inv, U1<0
          default      : f_addr2_b_in = 'bx;
        endcase
      end
    endfunction // f_addr2_b_in



    wire [4:0] sel_addr2_n;
    M_tilde12_t addr2_n;
    assign sel_addr2_n = {U3[MSB], U2[MSB], U3[0], U1[MSB], U1[0]};
    assign addr2_n = f_addr2_n(sel_addr2_n, I_DATA_N);
    function M_tilde12_t f_addr2_n;
      input [4:0]   sel_addr2_n;
      input M_tilde12_t I_DATA_N;
      begin
        casex(sel_addr2_n)
          5'b0x000 : f_addr2_n = 'h0;
          5'b1x000 : f_addr2_n = I_DATA_N;
          5'bxx100 : f_addr2_n = {I_DATA_N[MSB], I_DATA_N[MSB:1]};
          5'bxxx01 : f_addr2_n = 'h0;
          5'b0x01x : f_addr2_n = I_DATA_N;
          5'b1x01x : f_addr2_n = 'h0;
          5'bxx11x : f_addr2_n = {I_DATA_N[MSB], I_DATA_N[MSB:1]};
          default f_addr2_n = 'hx;
        endcase // casex (sel_addr2_n)
      end
    endfunction // f_addr2_n


    wire [4:0] sel_addr2_ci_n;
    wire       addr2_ci_n;
    assign sel_addr2_ci_n = {U3[MSB], U2[MSB], U3[0], U1[MSB], U1[0]};
    assign addr2_ci_n = f_addr2_ci_n(sel_addr2_ci_n);
    function f_addr2_ci_n;
      input [4:0]   sel_addr2_ci_n;
      begin
        casex(sel_addr2_ci_n)
          5'bxx000 : f_addr2_ci_n = 'b0;
          5'bxx100 : f_addr2_ci_n = 'b1;
          5'bxxx01 : f_addr2_ci_n = 'b1;
          5'bxxx1x : f_addr2_ci_n = 'b1;
          default f_addr2_ci_n = 'bx;
        endcase // casex (sel_addr2_ci_n)
      end
    endfunction // f_addr2_n


    // addrs
    M_tilde12_t sum1;
    M_tilde12_t sum2;
    wire         co1;
    wire         co2;

    assign {co1, sum1} = addr1_a + addr1_b + addr1_ci;
    assign {co2, sum2} = addr2_a + addr2_b + addr2_n + addr2_ci_n;


    // registers
    wire [4:0] sel_in_U0;
    M_tilde12_t in_U0;
    assign sel_in_U0 = {I_START, U1_is_1, U1[MSB], U1[0], sum1[MSB]};
    assign in_U0 = f_in_U0(sel_in_U0, U0, U1, I_WDATA);
    function M_tilde12_t f_in_U0;
      input [4:0] sel_in_U0;
      input M_tilde12_t U0;
      input M_tilde12_t U1;
      input M_tilde12_t I_WDATA;
      begin
        casex(sel_in_U0)
          5'b0000x : f_in_U0 = U0;
          5'b00010 : f_in_U0 = U1;
          5'b00011 : f_in_U0 = U0;
          5'b001xx : f_in_U0 = U0;
          5'b01xxx : f_in_U0 = U0;
          5'b1xxxx : f_in_U0 = I_DATA_N;
          default : f_in_U0 = 'hx;
        endcase // case (sel_in_U0)
      end
    endfunction // f_in_U0


    wire [1:0] sel_in_U1;
    M_tilde12_t in_U1;
    assign sel_in_U1 = {I_START, inv_busy};
    assign in_U1 = f_in_U1(sel_in_U1, U1, sum1, I_WDATA);
    function M_tilde12_t f_in_U1;
      input [1:0] sel_in_U1;
      input M_tilde12_t U1;
      input M_tilde12_t sum1;
      input M_tilde12_t I_WDATA;
      begin
        casex(sel_in_U1)
          2'b00 : f_in_U1 = U1;
          2'b01 : f_in_U1 = sum1;
          2'b1x : f_in_U1 = I_WDATA;
          default : f_in_U1 = 'hx;
        endcase // case (sel_in_U1)
      end
    endfunction // f_in_U1



    wire [4:0] sel_in_U2;
    M_tilde12_t in_U2;
    assign sel_in_U2 = {I_START, U1_is_1, U1[MSB], U1[0], sum1[MSB]};
    assign in_U2 = f_in_U2(sel_in_U2, U2, U3);
    function M_tilde12_t f_in_U2;
      input [4:0] sel_in_U2;
      input M_tilde12_t U2;
      input M_tilde12_t U3;
      begin
        casex(sel_in_U2)
          5'bx000x : f_in_U2 = U2;
          5'bx0010 : f_in_U2 = U3;
          5'bx0011 : f_in_U2 = U2;
          5'bx01xx : f_in_U2 = U2;
          5'b01xxx : f_in_U2 = U2;
          5'b11xxx : f_in_U2 = '0;
          default : f_in_U2 = 'hx;
        endcase // case (sel_in_U2)
      end
    endfunction // f_in_U2


    wire [1:0] sel_in_U3;
    M_tilde12_t in_U3;
    assign sel_in_U3 = {I_START, inv_busy};
    assign in_U3 = f_in_U3(sel_in_U3, U3, sum2);
    function M_tilde12_t f_in_U3;
      input [1:0] sel_in_U3;
      input M_tilde12_t U3;
      input M_tilde12_t sum2;
      begin
        casex(sel_in_U3)
          2'b00 : f_in_U3 = U3;
          2'bx1 : f_in_U3 = sum2;
          2'b10 : f_in_U3 = PARAMS_BN254_d0::RmodM;
          default : f_in_U3 = 'hx;
        endcase // case (sel_in_U3)
      end
    endfunction // f_in_U3


    // write data
    always @(posedge clk or negedge rstn) begin
      if(!rstn) begin
        U0 <= 'h0;
        U1 <= 'h1;
        U2 <= 'h0;
        U3 <= 'h0;
      end
      else begin
        U0 <= in_U0;
        U1 <= in_U1;
        U2 <= in_U2;
        U3 <= in_U3;
      end
    end

endmodule



module extendedEuclidean5(a,p,a_inv,result_flag,startflag,clk,rstn,invcnt);
    parameter bit_width = 256;
    parameter a_width = 289;
    input [a_width:0] a;
    input [bit_width - 1:0] p;
    output [bit_width - 1:0] a_inv;
    output result_flag;
    input startflag, clk,rstn;
    output reg[2:0] invcnt;
    
    reg [bit_width + 1:0] x1;
    reg [bit_width + 1:0] x2;
    reg [a_width: 0] u_latch;
    reg [a_width: 0] v_latch;
    reg  result;

    
    wire [bit_width + 1:0] x1_wire;
    wire [bit_width + 1:0] x2_wire;
    wire [bit_width + 1:0] p2_wire; // p/2_wire: ãƒ¬ã‚¸ã‚¹ã‚¿ã‹åŒ–ã—ãŸã»ã?ãŒã„ã?ã‹ã‚‚?¼šé?ç·šé…å»¶å¢—å¤§é˜²æ­¢
    wire [bit_width + 1:0] p4_wire; // p/4_wire: ãƒ¬ã‚¸ã‚¹ã‚¿ã‹åŒ–ã—ãŸã»ã?ãŒã„ã?ã‹ã‚‚?¼šé?ç·šé…å»¶å¢—å¤§é˜²æ­¢
    wire [bit_width + 1:0] x1_2_wire;
    wire [bit_width + 1:0] x1_4_wire;
    wire [bit_width + 1:0] x2_2_wire;
    wire [bit_width + 1:0] x2_4_wire;
    wire [bit_width + 1:0] x1_wire_u2;
    wire [bit_width + 1:0] x1_wire_u4;
    wire [bit_width + 1:0] x2_wire_u2;
    wire [bit_width + 1:0] x2_wire_u4;
    wire [bit_width + 1:0] x1_wire_33;
    wire [bit_width + 1:0] x2_wire_33;
    wire [a_width:0] u2_wire;
    wire [a_width:0] u4_wire;
    wire [a_width:0] v2_wire;
    wire [a_width:0] v4_wire;
    wire [a_width:0] u_wire;
    wire [a_width:0] v_wire;
    wire [a_width:0] u_wire_33;
    wire [a_width:0] v_wire_33;
    
    wire [a_width:0] uv_wire;
    wire [a_width:0] vu_wire;

    wire [bit_width + 1:0] x1x2_wire;
    wire [bit_width + 1:0] x2x1_wire;
    
    assign uv_wire = u_latch - v_latch;
    assign vu_wire = v_latch - u_latch;
    assign x1x2_wire = x1 - x2;
    assign x2x1_wire = x2 - x1;
	
	assign p2_wire = {3'b0, p[bit_width-1: 1]};
	assign p4_wire = {4'b0, p[bit_width-1: 2]};
	
	//è²?å€¤ã«å¯¾å¿œã™ã‚‹ãŸã‚?¼Ÿï¼Ÿï¼Ÿï¼?
	assign x1_2_wire = {x1[bit_width+1], x1[bit_width+1: 1]};
	assign x1_4_wire = {x1[bit_width+1],x1[bit_width+1], x1[bit_width+1: 2]};
    
    assign x2_2_wire = {x2[bit_width+1], x2[bit_width+1: 1]};
    assign x2_4_wire = {x2[bit_width+1],x2[bit_width+1], x2[bit_width+1: 2]};
	
	assign x1_wire_u2 = (x1[0])?(x1_2_wire+p2_wire+ 256'b1):x1_2_wire;
	assign x1_wire_u4 = (x1[1:0] == 2'b00)? x1_4_wire:
						(x1[1:0] == 2'b10)? x1_4_wire + p2_wire + 256'b1:
						(x1[1:0] == 2'b01)? x1_4_wire + p4_wire + 256'b1:
					/*(x1[1:0] == 2'b11)?*/ x1_4_wire + p4_wire + p2_wire + 256'b10;
	
	assign x2_wire_u2 = (x2[0])?(x2_2_wire+p2_wire+ 256'b1):x2_2_wire;
	assign x2_wire_u4 = (x2[1:0] == 2'b00)? x2_4_wire:
						(x2[1:0] == 2'b10)? x2_4_wire + p2_wire + 256'b1:
						(x2[1:0] == 2'b01)? x2_4_wire + p4_wire + 256'b1:
					/*(x2[1:0] == 2'b11)?*/ x2_4_wire + p4_wire + p2_wire + 256'b10;
					
	
                
    assign u2_wire = {1'b0, u_latch[a_width:1]};
    assign u4_wire = {2'b0, u_latch[a_width:2]};
    assign v2_wire = {1'b0, v_latch[a_width:1]};
    assign v4_wire = {2'b0, v_latch[a_width:2]};
    assign u_wire = (u_latch[1:0] == 2'b10)?u2_wire:u4_wire;
    assign v_wire = (v_latch[1:0] == 2'b10)?v2_wire:v4_wire;
	
    assign x1_wire = (u_latch[1:0] == 2'b10)?x1_wire_u2:x1_wire_u4;
    assign x2_wire = (v_latch[1:0] == 2'b10)?x2_wire_u2:x2_wire_u4;
    
	assign x1_wire_33 = (x1[0] == 1'b1 && x2[0] == 1'b0)? (x1_2_wire - x2_2_wire + p2_wire + 1):
						(x1[0] == 1'b0 && x2[0] == 1'b1)? (x1_2_wire - x2_2_wire + p2_wire):
						(x1_2_wire - x2_2_wire);
						
	assign x2_wire_33 = (x1[0] == 1'b0 && x2[0] == 1'b1)? (x2_2_wire - x1_2_wire + p2_wire + 1):
						(x1[0] == 1'b1 && x2[0] == 1'b0)? (x2_2_wire - x1_2_wire + p2_wire):
						(x2_2_wire - x1_2_wire);
						
						
    assign result_flag = result;
	
	
    //assign x1_wire_33 = ((x1[0]^x2[0])==0)?( x1_2_wire - x2_2_wire):
    //                    (x2[0]==1)?(x1_2_wire - x2_2_wire + p2_wire):
    //                    (x1_2_wire - x2_2_wire + p2_wire + 1);
    //assign x2_wire_33 = ((x1[0]^x2[0])==0)?( x2_2_wire - x1_2_wire):
    //                    (x1[0]==1)?(x2_2_wire - x1_2_wire + p2_wire):
    //                    (x2_2_wire - x1_2_wire + p2_wire + 1);
                        
    assign u_wire_33 = u2_wire - v2_wire;
    assign v_wire_33 = v2_wire - u2_wire;
	
	
    assign a_inv = result?((u_latch == 1)?
                    (x1[bit_width + 1]?x1+p:
                    ((x1>=p)?x1-p:x1))
                    :(x2[bit_width + 1]?x2+p:
                    ((x2>=p)?x2-p:x2))):0;
    
    
    always @(posedge clk)begin
        if(!rstn)begin
            x1 <= 1;
            x2 <= 0;
            u_latch <= 0;
            v_latch <= 0;
            result <= 1;
            invcnt <= 0;
        end else if(startflag)begin
            x1 <= 1;
            x2 <= 0;
            u_latch <= a;
            v_latch <= p;
            result <= 0;
            invcnt <= invcnt + 1;
        end else if(result == 0) begin
			if( u_latch[0] == 1'b0) begin
				u_latch <= u_wire;
				x1 <= x1_wire;
			end else if(v_latch[0] == 1'b0)begin
				v_latch<= v_wire;
				x2<= x2_wire;
			end else begin
				if(u_latch >= v_latch)begin
				/*if(uv_wire[0] == 1'b1)begin
                            u_latch <= uv_wire;
                            x1 <= x1x2_wire;
				        end else begin*/
                    u_latch <= u_wire_33;
                    x1 <= x1_wire_33;
				        //end
				end else begin
                    /*if(vu_wire[0] == 1'b1)begin
                        v_latch <= vu_wire;
                        x2 <= x2x1_wire;
                    end else begin*/
                        v_latch <= v_wire_33;
                        x2 <= x2_wire_33;
                    //end
				end
			end
			if( u_latch == 1'b1 || v_latch == 1'b1) begin
				result <= 1;
			end
        end
    end
endmodule
