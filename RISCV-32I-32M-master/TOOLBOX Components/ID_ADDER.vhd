-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	           |
-- |===========================================================|
-- |student:    Georgios Georgiadis			                   |
-- |supervisor: Kavousianos Xrysovalantis			           |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2022      	               |
-- |  		     VCAS LABORATORY			                   |
-- +===========================================================+
-- +===========================================================+
-- |		RISC-V RV32I ISA IMPLEMENTATION  	               |
-- |===========================================================|
-- |student:    Deligiannis Nikos			                   |
-- |supervisor: Aristides Efthymiou			                   |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2019      	               |
-- |  		     VCAS LABORATORY			                   |
-- +===========================================================+

-- *** 2/5: INSTRUCTION DECODE (ID) MODULE DESIGN ***
------------------------------------------------------------
-- PART#4: ADDER 
-- " This is a special type of Adder which calculates 
--   the conditional/unconditional jump target addresses. "
------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY ID_ADDER IS

	PORT(
		PC_VALUE  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		IMMEDIATE : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		OUTPUT 	  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );
		 
END ID_ADDER;

ARCHITECTURE STRUCTURAL OF ID_ADDER IS

	SIGNAL RIPPLE_CARRY : STD_LOGIC_VECTOR(0 TO 31) := (OTHERS => '0') ;

	BEGIN
	
	ADDERS: FOR I IN 0 TO 31 GENERATE
	 
		OTHER: IF I < 31 GENERATE 

			ADDERS: ADDER_2B
				PORT MAP( 
						A  => PC_VALUE(I),
						B  => IMMEDIATE(I),
						CI => RIPPLE_CARRY(I),
						S  => OUTPUT(I),
						CO => RIPPLE_CARRY(I+1)
					);
							
		END GENERATE OTHER;
		
		MSB : IF I = 31 GENERATE
		
			ADDER: ADDER_2B_MSB
				PORT MAP( 
						A  => PC_VALUE(I),
						B  => IMMEDIATE(I),
						CI => RIPPLE_CARRY(I),
						S  => OUTPUT(I)
					);
						   
		END GENERATE MSB;			
		
	END GENERATE ADDERS;
	
END STRUCTURAL;