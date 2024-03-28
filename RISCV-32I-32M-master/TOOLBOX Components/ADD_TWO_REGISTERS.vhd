-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	           |
-- |===========================================================|
-- |student:    Georgios Georgiadis			                   |
-- |supervisor: Kavousianos Xrysovalantis			           |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2022      	               |
-- |  		     VCAS LABORATORY			                   |
-- +===========================================================+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY ADD_TWO_REGISTERS IS

	PORT(
		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        AADD : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
        BADD : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
		LSBOUT : OUT  STD_LOGIC_VECTOR(31  DOWNTO 0);
        MSBOUT : OUT  STD_LOGIC_VECTOR(31  DOWNTO 0)
	    );
		 
END ADD_TWO_REGISTERS;

ARCHITECTURE STRUCTURAL OF ADD_TWO_REGISTERS IS
    SIGNAL AEXTEND : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL AADDEXTEND : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL BEXTEND : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL BADDEXTEND : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL RESZERO : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL EXT : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL AOUT : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL BOUT : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL BEXTOUT : STD_LOGIC_VECTOR(32 DOWNTO 0);
    

    BEGIN
        AEXTEND <= '0' & A;
        AADDEXTEND <= '0' & AADD;
        BEXTEND <= '0' & B;
        BADDEXTEND <= '0' & BADD;

        ADDERA :EXE_ADDER_SUBBER
        PORT MAP(
            A=>AEXTEND,
            B=>AADDEXTEND,
            OP=>'0',
            S=>AOUT
        );
        ADDERB :EXE_ADDER_SUBBER
        PORT MAP(
            A=>BEXTEND,
            B=>BADDEXTEND,
            OP=>'0',
            S=>BEXTOUT
        );
        EXT<= RESZERO & AOUT(32);
        ADDERBEXT :EXE_ADDER_SUBBER
        PORT MAP(
            A=>BEXTOUT,
            B=>EXT,
            OP=>'0',
            S=>BOUT
        );
        LSBOUT <=AOUT(31 DOWNTO 0);
        MSBOUT <=BOUT(31 DOWNTO 0);
END STRUCTURAL;
