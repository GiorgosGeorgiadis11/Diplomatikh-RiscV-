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

ENTITY IMPROVED_LONG_DIV IS

	PORT(
		  A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
      REMAINDER  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		  RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );
		 
END IMPROVED_LONG_DIV;

ARCHITECTURE STRUCTURAL OF IMPROVED_LONG_DIV IS
    TYPE ARR31 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR32 IS ARRAY(0 TO 33) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RLSB : ARR32;
    SIGNAL RMSB : ARR32;
    SIGNAL SCR : ARR31;
    SIGNAL SHIFR : ARR31;
    SIGNAL SHIFL : ARR31;
    SIGNAL SIZETEST : STD_LOGIC_VECTOR(31 DOWNTO 0);


    BEGIN
      RLSB(0)<= A;
      RMSB(0)<= (OTHERS => '0');

      SHIFTLEFT :SHIFT_TWO_REGISTERS
          PORT MAP(
            REGLSB =>RLSB(0),
            REGMSB =>RMSB(0),
            NFILL =>'0',
            LSBOUT =>RLSB(1),
            MSBOUT =>RMSB(1)
          );

      MAIN: FOR I IN 1 TO 32 GENERATE
          CHECKSIZE :SIZE_COMPARATOR
                PORT MAP(
                  A =>RMSB(I),
                  B =>B,
                  O =>SIZETEST(I-1),
                  R =>SCR(I-1)
                );
            SHIFTLEFT :SHIFT_TWO_REGISTERS
                PORT MAP(
                  REGLSB =>RLSB(I),
                  REGMSB =>SCR(I-1),
                  NFILL =>SIZETEST(I-1),
                  LSBOUT =>RLSB(I+1),
                  MSBOUT =>RMSB(I+1)
                );
      END GENERATE MAIN;

      SHIFTRLLEFT :BARREL_SHIFTER
          PORT MAP(
              VALUE_A =>RMSB(33),
              SHAMT_B =>"00001",
              OPCODE =>"00",
              RESULT =>REMAINDER
          );
      RESULT<=RLSB(33);


END STRUCTURAL;
