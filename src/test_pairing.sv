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

import CURVE_PARAMS::*;

`ifdef BLS12_381
    localparam bit_width = 381;
`else
    localparam bit_width = 254;
`endif 

module test_pairing;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_LOOP = 2;
                
    reg clk, rstn, run, extin_en;
    reg [3:0] n_func;
    reg [23:0] cycle_cnt;
    reg [BRAM_DEPTH-1:0] extin_addr, extout_addr;
    redundant_poly_L3 extin_data, extout_data;
    wire busy;

    wire [bit_width-1:0] debug_memout0, debug_memout1, debug_preadd0, debug_preadd1, debug_red0, debug_red1, debug_qpmm, debug_cmul, debug_postadd;
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
    wire [bit_width-1:0] debug_add_buf_0, debug_add_buf_1, debug_add_buf_2, debug_add_buf_3, debug_dly_x, debug_dly_y;
    assign debug_add_buf_0 = MR(func_L3touint(DUT.preadder.add_buf_0));
    assign debug_add_buf_1 = MR(func_L3touint(DUT.preadder.add_buf_1));
    assign debug_add_buf_2 = MR(func_L3touint(DUT.preadder.add_buf_2));
    assign debug_add_buf_3 = MR(func_L3touint(DUT.preadder.add_buf_3));
    assign debug_dly_x = MR(func_L3touint(DUT.preadder.dly_x));
    assign debug_dly_y = MR(func_L3touint(DUT.preadder.dly_y));

    //// For postadd debug
    wire [bit_width-1:0] debug_reg1_wire, debug_reg2_wire, debug_reg3_wire;
    assign debug_reg1_wire = MR(func_L3touint(DUT.postadder.reg1_wire));
    assign debug_reg2_wire = MR(func_L3touint(DUT.postadder.reg2_wire));
    assign debug_reg3_wire = MR(func_L3touint(DUT.postadder.reg3_wire));

    BN254_pairing DUT(.clk, .rstn, .run, .n_func, .endflag(), .opstart(), .busy, 
        .extin_data, .extin_en, .extin_addr, .extout_data, .extout_addr);

    always begin
        #(CYCLE/2) clk <= ~clk;
    end

    always @(posedge clk)begin
        if(run)
            cycle_cnt <= '0;
        else if(busy)
            cycle_cnt <= cycle_cnt + 1'b1;
    end
    /*-------------------------------------------
    Test
    -------------------------------------------*/
    initial begin
        clk <= 1;
        rstn <= 1;
        run <= 0;
        extout_addr <= 0;
        n_func <= 3;
        extin_en <= 0;
        #1000
        rstn <= 0;
        #100
        rstn <= 1;
        #1000;
       
        for (integer k = 0; k < N_LOOP; k = k + 1) begin
            `ifdef BLS12_381
                ram_init_BLS();
            `else
                ram_init_BN();
            `endif 
            run <= 1;
            #(CYCLE);
            run <= 0;
            #1000;
            wait(!busy);
            for(integer j=0;j<N_THREADS;j=j+1) begin
                $display("\n Thread %d\n", j);
                for(integer i=0;i<12;i=i+1) begin
                    extout_addr <= 'h10 + (j << 7)+ i;
                    #(CYCLE*5);
                    $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % CURVE_PARAMS::Mod);
                end
            end

            $display( "\n###############################################\n",
                        "%d pairings completed in %d [cycles]\n", N_THREADS, cycle_cnt,
                        "###############################################");
        end

    $finish;
    end


    task ram_init_BN;

       //Init
       write_rams(9'h08, 0, 0);                                                                       // 0 (ordinary form)
       write_rams(9'h09, 320'h1e3ad4f19ece02905cd917dec0178837a70990ae5b87678a825bfd79f8a881b8, 0);   // r^2 (ordinary form)
       write_rams(9'h0a, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d, 0);    // r (ordinary form)
       write_rams(9'h0b, 1, 0);                                                                       // 1 (ordinary form)
       write_rams(9'h0c, 320'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc, 0);   // ec_frpb_p   Overwritten
       write_rams(9'h0d, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // ec_frpb_p
       write_rams(9'h0e, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // ec_frpb_p
       write_rams(9'h0f, 320'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa, 0);   // frobFp6_8?
        
       write_rams(9'h4f, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // g300
       write_rams(9'h5d, 320'h1f6d4e3c505f417e7c275b73857179afe2c2010eeeffabeace000105f0aeb9a6, 0);   // 
       write_rams(9'h5e, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d, 0);   // 
       write_rams(9'h5f, 320'h1eff3a21bcacdbecddccf3227e232976729d52e23a2fb2554d31712d452a77f0, 0);   // 
       write_rams(9'h6d, 320'h172d23914e303a10a72e82ac1a586ca5193c1434b1ecffa1a2d6130bfe6093e, 0);   // 
       write_rams(9'h6e, 320'h181b51ef3711dc48902788c90ff150544922738e6dce3c3535d3f98098f34769, 0);   // 
       write_rams(9'h6f, 320'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc, 0);   // 
       write_rams(9'h7d, 320'h20720c5ad18fdf8de83fdb4d3fc8b040c4311425854e824f675ed25e0510812e, 0);   // 
       write_rams(9'h7e, 320'h12be28d8f88ee23c6819b6c36a9d360c965d8b62a33218074a2c0579765dff17, 0);   // 
       write_rams(9'h7f, 320'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa, 0);   // 
        
       // Test vectors generated by mcl library
       // First pairing input P, Q
       write_ram(9'h00, 320'h165a975d19ff0e09a8a7c2ea59dd80c6d02271a48b0e82ae9477221e7e7f2cb7, 0);   // Qx_0
       write_ram(9'h01, 320'he71c380b835ea161f12e388f0549896d2291fa038a92d8d1202bf4600982370, 0);   // Qx_1
       write_ram(9'h02, 320'h1f012fe65c9ef300ef562319f3e548c4c1374248fc4ab9dda8ea5789992fdf59, 0);   // Qy_0
       write_ram(9'h03, 320'h176651a9e2c944c47489f40cfb96bb043511c7b77a82aa52069125a158b5764b, 0);    // Qy_1
       write_ram(9'h04, 320'h1, 0);    // Qz_0
       write_ram(9'h05, 0, 0);                                                                       // Qz_1
       write_ram(9'h06, 320'h1f533e7ecd21721d7d3812c4879037c8e3129182db6da9d451002c82c07c8684, 0);   // Px
       write_ram(9'h07, 320'h14b8841aa46f686c257272403eb2ddf5d29a7a9b2eed83f618e0286fa64a6372, 0);   // Py

       // Second pairing input 2P, Q
       write_ram(9'h80, 320'h165a975d19ff0e09a8a7c2ea59dd80c6d02271a48b0e82ae9477221e7e7f2cb7, 0);   // Qx_0
       write_ram(9'h81, 320'he71c380b835ea161f12e388f0549896d2291fa038a92d8d1202bf4600982370, 0);   // Qx_1
       write_ram(9'h82, 320'h1f012fe65c9ef300ef562319f3e548c4c1374248fc4ab9dda8ea5789992fdf59, 0);   // Qy_0
       write_ram(9'h83, 320'h176651a9e2c944c47489f40cfb96bb043511c7b77a82aa52069125a158b5764b, 0);    // Qy_1
       write_ram(9'h84, 320'h1, 0);    // Qz_0
       write_ram(9'h85, 0, 0);                                                                       // Qz_1
       write_ram(9'h86, 320'h207f399f16ce1a2c1375d67f31acf4eaabbf2ffc67b4018007db6384c3f0d40, 0);   // Px
       write_ram(9'h87, 320'hca7d2bc8e46f1a1c8e26d7d38ef6f2be7a8c7bcbd0e1832802ce49eb94c24d6, 0);   // Py 
        
      // Third pairing input P, 2Q
       write_ram(9'h100, 320'h1dc527783bb000859f9706d7374afa3d7b1e142b0622519c8399298000f2aefc, 0);   // Qx_0
       write_ram(9'h101, 320'h1ff707294f4c30ef423cecab0a0e964c3d99eed7a153cf546985154cb6ad45c0, 0);   // Qx_1
       write_ram(9'h102, 320'h1c04ac49d0df85fb1060eb945a7411950b70783a8e6a2738b93e08d5c9c7061b, 0);   // Qy_0
       write_ram(9'h103, 320'h1d6f1dfe65ded635dead872494a6141dbb57bd59051da9ae96d07708d49ccc1d, 0);    // Qy_1
       write_ram(9'h104, 320'h1, 0);    // Qz_0
       write_ram(9'h105, 0, 0);                                                                       // Qz_1
       write_ram(9'h106, 320'h1f533e7ecd21721d7d3812c4879037c8e3129182db6da9d451002c82c07c8684, 0);   // Px
       write_ram(9'h107, 320'h14b8841aa46f686c257272403eb2ddf5d29a7a9b2eed83f618e0286fa64a6372, 0);   // Py

      // 4th pairing input 2P, 2Q
       write_ram(9'h180, 320'h1dc527783bb000859f9706d7374afa3d7b1e142b0622519c8399298000f2aefc, 0);   // Qx_0
       write_ram(9'h181, 320'h1ff707294f4c30ef423cecab0a0e964c3d99eed7a153cf546985154cb6ad45c0, 0);   // Qx_1
       write_ram(9'h182, 320'h1c04ac49d0df85fb1060eb945a7411950b70783a8e6a2738b93e08d5c9c7061b, 0);   // Qy_0
       write_ram(9'h183, 320'h1d6f1dfe65ded635dead872494a6141dbb57bd59051da9ae96d07708d49ccc1d, 0);    // Qy_1
       write_ram(9'h184, 320'h1, 0);    // Qz_0
       write_ram(9'h185, 0, 0);                                                                       // Qz_1
       write_ram(9'h186, 320'h207f399f16ce1a2c1375d67f31acf4eaabbf2ffc67b4018007db6384c3f0d40, 0);   // Px
       write_ram(9'h187, 320'hca7d2bc8e46f1a1c8e26d7d38ef6f2be7a8c7bcbd0e1832802ce49eb94c24d6, 0);   // Py

        if (N_THREADS > 4) begin
           //5th pairing input 4P, Q
           write_ram(10'h200, 320'h18385828e1e41b2a859c200caf5f9cc4d2b9011f41994717a18a22429704e210, 0);   // Qx_0
           write_ram(10'h201, 320'h177e7c7d4889ee15a8b6ecb1d9a734286c7c1bc1442a3b83599a4251eab78ba8, 0);   // Qx_1
           write_ram(10'h202, 320'h1e7f757bc9b6464bf6d4e58e226e9c99629939da2567751118aff08d67fb3dbb, 0);   // Qy_0
           write_ram(10'h203, 320'h118f6ee1a22fecf493454224f604ebfb98337fce97b56c0ecad2f655c2525aa0, 0);    // Qy_1
           write_ram(10'h204, 320'h1, 0);    // Qz_0
           write_ram(10'h205, 0, 0);                                                                       // Qz_1
           write_ram(10'h206, 320'h1f533e7ecd21721d7d3812c4879037c8e3129182db6da9d451002c82c07c8684, 0);   // Px
           write_ram(10'h207, 320'h14b8841aa46f686c257272403eb2ddf5d29a7a9b2eed83f618e0286fa64a6372, 0);   // Py
        end
    endtask

    task ram_init_BLS;

       //Init
        write_rams('h08, 0, 0);                                                                       // 0 (ordinary form)
        write_rams('h09, 'h1e3ad4f19ece02905cd917dec0178837a70990ae5b87678a825bfd79f8a881b8, 0);   // r^2 (ordinary form)
        write_rams('h0a, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // r (ordinary form)
        write_rams('h0b, 1, 0);                                                                       // 1 (ordinary form)
        write_rams('h0c, 'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc, 0);   // ec_frpb_p   Overwritten
        write_rams('h0d, 'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // ec_frpb_p
        write_rams('h0e, 'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // ec_frpb_p
        write_rams('h0f, 'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa, 0);   // frobFp6_8?
        write_rams('h10, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // f00 = r = 1
        write_rams('h11, 0, 0);                                                                       // f01
        write_rams('h12, 0, 0);                                                                       // f10
        write_rams('h13, 0, 0);                                                                       // f11
        write_rams('h14, 0, 0);                                                                       // f20
        write_rams('h15, 0, 0);                                                                       // f21
        write_rams('h16, 0, 0);                                                                       // f30
        write_rams('h17, 0, 0);                                                                       // f31
        write_rams('h18, 0, 0);                                                                       // f40
        write_rams('h19, 0, 0);                                                                       // f41
        write_rams('h1a, 0, 0);                                                                       // f50
        write_rams('h1b, 0, 0);                                                                       // f51

        write_rams('h4f, 'h1918b2ff37a01105c6d89cb6c86510d3555f2b61aa5057b0fc05b83ae17d6c6469221c3ba0fe05f053c8b3106d013e3c, 0);   // g300
        write_rams('h5d, 'h13daa341cf52bed04b6d2bec1eecbc289f43119238a9a8bae636d179ace83886407d32fb27683705f5d5e2ae2c03f7de, 0);   // 
        write_rams('h5e, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d, 0);   // 
        write_rams('h5f, 'he85eeb01dfd59484430aff7ae69c040f1820234934bb0e6b2b1a66153389bfb589e3c31055fa0f66364cef92fe6c6f, 0);   // 
        write_rams('h6d, 'h81d087ad6d7893b702027a69aebf999836f9105301cd26ea88be9e5ae0fb8a377b5eee1c438490410cb7ffa2f25871b, 0);   // 
        write_rams('h6e, 'hc6a9d1d384250dd75d04badabf41e7a17d1ed82797158456614b482b5df19ea82e45e0af305065ec279aa0199419789, 0);   // 
        write_rams('h6f, 'h6442e74ce1529137621cfe387952dcb529db38fbe95ee40e51ab35b6c165c4ca4b5910769193d64fe508cafc545e4bc, 0);   // 
        write_rams('h7d, 'h9056765d8b75ecff46332a615d2959d9287b12879518d7d13b7044bc34342632d3fd2a4d48e43137701cce9c223f38a, 0);   // 
        write_rams('h7e, 'h13bce3756b6abd86d4f9d7d2bbb67f0c11d997f534ef247e82161f458a9a99d779f66ef7483ac29abbae73503ab9c5ef, 0);   // 
        write_rams('h7f, 'hd9674cd013d95bcd54b5c0897578e5d4ca55e027a13ba7a011c1e1e40d1dc399bc7a1f3be4ef9a0f78555fe66be1322, 0);   // 
        
        

        //input RAM0
        //Q
        write_ram('h00, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);   // Qx_0
        write_ram('h01, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);   // Qx_1
        write_ram('h02, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);   // Qy_0
        write_ram('h03, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);    // Qy_1
        write_ram('h04, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // Qz_0
        write_ram('h05, 0, 0);   // Qz_1
        //P                                                                    
        write_ram('h06, 'h1860eac3d6a95df6e3eeb0e1fc6b63665a43e04e717c672e6f948a8cbcb20fc0b91497f7148bc43b0c7957ae8a7ef407, 0);   // Px
        write_ram('h07, 'hfc3609f47066f909d63f8e2381d5404bc703555b49eed2a45f1c15fbc47ab6dc898c1e07266b9306d3ee6b56b373a71, 0);   // Py
        // Pz
        //T
        write_ram('h20, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);   // Tx_0
        write_ram('h21, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);   // Tx_1
        write_ram('h22, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);   // Ty_0
        write_ram('h23, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);    // Ty_1
        write_ram('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // Tz_0
        write_ram('h25, 0, 0);                                                                       // Tz_1
    //input RAM1
        //10Q
        write_ram('h80, 'h1638533957d540a9d2370f17cc7ed5863bc0b995b8825e0ee1ea1e1e4d00dbae81f14b0bf3611b78c952aacab827a053, 1);    //Qx_0
        write_ram('h81, 'h0a4edef9c1ed7f729f520e47730a124fd70662a904ba1074728114d1031e1572c6c886f6b57ec72a6178288c47c33577, 1);   //Qx_1
        write_ram('h82, 'h0468fb440d82b0630aeb8dca2b5256789a66da69bf91009cbfe6bd221e47aa8ae88dece9764bf3bd999d95d71e4c9899, 1);    //Qy_0
        write_ram('h83, 'h0f6d4552fa65dd2638b361543f887136a43253d9c66c411697003f7a13c308f5422e1aa0a59c8967acdefd8b6e36ccf3, 1);    //Qy_1
        write_ram('h84, 'h1, 1);    //Qz_0        
        write_ram('h85, '0, 1);                                                                      //Qz_1
        //P
        write_ram('h86, 'h17f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb, 1);   // Px
        write_ram('h87, 'h08b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1, 1);   // Py
        // Pz
        //T
        write_ram('ha0, 'h1638533957d540a9d2370f17cc7ed5863bc0b995b8825e0ee1ea1e1e4d00dbae81f14b0bf3611b78c952aacab827a053, 1);   // Tx_0
        write_ram('ha1, 'h0a4edef9c1ed7f729f520e47730a124fd70662a904ba1074728114d1031e1572c6c886f6b57ec72a6178288c47c33577, 1);   // Tx_1
        write_ram('ha2, 'h0468fb440d82b0630aeb8dca2b5256789a66da69bf91009cbfe6bd221e47aa8ae88dece9764bf3bd999d95d71e4c9899, 1);   // Ty_0
        write_ram('ha3, 'h0f6d4552fa65dd2638b361543f887136a43253d9c66c411697003f7a13c308f5422e1aa0a59c8967acdefd8b6e36ccf3, 1);    // Ty_1
        write_ram('ha4, 'h1, 1);    // Tz_0
        write_ram('ha5, 0, 1);    
                                                                  
        //input RAM2
        //Q
        write_ram('h100, 'h024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8, 1);
        write_ram('h101, 'h13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e, 1);
        write_ram('h102, 'h0ce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801, 1);
        write_ram('h103, 'h0606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be, 1);
        write_ram('h104, 'h1, 1);
        write_ram('h105, 'h0, 0);
        //10P
        write_ram('h106, 'h0572cbea904d67468808c8eb50a9450c9721db309128012543902d0ac358a62ae28f75bb8f1c7c42c39a8c5529bf0f4e, 1);
        write_ram('h107, 'h166a9d8cabc673a322fda673779d8e3822ba3ecb8670e461f73bb9021d5fd76a4c56d9d4cd16bd1bba86881979749d28, 1);
         //T
        write_ram('h120, 'h024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8, 1);   // Tx_0
        write_ram('h121, 'h13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e, 1);   // Tx_1
        write_ram('h122, 'h0ce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801, 1);   // Ty_0
        write_ram('h123, 'h0606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be, 1);    // Ty_1
        write_ram('h124, 'h1, 1);    // Tz_0
        write_ram('h125, 0, 1);  

        //input RAM3
        //Q
        write_ram('h180, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);   // Qx_0
        write_ram('h181, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);   // Qx_1
        write_ram('h182, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);   // Qy_0
        write_ram('h183, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);    // Qy_1
        write_ram('h184, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // Qz_0
        write_ram('h185, 0, 0);   // Qz_1
        //P                                                                    
        write_ram('h186, 'h1860eac3d6a95df6e3eeb0e1fc6b63665a43e04e717c672e6f948a8cbcb20fc0b91497f7148bc43b0c7957ae8a7ef407, 0);   // Px
        write_ram('h187, 'hfc3609f47066f909d63f8e2381d5404bc703555b49eed2a45f1c15fbc47ab6dc898c1e07266b9306d3ee6b56b373a71, 0);   // Py
        // Pz
        //T
        write_ram('h1a0, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);   // Tx_0
        write_ram('h1a1, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);   // Tx_1
        write_ram('h1a2, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);   // Ty_0
        write_ram('h1a3, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);    // Ty_1
        write_ram('h1a4, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // Tz_0
        write_ram('h1a5, 0, 0);                                                                       // Tz_1

        //input RAM4
        //Q
        write_ram('h200, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);
        write_ram('h201, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);
        write_ram('h202, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);
        write_ram('h203, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);
        write_ram('h204, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);
        write_ram('h205, 'h0, 0);
        //2P
        write_ram('h206, 'h135939fd3cd20b24945f8ad96a0acb9cb8f92ca6b8604ceae4d1bb58648157f4006e4521767b8a28454b0066d995a60, 0);
        write_ram('h207, 'h104e465233f2029c658cd507eb3d7f3d4b8ea37c977b1e5b6113ea23218e2400b7418ec83c23c805053743d13f8f51cc, 0);
         //T
        write_ram('h220, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);   // Tx_0
        write_ram('h221, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);   // Tx_1
        write_ram('h222, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);   // Ty_0
        write_ram('h223, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);    // Ty_1
        write_ram('h224, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // Tz_0
        write_ram('h225, 0, 0);  

        if (N_THREADS > 5) begin
            //input RAM5
            //Q
            write_ram('h280, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);   // Qx_0
            write_ram('h281, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);   // Qx_1
            write_ram('h282, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);   // Qy_0
            write_ram('h283, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);    // Qy_1
            write_ram('h284, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // Qz_0
            write_ram('h285, 0, 0);   // Qz_1
            //P                                                                    
            write_ram('h286, 'h1860eac3d6a95df6e3eeb0e1fc6b63665a43e04e717c672e6f948a8cbcb20fc0b91497f7148bc43b0c7957ae8a7ef407, 0);   // Px
            write_ram('h287, 'hfc3609f47066f909d63f8e2381d5404bc703555b49eed2a45f1c15fbc47ab6dc898c1e07266b9306d3ee6b56b373a71, 0);   // Py
            // Pz
            //T
            write_ram('h2a0, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f, 0);   // Tx_0
            write_ram('h2a1, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917, 0);   // Tx_1
            write_ram('h2a2, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6, 0);   // Ty_0
            write_ram('h2a3, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53, 0);    // Ty_1
            write_ram('h2a4, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd, 0);    // Tz_0
            write_ram('h2a5, 0, 0);                                                                       // Tz_1
        end
    endtask

    
    task write_ram(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val, input MR);
        // If MR = 1, the input val is transformed in Mongomery domain
        reg [999:0] tmp_val;
        tmp_val = val*CURVE_PARAMS::RmodM;
        extin_addr <= addr;
        extin_data <= inttoL3((MR)? tmp_val % CURVE_PARAMS::Mod : val);
        extin_en <= 1;
        #(CYCLE);
        extin_en <= 0;

    endtask
    
    task write_rams(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val, input MR);
        for(integer i = 0; i < N_THREADS; i = i + 1) begin
             write_ram(addr + (i << 7), val, MR);
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

    function uint_fpa_t func_L3tolazyuint;
        input redundant_poly_L3 din;

        func_L3tolazyuint = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            func_L3tolazyuint = func_L3tolazyuint + (din[i].val << ($bits(fp_div4_t)*i));
        end
    endfunction

    function uint_fpa_t func_L3touint;
        input redundant_poly_L3 din;

        func_L3touint = 0;
        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
            func_L3touint = func_L3touint + ({din[i].carry[L3_CARRY-1] ? 'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff : '0, din[i]} << ($bits(fp_div4_t)*i));
        end
        func_L3touint = func_L3touint + {CURVE_PARAMS::M_tilde, 9'h000};
    endfunction

    function uint_fpa_t MR;
        input uint_fpa_t din;
        logic [999:0] tmp;
        tmp = din * CURVE_PARAMS::R_INV;
        MR = tmp % CURVE_PARAMS::Mod;
    endfunction
endmodule

