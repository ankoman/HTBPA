//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: YNU
//// Engineer: Junichi Sakamoto
//// 
//// Create Date: 2022/10/21 17:45:33
//// Design Name: 
//// Module Name: test_pairing
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////

//import PARAMS_BN254_d0::*;

////localparam bit_width = 381; // BLS
//localparam bit_width = 256; //BN

//module test_pairing;
//    localparam 
//        CYCLE = 10,
//        DELAY = 2,
//        N_DATA = 1000000;
               
//    reg clk, rstn, run, swrst, extin_en;
//    reg [3:0] n_func;
//    reg [BRAM_DEPTH-1:0] extin_addr, extout_addr;
//    redundant_poly_L3 extin_data, extout_data;
//    wire busy;

//    wire [bit_width-1:0] debug_memout0, debug_memout1, debug_preadd0, debug_preadd1, debug_red0, debug_red1, debug_qpmm, debug_cmul, debug_postadd;
//    assign debug_memout0 = MR(func_L3touint(DUT.memout0));
//    assign debug_memout1 = MR(func_L3touint(DUT.memout1));
//    assign debug_preadd0 = MR(func_L3touint(DUT.preadd_out0));
//    assign debug_preadd1 = MR(func_L3touint(DUT.preadd_out1));
//    assign debug_red0 = MR(DUT.red_out0);
//    assign debug_red1 = MR(DUT.red_out1);
//    assign debug_qpmm = MR(DUT.qpmm_out);
//    assign debug_cmul = MR(func_L1toint(DUT.cmul_out));
//    assign debug_postadd = MR(func_L3touint(DUT.postadd_out));

//    //// For preadd debug
//    wire [bit_width-1:0] debug_add_buf_0, debug_add_buf_1, debug_add_buf_2, debug_add_buf_3, debug_dly_x, debug_dly_y;
//    assign debug_add_buf_0 = MR(func_L3touint(DUT.preadder.add_buf_0));
//    assign debug_add_buf_1 = MR(func_L3touint(DUT.preadder.add_buf_1));
//    assign debug_add_buf_2 = MR(func_L3touint(DUT.preadder.add_buf_2));
//    assign debug_add_buf_3 = MR(func_L3touint(DUT.preadder.add_buf_3));
//    assign debug_dly_x = MR(func_L3touint(DUT.preadder.dly_x));
//    assign debug_dly_y = MR(func_L3touint(DUT.preadder.dly_y));

//    //// For postadd debug
//    wire [bit_width-1:0] debug_reg1_wire, debug_reg2_wire, debug_reg3_wire;
//    assign debug_reg1_wire = MR(func_L3touint(DUT.postadder.reg1_wire));
//    assign debug_reg2_wire = MR(func_L3touint(DUT.postadder.reg2_wire));
//    assign debug_reg3_wire = MR(func_L3touint(DUT.postadder.reg3_wire));

//    BN254_pairing DUT(.clk, .rstn, .swrst, .run, .n_func, .endflag(), .opstart(), .busy, 
//       .extin_data, .extin_en, .extin_addr, .extout_data, .extout_addr);
    
//    always begin
//        #(CYCLE/2) clk <= ~clk;
//    end
    
//    /*-------------------------------------------
//    Test
//    -------------------------------------------*/
//    initial begin
//        clk <= 1;
//        rstn <= 1;
//        run <= 0;
//        swrst <= 0;
//        extout_addr <= 0;
//        n_func <= 3;
//        extin_en <= 0;
//        #1000
//        rstn <= 0;
//        #100
//        rstn <= 1;
//        #1000;
//        swrst <= 1;
//        #100;
//        ram_init_BN();
 
//        swrst <= 0;
//        run <= 1;
//        #(CYCLE);
//        run <= 0;
//        #1000;
//        wait(!busy);
        
//        $display("\nFirst pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h10 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
//        $display("\nSecond pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h90 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
//        $display("\nThird pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h110 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
//        $display("\n4th pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h190 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
        
//        ram_init_BN();

//        swrst <= 0;
//        run <= 1;
//        #(CYCLE);
//        run <= 0;
//        #1000;
//        wait(!busy);
        
//        $display("\nFirst pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h10 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
//        $display("\nSecond pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h90 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
//        $display("\nThird pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h110 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
//        $display("\n4th pairing \n");
//        for(integer i=0;i<12;i=i+1) begin
//            extout_addr <= 'h190 + i;
//            #(CYCLE*5);
//            $display("i = %d: %h", i, func_L3tolazyuint(extout_data) % PARAMS_BN254_d0::Mod);
//        end
//    $finish;
//    end


//    task ram_init_BN;

//        //Init
//        write_rams(9'h08, 0, 0);                                                                       // 0 (ordinary form)
//        write_rams(9'h09, 320'h1e3ad4f19ece02905cd917dec0178837a70990ae5b87678a825bfd79f8a881b8, 0);   // r^2 (ordinary form)
//        write_rams(9'h0a, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d, 0);    // r (ordinary form)
//        write_rams(9'h0b, 1, 0);                                                                       // 1 (ordinary form)
//        write_rams(9'h0c, 320'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc, 0);   // ec_frpb_p   Overwritten
//        write_rams(9'h0d, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // ec_frpb_p
//        write_rams(9'h0e, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // ec_frpb_p
//        write_rams(9'h0f, 320'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa, 0);   // frobFp6_8?
        
