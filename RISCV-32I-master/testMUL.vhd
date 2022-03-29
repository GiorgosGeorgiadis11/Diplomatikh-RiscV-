library ieee;
use ieee.std_logic_1164.all;
LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

entity testMUL is
end entity;
 
architecture sim of testMUL is
    signal VALUE_A : STD_LOGIC_VECTOR(31 DOWNTO 0) := "10001010101010100101001000010101";
	signal VALUE_B : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000011111111111111111111";
    signal MSBRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal RESULT : STD_LOGIC_VECTOR(31 DOWNTO 0); 
    
 
begin
    -- An instance of T15_Mux with architecture rtl
    i_MUL : entity work.MUL port map(
        A 	   => VALUE_A,
				B 	   => VALUE_B,
                MSBRESULT  => MSBRESULT,
				RESULT 	   => RESULT);
    -- Testbench process
    process is
    begin
        wait;
    end process;
 
end architecture;


