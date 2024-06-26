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
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PART#1: DECODER
-- " Given specific bit segments from the instruction
--   fetched word, this Decoder "classifies" the command
--   as R/I/S/U/B/J by providing the necessary control
--   signals to the following units (e.g. ALU). 
--							 				
--   CONTROL WORD TRANSLATION:
--     |
--     | => BIT[0]     : JALR   (0  : No  | 1  : Yes) ** This will be appended later by ID **
--     | --------------------------------------------
--     | => BIT[1]     : LUI    (0  : No  | 1  : Yes)              
--     | => BIT[2]     : JUMP   (0  : No  | 1  : Yes)
--     | => BIT[3]     : PC	    (0  : RS1 | 1  : PC) ** ALSO IMM = 4 for ALU for JUMPS **
--     | => BIT[4]     : IMM	(0  : RS2 | 1  : IMM)
--     | => BIT[5]     : SLT    (0  : No  | 1  : Yes)
--     | => BIT[6]     : BRANCH (0  : No  | 1  : Yes)
--     | => BIT[7]     : EQ/LT  (0  : Eq  | 1  : LT )
--     | => BIT[8]     : INV    (0  : No  | 1  : Yes)
--     | => BIT[11..9] : ALU OP (000 : Add | 001 : Sub | 010: Logic | 011: Shift | 100: Mul | 101: Mulh | 110: Div | 111: Rem)  --\  Since the bits [9..8] determine the ALU's output, there
--     | => BIT[13..12]: BAS OP (00 : Srl | 01 : Sll | 10: Sra   | 11: Error)     \ is no problem using the same bits [11..10] to represent different
--     | 		 LOG OP (00 : And | 01 : Or  | 10: Xor   | 11: Error)     / operations in different ALU modules. Note for JALR command the bit
--     |                 ADD OP (0X : Sgn | 1X : Unsg)                         --/  will be used to set the ALU result's LSB to zero. XOR = 1.
--     | => BIT[16..14]: MEM OP (000: LB  | 001: LH | 010: LW  --\ 
--     |			 100: SB  | 101: SH | 110: SW     | The MSB signifies the operation when
--     |	 	         111: MEM-FREE-OP)             --/  the bits[6..5] define the byte enable. 
--     | => BIT[17]    : MEM U  (0  : Sgn | 1  : Unsg)
--     | => BIT[18]    : WB  OP (0  : No  | 1  : Yes)
--     | => BIT[21..19]: IMMGEN (000: I   | 001: S  | 010: B
--                               011: U   | 100: J)
--
-- " Bits [19..17] will be used for ID controlling while [16..0] are about EXE,MEM and WB stages.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TODO:
-- * REPLACE THE SIGNALS' TEST VALUES WITH THE CORRECT ONES. ==> DONE

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY ID_DECODER IS
			
	GENERIC ( CTRL_WORD_SIZE : INTEGER := 20 );
	
	PORT(
		MUX_4X1_SEL  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0); -- funct7 bit
		MUX_8X1_SEL  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0); -- funct3
		MUX_32X1_SEL : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); -- opcode
		CONTROL_WORD : OUT STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0)
	    );

END ID_DECODER;
 