//        write_rams(9'h4f, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823, 0);   // g300
//        write_rams(9'h5d, 320'h1f6d4e3c505f417e7c275b73857179afe2c2010eeeffabeace000105f0aeb9a6, 0);   // 
//        write_rams(9'h5e, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d, 0);   // 
//        write_rams(9'h5f, 320'h1eff3a21bcacdbecddccf3227e232976729d52e23a2fb2554d31712d452a77f0, 0);   // 
//        write_rams(9'h6d, 320'h172d23914e303a10a72e82ac1a586ca5193c1434b1ecffa1a2d6130bfe6093e, 0);   // 
//        write_rams(9'h6e, 320'h181b51ef3711dc48902788c90ff150544922738e6dce3c3535d3f98098f34769, 0);   // 
//        write_rams(9'h6f, 320'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc, 0);   // 
//        write_rams(9'h7d, 320'h20720c5ad18fdf8de83fdb4d3fc8b040c4311425854e824f675ed25e0510812e, 0);   // 
//        write_rams(9'h7e, 320'h12be28d8f88ee23c6819b6c36a9d360c965d8b62a33218074a2c0579765dff17, 0);   // 
//        write_rams(9'h7f, 320'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa, 0);   // 
        
        
//        // First pairing input P, Q
//        write_ram(9'h00, 320'h165a975d19ff0e09a8a7c2ea59dd80c6d02271a48b0e82ae9477221e7e7f2cb7, 0);   // Qx_0
//        write_ram(9'h01, 320'he71c380b835ea161f12e388f0549896d2291fa038a92d8d1202bf4600982370, 0);   // Qx_1
//        write_ram(9'h02, 320'h1f012fe65c9ef300ef562319f3e548c4c1374248fc4ab9dda8ea5789992fdf59, 0);   // Qy_0
//        write_ram(9'h03, 320'h176651a9e2c944c47489f40cfb96bb043511c7b77a82aa52069125a158b5764b, 0);    // Qy_1
//        write_ram(9'h04, 320'h1, 0);    // Qz_0
//        write_ram(9'h05, 0, 0);                                                                       // Qz_1
//        write_ram(9'h06, 320'h1f533e7ecd21721d7d3812c4879037c8e3129182db6da9d451002c82c07c8684, 0);   // Px
//        write_ram(9'h07, 320'h14b8841aa46f686c257272403eb2ddf5d29a7a9b2eed83f618e0286fa64a6372, 0);   // Py

        
//        // Second pairing input 2P, Q
//        write_ram(9'h80, 320'h165a975d19ff0e09a8a7c2ea59dd80c6d02271a48b0e82ae9477221e7e7f2cb7, 0);   // Qx_0
//        write_ram(9'h81, 320'he71c380b835ea161f12e388f0549896d2291fa038a92d8d1202bf4600982370, 0);   // Qx_1
//        write_ram(9'h82, 320'h1f012fe65c9ef300ef562319f3e548c4c1374248fc4ab9dda8ea5789992fdf59, 0);   // Qy_0
//        write_ram(9'h83, 320'h176651a9e2c944c47489f40cfb96bb043511c7b77a82aa52069125a158b5764b, 0);    // Qy_1
//        write_ram(9'h84, 320'h1, 0);    // Qz_0
//        write_ram(9'h85, 0, 0);                                                                       // Qz_1
//        write_ram(9'h86, 320'h207f399f16ce1a2c1375d67f31acf4eaabbf2ffc67b4018007db6384c3f0d40, 0);   // Px
//        write_ram(9'h87, 320'hca7d2bc8e46f1a1c8e26d7d38ef6f2be7a8c7bcbd0e1832802ce49eb94c24d6, 0);   // Py 
        
        
//       // Third pairing input P, 2Q
//        write_ram(9'h100, 320'h1dc527783bb000859f9706d7374afa3d7b1e142b0622519c8399298000f2aefc, 0);   // Qx_0
//        write_ram(9'h101, 320'h1ff707294f4c30ef423cecab0a0e964c3d99eed7a153cf546985154cb6ad45c0, 0);   // Qx_1
//        write_ram(9'h102, 320'h1c04ac49d0df85fb1060eb945a7411950b70783a8e6a2738b93e08d5c9c7061b, 0);   // Qy_0
//        write_ram(9'h103, 320'h1d6f1dfe65ded635dead872494a6141dbb57bd59051da9ae96d07708d49ccc1d, 0);    // Qy_1
//        write_ram(9'h104, 320'h1, 0);    // Qz_0
//        write_ram(9'h105, 0, 0);                                                                       // Qz_1
//        write_ram(9'h106, 320'h1f533e7ecd21721d7d3812c4879037c8e3129182db6da9d451002c82c07c8684, 0);   // Px
//        write_ram(9'h107, 320'h14b8841aa46f686c257272403eb2ddf5d29a7a9b2eed83f618e0286fa64a6372, 0);   // Py


//       // 4th pairing input 2P, 2Q
//        write_ram(9'h180, 320'h1dc527783bb000859f9706d7374afa3d7b1e142b0622519c8399298000f2aefc, 0);   // Qx_0
//        write_ram(9'h181, 320'h1ff707294f4c30ef423cecab0a0e964c3d99eed7a153cf546985154cb6ad45c0, 0);   // Qx_1
//        write_ram(9'h182, 320'h1c04ac49d0df85fb1060eb945a7411950b70783a8e6a2738b93e08d5c9c7061b, 0);   // Qy_0
//        write_ram(9'h183, 320'h1d6f1dfe65ded635dead872494a6141dbb57bd59051da9ae96d07708d49ccc1d, 0);    // Qy_1
//        write_ram(9'h184, 320'h1, 0);    // Qz_0
//        write_ram(9'h185, 0, 0);                                                                       // Qz_1
//        write_ram(9'h186, 320'h207f399f16ce1a2c1375d67f31acf4eaabbf2ffc67b4018007db6384c3f0d40, 0);   // Px
//        write_ram(9'h187, 320'hca7d2bc8e46f1a1c8e26d7d38ef6f2be7a8c7bcbd0e1832802ce49eb94c24d6, 0);   // Py

