-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	           |
-- |===========================================================|
-- |student:    Georgios Georgiadis			                   |
-- |supervisor: Kavousianos Xrysovalantis			           |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2022      	               |
-- |  		     VCAS LABORATORY			                   |
-- +===========================================================+

-- This component is the multiplier
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY ARRAY_MUL IS
	PORT(
		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
        MSBRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );	 
END ARRAY_MUL;

ARCHITECTURE STRUCTURAL OF ARRAY_MUL IS

    TYPE ARR32X32 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR32X33 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
    TYPE ARR31X33 IS ARRAY(0 TO 30) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL PC : ARR32X32;
    SIGNAL PCS : ARR32X33;
    SIGNAL PCC : ARR31X33;
    SIGNAL OP : STD_LOGIC := '0'; --for add

    BEGIN
    ICOMPUTEPC:FOR I IN 0 TO 31 GENERATE
        JCOMPUTEPC:FOR J IN 0 TO 31 GENERATE
            PC(I)(J) <= A(I) AND B(J);
        END GENERATE JCOMPUTEPC;
    END GENERATE ICOMPUTEPC;

    INITIALIAZEPCCS:FOR J IN 0 TO 30 GENERATE
        PCS(0)(J) <= PC(0)(J);
        PCC(J)(0) <= '0';
    END GENERATE INITIALIAZEPCCS;
    PCS(0)(31) <= PC(0)(31);
    PCS(0)(32) <= '0';

    ICOMPUTEPCCS:FOR I IN 1 TO 31 GENERATE
        JCOMPUTEPCCS:FOR J IN 0 TO 31 GENERATE
            COMPUTERASRAC :EXE_ADDER_SUBBER_CELL 
            PORT MAP(
                A=>PC(I)(J),
                B=>PCS(I-1)(J+1),
                CI=>PCC(I-1)(J),
                OP=>OP,
                S=>PCS(I)(J),
                CO=>PCC(I-1)(J+1)
            );
            PCS(I)(32)<=PCC(I-1)(32);
        END GENERATE JCOMPUTEPCCS;
    END GENERATE ICOMPUTEPCCS;

    COMPUTERESULT:FOR I IN 0 TO 31 GENERATE
        RESULT(I)<=PCS(I)(0);
    END GENERATE COMPUTERESULT;

    COMPUTEMSBRESULT:FOR I IN 0 TO 31 GENERATE
        MSBRESULT(I)<=PCS(31)(I+1);
    END GENERATE COMPUTEMSBRESULT;

END STRUCTURAL;
