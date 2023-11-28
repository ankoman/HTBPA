# HTBPA
High Throughput Bilinear Pairing Accelerator

# How to use
## Create project
On the Vivado Tcl shell (tested on version 2020.1), 
type the following command
```
source create_prj.tcl
```
Then, Vivado project files will be generated at `./HTBPA` directory.

## Open project in GUI
```
cd ./HTBPA
vivado HTBPA.xpr
```

## Parameters
You can change the following macros in `params.sv` to change the implementation parameters.  
(`params.sv` is displayed in the `Sources -> Libraries` tab on the Vivado GUI.)

|Macro|Range|Description|
|----|----|----|
|LAT_PE|1 to 4 |Latency of the processing elements (PE)|
|N_CORES|1 to 8 for BLS12 <br> 1 to 16 for BN254|The number of pairing cores to be implemented|
|BN254 and <br> BLS12_381|NA|Elliptic curve parameter to be implemented. Define either one.|

## Run simulation
On the Vivado GUI, click `Run Simulation -> Run Bihavioral Simulation`, then `Run All (F3)` on the menu bar.  
The simulation takes a few or ten mitutes. When the simulation is finished, the multiple pairing execution results are shown in the Tcl console depending on the number of conccurent execution (the number of threads).

Below is an example of the simulation results (`BL254, LAT_PE = 3`). Under this parameters, the number of threads become four, so the results show foru pairing outcomes.  
The four results correspond to $e(P, Q), e(2P, Q), e(P, 2Q), e(2P, 2Q)$, respectively, so the second and third results should be the same ($e(\cdot,\cdot)$ is the pairing function).  
See the `test_pairing.sv` for more detailed test vectors.

