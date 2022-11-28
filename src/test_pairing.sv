`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YNU
// Engineer: Junichi Sakamoto
// 
// Create Date: 2022/10/21 17:45:33
// Design Name: 
// Module Name: test_pairing
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

module test_pairing;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 1000000;
               
    reg clk, rstn, run, swrst, extin_en;
    reg [3:0] n_func;
    reg [8:0] extin_addr, addr_dout;
    redundant_poly_L3 extin_data;
    wire [289-1:0] extout_data;
    wire busy;

    wire [255:0] debug_memout0, debug_memout1, debug_preadd0, debug_preadd1, debug_red0, debug_red1, debug_qpmm, debug_cmul, debug_postadd;
    assign debug_memout0 = MR(func_L3touint(DUT.memout0));
    assign debug_memout1 = MR(func_L3touint(DUT.memout1));
    assign debug_preadd0 = MR(func_L3touint(DUT.preadd_out0));
    assign debug_preadd1 = MR(func_L3touint(DUT.preadd_out1));
    assign debug_red0 = MR(DUT.red_out0);
    assign debug_red1 = MR(DUT.red_out1);
    assign debug_qpmm = MR(DUT.qpmm_out);
    assign debug_cmul = MR(func_L1toint(DUT.cmul_out));
    assign debug_postadd = MR(func_L3touint(DUT.postadd_out));

    //// For preadd debug
    wire [255:0] debug_add_buf_0, debug_add_buf_1, debug_add_buf_2, debug_add_buf_3, debug_dly_x, debug_dly_y;
    assign debug_add_buf_0 = MR(func_L3touint(DUT.preadder.add_buf_0));
    assign debug_add_buf_1 = MR(func_L3touint(DUT.preadder.add_buf_1));
    assign debug_add_buf_2 = MR(func_L3touint(DUT.preadder.add_buf_2));
    assign debug_add_buf_3 = MR(func_L3touint(DUT.preadder.add_buf_3));
    assign debug_dly_x = MR(func_L3touint(DUT.preadder.dly_x));
    assign debug_dly_y = MR(func_L3touint(DUT.preadder.dly_y));

    //// For postadd debug
    wire [255:0] debug_reg1_wire, debug_reg2_wire, debug_reg3_wire;
    assign debug_reg1_wire = MR(func_L3touint(DUT.postadder.reg1_wire));
    assign debug_reg2_wire = MR(func_L3touint(DUT.postadder.reg2_wire));
    assign debug_reg3_wire = MR(func_L3touint(DUT.postadder.reg3_wire));

    BN254_pairing DUT(.clk, .rstn, .swrst, .run, .n_func, .endflag(), .opstart(), .busy, 
       .extin_data, .extin_en, .extin_addr, .extout_data(extout_data), .extout_addr(addr_dout));
    
    always begin
        #(CYCLE/2) clk <= ~clk;
    end
    
    /*-------------------------------------------
    Test
    -------------------------------------------*/
    initial begin
        clk <= 1;
        rstn <= 1;
        run <= 0;
        swrst <= 0;
        addr_dout <= 0;
        n_func <= 3;
        extin_en <= 0;
        #1000
        rstn <= 0;
        #100
        rstn <= 1;
        #1000;
        swrst <= 1;
        #100;
        ram_init();
        swrst <= 0;
        run <= 1;
        #(CYCLE);
        run <= 0;
        #1000;
        wait(!busy);
        #100
        
        for(integer i=0;i<12;i=i+1) begin
            addr_dout <= 8'h10 + i;
            #(CYCLE*100);
            $display("i = %d: %h", i, extout_data);
        end
    
    $finish;
    end

    task ram_init;
        //////// Ordinary form
        // write_rams(9'h00, 320'h135ac8d3dfa7c6ed32d1f81ba636425c9bbd750d1e707c5230c1fb6a19086515);   // Qx_0
        // write_rams(9'h01, 320'h142442f78ef066d44279b14dae55cdff34ab18fd0a68e88e0ad4041504c14982);   // Qx_1
        // write_rams(9'h02, 320'hb69136889b5b368df14c6125f58d5b56f790959a3e04b3b756b0715e7180322);    // Qy_0
        // write_rams(9'h03, 320'h115e2eac26a974652371ea2c0247145f4a814d53964ddb776025f0ae35354579);   // Qy_1
        // write_rams(9'h04, 1);                                                                    // Qz_0
        // write_rams(9'h05, 0);                                                                    // Qz_1
        // write_rams(9'h06, 320'h75a767f4b1cb8bd2130260c8c69778ffd42f697651116565c6460364a1eb1b7);    // Px
        // write_rams(9'h07, 320'h132682b85419eefcd5e73e3f673617d94d7bd307122411e6ba8982dd85e69ea9);   // Py
        // write_rams(9'h08, 1);                                                                    // Pz
        // write_rams(9'h09, 320'h128a91347d05f46cb119f52b9a3df6b7ce6c2a12e9a7e0db7ba8a33509ff2c04);   // r2
        // write_rams(9'h0a, 1);                                                                    // r
        // write_rams(9'h0b, 1);                                                                    // 1

        // Almost inputs are Montgomery form
        write_rams(9'h00, 320'h11095cf5bb920088bd85bf335c712806d6283389fcfd2a6e3ccf26cfe62604ff);   // Qx_0
        write_rams(9'h01, 320'h1d22aeb8a7103a46ac3574d73e04d1ac197d318d9fec0fa7dd3e3db1262ab5b0);   // Qx_1
        write_rams(9'h02, 320'h1a0f1e9dc3ede0705c1c062231fc3a61f887cbc9ef6fe76682df0072d4708bcc);   // Qy_0
        write_rams(9'h03, 320'hf87b1dd029582349bc94017c1eb2c07cb845a2239a1fd0ee84481358ccab325);    // Qy_1
        write_rams(9'h04, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d);    // Qz_0
        write_rams(9'h05, 0);                                                                       // Qz_1
        write_rams(9'h06, 320'h19d677cf231f958a96eef7b3d98f4d7a52fa3fd983fa21a8fad069b533b62400);   // Px
        write_rams(9'h07, 320'h1bd9df4dd90a7fb0bc432a5e3b1affb7493052d44002a2eae20718d22e0523b2);   // Py
        // Pz
        write_rams(9'h09, 320'h1e3ad4f19ece02905cd917dec0178837a70990ae5b87678a825bfd79f8a881b8);   // r^2 (ordinary form)
        write_rams(9'h0a, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d);    // r (ordinary form)
        write_rams(9'h0b, 1);                                                                       // 1 (ordinary form)
        write_rams(9'h0c, 320'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc);   // ec_frpb_p
        write_rams(9'h0d, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823);   // ec_frpb_p
        write_rams(9'h0e, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823);   // ec_frpb_p
        write_rams(9'h0f, 320'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa);   // frobFp6_8?


        write_rams(9'h10, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d);    // f00 = r = 1
        write_rams(9'h11, 0);                                                                       // f01
        write_rams(9'h12, 0);                                                                       // f10
        write_rams(9'h13, 0);                                                                       // f11
        write_rams(9'h14, 0);                                                                       // f20
        write_rams(9'h15, 0);                                                                       // f21
        write_rams(9'h16, 0);                                                                       // f30
        write_rams(9'h17, 0);                                                                       // f31
        write_rams(9'h18, 0);                                                                       // f40
        write_rams(9'h19, 0);                                                                       // f41
        write_rams(9'h1a, 0);                                                                       // f50
        write_rams(9'h1b, 0);                                                                       // f51

        write_rams(9'h20, 320'h11095cf5bb920088bd85bf335c712806d6283389fcfd2a6e3ccf26cfe62604ff);   // Tx_0
        write_rams(9'h21, 320'h1d22aeb8a7103a46ac3574d73e04d1ac197d318d9fec0fa7dd3e3db1262ab5b0);   // Tx_1
        write_rams(9'h22, 320'h1a0f1e9dc3ede0705c1c062231fc3a61f887cbc9ef6fe76682df0072d4708bcc);   // Ty_0
        write_rams(9'h23, 320'hf87b1dd029582349bc94017c1eb2c07cb845a2239a1fd0ee84481358ccab325);    // Ty_1
        write_rams(9'h24, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d);    // Tz_0
        write_rams(9'h25, 0);                                                                       // Tz_1

        write_rams(9'h1f, 320'h2523648240000001ba344d80000000086121000000000013a700000000000013);   // p (ordinary form) iran?

        write_rams(9'h5e, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823);   // g300
        write_rams(9'h5f, 320'h1f6d4e3c505f417e7c275b73857179afe2c2010eeeffabeace000105f0aeb9a6);   // 
        write_rams(9'h6c, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d);   // 
        write_rams(9'h6d, 320'h1eff3a21bcacdbecddccf3227e232976729d52e23a2fb2554d31712d452a77f0);   // 
        write_rams(9'h6e, 320'h172d23914e303a10a72e82ac1a586ca5193c1434b1ecffa1a2d6130bfe6093e);   // 
        write_rams(9'h6f, 320'h181b51ef3711dc48902788c90ff150544922738e6dce3c3535d3f98098f34769);   // 
        write_rams(9'h7c, 320'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc);   // 
        write_rams(9'h7d, 320'h20720c5ad18fdf8de83fdb4d3fc8b040c4311425854e824f675ed25e0510812e);   // 
        write_rams(9'h7e, 320'h12be28d8f88ee23c6819b6c36a9d360c965d8b62a33218074a2c0579765dff17);   // 
        write_rams(9'h7f, 320'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa);   // 

        // After ML
        write_rams(9'h10, 320'h18d0e499912c4eb7e63c6c566edf02679fa1bfe1cad4b9743690353641f7697e);    // f00
        write_rams(9'h11, 320'h3db73d45143be3fd0cfa1cc1c2246299c1ae5d09df32f30603af7d970d1dd22);                                                                       // f01
        write_rams(9'h12, 320'h1aa32aab0970df6bae1737cdf5b14c4b5e4478d56ff3696e4ac8e4badbe60904);                                                                       // f10
        write_rams(9'h13, 320'h24d15a5533ce05eb31b93b55e3883bbb75264bac8b9888775e0218b187b0a962);                                                                       // f11
        write_rams(9'h14, 320'h49e592cfcb464c5256c9c666597ba7f842845968c4b49cd304e09346c128c58);                                                                       // f20
        write_rams(9'h15, 320'h1615f339204afe95ac9bccdd962204f8722bfafcb8c52e24820883dc61eee938);                                                                       // f21
        write_rams(9'h16, 320'h89aa5045ef282b1fd00c8b5f72591796c12e3789e033a030ffa41ec5b287029);                                                                       // f30
        write_rams(9'h17, 320'ha124c8a0142e1b4a70a603d550c9536d7c2a9d0409ee38e414e1586051fd495);                                                                       // f31
        write_rams(9'h18, 320'h1390b8bdff9e683f908b525591f8e45e8f7a6598a1fb57b589e5bd1adc9e6fb1);                                                                       // f40
        write_rams(9'h19, 320'hcb05560905bf777bb2af456027795584161f029a0fedd26c051194fda71e6a);                                                                       // f41
        write_rams(9'h1a, 320'h22b04080ebf98717c8ed3a6c9c9e6e7fce714c0fe8c7bc3d308418159559b83e);                                                                       // f50
        write_rams(9'h1b, 320'h11b7267bc24d434f4a66ac2e64b614cb1e333840b0b7922e6e533639df8fadc4);                                                                       // f51

    endtask

    task write_rams(input [8:0] addr, input M_tilde12_t val);
        for(integer i = 0; i < 4; i = i + 1) begin
            extin_addr <= addr + (i << 7);
            extin_data <= inttoL3(val);
            extin_en <= 1;
            #(CYCLE);
            extin_en <= 0;
        end
    endtask

    function redundant_poly_L3 inttoL3;
        input M_tilde12_t in_int;
        fp_div4_t[ADD_DIV-1:0] poly;
        poly = in_int;
        inttoL3 = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            inttoL3[i].carry = '0;
            inttoL3[i].val = poly[i];
        end
    endfunction

    function uint_fpa_t func_L1toint;
        input redundant_poly_L1 din;

        func_L1toint = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            func_L1toint = func_L1toint + (din[i] << ($bits(fp_div4_t)*i));
        end
    endfunction

    function uint_fpa_t func_L3touint;
        input redundant_poly_L3 din;

        func_L3touint = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            func_L3touint = func_L3touint + ({din[i].carry[L3_CARRY-1] ? 320'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff : '0, din[i]} << ($bits(fp_div4_t)*i));
        end
        func_L3touint = func_L3touint + {PARAMS_BN254_d0::M_tilde, 9'h000};
    endfunction

    function uint_fpa_t MR;
        input uint_fpa_t din;
        logic [999:0] tmp;
        tmp = din * PARAMS_BN254_d0::R_INV;
        MR = tmp % PARAMS_BN254_d0::Mod;
    endfunction
endmodule