ARCHITECTURE STRUCTURAL OF ID_DECODER IS
	                      
    -- LOAD COMANDS --------------------------------------------        IMGEN  WB MEU  MEM  A/S/L ALU INV EQLT BR SLT IMM  PC  J  LUI                                                             
	SIGNAL L_LB    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"000"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL L_LH    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"001"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL L_LW    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"010"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0";
	SIGNAL L_LBU   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"1"&"000"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0";
	SIGNAL L_LHU   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"1"&"001"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	-- I COMMANDS ----------------------------------------------    						
	SIGNAL I_ADDI  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL I_SLLI  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"01"&"011"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL I_SLTI  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"00"&"001"&"0"&"0"&"0"&"1"&"1"&"0"&"0"&"0";
	SIGNAL I_SLTIU : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"11"&"001"&"0"&"0"&"0"&"1"&"1"&"0"&"0"&"0"; 
	SIGNAL I_XORI  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"10"&"010"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL I_SRLI  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"00"&"011"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL I_SRAI  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"10"&"011"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL I_ORI   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"01"&"010"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL I_ANDI  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"00"&"010"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	-- STORE COMMANDS ------------------------------------------
	SIGNAL S_SB    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "001"&"0"&"0"&"100"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	SIGNAL S_SH    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "001"&"0"&"0"&"101"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0";
	SIGNAL S_SW    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "001"&"0"&"0"&"110"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"0"&"0"; 
	-- R COMMANDS ----------------------------------------------
	SIGNAL R_MUL   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"100"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_MULH  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"101"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_MULHU : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"10"&"101"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_MULHSU: STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"11"&"101"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_DIV   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"110"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_DIVU  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"10"&"110"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_REM   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"111"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_REMU  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"10"&"111"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_ADD   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"000"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_SUB   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"001"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0"; 
	SIGNAL R_SLL   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"01"&"011"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_SLT   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"001"&"0"&"0"&"0"&"1"&"0"&"0"&"0"&"0"; 
	SIGNAL R_SLTU  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"11"&"001"&"0"&"0"&"0"&"1"&"0"&"0"&"0"&"0"; 
	SIGNAL R_XOR   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"10"&"010"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_SRL   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"011"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0"; 
	SIGNAL R_SRA   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"10"&"011"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0";
	SIGNAL R_OR    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"01"&"010"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0"; 
	SIGNAL R_AND   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "111"&"1"&"0"&"111"&"00"&"010"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0"; 
	-- BRANCH COMMANDS -----------------------------------------
	SIGNAL B_BEQ   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "010"&"0"&"0"&"111"&"00"&"001"&"0"&"1"&"1"&"0"&"0"&"0"&"0"&"0";
	SIGNAL B_BNE   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "010"&"0"&"0"&"111"&"00"&"001"&"1"&"1"&"1"&"0"&"0"&"0"&"0"&"0"; 
	SIGNAL B_BLT   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "010"&"0"&"0"&"111"&"00"&"001"&"0"&"0"&"1"&"0"&"0"&"0"&"0"&"0"; 
	SIGNAL B_BGE   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "010"&"0"&"0"&"111"&"00"&"001"&"1"&"0"&"1"&"0"&"0"&"0"&"0"&"0"; 
	SIGNAL B_BLTU  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "010"&"0"&"0"&"111"&"11"&"001"&"0"&"0"&"1"&"0"&"0"&"0"&"0"&"0"; 
	SIGNAL B_BGEU  : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "010"&"0"&"0"&"111"&"11"&"001"&"1"&"0"&"1"&"0"&"0"&"0"&"0"&"0"; 
	-- OTHERS --------------------------------------------------
	SIGNAL AUIPC   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "011"&"1"&"0"&"111"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"1"&"0"&"0"; 
	SIGNAL LUI     : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "011"&"1"&"0"&"111"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"1"&"0"&"1"; 
	SIGNAL JALR    : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "000"&"1"&"0"&"111"&"01"&"000"&"0"&"0"&"0"&"0"&"1"&"0"&"1"&"0"; 
	SIGNAL JAL     : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := "100"&"1"&"0"&"111"&"00"&"000"&"0"&"0"&"0"&"0"&"1"&"1"&"1"&"0"; 
	-- CARRIERS ------------------------------------------------
	SIGNAL BUF_2A   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2B   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2C   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2D   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2E   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2F   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2G   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2H   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_2I   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	
	SIGNAL BUF_8A   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_8B   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_8C   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_8D   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	SIGNAL BUF_8E   : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0);
	
	CONSTANT GND      : STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0) := (OTHERS => '0');
	
	BEGIN
		-- MUX LEVEL 1 --
		MUX_4X1_A : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
					   	D0  => I_SRLI,
						D1  => I_SRAI,
						D2  => GND,
						D3  => GND,
						SEL => MUX_4X1_SEL,
						O   => BUF_2A
				           );
		MUX_4X1_B : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => R_ADD,
						D1   => R_SUB,
						D2   => R_MUL,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2B
					   );
		MUX_4X1_C : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => R_SLL,
						D1   => GND,
						D2   => R_MULH,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2C
						);
		MUX_4X1_D : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => R_SLT,
						D1   => GND,
						D2   => R_MULHU,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2D
						);
		MUX_4X1_E : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => R_SLTU,
						D1   => GND,
						D2   => R_MULHSU,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2E
						);
		MUX_4X1_F : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => R_XOR,
						D1   => GND,
						D2   => R_DIV,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2F
						);
		MUX_4X1_G : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP(
						D0   => R_SRL,
						D1   => R_SRA,
						D2   => R_DIVU,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2G
					   );
		MUX_4X1_H : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => R_OR,
						D1   => GND,
						D2   => R_REM,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2H
						);
		MUX_4X1_I : MUX4X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => R_AND,
						D1   => GND,
						D2   => R_REMU,
						D3   => GND,
						SEL  => MUX_4X1_SEL,
						O    => BUF_2I
						);
		-- MUX LEVEL 2 --
		MUX_8X1_A : MUX8X1 
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => L_LB,  -- fucnt3 000
						D1   => L_LH,  -- funct3 001
						D2   => L_LW,  -- funct3 010
						D3   => GND,
						D4   => L_LBU, -- funct3 100 
						D5   => L_LHU, -- funct3 101
						D6   => GND,
						D7   => GND,
						SEL  => MUX_8X1_SEL,
						O    => BUF_8A
					   );
		MUX_8X1_B : MUX8X1		
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0  => I_ADDI, -- funct3 000
						D1  => I_SLLI, -- funct3 001
						D2  => I_SLTI, -- funct3 010
						D3  => I_SLTIU,-- funct3 011
						D4  => I_XORI, -- funct3 100
						D5  => BUF_2A, -- funct3 101 
						D6  => I_ORI,  -- funct3 110
						D7  => I_ANDI, -- funct3 111
						SEL => MUX_8X1_SEL,
						O   => BUF_8B
					   );
		MUX_8X1_C: MUX8X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0   => S_SB, -- funct3 000
						D1   => S_SH, -- funct3 001
						D2   => S_SW, -- funct3 010
						D3   => GND,
						D4   => GND,
						D5   => GND,
						D6   => GND,
						D7   => GND,
						SEL  => MUX_8X1_SEL,
						O    => BUF_8C
					   );
		MUX_8X1_D: MUX8X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP(
						D0   => BUF_2B, -- funct3 000
						D1   => BUF_2C,  -- funct3 001
						D2   => BUF_2D,  -- funct3 010
						D3   => BUF_2E, -- funct3 011
						D4   => BUF_2F,  -- funct3 100
						D5   => BUF_2G, -- funct3 101
						D6   => BUF_2H,   -- funct3 110
						D7   => BUF_2I,  -- funct3 111
						SEL  => MUX_8X1_SEL,
						O    => BUF_8D
					   );
		MUX_8X1_E: MUX8X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP(
						D0   => B_BEQ,  -- funct3 000
						D1   => B_BNE,  -- funct3 001
						D2   => GND,
						D3   => GND,
						D4   => B_BLT,  -- funct3 100
						D5   => B_BGE,  -- funct3 101
						D6   => B_BLTU, -- funct3 110
						D7   => B_BGEU, -- funct3 111
						SEL  => MUX_8X1_SEL,
						O    => BUF_8E
					   );
		-- MUX LEVEL 3 --
		MUX_32X1: MUX32X1
				GENERIC MAP( INSIZE => CTRL_WORD_SIZE )
				PORT    MAP( 
						D0  => BUF_8A,
						D1  => GND,
						D2  => GND,
						D3  => GND,
						D4  => BUF_8B,
						D5  => AUIPC,
						D6  => GND,
						D7  => GND,
						D8  => BUF_8C,
						D9  => GND,
						D10	=> GND,
						D11 => GND,
						D12 => BUF_8D,
						D13 => LUI,
						D14 => GND,
						D15 => GND,
						D16 => GND,
						D17 => GND,
						D18 => GND,
						D19 => GND,
						D20 => GND,
						D21 => GND,
						D22 => GND,
						D23 => GND,
						D24 => BUF_8E,
						D25 => JALR,
						D26 => GND,
						D27 => JAL,
						D28 => GND,
						D29 => GND,
						D30 => GND,
						D31 => GND,
						SEL => MUX_32X1_SEL,
						O   => CONTROL_WORD
					   );
							
END STRUCTURAL;												