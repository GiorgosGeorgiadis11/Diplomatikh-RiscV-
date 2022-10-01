-- This component is used to make the two complement
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY TWOS_COMPLEMENT IS

	PORT(
		  A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
          B : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
          SIGNA : IN STD_LOGIC;
          SIGNB : IN STD_LOGIC;
          BEFOREAFTER : IN STD_LOGIC;
		  OP : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          ONEREGMANAGMENT : IN STD_LOGIC;
          RESULTA  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		  RESULTB  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );
		 
END TWOS_COMPLEMENT;

ARCHITECTURE STRUCTURAL OF TWOS_COMPLEMENT IS
    SIGNAL MUSTCOMPLEMENTA : STD_LOGIC;
    SIGNAL MUSTCOMPLEMENTB : STD_LOGIC;
    
    SIGNAL COMPLEMENTA  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL COMPLEMENTB  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MUXA  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MUXB  : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL EXTA  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL EXTB  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL CHOOSEEXTADDB : STD_LOGIC;
    SIGNAL EXTADDA  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL EXTADDB  : STD_LOGIC_VECTOR(32 DOWNTO 0);

    SIGNAL SIGNAB : STD_LOGIC;
    SIGNAL MUSTCOMPLEMENTBEFOREA : STD_LOGIC;
    SIGNAL MUSTCOMPLEMENTBEFOREB : STD_LOGIC;
    SIGNAL MULHSU : STD_LOGIC;
    SIGNAL SIGNAFTERAB : STD_LOGIC;
    SIGNAL MUSTCOMPLEMENTAFTER : STD_LOGIC;

    SIGNAL FINALA  : STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL FINALB  : STD_LOGIC_VECTOR(32 DOWNTO 0);

    SIGNAL RESZERO32 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  
	BEGIN
        MUSTCOMPLEMENTBEFOREA <= (OP(1) XNOR OP(0)) AND SIGNA;
        MUSTCOMPLEMENTBEFOREB <= (OP(1) NOR OP(0)) AND SIGNB;
        MULHSU <= OP(1) AND OP(0);
        SIGNAB <= SIGNA XOR SIGNB;
        SELECTSIGNAFTER: MUX2X1_BIT
            PORT    MAP( 
                    D0  => SIGNAB,
                    D1  => SIGNA,
                    SEL => MULHSU,
                    O   => SIGNAFTERAB
                    );
        MUSTCOMPLEMENTAFTER  <= (OP(1) XNOR OP(0)) AND SIGNAFTERAB;
        SELECTA: MUX2X1_BIT
            PORT    MAP( 
                    D0  => MUSTCOMPLEMENTBEFOREA,
                    D1  => MUSTCOMPLEMENTAFTER,
                    SEL => BEFOREAFTER,
                    O   => MUSTCOMPLEMENTA
                    );
        SELECTB: MUX2X1_BIT
            PORT    MAP( 
                    D0  => MUSTCOMPLEMENTBEFOREB,
                    D1  => MUSTCOMPLEMENTAFTER,
                    SEL => BEFOREAFTER,
                    O   => MUSTCOMPLEMENTB
                    );

          
        MAIN: FOR I IN 0 TO 31 GENERATE
            COMPLEMENTA(I) <= NOT A(I);
            CHOOSEBITA :MUX2X1_BIT
                    PORT MAP(
                        D0 => A(I),
                        D1 => COMPLEMENTA(I),
                        SEL => MUSTCOMPLEMENTA,
                        O=> MUXA(I)
                    );
            COMPLEMENTB(I) <= NOT B(I);
            CHOOSEBITB :MUX2X1_BIT
                PORT MAP(
                    D0 => B(I),
                    D1 => COMPLEMENTB(I),
                    SEL => MUSTCOMPLEMENTB,
                    O=> MUXB(I)
                );
        END GENERATE MAIN;

        EXTA<='0'&MUXA;
        EXTADDA <= RESZERO32 & MUSTCOMPLEMENTA;
        ADDERA :EXE_ADDER_SUBBER
            PORT MAP(
            A=>EXTA,
            B=>EXTADDA,
            OP=>'0',
            S=>FINALA
            );

        CHOOSEADDB :MUX2X1_BIT
                PORT MAP(
                    D0 => MUSTCOMPLEMENTB,
                    D1 => FINALA(32),
                    SEL => ONEREGMANAGMENT,
                    O=> CHOOSEEXTADDB
                );
        EXTB<='0'&MUXB;
        EXTADDB <= RESZERO32 & CHOOSEEXTADDB;
        ADDERB :EXE_ADDER_SUBBER
            PORT MAP(
            A=>EXTB,
            B=>EXTADDB,
            OP=>'0',
            S=>FINALB
            );

        RESULTA <= FINALA(31 DOWNTO 0);
        RESULTB <= FINALB(31 DOWNTO 0);
        
END STRUCTURAL;