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

ENTITY RIPPLE_CARRY_MUL IS
	PORT(
		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
        MSBRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );	 
END RIPPLE_CARRY_MUL;

ARCHITECTURE STRUCTURAL OF RIPPLE_CARRY_MUL IS

    TYPE ARR32X32 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC : ARR32X32;
    SIGNAL PCS : ARR32X32;
    SIGNAL PCC : ARR32X32;
    SIGNAL RAS,RAC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL OP : STD_LOGIC := '0'; --for add

    BEGIN
    ICOMPUTEPC:FOR I IN 0 TO 31 GENERATE
        JCOMPUTEPC:FOR J IN 0 TO 31 GENERATE
            PC(I)(J) <= A(I) AND B(J);
        END GENERATE JCOMPUTEPC;
    END GENERATE ICOMPUTEPC;

    INITIALIAZEPCCS:FOR J IN 0 TO 31 GENERATE
        PCS(0)(J) <= PC(0)(J);
        PCC(0)(J) <= '0';
    END GENERATE INITIALIAZEPCCS;

    ICOMPUTEPCCS:FOR I IN 1 TO 31 GENERATE
        JCOMPUTEPCCS:FOR J IN 0 TO 30 GENERATE
            COMPUTEPCCS :EXE_ADDER_SUBBER_CELL 
            PORT MAP(
                A=>PC(I)(J),
                B=>PCS(I-1)(J+1),
                CI=>PCC(I-1)(J),
                OP=>OP,
                S=>PCS(I)(J),
                CO=>PCC(I)(J)
            );
            PCS(I)(31)<=PC(I)(31);
        END GENERATE JCOMPUTEPCCS;
    END GENERATE ICOMPUTEPCCS;

    RAC(0) <= '0';
    ICOMPUTERASRAC:FOR I IN 0 TO 30 GENERATE
        COMPUTERASRAC :EXE_ADDER_SUBBER_CELL 
        PORT MAP(
            A=>PCS(31)(I+1),
            B=>PCC(31)(I),
            CI=>RAC(I),
            OP=>OP,
            S=>RAS(I),
            CO=>RAC(I+1)
        );
    END GENERATE ICOMPUTERASRAC;

    COMPUTERESULT:FOR I IN 0 TO 31 GENERATE
        RESULT(I)<=PCS(I)(0);
    END GENERATE COMPUTERESULT;

    COMPUTEMSBRESULT:FOR I IN 0 TO 30 GENERATE
        MSBRESULT(I)<=RAS(I);
    END GENERATE COMPUTEMSBRESULT;
    MSBRESULT(31) <= RAC(31);

END STRUCTURAL;