//    endtask

//    task ram_init_BLS;

//        // Almost inputs are Montgomery form
////        write_rams('h00, 'hdf4b8af9746f731eb102e37bfdab7e29ce9d97ae2b7046df03622f1568b576a);   // Qx_0
////        write_rams('h01, 'h1b6d06e2282f8434be29699dddb004ecedaaa8152cd3082464fa2162d36870a5);   // Qx_1
////        write_rams('h02, 'h3e16a641e9f3ce130e6ec789f41c190d9792f757e643c8319c67a83bf14f68);   // Qy_0
////        write_rams('h03, 'h1a53f52eb682ea1c805a889cabababb022121eb047104c624387d79815953f96);    // Qy_1
////        write_rams('h04, 'h193b2c4b527f2b1f249612e38fe76c1292fa4721a6c6f23463ef84a7591c173e);    // Qz_0
////        write_rams('h05, 0);                                                                       // Qz_1
////        write_rams('h06, 'h5aedec8f3900eafc21a6b9e4e310cfdfa302dab947f4c5dbb64d9b53ee87849);   // Px
////        write_rams('h07, 'hcbfaad8f4278ee0b0448c9c7ca492900afa8e7401209607eee50e6249c93d91);   // Py
////        // Pz
////        write_rams('h09, 'h1590eecd31b5fe744d06912ae87b9d8555221eae39569dd56985466f53e937f0);   // r^2 (ordinary form)
////        write_rams('h0a, 'h193b2c4b527f2b1f249612e38fe76c1292fa4721a6c6f23463ef84a7591c173e);    // r (ordinary form)
////        write_rams('h0b, 1);                                                                       // 1 (ordinary form)
////        write_rams('h0c, 'h11f19657facc549adefe480d6f056833d2857542c9d1a28ecd1dc5347f334cf);   // ec_frpb_p
////        write_rams('h0d, 'h93d8a46d44a06f6f1a1884ee227cce38db1c2ad25fa7ef135c9c7e5bf397b6d);   // ec_frpb_p
////        write_rams('h0e, 'h93d8a46d44a06f6f1a1884ee227cce38db1c2ad25fa7ef135c9c7e5bf397b6d);   // ec_frpb_p
////        write_rams('h0f, 'hac91ed16dd40f98e7ae561b99283d7290fe618a2c9bf3b6563e9f055ef0b406);   // frobFp6_8?


////        write_rams('h10, 'h193b2c4b527f2b1f249612e38fe76c1292fa4721a6c6f23463ef84a7591c173e);    // f00 = r = 1
////        write_rams('h11, 0);                                                                       // f01
////        write_rams('h12, 0);                                                                       // f10
////        write_rams('h13, 0);                                                                       // f11
////        write_rams('h14, 0);                                                                       // f20
////        write_rams('h15, 0);                                                                       // f21
////        write_rams('h16, 0);                                                                       // f30
////        write_rams('h17, 0);                                                                       // f31
////        write_rams('h18, 0);                                                                       // f40
////        write_rams('h19, 0);                                                                       // f41
////        write_rams('h1a, 0);                                                                       // f50
////        write_rams('h1b, 0);                                                                       // f51

////        write_rams('h20, 'hdf4b8af9746f731eb102e37bfdab7e29ce9d97ae2b7046df03622f1568b576a);   // Tx_0
////        write_rams('h21, 'h1b6d06e2282f8434be29699dddb004ecedaaa8152cd3082464fa2162d36870a5);   // Tx_1
////        write_rams('h22, 'h3e16a641e9f3ce130e6ec789f41c190d9792f757e643c8319c67a83bf14f68);   // Ty_0
////        write_rams('h23, 'h1a53f52eb682ea1c805a889cabababb022121eb047104c624387d79815953f96);    // Ty_1
////        write_rams('h24, 'h193b2c4b527f2b1f249612e38fe76c1292fa4721a6c6f23463ef84a7591c173e);    // Tz_0
////        write_rams('h25, 0);                                                                       // Tz_1       


