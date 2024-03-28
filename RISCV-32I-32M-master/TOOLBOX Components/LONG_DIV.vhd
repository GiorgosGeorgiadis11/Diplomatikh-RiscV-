-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	           |
-- |===========================================================|
-- |student:    Georgios Georgiadis			                   |
-- |supervisor: Kavousianos Xrysovalantis			           |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2022      	               |
-- |  		     VCAS LABORATORY			                   |
-- +===========================================================+

-- This component is the divisor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY LONG_DIV IS

	PORT(
		  A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
          REMAINDER  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		  RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );
		 
END LONG_DIV;

ARCHITECTURE STRUCTURAL OF LONG_DIV IS
    TYPE ARR31 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR32 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL R : ARR32;
    SIGNAL RSHIFT : ARR31;
    SIGNAL RSHIFTA : ARR31;
    SIGNAL SIZETEST : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RESZERO : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');


    BEGIN
        R(32) <=RESZERO;
        MAIN: FOR I IN 31 DOWNTO 0 GENERATE
            SHIFTLEFT :BARREL_SHIFTER
                PORT MAP(
                    VALUE_A =>R(I+1),
                    SHAMT_B =>"00001",
                    OPCODE =>"01",
                    RESULT =>RSHIFT(I)
                );
            RSHIFTA(I) <= RSHIFT(I)(31 DOWNTO 1) & A(I);
            CHECKSIZE :SIZE_COMPARATOR 
                PORT MAP(
                    A =>RSHIFTA(I),
                    B =>B,
                    R =>R(I),
                    O =>SIZETEST(I)
                );
            RESULT(I) <= SIZETEST(I);
        END GENERATE MAIN;
        REMAINDER <=R(0);
END STRUCTURAL;