# Final post route verification checks for MAC

set PROJ_ROOT $env(PROJ_ROOT)

restoreDesign $PROJ_ROOT/results/mac_innovus_postroute.enc.dat mac

file mkdir $PROJ_ROOT/reports/final_verify

# Basic physical and connectivity checks
verify_drc \
    -report $PROJ_ROOT/reports/final_verify/final_verify_drc.rpt

verifyConnectivity \
    -type all \
    -report $PROJ_ROOT/reports/final_verify/final_verify_connectivity.rpt

# Optional geometry/process antenna style checks if supported
catch {
    verifyProcessAntenna \
        -report $PROJ_ROOT/reports/final_verify/final_verify_antenna.rpt
}

# Save log/database after verification
saveDesign $PROJ_ROOT/results/final/mac_verified.enc

exit