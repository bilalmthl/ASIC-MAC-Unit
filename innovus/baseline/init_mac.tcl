# Early baseline placement script.
# Kept for reference only.
# Final baseline flow uses init_mac_opt.tcl.

set PROJ_ROOT $env(PROJ_ROOT)

set init_design_netlisttype Verilog
set init_verilog [list $PROJ_ROOT/results/sweep_500ps/mac_mapped.v]
set init_top_cell mac

set init_lef_file [list \
    $env(ASAP7_TECH_LEF) \
    $env(ASAP7_CELL_LEF) \
]

set init_mmmc_file $PROJ_ROOT/innovus/mmmc_mac.tcl

set init_pwr_net VDD
set init_gnd_net VSS

init_design

globalNetConnect VDD -type pgpin -pin VDD -inst *
globalNetConnect VSS -type pgpin -pin VSS -inst *

# initial floorplan
floorPlan -r 1.0 0.70 2 2 2 2

# ASAP7 track workaround
add_tracks -honor_pitch

# avoid high metal layers for this small block
setDesignMode -bottomRoutingLayer M2 -topRoutingLayer M7

# simple placement
place_design

# pre-CTS timing
timeDesign -preCTS -outDir $PROJ_ROOT/reports/innovus_preCTS_timing

saveDesign $PROJ_ROOT/results/mac_innovus_init.enc

exit