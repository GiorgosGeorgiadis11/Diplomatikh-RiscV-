create_clock -name CLK -period 40 [get_ports {CLK}]

set_false_path -from [get_ports {RST}]