# Run from any working directory with Vivado 2018.3-compatible IP available.
set root [file normalize [file join [file dirname [info script]] ..]]
if {[llength $argv] != 1} { error "Usage: -tclargs hazard|forwarding|sram|sram-alternate" }
set snapshot [lindex $argv 0]
if {$snapshot ni {hazard forwarding sram sram-alternate}} { error "Unknown snapshot: $snapshot" }
set src [file join $root snapshots $snapshot]
set out [file join $root build $snapshot]
if {[file exists $out]} { error "Build directory already exists: $out. Move it before rebuilding." }
file mkdir $out
file copy $src [file join $out input]
set input [file join $out input]
create_project processor $out -part xc7z010clg400-1
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]
set_property XPM_LIBRARIES {XPM_MEMORY} [current_project]
add_files -norecurse [glob [file join $input rtl *.v]]
foreach f [glob -nocomplain [file join $input rtl *.vhd]] { add_files -norecurse $f }
add_files -fileset sim_1 -norecurse [glob [file join $input tb *.v]]
add_files -fileset constrs_1 -norecurse [glob [file join $input constraints *.xdc]]
foreach xci [glob [file join $input ip * *.xci]] { read_ip $xci }
# Resolve the relocated ROM path explicitly before generating output products.
set_property CONFIG.coefficient_file [file join $input memory output.coe] [get_ips dist_mem_gen_0]
generate_target all [get_ips]
set_property top ARM_Wrapper [get_filesets sources_1]
set_property top ARM_TB [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
close_project
