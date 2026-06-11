# MMMC setup for MAC Innovus run

set PROJ_ROOT $env(PROJ_ROOT)
set ASAP7_LIBS [split $env(ASAP7_LIBS)]

create_library_set -name libs_tt \
    -timing $ASAP7_LIBS

create_rc_corner -name rc_typical

create_delay_corner -name dc_tt \
    -library_set libs_tt \
    -rc_corner rc_typical

create_constraint_mode -name cm_func \
    -sdc_files [list $PROJ_ROOT/results/sweep_610ps/mac_mapped.sdc]

create_analysis_view -name av_setup \
    -constraint_mode cm_func \
    -delay_corner dc_tt

create_analysis_view -name av_hold \
    -constraint_mode cm_func \
    -delay_corner dc_tt

set_analysis_view \
    -setup [list av_setup] \
    -hold [list av_hold]