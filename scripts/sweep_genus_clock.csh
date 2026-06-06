#!/bin/tcsh

cd ~/asic_mac_project

source /CMC/scripts/cadence.genus21.19.000.csh
source scripts/setup_asap7.csh

foreach PERIOD (2000 1500 1300 1200 1100 1000 900 800 700 600 500 450 400 350 300)

    echo "======================================"
    echo "Running Genus for clock period: ${PERIOD} ps"
    echo "======================================"

    cat > constraints/mac.sdc <<EOF
create_clock -name clk -period ${PERIOD} [get_ports clk]

set_input_delay 100 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 100 -clock clk [all_outputs]

set_load 0.01 [all_outputs]
EOF

    genus -f genus/synth_mac.tcl

    mkdir -p reports/sweep_${PERIOD}ps
    mkdir -p results/sweep_${PERIOD}ps

    cp reports/genus_area.rpt reports/sweep_${PERIOD}ps/
    cp reports/genus_timing.rpt reports/sweep_${PERIOD}ps/
    cp reports/genus_power.rpt reports/sweep_${PERIOD}ps/
    cp reports/genus_qor.rpt reports/sweep_${PERIOD}ps/
    cp results/mac_mapped.v results/sweep_${PERIOD}ps/
    cp results/mac_mapped.sdc results/sweep_${PERIOD}ps/

end