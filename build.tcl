set top_module top_risc_v
set fpga_part xc7a35tcpg236-1

set script_dir [file dirname [file normalize [info script]]]
set out_dir [file join $script_dir "Results"]
set bit_dir [file join $script_dir "Bitgen"]

file mkdir $out_dir
file mkdir $bit_dir


read_vhdl [glob [file join $script_dir "sources" "*.vhd"]]
read_mem [file join $script_dir "program" "inst_program.mem"]
read_xdc [file join $script_dir "constr" "basys3.xdc"]

synth_design -top $top_module -part $fpga_part
report_utilization -file [file join $out_dir "Utilization_post_synthesis"]

opt_design
place_design
route_design
report_utilization -file [file join $out_dir "Utilization_post_routing.rpt"]
report_timing_summary -file [file join $out_dir "Timing Report.rpt"]

write_bitstream [file join $bit_dir "${top_module}.bit"]


