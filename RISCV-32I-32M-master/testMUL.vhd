library ieee;
use ieee.std_logic_1164.all;
LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

entity testMUL is
end entity;
 
architecture sim of testMUL is
    signal VALUE_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal VALUE_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal MSBRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal RESULT : STD_LOGIC_VECTOR(31 DOWNTO 0); 

    signal PassFail : STD_LOGIC;
    signal EXPECTEDRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal EXPECTEDMSBRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
 
begin
    --i_MUL : entity work.BASIC_MUL port map( --BASIC MUL INSTANCE
    --i_MUL : entity work.ARRAY_MUL port map( --ARRAY MUL INSTANCE
    i_MUL : entity work.RIPPLE_CARRY_MUL port map( --RIPPLE CARRY MUL INSTANCE
        A 	   => VALUE_A,
		B 	   => VALUE_B,
        MSBRESULT  => MSBRESULT,
		RESULT 	   => RESULT);
    -- Testbench process
    process is
        begin
        
            VALUE_A <= "00000000000000000000000000000000";
            VALUE_B <= "00000000000000000000000000001010";
            EXPECTEDRESULT <= "00000000000000000000000000000000";
            EXPECTEDMSBRESULT <= "00000000000000000000000000000000";
            wait for 10 ns;
    
            VALUE_A <= "00000000000000000000000000011111";
            VALUE_B <= "00000000000000000000000000000011";
            EXPECTEDRESULT <= "00000000000000000000000001011101";
            EXPECTEDMSBRESULT <= "00000000000000000000000000000000";
            wait for 10 ns;
    
            VALUE_A <= "10000000000000000000000000000000";
            VALUE_B <= "01000000000000000000000000000000";
            EXPECTEDRESULT <= "00000000000000000000000000000000";
            EXPECTEDMSBRESULT <= "00100000000000000000000000000000";
            wait for 10 ns;

            VALUE_A <= "01110000000000000000000000000011";
            VALUE_B <= "00000000000000000000000011111111";
            EXPECTEDRESULT <= "10010000000000000000001011111101";
            EXPECTEDMSBRESULT <= "00000000000000000000000001101111";
            wait for 10 ns;
            wait;
        end process;
    
        process(RESULT,MSBRESULT) is
            begin
                if (RESULT = EXPECTEDRESULT) and (MSBRESULT = EXPECTEDMSBRESULT) then
                    PassFail <= '1';
                else
                    PassFail <= '0';
                end if;
        end process;
 
end architecture;


