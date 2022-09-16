-- This component is the multiplier
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY BASIC_MUL IS
	PORT(
		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
    MSBRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );	 
END BASIC_MUL;

ARCHITECTURE STRUCTURAL OF BASIC_MUL IS
    TYPE ARR31 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR32 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ARIGHT : ARR32;
    SIGNAL ALEFT : ARR32;
    SIGNAL ALEFTMUX : ARR31;
    SIGNAL ARIGHTMUX : ARR31;
    SIGNAL LSB : ARR32;
    SIGNAL MSB : ARR32;
    SIGNAL RESZERO31 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    BEGIN
        ALEFT(0)<=A;
        ARIGHT(0)<=RESZERO31;
        LSB(0)<=RESZERO31;
        MSB(0)<=RESZERO31;

        MAIN: FOR I IN 0 TO 31 GENERATE
            CHECKONEB1 :MUX2X1 
                GENERIC MAP(INSIZE => 32)
                    PORT MAP(
                        D0 => RESZERO31,
                        D1 => ALEFT(I),
                        SEL => B(I),
                        O=> ALEFTMUX(I)
                    );
            CHECKONEB2 :MUX2X1
                GENERIC MAP(INSIZE => 32)
                    PORT MAP(
                        D0 => RESZERO31,
                        D1 => ARIGHT(I),
                        SEL => B(I),
                        O=> ARIGHTMUX(I)
                    );

            ADDAB :ADD_TWO_REGISTERS
                PORT MAP(
                    A =>LSB(I),
                    AADD =>ALEFTMUX(I),
                    B =>MSB(I),
                    BADD =>ARIGHTMUX(I),
                    LSBOUT =>LSB(I+1),
                    MSBOUT =>MSB(I+1)
                );

            SHIFTLEFT :SHIFT_TWO_REGISTERS
                PORT MAP(
                  REGLSB =>ALEFT(I),
                  REGMSB =>ARIGHT(I),
                  NFILL =>'0',
                  LSBOUT =>ALEFT(I+1),
                  MSBOUT =>ARIGHT(I+1)
                );

        END GENERATE MAIN;
        RESULT<=LSB(32);
        MSBRESULT<=MSB(32);
END STRUCTURAL;
