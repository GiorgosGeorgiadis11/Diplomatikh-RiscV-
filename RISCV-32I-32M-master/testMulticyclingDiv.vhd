library ieee;
use ieee.std_logic_1164.all;
LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

entity testMulticyclingDiv is
end entity;
 
architecture sim of testMulticyclingDiv is
    SIGNAL A : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL B : STD_LOGIC_VECTOR(31  DOWNTO 0);
    SIGNAL PREVPCS : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PREVRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CYCLE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL NEXTPCS : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RESULT    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL REMAINDER : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
 
begin
    i_DIV : entity work.DIV_MULTICYCLING port map(
        A 	      => A,
        B	      => B,
        PREVPCS   => PREVPCS,
        PREVRESULT=> PREVRESULT,
        CYCLE 	  => CYCLE,
        NEXTPCS   => NEXTPCS,
        RESULT    => RESULT,
        REMAINDER => REMAINDER);
    -- Testbench process
    process is
        begin
        
            A <= "00000000000000000000000000000000";
            B <= "00000000000000000000000000000000";
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00000";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00001";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00010";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00011";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00100";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00101";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00110";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "00111";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01000";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01001";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01010";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01011";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01100";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01101";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01110";
            wait for 10 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVRESULT <= RESULT;
            CYCLE <= "01111";
            wait for 10 ns;
      
            wait;
    end process;

 
end architecture;


