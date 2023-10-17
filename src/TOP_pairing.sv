`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/21 10:53:29
// Design Name: 
// Module Name: TOP_pairing
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
localparam N_CORES = 7;

module TOP_pairing(
    input   default_sysclk1_300_clk_n,
            default_sysclk1_300_clk_p,
            CPU_RESET,  //Active high
            RUN,
            LATCH,
    input [12:0] addr,
    output redundant_poly_L3 extout
    );
    
    wire clk;
    redundant_poly_L3[N_CORES-1:0] buf_out;
    redundant_poly_L3[N_CORES-1:0] pairing_out;
    assign extout = buf_out[addr[12:8]];
    
    for(genvar i = 0; i < N_CORES; i = i + 1) begin
        BN254_pairing DUT
            (.clk,
             .rstn(!CPU_RESET), 
             .run(RUN), 
             .n_func(4'd0), 
             .extin_addr(), 
             .extout_addr(addr[7:0]), 
             .extin_data(), 
             .extin_en(), 
             .extout_data(pairing_out[i])
             );
             
         always @(posedge clk) begin
            if(CPU_RESET)
                buf_out[i] <= '0;
            else if (LATCH)
                buf_out[i] <= pairing_out[i];

         end
    end

    clk_wiz_600 clk_wiz
        (.clk_in1_n(default_sysclk1_300_clk_n),
        .clk_in1_p(default_sysclk1_300_clk_p),
        .clk_out1(clk)
        );

endmodule
