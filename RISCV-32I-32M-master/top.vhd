library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity top is
end entity;
 
architecture sim of top is
    signal CLK        : STD_LOGIC := '1';
    signal RST        : STD_LOGIC := '1';
    signal CYCLES     : integer := 0;
    SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CTRL_WORD : STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL ALU_VALUE_A  : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_VALUE_B  : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL TEST_STALL : STD_LOGIC;
 
begin
    
    -- An instance of T15_Mux with architecture rtl
    main : entity work.rv32i port map(
        CLK => CLK,
		RST => RST,
        I_F => PC,
        I_D => CTRL_WORD,
        ALU_VALUE_A => ALU_VALUE_A,
        ALU_VALUE_B => ALU_VALUE_B,
        ALU => ALU,
        TEST_STALL => TEST_STALL);
 
    process is
    begin
        RST <= '1';
        CLK <= '0';
        WAIT FOR 20 NS;
        RST <= '0';
        CLK <= '0';
        WAIT FOR 20 NS;
        LOOP
            CLK <= '1';
            WAIT FOR 40 NS;
            CLK <= '0';
            WAIT FOR 40 NS;
            EXIT WHEN (PC = "11000000000000000001000001110011");
        END LOOP;
        CLK <= '1';
        WAIT FOR 40 NS;
        CLK <= '0';
        WAIT FOR 40 NS;
        CLK <= '1';
        WAIT;
    end process;
    
    process(CLK) is
    begin
      if rising_edge(CLK) then
        CYCLES <= CYCLES + 1;
        end if;
    end process;
 
end architecture;

--     CLK <= not CLK after 20 ns;
--     CLK <= not CLK after 20 ns;
    
--     process is
--     begin
--         wait for 1 ns;
--         RST <= not RST;
--         wait;
--     end process;
    
--     process(CLK) is
--     begin
--       if rising_edge(CLK) then
--         CYCLES <= CYCLES + 1;
--         end if;
--     end process;
 
-- end architecture;