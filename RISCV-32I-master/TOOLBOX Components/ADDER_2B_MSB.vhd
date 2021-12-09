LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ADDER_2B_MSB IS

	PORT( 
		A  : IN STD_LOGIC;
		B  : IN STD_LOGIC;
		CI : IN STD_LOGIC;
		S  : OUT STD_LOGIC
	);

END ADDER_2B_MSB;

ARCHITECTURE RTL OF ADDER_2B_MSB IS

	SIGNAL PARTIAL_SUM : STD_LOGIC;

	BEGIN 

	PARTIAL_SUM <= A XOR B;
	S	    <= PARTIAL_SUM XOR CI;

END RTL;