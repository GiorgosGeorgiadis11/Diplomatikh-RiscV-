library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

entity testDIV is
end entity;
 
architecture sim of testDIV is
    signal VALUE_A : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000010011";
		signal VALUE_B : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000011";
		signal RESULT : STD_LOGIC_VECTOR(31 DOWNTO 0); 
    
 
begin
    -- An instance of T15_Mux with architecture rtl
    i_DIV : entity work.DIV port map(
        A 	   => VALUE_A,
				B 	   => VALUE_B,
				RESULT 	   => RESULT);
    -- Testbench process
    process is
    begin
        wait;
    end process;
 
end architecture;


