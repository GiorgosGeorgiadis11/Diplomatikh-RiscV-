LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY DIV IS

	PORT(
		  A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
		  RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );
		 
END DIV;

ARCHITECTURE STRUCTURAL OF DIV IS
    TYPE ARR31 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR31_31 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR32 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
    TYPE ARR1 IS ARRAY(0 TO 31) OF STD_LOGIC;
    SIGNAL RRESULT : ARR31;
    SIGNAL RSHIFT : ARR31_31;
    SIGNAL RA : ARR31_31;
    SIGNAL R : ARR32;
    SIGNAL REXTENDED : ARR32;
    SIGNAL MUXOUTREXTENDED :ARR32;
    SIGNAL Q : ARR31;
    SIGNAL MUXOUTR : ARR31_31;
    SIGNAL SIZETEST  : ARR1;
    SIGNAL RESZERO : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');


    BEGIN
      MAIN: FOR I IN 31 DOWNTO 0 GENERATE --for i in range(31,0,-1)
        INITIALIZE: IF I = 31 GENERATE
          Q(I+1)<=(OTHERS=>'0'); --Q = 0
          RRESULT(I+1)<=(OTHERS=>'0'); --R = 0
        END GENERATE INITIALIZE;

        SHIFTLEFT :BARREL_SHIFTER --SHIFT LEFT BY 1
          PORT MAP(
            VALUE_A =>RRESULT(I+1),
            SHAMT_B =>"00001",
            OPCODE =>"01",
            RESULT =>RSHIFT(I)
          );
        RA(I)<=RSHIFT(I)(31 DOWNTO 1)&A(I);--R(0) = A(I)
        
        CHECKSIZE :SIZE_COMPARATOR -- RETURN 0:IF R<B OR 1:IF R>=B
          PORT MAP(
            A =>RA(I),
            B =>B,
            O =>SIZETEST(I)
          );

        RNEXT : IF I>0 GENERATE
          CHECKIFR :MUX2X1 --IF R>= B
          GENERIC MAP(INSIZE => 32)
            PORT MAP(
              D0 => RESZERO,
              D1 => B,
              SEL => SIZETEST(I),
              O=> MUXOUTR(I)
            );
          REXTENDED(I)<='0'&RA(I);
          MUXOUTREXTENDED(I)<='0'&MUXOUTR(I);
          SUB :EXE_ADDER_SUBBER --R = R - B
            PORT MAP(
              A=>REXTENDED(I),
              B=>MUXOUTREXTENDED(I),
              OP=>'1',
              S=>R(I)
            );
            
          RRESULT(I)<=R(I)(31 DOWNTO 0);
        END GENERATE RNEXT;

        Q(I)<=Q(I+1)(31 DOWNTO I+1)&SIZETEST(I)&Q(I+1)(I-1 DOWNTO 0); --Q[I] = 1
      END GENERATE MAIN;
      RESULT<=Q(0);


END STRUCTURAL;
