library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity top is
end entity;
 
architecture sim of top is
    signal CLK        : STD_LOGIC := '1';
    signal RST        : STD_LOGIC := '1';
    signal cycle_counter : integer := 0;
 
begin
    
    -- An instance of T15_Mux with architecture rtl
    main : entity work.rv32i port map(
        CLK 	   => CLK,
					RST 	   => RST);
 
    CLK <= not CLK after 50ps;
    -- Testbench process
    process is
    begin
        wait for 10ps;
        RST <= not RST;
        wait;
    end process;
    
    process(CLK) is
    begin
      if rising_edge(CLK) then
          cycle_counter <= cycle_counter + 1;
        end if;
    end process;
 
end architecture;

