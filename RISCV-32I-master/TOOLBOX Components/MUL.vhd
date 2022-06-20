LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY MUL IS
	PORT(
		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
    MSBRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );	 
END MUL;

ARCHITECTURE STRUCTURAL OF MUL IS
    TYPE ARR4 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(4 DOWNTO 0);
    TYPE ARR31 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR32 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL SHAMT  : ARR4; -- slide amount
    SIGNAL ARIGHT : ARR31; -- help variable for MSBRESULT
    SIGNAL ALEFT : ARR31; -- help variable for RESULT
    SIGNAL ALEFTMUX : ARR31;
    SIGNAL ALEFTMUXEXT : ARR32;
    SIGNAL ARIGHTMUX : ARR31;
    SIGNAL ARIGHTMUXEXT : ARR32;
    SIGNAL R : ARR32;
    SIGNAL RADD : ARR32;
    SIGNAL MR : ARR32;
    SIGNAL EXT : ARR32;
    SIGNAL EXTEXT : ARR32;
    SIGNAL EXTADD : ARR32;
    SIGNAL BH : ARR31; -- help variable for B
    SIGNAL RESZERO31 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RESZERO32 : STD_LOGIC_VECTOR(32 DOWNTO 0) := (OTHERS => '0');

    BEGIN
        --For i in range(0,31)
        MAIN: FOR I IN 0 TO 31 GENERATE 
            --Initialize
            INITIALIZE: IF I = 0 GENERATE 
                ARIGHT(I) <= RESZERO31;
                ALEFT(I) <= A;
                BH(I) <= B;
                MR(I) <= '0'& RESZERO31;
                R(I)  <= '0'& RESZERO31;
                SHAMT(I) <= "11111";
            END GENERATE INITIALIZE;

            --If B(0) == 1
            CHECKONEB1 :MUX2X1 
                GENERIC MAP(INSIZE => 32)
                    PORT MAP(
                        D0 => RESZERO31,
                        D1 => ALEFT(I),
                        SEL => BH(I)(0),
                        O=> ALEFTMUX(I)
                    );
            CHECKONEB2 :MUX2X1
                GENERIC MAP(INSIZE => 32)
                    PORT MAP(
                        D0 => RESZERO31,
                        D1 => ARIGHT(I),
                        SEL => BH(I)(0),
                        O=> ARIGHTMUX(I)
                    );

            --R = R + ALEFT        
            ALEFTMUXEXT(I) <= '0'& ALEFTMUX(I);
            RADD(I)<='0' & R(I)(31 DOWNTO 0);
            RADDER :EXE_ADDER_SUBBER 
                PORT MAP(
                    A=>RADD(I),
                    B=>ALEFTMUXEXT(I),
                    OP=>'0',
                    S=>R(I+1)
                );
            
            --EXT = R(32)
            EXTEXT(I) <= RESZERO31 & R(I+1)(32);
            CHECKONEB3EXT :MUX2X1
                GENERIC MAP(INSIZE => 33)
                    PORT MAP(
                        D0 => RESZERO32,
                        D1 => EXTEXT(I),
                        SEL => BH(I)(0),
                        O=> EXT(I)
                    );

            --MR = MR + ARIGHT + EXT
            ARIGHTMUXEXT(I) <= '0'& ARIGHTMUX(I);
            MRADDER1 :EXE_ADDER_SUBBER
                PORT MAP(
                    A=>EXT(I),
                    B=>ARIGHTMUXEXT(I),
                    OP=>'0',
                    S=>EXTADD(I)
                );
            MRADDER2 :EXE_ADDER_SUBBER
                PORT MAP(
                    A=>MR(I),
                    B=>EXTADD(I),
                    OP=>'0',
                    S=>MR(I+1)
                );
 
            --ARIGHT = A>>31-i
            ARSHIFTER :BARREL_SHIFTER
                PORT MAP(
                    VALUE_A =>A,
                    SHAMT_B =>SHAMT(I),
                    OPCODE =>"00",
                    RESULT =>ARIGHT(I+1)
                );
            SHAMT(I+1)<=std_logic_vector(unsigned(SHAMT(I)) - 1);

            --ALEFT = ALEFT<<1
            ALSHIFTER :BARREL_SHIFTER
                PORT MAP(
                    VALUE_A =>ALEFT(I),
                    SHAMT_B =>"00001",
                    OPCODE =>"01",
                    RESULT =>ALEFT(I+1)
                );

            --B = B>>1
            BSHIFTER :BARREL_SHIFTER
                PORT MAP(
                    VALUE_A =>BH(I),
                    SHAMT_B =>"00001",
                    OPCODE =>"00",
                    RESULT =>BH(I+1)
                );

        END GENERATE MAIN;
        RESULT<=R(32)(31 DOWNTO 0);
        MSBRESULT<=MR(32)(31 DOWNTO 0);
END STRUCTURAL;