//        // // Almost inputs are Montgomery form
//        // write_rams('h00, 'h45fbd8f8d52b136278c32a8c1d5de69d2e66769f75656b9103c9dd1fba39bd6863a8329efc5716eb7609c24cde9a4bd);   // Qx_0
//        // write_rams('h01, 'h8de0f2a16b0f898812a85f807fcf8b14246f7b97e7264734bffd291b1adaf117f2460c085a9117d80d3c8e1fc6d98cc);   // Qx_1
//        // write_rams('h02, 'h142a181afef8ed20b7286c5003f0c3637f171cc5a6d83b9ce6f56be6112945c27730987182fe8b6518a95c82a14103f0);   // Qy_0
//        // write_rams('h03, 'h24877e84cc22df73bdb0a13858b27bd4d2af7a097b8bbb36793be3c80f5551508ae5039815e1a8f9d76bb559c0c7bfe);    // Qy_1
//        // write_rams('h04, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Qz_0
//        // write_rams('h05, 0);                                                                       // Qz_1
//        // write_rams('h06, 'h3bbdd05662a61bb1cfa274424913afa85292cc7bc983baa8e677e3a40bcf3b663eecb0f04510559375cd226350d2b93);   // Px
//        // write_rams('h07, 'he61e4e35d46c72cd86427e942de1c92db98f02f1f7fba79849442a809d05d9bef464169d71076e847b4a8981b79a7ff);   // Py
//        // // Pz
//        // write_rams('h09, 'h11e41d6827510424302748620c16c6767000b6609ab32f0bbce50a9fa478fa904fb1a226d7c8c3b38ac02e272c3d3bb1);   // r^2 (ordinary form)
//        // write_rams('h0a, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // r (ordinary form)
//        // write_rams(9'h0b, 1);                                                                       // 1 (ordinary form)
//        // write_rams(9'h0c, 320'h12653ba947711dc5521a96bc9562c9fbcac3749d5ccde80c5cd3fa8689a200fc);   // ec_frpb_p
//        // write_rams(9'h0d, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823);   // ec_frpb_p
//        // write_rams(9'h0e, 320'h6242a6083532414dc675a5d81dcd691ee83ad1dc5d04dbe59ce8ed2bad58823);   // ec_frpb_p
//        // write_rams(9'h0f, 320'hd08129308ee23b92a0cc4b6f00eafb417fe8c719231c3de712c067f670cb8aa);   // frobFp6_8?


//        // write_rams('h10, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // f00 = r = 1
//        // write_rams('h11, 0);                                                                       // f01
//        // write_rams('h12, 0);                                                                       // f10
//        // write_rams('h13, 0);                                                                       // f11
//        // write_rams('h14, 0);                                                                       // f20
//        // write_rams('h15, 0);                                                                       // f21
//        // write_rams('h16, 0);                                                                       // f30
//        // write_rams('h17, 0);                                                                       // f31
//        // write_rams('h18, 0);                                                                       // f40
//        // write_rams('h19, 0);                                                                       // f41
//        // write_rams('h1a, 0);                                                                       // f50
//        // write_rams('h1b, 0);                                                                       // f51

//        // write_rams('h20, 'h45fbd8f8d52b136278c32a8c1d5de69d2e66769f75656b9103c9dd1fba39bd6863a8329efc5716eb7609c24cde9a4bd);   // Tx_0
//        // write_rams('h21, 'h8de0f2a16b0f898812a85f807fcf8b14246f7b97e7264734bffd291b1adaf117f2460c085a9117d80d3c8e1fc6d98cc);   // Tx_1
//        // write_rams('h22, 'h142a181afef8ed20b7286c5003f0c3637f171cc5a6d83b9ce6f56be6112945c27730987182fe8b6518a95c82a14103f0);   // Ty_0
//        // write_rams('h23, 'h24877e84cc22df73bdb0a13858b27bd4d2af7a097b8bbb36793be3c80f5551508ae5039815e1a8f9d76bb559c0c7bfe);    // Ty_1
//        // write_rams('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Tz_0
//        // write_rams('h25, 0);                                                                       // Tz_1                                                                  // f51

//    endtask

    
//    task write_ram(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val, input MR);
//        reg [999:0] tmp_val;
//        tmp_val = val*PARAMS_BN254_d0::RmodM;
//        extin_addr <= addr;
//        extin_data <= inttoL3((MR)? tmp_val % PARAMS_BN254_d0::Mod : val);
//        extin_en <= 1;
//        #(CYCLE);
//        extin_en <= 0;

//    endtask
    
//    task write_rams(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val, input MR);
//        for(integer i = 0; i < N_THREADS; i = i + 1) begin
//            write_ram(addr + (i << 7), val, MR);
//        end
//    endtask

//    function redundant_poly_L3 inttoL3;
//        input M_tilde12_t in_int;
//        fp_div4_t[ADD_DIV-1:0] poly;
//        poly = in_int;
//        inttoL3 = 0;
//        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
//            inttoL3[i].carry = '0;
//            inttoL3[i].val = poly[i];
//        end
//    endfunction

//    function uint_fpa_t func_L1toint;
//        input redundant_poly_L1 din;

//        func_L1toint = 0;
//        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
//            func_L1toint = func_L1toint + (din[i] << ($bits(fp_div4_t)*i));
//        end
//    endfunction

//    function uint_fpa_t func_L3tolazyuint;
//        input redundant_poly_L3 din;

//        func_L3tolazyuint = 0;
//        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
//            func_L3tolazyuint = func_L3tolazyuint + (din[i].val << ($bits(fp_div4_t)*i));
//        end
//    endfunction

//    function uint_fpa_t func_L3touint;
//        input redundant_poly_L3 din;

//        func_L3touint = 0;
//        for(integer i = 0; i < ADD_DIV; i = i + 1) begin
//            func_L3touint = func_L3touint + ({din[i].carry[L3_CARRY-1] ? 'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff : '0, din[i]} << ($bits(fp_div4_t)*i));
//        end
//        func_L3touint = func_L3touint + {PARAMS_BN254_d0::M_tilde, 9'h000};
//    endfunction

//    function uint_fpa_t MR;
//        input uint_fpa_t din;
//        logic [999:0] tmp;
//        tmp = din * PARAMS_BN254_d0::R_INV;
//        MR = tmp % PARAMS_BN254_d0::Mod;
//    endfunction
//endmodule


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

localparam bit_width = 381; // BLS
// localparam bit_width = 256; //BN

