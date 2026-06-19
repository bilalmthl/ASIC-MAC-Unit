set PROJ_ROOT $env(PROJ_ROOT)

# Start from the optimized post-place database.
restoreDesign $PROJ_ROOT/results/mac_innovus_init.enc.dat mac

# Disable SIaware delay/optimization modes.
setDelayCalMode -SIAware false

set RPT_DIR $PROJ_ROOT/reports/innovus_postroute
file mkdir $RPT_DIR

# Baseline post-place timing before CTS.
timeDesign -preCTS -expandedViews -outDir $RPT_DIR/preCTS
report_timing -max_paths 10 > $RPT_DIR/preCTS_timing.rpt
summaryReport -noHtml -outfile $RPT_DIR/preCTS_summary.rpt
report_power > $RPT_DIR/preCTS_power.rpt

# Clock tree synthesis.
set_ccopt_property target_skew 0.050
create_ccopt_clock_tree_spec -file $PROJ_ROOT/results/mac_ccopt.spec
source $PROJ_ROOT/results/mac_ccopt.spec
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
# setNanoRouteMode -routeWithSiDriven true
routeDesign

# Post-route optimization and hold repair.
optDesign -postRoute -setup
optDesign -postRoute -setup
optDesign -postRoute -hold

# Final post-route reports.
timeDesign -postRoute -expandedViews -outDir $RPT_DIR/postRoute
report_timing -max_paths 10 > $RPT_DIR/innovus_postroute_timing.rpt
report_area > $RPT_DIR/innovus_postroute_area.rpt
report_power > $RPT_DIR/innovus_postroute_power.rpt
summaryReport -noHtml -outfile $RPT_DIR/innovus_postroute_summary.rpt

saveDesign $PROJ_ROOT/results/mac_innovus_postroute.enc

exit