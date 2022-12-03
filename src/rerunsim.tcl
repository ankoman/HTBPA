reset_target all [get_files  P:/prj/QPMM_d0/QPMM_d0.srcs/sources_1/ip/csig_rom/csig_rom.xci]
export_ip_user_files -of_objects  [get_files  P:/prj/QPMM_d0/QPMM_d0.srcs/sources_1/ip/csig_rom/csig_rom.xci] -sync -no_script -force -quiet
relaunch_sim
run all