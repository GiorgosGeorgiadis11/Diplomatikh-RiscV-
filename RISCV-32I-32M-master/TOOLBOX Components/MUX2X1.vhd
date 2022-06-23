-- Typical 2 to 1 Generic input Multiplexer.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX2X1 IS 

	GENERIC( INSIZE : INTEGER   := 10 );
	
	PORT(
		D0 : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
		D1 : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
		SEL : IN  STD_LOGIC;
		O  : OUT STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0)
	    );

END MUX2X1;

ARCHITECTURE RTL OF MUX2X1 IS
BEGIN

	O <= D0 WHEN ( SEL = '0' ) ELSE D1;
	
END RTL;