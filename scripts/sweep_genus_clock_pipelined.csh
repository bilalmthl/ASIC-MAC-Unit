#!/bin/tcsh

cd ~/asic_mac_project

source /CMC/scripts/cadence.genus21.19.000.csh
source scripts/setup_asap7.csh

foreach PERIOD (2000 1500 1300 1200 1100 1000 900 800 700 600 500 450 400 350 300 250 200)

    echo "============================================================"
    echo "Running pipelined MAC Genus synthesis for ${PERIOD} ps"
    echo "============================================================"

    cat > constraints/mac_pipelined.sdc <<EOF
create_clock -name clk -period ${PERIOD} [get_ports clk]

set_input_delay 100 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 100 -clock clk [all_outputs]

set_load 0.01 [all_outputs]
EOF

    genus -f genus/synth_mac_pipelined.tcl

    mkdir -p reports/pipelined_sweep_${PERIOD}ps
    mkdir -p results/pipelined_sweep_${PERIOD}ps

    cp reports/pipelined/genus_area.rpt reports/pipelined_sweep_${PERIOD}ps/
    cp reports/pipelined/genus_timing.rpt reports/pipelined_sweep_${PERIOD}ps/
    cp reports/pipelined/genus_power.rpt reports/pipelined_sweep_${PERIOD}ps/
    cp reports/pipelined/genus_qor.rpt reports/pipelined_sweep_${PERIOD}ps/
    cp reports/pipelined/genus_check_design.rpt reports/pipelined_sweep_${PERIOD}ps/

    cp results/pipelined/mac_pipelined_mapped.v results/pipelined_sweep_${PERIOD}ps/
    cp results/pipelined/mac_pipelined_mapped.sdc results/pipelined_sweep_${PERIOD}ps/

end