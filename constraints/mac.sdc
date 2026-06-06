create_clock -name clk -period 1.0 [get_ports clk]

set_input_delay 0.1 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 0.1 -clock clk [all_outputs]

set_load 0.01 [all_outputs]