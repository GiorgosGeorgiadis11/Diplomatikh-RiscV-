LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY TWOS_COMPLEMENT IS

	PORT(
		  A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  OP : IN  STD_LOGIC;
          SIGNE : IN  STD_LOGIC;
          CIN : IN  STD_LOGIC;
          COUT : OUT  STD_LOGIC;
		  RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );
		 
END TWOS_COMPLEMENT;

ARCHITECTURE STRUCTURAL OF TWOS_COMPLEMENT IS
    SIGNAL MUXCH  : STD_LOGIC;
    SIGNAL COMPLEMENT  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FINAL  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ADDEROUTPUT  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL ADD  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL FINALADD  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL EXTENDEDA  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL OPADD  : STD_LOGIC := '0';
  
	BEGIN
        MUXCH <= (NOT OP) AND SIGNE;
        MAIN: FOR I IN 0 TO 31 GENERATE
            COMPLEMENT(I) <= NOT A(I);
            CHOOSEBIT :MUX2X1_BIT
                    PORT MAP(
                        D0 => A(I),
                        D1 => COMPLEMENT(I),
                        SEL => MUXCH,
                        O=> FINAL(I)
                    );
            ADDONE: IF I = 31 GENERATE
                CHOOSEADD :MUX2X1
                    GENERIC MAP(INSIZE => 33)
                        PORT MAP(
                            D0 => "000000000000000000000000000000000",
                            D1 => "000000000000000000000000000000001",
                            SEL => MUXCH,
                            O=> ADD
                        );
                CHOOSEADDMULH :MUX2X1
                    GENERIC MAP(INSIZE => 33)
                        PORT MAP(
                            D0 => "000000000000000000000000000000000",
                            D1 => ADD,
                            SEL => CIN,
                            O=> FINALADD
                        );
                EXTENDEDA<='0'&FINAL;
                ADDER :EXE_ADDER_SUBBER
                    PORT MAP(
                    A=>EXTENDEDA,
                    B=>FINALADD,
                    OP=>OPADD,
                    S=>ADDEROUTPUT
                    );
            END GENERATE ADDONE;
        END GENERATE MAIN;
        COUT<=ADDEROUTPUT(32);
        RESULT<= ADDEROUTPUT(31 DOWNTO 0);
        
END STRUCTURAL;
