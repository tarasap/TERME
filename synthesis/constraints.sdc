set sdc_version 2.0

# Clock
create_clock -name clk -period 2.45 [get_ports clk]
set_clock_uncertainty 0.05 -setup [get_clocks clk]
set_clock_uncertainty 0.05 -hold [get_clocks clk]
set_clock_transition 0.1 [get_clocks clk]

# ADD: Clock latency (critical for hold)
set_clock_latency -max 0.3 [get_clocks clk]
set_clock_latency -min 0.3 [get_clocks clk]

# Reset
set_ideal_network [get_ports rst]
set_false_path -from [get_ports rst] -to [all_registers]

# Input delays - One line per port
#set_input_delay 0.3 -clock clk [get_ports Irq_Timer_i]
#set_input_delay 0.3 -clock clk [get_ports Irq_Ext_i]
#set_input_delay 0.3 -clock clk [get_ports Irq_software_i]
#set_input_delay 0.3 -clock clk [get_ports instructionMemoryData]
#set_input_delay 0.3 -clock clk [get_ports memoryReadData]

# Output delays
set_output_delay 0.3 -clock clk [all_outputs]

# Load
set_load 0.02 [all_outputs]