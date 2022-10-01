create_clock -name CLK -period 39.9 [get_ports {CLK}]

set_false_path -from [get_ports {RST}]