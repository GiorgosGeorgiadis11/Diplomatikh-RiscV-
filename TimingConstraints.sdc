create_clock -name TestClk -period 540 [get_ports {CLK}]

set_false_path -from [get_ports {RST}]