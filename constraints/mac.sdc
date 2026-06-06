create_clock -name clk -period 300 [get_ports clk]

set_input_delay 100 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 100 -clock clk [all_outputs]

set_load 0.01 [all_outputs]