module test_pairing;
    localparam 
        CYCLE = 10,
        DELAY = 2,
        N_DATA = 1000000;
               
    reg clk, rstn, run, swrst, extin_en;
    reg [3:0] n_func;
    reg [BRAM_DEPTH-1:0] extin_addr, extout_addr;
    redundant_poly_L3 extin_data;
    wire [289-1:0] extout_data;
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

    BN254_pairing DUT(.clk, .rstn, .swrst, .run, .n_func, .endflag(), .opstart(), .busy, 
       .extin_data, .extin_en, .extin_addr, .extout_data(extout_data), .extout_addr);
    
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
        extout_addr <= 0;
        n_func <= 3;
        extin_en <= 0;
        #1000
        rstn <= 0;
        #100
        rstn <= 1;
        #1000;
        swrst <= 1;
        #100;
        ram_init_BLS();
        swrst <= 0;
        run <= 1;
        #(CYCLE);
        run <= 0;
        #1000;
        wait(!busy);
        
        
       $display("\nFirst pairing \n");
       for(integer i=0;i<12;i=i+1) begin
           extout_addr <= 'h10 + i;
           #(CYCLE*5);
           $display("i = %d: %h", i, MR(func_L3touint(DUT.postadder.reg1_wire)));
       end
       $display("\nSecond pairing \n");
       for(integer i=0;i<12;i=i+1) begin
           extout_addr <= 'h90 + i;
           #(CYCLE*5);
           $display("i = %d: %h", i, MR(func_L3touint(DUT.postadder.reg1_wire)));
       end
       $display("\nThird pairing \n");
       for(integer i=0;i<12;i=i+1) begin
           extout_addr <= 'h110 + i;
           #(CYCLE*5);
           $display("i = %d: %h", i, MR(func_L3touint(DUT.postadder.reg1_wire)));
       end

    
    $finish;
    end

    task ram_init_BLS;
        // Almost inputs are Montgomery form
    
    //input RAM0
        //Q
        write_ram0('h00, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f);   // Qx_0
        write_ram0('h01, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917);   // Qx_1
        write_ram0('h02, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6);   // Qy_0
        write_ram0('h03, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53);    // Qy_1
        write_ram0('h04, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Qz_0
        write_ram0('h05, 0);   // Qz_1
        //P                                                                    
        write_ram0('h06, 'h1860eac3d6a95df6e3eeb0e1fc6b63665a43e04e717c672e6f948a8cbcb20fc0b91497f7148bc43b0c7957ae8a7ef407);   // Px
        write_ram0('h07, 'hfc3609f47066f909d63f8e2381d5404bc703555b49eed2a45f1c15fbc47ab6dc898c1e07266b9306d3ee6b56b373a71);   // Py
        // Pz
        //T
        write_ram0('h20, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f);   // Tx_0
        write_ram0('h21, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917);   // Tx_1
        write_ram0('h22, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6);   // Ty_0
        write_ram0('h23, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53);    // Ty_1
        write_ram0('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Tz_0
        write_ram0('h25, 0);                                                                       // Tz_1
    //input RAM1
        //2Q
        write_ram1('h00, 'h058191924350bcd76f67b7631863366b9894999d1a3caee9a1a893b53e2ae580b3f5fb2687b4961af5f28fa202940a10);    //Qx_0
        write_ram1('h01, 'h11922a097360edf3c2b6ed0ef21585471b1ab6cc8541b3673bb17e18e2867806aaa0c59dbccd60c3a5a9c0759e23f606);   //Qx_1
        write_ram1('h02, 'h0083fd8e7e80dae507d3a975f0ef25a2bbefb5e96e0d495fe7e6856caa0a635a597cfa1f5e369c5a4c730af860494c4a);    //Qy_0
        write_ram1('h03, 'h0b2bc2a163de1bf2e7175850a43ccaed79495c4ec93da33a86adac6a3be4eba018aa270a2b1461dcadc0fc92df64b05d);    //Qy_1
        write_ram1('h04, 'h15f65ec3fa80e4935c071a97a256ec6d77ce5853705257455f48985753c758baebf4000bc40c0002760900000002fffd);    //Qz_0        
        write_ram1('h05, '0);                                                                      //Qz_1
        //P
        write_ram1('h06, 'h120177419e0bfb75edce6ecc21dbf440f0ae6acdf3d0e747154f95c7143ba1c17817fc679976fff55cb38790fd530c16);   // Px
        write_ram1('h07, 'h0bbc3efc5008a26a0e1c8c3fad0059c051ac582950405194dd595f13570725ce8c22631a7918fd8ebaac93d50ce72271);   // Py
        // Pz
        //T
        write_ram1('h20, 'h058191924350bcd76f67b7631863366b9894999d1a3caee9a1a893b53e2ae580b3f5fb2687b4961af5f28fa202940a10);   // Tx_0
        write_ram1('h21, 'h11922a097360edf3c2b6ed0ef21585471b1ab6cc8541b3673bb17e18e2867806aaa0c59dbccd60c3a5a9c0759e23f606);   // Tx_1
        write_ram1('h22, 'h0083fd8e7e80dae507d3a975f0ef25a2bbefb5e96e0d495fe7e6856caa0a635a597cfa1f5e369c5a4c730af860494c4a);   // Ty_0
        write_ram1('h23, 'h0b2bc2a163de1bf2e7175850a43ccaed79495c4ec93da33a86adac6a3be4eba018aa270a2b1461dcadc0fc92df64b05d);    // Ty_1
        write_ram1('h24, 'h15f65ec3fa80e4935c071a97a256ec6d77ce5853705257455f48985753c758baebf4000bc40c0002760900000002fffd);    // Tz_0
        write_ram1('h25, 0);    
                                                                  
    //input RAM2
        //Q
        write_ram2('h00, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f);
        write_ram2('h01, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917);
        write_ram2('h02, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6);
        write_ram2('h03, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53);
        write_ram2('h04, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);
        write_ram2('h05, 'h0);
        //2P
        write_ram3('h06, 'h135939fd3cd20b24945f8ad96a0acb9cb8f92ca6b8604ceae4d1bb58648157f4006e4521767b8a28454b0066d995a60);
        write_ram3('h07, 'h104e465233f2029c658cd507eb3d7f3d4b8ea37c977b1e5b6113ea23218e2400b7418ec83c23c805053743d13f8f51cc);
         //T
        write_ram2('h20, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f);   // Tx_0
        write_ram2('h21, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917);   // Tx_1
        write_ram2('h22, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6);   // Ty_0
        write_ram2('h23, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53);    // Ty_1
        write_ram2('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Tz_0
        write_ram2('h25, 0);   

    //input RAM3
        //2Q
        write_ram3('h00, 'h750cfcb468da1c85302a15465ea52bdfb01db2cfae939336a0c2dc21a75136c9fdaeb63736df445d9b9cc614b5bfe1f);
        write_ram3('h01, 'h1881b0542d4f83c8184ab4f566b84e7cd210febf7d1204f14ee72fa8df477f0b0641270815dcf85264bbe5f5d4c5cbb5);
        write_ram3('h02, 'h1d12f535390b2542a7c1b9647b52269beeec5b3d27f371d463b803a8ff8da05c1155fe56ff432c38dbeecd21eefd1ac);
        write_ram3('h03, 'he71fce473c95ae9a6d151e739cd67ec89778c05e28b624268ea1eef53c378f8df3ebbb921641fa01744d72e290467c9);
        write_ram3('h04, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);
        write_ram3('h05, 'h0);
        //2P
        write_ram3('h06, 'h135939fd3cd20b24945f8ad96a0acb9cb8f92ca6b8604ceae4d1bb58648157f4006e4521767b8a28454b0066d995a60);
        write_ram3('h07, 'h104e465233f2029c658cd507eb3d7f3d4b8ea37c977b1e5b6113ea23218e2400b7418ec83c23c805053743d13f8f51cc);
        //T
        write_ram3('h20, 'h750cfcb468da1c85302a15465ea52bdfb01db2cfae939336a0c2dc21a75136c9fdaeb63736df445d9b9cc614b5bfe1f);   // Tx_0
        write_ram3('h21, 'h1881b0542d4f83c8184ab4f566b84e7cd210febf7d1204f14ee72fa8df477f0b0641270815dcf85264bbe5f5d4c5cbb5);   // Tx_1
        write_ram3('h22, 'h1d12f535390b2542a7c1b9647b52269beeec5b3d27f371d463b803a8ff8da05c1155fe56ff432c38dbeecd21eefd1ac);   // Ty_0
        write_ram3('h23, 'he71fce473c95ae9a6d151e739cd67ec89778c05e28b624268ea1eef53c378f8df3ebbb921641fa01744d72e290467c9);    // Ty_1
        write_ram3('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Tz_0
        write_ram3('h25, 0);    
    
    //input RAM4
        //3Q
        write_ram4('h00, 'h1563bbea0ab1114206e00d4ab84ae2970dca70eaa2eeef115c6f3328695e4cfcdbcdd29a5adbf9c01bcc2fa0c2278496);
        write_ram4('h01, 'h21cc14f8ebc2f20876e2269ef23a0028aa93bfcfdaeb508557a8b1fe9045fb67b78982ce38108647cdb6ba9dfe697ad);
        write_ram4('h02, 'h10a37a7f25c82b59e30d5e4df47d6077003c11de7ac6a8f9661b9b29ab36cf9022b4f63de6d74d01465e0822f44e6248);
        write_ram4('h03, 'h6cee0d4dc3bfcf6f741a29a9e47f29d37d9bb5fe1a6b05e341dd3930fa31321809b507641b42c378d7283c555c997d4);
        write_ram4('h04, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);
        write_ram4('h05, 'h0);
        //2P
        write_ram4('h06, 'h135939fd3cd20b24945f8ad96a0acb9cb8f92ca6b8604ceae4d1bb58648157f4006e4521767b8a28454b0066d995a60);
        write_ram4('h07, 'h104e465233f2029c658cd507eb3d7f3d4b8ea37c977b1e5b6113ea23218e2400b7418ec83c23c805053743d13f8f51cc);
        //T
        write_ram4('h20, 'h1563bbea0ab1114206e00d4ab84ae2970dca70eaa2eeef115c6f3328695e4cfcdbcdd29a5adbf9c01bcc2fa0c2278496);   // Tx_0
        write_ram4('h21, 'h21cc14f8ebc2f20876e2269ef23a0028aa93bfcfdaeb508557a8b1fe9045fb67b78982ce38108647cdb6ba9dfe697ad);   // Tx_1
        write_ram4('h22, 'h10a37a7f25c82b59e30d5e4df47d6077003c11de7ac6a8f9661b9b29ab36cf9022b4f63de6d74d01465e0822f44e6248);   // Ty_0
        write_ram4('h23, 'h6cee0d4dc3bfcf6f741a29a9e47f29d37d9bb5fe1a6b05e341dd3930fa31321809b507641b42c378d7283c555c997d4);    // Ty_1
        write_ram4('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Tz_0
        write_ram4('h25, 0);    

    //input RAM5
        //3Q
        write_ram5('h00, 'h1563bbea0ab1114206e00d4ab84ae2970dca70eaa2eeef115c6f3328695e4cfcdbcdd29a5adbf9c01bcc2fa0c2278496);
        write_ram5('h01, 'h21cc14f8ebc2f20876e2269ef23a0028aa93bfcfdaeb508557a8b1fe9045fb67b78982ce38108647cdb6ba9dfe697ad);
        write_ram5('h02, 'h10a37a7f25c82b59e30d5e4df47d6077003c11de7ac6a8f9661b9b29ab36cf9022b4f63de6d74d01465e0822f44e6248);
        write_ram5('h03, 'h6cee0d4dc3bfcf6f741a29a9e47f29d37d9bb5fe1a6b05e341dd3930fa31321809b507641b42c378d7283c555c997d4);
        write_ram5('h04, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);
        write_ram5('h05, 'h0);
        //3P
        write_ram5('h06, 'h1492f749c65bf8806d66579116e123d4704a411e23080ca5dba32e3b3c63c3c4e74e98373c8936575e55e547bb356315);
        write_ram5('h07, 'ha1995312f00d1cea99a60ceecf121bc3084f2c2174e5467d86ced3a78cbaf7475579666026bbb5fb4d8a6006aa46974);
        //T
        write_ram5('h20, 'h1563bbea0ab1114206e00d4ab84ae2970dca70eaa2eeef115c6f3328695e4cfcdbcdd29a5adbf9c01bcc2fa0c2278496);   // Tx_0
        write_ram5('h21, 'h21cc14f8ebc2f20876e2269ef23a0028aa93bfcfdaeb508557a8b1fe9045fb67b78982ce38108647cdb6ba9dfe697ad);   // Tx_1
        write_ram5('h22, 'h10a37a7f25c82b59e30d5e4df47d6077003c11de7ac6a8f9661b9b29ab36cf9022b4f63de6d74d01465e0822f44e6248);   // Ty_0
        write_ram5('h23, 'h6cee0d4dc3bfcf6f741a29a9e47f29d37d9bb5fe1a6b05e341dd3930fa31321809b507641b42c378d7283c555c997d4);    // Ty_1
        write_ram5('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Tz_0
        write_ram5('h25, 0);    

//input all RAM
         write_rams('h10, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // f00 = r = 1
         write_rams('h11, 0);                                                                       // f01
         write_rams('h12, 0);                                                                       // f10
         write_rams('h13, 0);                                                                       // f11
         write_rams('h14, 0);                                                                       // f20
         write_rams('h15, 0);                                                                       // f21
         write_rams('h16, 0);                                                                       // f30
         write_rams('h17, 0);                                                                       // f31
         write_rams('h18, 0);                                                                       // f40
         write_rams('h19, 0);                                                                       // f41
         write_rams('h1a, 0);                                                                       // f50
         write_rams('h1b, 0);                                                                       // f51
        
        // After Miller loop
    //    write_rams('h10, 'h432959f9d7c368cc23086c367e2f291841e1bf4a6180d08dfbe81dd0db818a8e93c9a1dd8c2f96b879e3b8753dd0abe);
    //    write_rams('h11, 'h1027bb5daa5aa6aa47e5bccf92c3140e1abdd38954c365c4de427eed2d4a86a4ce22fdbd3b99ef4cf23ac9456d70b9c5);
    //    write_rams('h12, 'h7df4f3548ee66f80745d44056cd744c31a610ab013958cc0a33d3f928f75d4c34f6c0ae7e491050638572e2566a9196);
    //    write_rams('h13, 'ha09c8981ef709281b56e886742432f0ce566a106bba14911aebb40a695c5ebdfd1f1da2434fba585158cf3c92fafea5);
    //    write_rams('h14, 'h18da1f3e22587fd5d29849df31e8546420aa0c84efc1cbaa10f78c7f8d63831c8c8009a8b53d41a732870ebfa16389a3);
    //    write_rams('h15, 'h6126596552ed4309c992329ff6d8e3e4de0e722d64f32b4f79bf88a89d11e8dfc9a247c77f3b01e37dcb231675e127);
    //    write_rams('h16, 'h1947a97e99c17468d469ddda9404387457c12b626df4045803923ffe0e131a0a3d71784b3e05f0a97fb3dfb209c5923f);
    //    write_rams('h17, 'h13943635f6de1d515217820b1d01e8a19816bfa7dcbbf04b05bb13a6eb055a3dec3ec241034cc60f1ad9953315a42910);
    //    write_rams('h18, 'hd6e6c672c75cd1b2f32f5935f3f6047db0a06306e453522d3b7a204db787512d93556cb1741fa9efcfc42dbf3fbcfbb);
    //    write_rams('h19, 'hd545b6ff3c1fdb0b2da74a88a25bd4f270362a904662c5331e7d047a4652911f4bca57c5dd63ad9a48a7a2391c3fd0c);
    //    write_rams('h1a, 'h11712630d03e0bdd0d6ab50f72b8e6cda19a9c2d814f8035d429be6f881ae906715db58f933d08dc7739ba66863f7a5e);
    //    write_rams('h1b, 'hd956f219fa82d782d5e0fea0331b410c99812aa42abf83d84203a0159e90f916943509841790729e78ea99addec9767);

        write_rams('h09, 'h11e41d6827510424302748620c16c6767000b6609ab32f0bbce50a9fa478fa904fb1a226d7c8c3b38ac02e272c3d3bb1);   // r^2 (ordinary form)
        write_rams('h0a, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // r (ordinary form)
        write_rams(9'h0b, 1);                                                                       // 1 (ordinary form)
//        write_rams('h20, 'hb7b1cc9e11446011fb76adf571133eb16098f225a8c2536900000073751cddd10befc6b2cd38765e31b42ecbfe5725f);   // Tx_0
//        write_rams('h21, 'h193290ce73dc6c4aad0fb76c4891f6dfae7c95f4ef825e952ddf82ee4a0a21220932f017d57c9fe67f1a5d370a93f917);   // Tx_1
//        write_rams('h22, 'h181c27943c4307efc584a0f76799344cf6a205bd1b3c632112aee64756092ba93d7ae97bc1e29d62ac79f63f150788b6);   // Ty_0
//        write_rams('h23, 'h5af173ec99cdf92cf1df4e0122399bddff451c1221909b699ced210714461cc6fde8e7d39c50a2104b10a74ca443a53);    // Ty_1
//        write_rams('h24, 'h6266ea86a2d27c9ffae7bca245ef0aec53439f2badb6a0480fa012749c8bd9dde2ecd0389ebc8f9c4291d51d3fbb2cd);    // Tz_0
//        write_rams('h25, 0);                                                                       // Tz_1

        write_rams(9'h4f, 'h1918b2ff37a01105c6d89cb6c86510d3555f2b61aa5057b0fc05b83ae17d6c6469221c3ba0fe05f053c8b3106d013e3c);   // g300
        write_rams(9'h5d, 'h13daa341cf52bed04b6d2bec1eecbc289f43119238a9a8bae636d179ace83886407d32fb27683705f5d5e2ae2c03f7de);   // 
        write_rams(9'h5e, 320'h5b61645efa0be833e0cf20c7a8e86587e5efef111005428d8fffefa0f51466d);   // 
        write_rams(9'h5f, 'he85eeb01dfd59484430aff7ae69c040f1820234934bb0e6b2b1a66153389bfb589e3c31055fa0f66364cef92fe6c6f);   // 
        write_rams(9'h6d, 'h81d087ad6d7893b702027a69aebf999836f9105301cd26ea88be9e5ae0fb8a377b5eee1c438490410cb7ffa2f25871b);   // 
        write_rams(9'h6e, 'hc6a9d1d384250dd75d04badabf41e7a17d1ed82797158456614b482b5df19ea82e45e0af305065ec279aa0199419789);   // 
        write_rams(9'h6f, 'h6442e74ce1529137621cfe387952dcb529db38fbe95ee40e51ab35b6c165c4ca4b5910769193d64fe508cafc545e4bc);   // 
        write_rams(9'h7d, 'h9056765d8b75ecff46332a615d2959d9287b12879518d7d13b7044bc34342632d3fd2a4d48e43137701cce9c223f38a);   // 
        write_rams(9'h7e, 'h13bce3756b6abd86d4f9d7d2bbb67f0c11d997f534ef247e82161f458a9a99d779f66ef7483ac29abbae73503ab9c5ef);   // 
        write_rams(9'h7f, 'hd9674cd013d95bcd54b5c0897578e5d4ca55e027a13ba7a011c1e1e40d1dc399bc7a1f3be4ef9a0f78555fe66be1322);   // 

        
    endtask

   function uint_fpa_t func_L3tolazyuint;
       input redundant_poly_L3 din;

       func_L3tolazyuint = 0;
       for(integer i = 0; i < ADD_DIV; i = i + 1) begin
           func_L3tolazyuint = func_L3tolazyuint + (din[i].val << ($bits(fp_div4_t)*i));
       end
   endfunction

    task write_rams(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val);
        for(integer i = 0; i < N_THREADS; i = i + 1) begin
            extin_addr <= addr + (i << 7);
            extin_data <= inttoL3(val);
            extin_en <= 1;
            #(CYCLE);
            extin_en <= 0;
        end
    endtask

    task write_ram0(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val);
        extin_addr <= addr + (0 << 7);
        extin_data <= inttoL3(val);
        extin_en <= 1;
        #(CYCLE);
        extin_en <= 0;
    endtask

    task write_ram1(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val);
        extin_addr <= addr + (1 << 7);
        extin_data <= inttoL3(val);
        extin_en <= 1;
        #(CYCLE);
        extin_en <= 0;
    endtask

    task write_ram2(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val);
        extin_addr <= addr + (2 << 7);
        extin_data <= inttoL3(val);
        extin_en <= 1;
        #(CYCLE);
        extin_en <= 0;
    endtask

    task write_ram3(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val);
        extin_addr <= addr + (3 << 7);
        extin_data <= inttoL3(val);
        extin_en <= 1;
        #(CYCLE);
        extin_en <= 0;
    endtask

    task write_ram4(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val);
        extin_addr <= addr + (4 << 7);
        extin_data <= inttoL3(val);
        extin_en <= 1;
        #(CYCLE);
        extin_en <= 0;
    endtask

    task write_ram5(input [BRAM_DEPTH-1:0] addr, input M_tilde12_t val);
        extin_addr <= addr + (5 << 7);
        extin_data <= inttoL3(val);
        extin_en <= 1;
        #(CYCLE);
        extin_en <= 0;
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
            func_L3touint = func_L3touint + ({din[i].carry[L3_CARRY-1] ? 'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff : '0, din[i]} << ($bits(fp_div4_t)*i));
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
