# CTS and routing script for pipelined MAC
set PROJ_ROOT $env(PROJ_ROOT)

# Start from the optimized pipelined post-place database.
restoreDesign $PROJ_ROOT/results/mac_pipelined_innovus_init.enc.dat mac_pipelined

# Disable SI-aware delay/optimization modes.
setDelayCalMode -SIAware false

# Separate report/result directories so baseline files are not overwritten.
set RPT_DIR $PROJ_ROOT/reports/pipelined_innovus
set RES_DIR $PROJ_ROOT/results/pipelined_innovus

file mkdir $RPT_DIR
file mkdir $RES_DIR

# Baseline post-place timing before CTS.
timeDesign -preCTS -expandedViews -outDir $RPT_DIR/preCTS
report_timing -max_paths 10 > $RPT_DIR/preCTS_timing.rpt
summaryReport -noHtml -outfile $RPT_DIR/preCTS_summary.rpt
report_power > $RPT_DIR/preCTS_power.rpt

# Clock tree synthesis.
set_ccopt_property target_skew 0.050
create_ccopt_clock_tree_spec -file $RES_DIR/mac_pipelined_ccopt.spec
source $RES_DIR/mac_pipelined_ccopt.spec
ccopt_design

# Repair timing after CTS.
optDesign -postCTS
optDesign -postCTS -hold

timeDesign -postCTS -expandedViews -outDir $RPT_DIR/postCTS
report_timing -max_paths 10 > $RPT_DIR/postCTS_timing.rpt
summaryReport -noHtml -outfile $RPT_DIR/postCTS_summary.rpt
report_power > $RPT_DIR/postCTS_power.rpt

# Timing-driven routing.
setNanoRouteMode -routeWithTimingDriven true
# Do not enable SI-driven routing unless OCV/SI setup is fixed.
# setNanoRouteMode -routeWithSiDriven true

routeDesign

# Post-route optimization and hold repair.
optDesign -postRoute -setup
optDesign -postRoute -setup
optDesign -postRoute -hold

# Final post-route reports.
timeDesign -postRoute -expandedViews -outDir $RPT_DIR/postRoute
report_timing -max_paths 10 > $RPT_DIR/pipelined_postroute_timing.rpt
report_area > $RPT_DIR/pipelined_postroute_area.rpt
report_power > $RPT_DIR/pipelined_postroute_power.rpt
summaryReport -noHtml -outfile $RPT_DIR/pipelined_postroute_summary.rpt

# Save final pipelined post-route database.
saveDesign $RES_DIR/mac_pipelined_postroute.enc

exit
