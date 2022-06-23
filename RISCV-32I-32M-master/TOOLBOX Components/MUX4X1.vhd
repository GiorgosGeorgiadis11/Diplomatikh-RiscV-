-- Typical 4 to 1 Generic input Multiplexer.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX4X1 IS 
	
	GENERIC ( INSIZE : INTEGER := 10 );
	
	PORT(	
		D0  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
		D1  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
		D2  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
		D3  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			
		SEL : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		 
		O : OUT STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0)
	     );

END MUX4X1;

ARCHITECTURE RTL OF MUX4X1 IS
BEGIN
	PROCESS(SEL,D0,D1,D2,D3)
	BEGIN
		CASE SEL IS 
		
			WHEN "00" => O <= D0;
			WHEN "01" => O <= D1;
			WHEN "10" => O <= D2;
			WHEN "11" => O <= D3;
			
			WHEN OTHERS => O <= (OTHERS =>'X');
			
		END CASE;
	END PROCESS;
	
END RTL;