```
 Thread           0

i =           0: 000000001522962cd2840cce085ba60e77f9ee2aefde17a8c58432c5c61b4c36280a9192
i =           1: 0000000018b57635a879190412ae8652669a1e22e3ccd1bfae18b2296808508225fb4823
i =           2: 000000001d65dd2bb6a916c34f8c2f5fbb122d15dadc50ce25786714a53c4ea38759bcc3
i =           3: 000000000fd8a54405ac27c359eab84f12813366f6e392ee47c56efd8e48669d782f40e2
i =           4: 00000000114b45d26e7558ab7d8455d04eff776a771fb58525de8ff2d8e40b03142b47e9
i =           5: 00000000048d9e20b6c045298d9780d85e2e6d78980918230a9d74a78f435c0ecfc81d93
i =           6: 000000001d668780f723c0e6b9f153cc38867111419aed26eb164f929f08809c6fbc6c98
i =           7: 000000002041b120d62592645b892348fc3038bf73e2d9194919bd36701140a9f73fa89a
i =           8: 00000000069da90405400fca977ace521fc5d98279ee076b223919bfa01c5e0fdce70893
i =           9: 0000000024bbb6c41ba5e445a122eea517f7a0040177e130aeff5b815deed9f1b87103a0
i =          10: 0000000019345c9aa53c012baeafb6990ab861b0a5735b223fe62bc3ef19607483d759ad
i =          11: 00000000132d35a6ea2153f2572ddc838496d115db53bd6fb06942dab4092426633c02e2

 Thread           1

i =           0: 0000000020ccb8ff2fb6d5fac4e71d9262ef794ff7144600a5f811b3ed954499d2e72f8b
i =           1: 00000000018333419e07986ba6afbbca3c83ba8ef14874a8fc738b95f55e9bb4cfda912c
i =           2: 000000001ae94503fd6606156b3392c5ac9a997820f0f5d26ea32bdac7dad06b6d8c5c6f
i =           3: 0000000005926891110b403eb33e7bc3a0d6c444511481328ad3b1509fbaed2f05a9d9f9
i =           4: 000000000259ef759471d782d9074c8248a3f3e3c7c04e52859e87b10b3929039165e08c
i =           5: 000000000274aea02bbb78fdccedb1865e51cf98dfba8e6bb9d3daec47214cd8839a6f59
i =           6: 0000000008b254283df593bcea3f69a31f3713f5a9b8708595e514d5409b2c3855954f91
i =           7: 00000000070e247e6966045276b6a06c9b8f690ea832c8855f51c8f663ed7a7127f04947
i =           8: 0000000008329cbb7c1c234fa1638d9c09f5394e8621b233a60ff9c74d59612b11112d79
i =           9: 000000000f33eeba50ee6ac7128d464f70d2675c16e3c5ff79c0c467711004986f39e878
i =          10: 000000000730341c9cb92284e9b68264793a860fb33d3e77cacd39a5307c707543401648
i =          11: 0000000003b65babd76f36342e2de5a8551ac7126abbcb19edeabf7d0ee46929da02b227

 Thread           2

i =           0: 0000000020ccb8ff2fb6d5fac4e71d9262ef794ff7144600a5f811b3ed954499d2e72f8b
i =           1: 00000000018333419e07986ba6afbbca3c83ba8ef14874a8fc738b95f55e9bb4cfda912c
i =           2: 000000001ae94503fd6606156b3392c5ac9a997820f0f5d26ea32bdac7dad06b6d8c5c6f
i =           3: 0000000005926891110b403eb33e7bc3a0d6c444511481328ad3b1509fbaed2f05a9d9f9
i =           4: 000000000259ef759471d782d9074c8248a3f3e3c7c04e52859e87b10b3929039165e08c
i =           5: 000000000274aea02bbb78fdccedb1865e51cf98dfba8e6bb9d3daec47214cd8839a6f59
i =           6: 0000000008b254283df593bcea3f69a31f3713f5a9b8708595e514d5409b2c3855954f91
i =           7: 00000000070e247e6966045276b6a06c9b8f690ea832c8855f51c8f663ed7a7127f04947
i =           8: 0000000008329cbb7c1c234fa1638d9c09f5394e8621b233a60ff9c74d59612b11112d79
i =           9: 000000000f33eeba50ee6ac7128d464f70d2675c16e3c5ff79c0c467711004986f39e878
i =          10: 000000000730341c9cb92284e9b68264793a860fb33d3e77cacd39a5307c707543401648
i =          11: 0000000003b65babd76f36342e2de5a8551ac7126abbcb19edeabf7d0ee46929da02b227

 Thread           3

i =           0: 000000000ee216284d7ebec51d5fcf67e3dfb816e1bb358bec1fe41f25cef347ff3f27db
i =           1: 000000000b24924a6dcc17d4ff4d9468e0ac828cc155774a92769fab58b160696217d83f
i =           2: 0000000012b7d254f4787fd4c0031bd8c813e5c92c7157080e2480ff4fe170272b6b5690
i =           3: 00000000059ddae296b0fa7ee172a8ac32cad5b4697f2c0825f178d686a7eba36ad3b81f
i =           4: 000000000ff0c3fab75a8795d6db77572dfc3be2d6c030dad6b3225626d7cefadf5ba156
i =           5: 0000000003b4606eb5e8616943d83873f190b8d6100323f9446eb575e9f90c03e29daf64
i =           6: 0000000010738f5ca71a939f1bb0833ec56d7b792fc59c8d16d45a997150db98ea1b2c1f
i =           7: 000000002086e4fdce1ef55f8d1245aae713e08ae72ee83a5f369213a5bdb4535866eed0
i =           8: 000000000bb68188408d4a798db1a2113c3410dc0bc05d8050cb286d50f089283e812630
i =           9: 000000000b8d69f73996ca6a54255ba7695af856e80a056c9e32bb48385d6eacf2b41ea7
i =          10: 000000000b1266da92d2b397e84d5b87884941a1b60a5a43e7fff01c2d7fb4cecb89ced5
i =          11: 000000001cbced54baa5f06c7a35faf9487b9fade3173fbc48d78acdda7bf2aec959b976

###############################################
          4 pairings completed in    88152 [cycles]
###############################################

```

## Implemantation

On the Vivado GUI, click `Run Implementation`. It takes tens of minutes or a day depending on the implementation parameters, `N_CORES` particulaly.
The implementation result will show that some routes go failed. This is due to the `-mode out_of_context` option in the synthesis phase.
  
The clock constraint is set to 600 MHz. To get the maximum operating frequency, using the worst negative slack, _WSN_ [ns],
$$F_{max} = \frac{10^3}{\frac{10^3}{600}-WNS}  \text{[MHz]} $$


# License
MIT license
