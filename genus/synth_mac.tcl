# paths
set PROJ_ROOT $env(PROJ_ROOT)
set ASAP7_LIB_DIR $env(ASAP7_LIB_DIR)
set ASAP7_LIBS $env(ASAP7_LIBS)

# output folders
file mkdir $PROJ_ROOT/reports
file mkdir $PROJ_ROOT/results
file mkdir $PROJ_ROOT/logs

# library setup
set_db init_lib_search_path $ASAP7_LIB_DIR
set_db library $ASAP7_LIBS

# read rtl
read_hdl -sv $PROJ_ROOT/rtl/mac.sv

# elaborate top module
elaborate mac

# timing constraints
read_sdc $PROJ_ROOT/constraints/mac.sdc

# check design
check_design > $PROJ_ROOT/reports/genus_check_design.rpt

# synthesis
syn_generic
syn_map
syn_opt

# reports
report_area   > $PROJ_ROOT/reports/genus_area.rpt
report_timing > $PROJ_ROOT/reports/genus_timing.rpt
report_power  > $PROJ_ROOT/reports/genus_power.rpt
report_qor    > $PROJ_ROOT/reports/genus_qor.rpt

# outputs for innovus
write_hdl > $PROJ_ROOT/results/mac_mapped.v
write_sdc > $PROJ_ROOT/results/mac_mapped.sdc

exit