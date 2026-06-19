set PROJ_ROOT $env(PROJ_ROOT)

restoreDesign $PROJ_ROOT/results/mac_innovus_init.enc.dat mac

file mkdir $PROJ_ROOT/reports/innovus

# timing and design checks
timeDesign -preCTS -outDir $PROJ_ROOT/reports/innovus/preCTS

report_timing > $PROJ_ROOT/reports/innovus/innovus_timing.rpt
report_area   > $PROJ_ROOT/reports/innovus/innovus_area.rpt
report_power  > $PROJ_ROOT/reports/innovus/innovus_power.rpt

# placement/utilization info
summaryReport -noHtml -outfile $PROJ_ROOT/reports/innovus/innovus_summary.rpt

saveDesign $PROJ_ROOT/results/mac_innovus_reported.enc

exit