library ieee;
use ieee.std_logic_1164.all;
LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

entity testMulticyclingMul is
end entity;
 
architecture sim of testMulticyclingMul is
    SIGNAL A : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL B : STD_LOGIC_VECTOR(31  DOWNTO 0);
    SIGNAL PREVPCS : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PREVPCC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PREVRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CYCLE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL NEXTPCS : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL NEXTPCC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RESULT    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MSBRESULT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
 
begin
    --i_MUL : entity work.BASIC_MUL port map( --BASIC MUL INSTANCE
    --i_MUL : entity work.ARRAY_MUL port map( --ARRAY MUL INSTANCE
    i_MUL : entity work.MUL_MULTICYCLING port map( --RIPPLE CARRY MUL INSTANCE
        A 	      => A,
        B	      => B,
        PREVPCS   => PREVPCS,
        PREVPCC   => PREVPCC,
        PREVRESULT=> PREVRESULT,
        CYCLE 	  => CYCLE,
        NEXTPCS   => NEXTPCS,
		NEXTPCC   => NEXTPCC,
        RESULT    => RESULT,
		MSBRESULT => MSBRESULT);
    -- Testbench process
    process is
        begin
        
            A <= "00001111111111111101000000000000";
            B <= "00000000000000000000000000010101";
            PREVPCS <= NEXTPCS;
            PREVPCC <= NEXTPCC;
            PREVRESULT <= RESULT;
            CYCLE <= "00000";
            wait for 100 ns;

            A <= A;
            B <= B;
            PREVPCS <= NEXTPCS;
            PREVPCC <= NEXTPCC;
            PREVRESULT <= RESULT;
            CYCLE <= "00001";
            wait for 100 ns;
    
            
            wait;
    end process;
 
end architecture;


