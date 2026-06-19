# Export final post-route MAC design artifacts and reports

set PROJ_ROOT $env(PROJ_ROOT)

# Restore final routed design
restoreDesign $PROJ_ROOT/results/mac_innovus_postroute.enc.dat mac

# Output folders
file mkdir $PROJ_ROOT/results/final
file mkdir $PROJ_ROOT/reports/final

# Final timing reports
timeDesign -postRoute -outDir $PROJ_ROOT/reports/final/postRoute_timing

report_timing > $PROJ_ROOT/reports/final/final_timing.rpt
report_area   > $PROJ_ROOT/reports/final/final_area.rpt
report_power  > $PROJ_ROOT/reports/final/final_power.rpt

summaryReport -noHtml -outfile $PROJ_ROOT/reports/final/final_summary.rpt

# Export implementation artifacts
saveNetlist $PROJ_ROOT/results/final/mac_postroute.v
write_sdc   $PROJ_ROOT/results/final/mac_postroute.sdc
defOut      $PROJ_ROOT/results/final/mac_postroute.def

# GDS export 
set ASAP7_STREAM_MAP $PROJ_ROOT/pdks/asap7/asap7_pdk_r1p7/cdslib/asap7_TechLib_10/asap7_fromAPR_08b.layermap
set ASAP7_STDCELL_GDS $PROJ_ROOT/pdks/asap7/asap7sc7p5t_28/GDS/asap7sc7p5t_28_R_220121a.gds
streamOut $PROJ_ROOT/results/final/mac_postroute.gds \
    -mapFile $ASAP7_STREAM_MAP \
    -merge $ASAP7_STDCELL_GDS \
    -libName DesignLib \
    -structureName mac \
    -units 1000 \
    -mode ALL

# Save final Innovus database
saveDesign $PROJ_ROOT/results/final/mac_postroute_final.enc

exit