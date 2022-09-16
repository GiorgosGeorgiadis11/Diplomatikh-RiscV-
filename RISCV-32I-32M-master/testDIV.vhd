library ieee;
use ieee.std_logic_1164.all;
LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

entity testDIV is
end entity;
 
architecture sim of testDIV is
    signal VALUE_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal VALUE_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal RESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal REMAINDER : STD_LOGIC_VECTOR(31 DOWNTO 0);

        signal PassFail : STD_LOGIC;
        signal EXPECTEDRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal EXPECTEDREMAINDER : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
 
begin
    --i_DIV : entity work.LONG_DIV port map( --LONG DIV INSTANCE
    --i_DIV : entity work.IMPROVED_RESTORE_DIV port map( --IMPROVED RESTORE DIV INSTANCE
    i_DIV : entity work.ARRAY_DIV port map( --ARRAY DIV INSTANCE
    --i_DIV : entity work.IMPROVED_ARRAY_DIV port map( --IMPROVED ARRAY DIV INSTANCE
        A 	   => VALUE_A,
		B 	   => VALUE_B,
        REMAINDER 	   => REMAINDER,
		RESULT 	   => RESULT);
    -- Testbench process
    process is
    begin
    
        VALUE_A <= "00000000000000000000000000000010";
        VALUE_B <= "00000000000000000000000000000000";
        EXPECTEDRESULT <= "11111111111111111111111111111111";
        EXPECTEDREMAINDER <= "00000000000000000000000000000010";
        wait for 10 ns;

        VALUE_A <= "00000000000000000000000000011110";
        VALUE_B <= "00000000000000000000000000000011";
        EXPECTEDRESULT <= "00000000000000000000000000001010";
        EXPECTEDREMAINDER <= "00000000000000000000000000000000";
        wait for 10 ns;

        VALUE_A <= "00000000000000000000000000010111";
        VALUE_B <= "00000000000000000000000000000011";
        EXPECTEDRESULT <= "00000000000000000000000000000111";
        EXPECTEDREMAINDER <= "00000000000000000000000000000010";
        wait for 10 ns;

        VALUE_A <= "00000000000000000000000000000110";
        VALUE_B <= "00000000000000000000000000001110";
        EXPECTEDRESULT <= "00000000000000000000000000000000";
        EXPECTEDREMAINDER <= "00000000000000000000000000000110";
        wait for 10 ns;

        VALUE_A <= "00000000000000010010111011001101";
        VALUE_B <= "00000000000000000000010111010111";
        EXPECTEDRESULT <= "00000000000000000000000000110011";
        EXPECTEDREMAINDER <= "00000000000000000000010011111000";
        wait for 10 ns;
        wait;
    end process;

    process(RESULT,REMAINDER) is
        begin
            if (RESULT = EXPECTEDRESULT) and (REMAINDER = EXPECTEDREMAINDER) then
                PassFail <= '1';
            else
                PassFail <= '0';
            end if;
    end process;

 
end architecture;


