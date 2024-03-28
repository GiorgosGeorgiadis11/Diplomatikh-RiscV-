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

ENTITY SHIFT_TWO_REGISTERS IS

	PORT(
		REGLSB : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		REGMSB : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
		NFILL : IN STD_LOGIC;
		LSBOUT : OUT  STD_LOGIC_VECTOR(31  DOWNTO 0);
        MSBOUT : OUT  STD_LOGIC_VECTOR(31  DOWNTO 0)
	    );
		 
END SHIFT_TWO_REGISTERS;

ARCHITECTURE STRUCTURAL OF SHIFT_TWO_REGISTERS IS
    SIGNAL SHIFTA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SHIFTB : STD_LOGIC_VECTOR(31 DOWNTO 0);

    BEGIN
        SHIFTRLLEFT :BARREL_SHIFTER
            PORT MAP(
                VALUE_A =>REGLSB,
                SHAMT_B =>"00001",
                OPCODE =>"01",
                RESULT =>SHIFTA
            );
        SHIFTRRLEFT :BARREL_SHIFTER
            PORT MAP(
                VALUE_A =>REGMSB,
                SHAMT_B =>"00001",
                OPCODE =>"01",
                RESULT =>SHIFTB
            );
        LSBOUT <=SHIFTA(31 DOWNTO 1) & NFILL;
        MSBOUT <=SHIFTB(31 DOWNTO 1) & REGLSB(31);
END STRUCTURAL;
