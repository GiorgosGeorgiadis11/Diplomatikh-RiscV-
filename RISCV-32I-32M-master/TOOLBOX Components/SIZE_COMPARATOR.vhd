-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	           |
-- |===========================================================|
-- |student:    Georgios Georgiadis			                   |
-- |supervisor: Kavousianos Xrysovalantis			           |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2022      	               |
-- |  		     VCAS LABORATORY			                   |
-- +===========================================================+

-- This component is used to compare two numbers
-- If A >= B return 1 else return 0
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY SIZE_COMPARATOR IS

	PORT(
		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
		R : OUT STD_LOGIC_VECTOR(31  DOWNTO 0);
		O : OUT STD_LOGIC
	    );
		 
END SIZE_COMPARATOR;

ARCHITECTURE STRUCTURAL OF SIZE_COMPARATOR IS
	SIGNAL A_EXTENDED : STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL B_EXTENDED : STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL SUB_RES : STD_LOGIC_VECTOR(32 DOWNTO 0);

    BEGIN
		A_EXTENDED <= '0' & A;
		B_EXTENDED <= '0' & B;
		Sub: EXE_ADDER_SUBBER --(A-B)
		PORT MAP(
				A  => A_EXTENDED,
				B  => B_EXTENDED,
				OP => '1',
				S  => SUB_RES
			);
		CHECKIF :MUX2X1
			GENERIC MAP(INSIZE => 32)
			  PORT MAP(
				D0 => SUB_RES(31 DOWNTO 0),
				D1 => A,
				SEL => SUB_RES(32),
				O=> R
			  );
		-- if A-B < 0 then SUB_RES(32) will be 1 else will be 0
		O <= NOT SUB_RES(32); -- if A>=B return 0 else return 1
END STRUCTURAL;
