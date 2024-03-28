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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY INSTRUCTION_DECODE IS 
	
	GENERIC( CTRL_WORD_TOTAL : INTEGER := 20; CTRL_WORD_OUT : INTEGER := 18);
	PORT   ( 	
			CLK,RST    : IN  STD_LOGIC;			--\
			WB_RD_LOAD : IN  STD_LOGIC_VECTOR(4  DOWNTO 0); --| Register File inputs.
			WB_RD_DATA : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); --/ 	
			PC_VALUE   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); -- Feed from
			IF_WORD    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); -- Instruction Fetch
				
			RD_FROM_EXE: IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			RD_FROM_MEM: IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			PIPE_LOAD_E: IN  STD_LOGIC;
			ISMULDIV: IN STD_LOGIC;

			RS1_VALUE  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); 
			RS2_VALUE  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RD_ADDR    : OUT STD_LOGIC_VECTOR(4  DOWNTO 0);
			IMMEDIATE  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			TARGET_AD  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); 
			PC_VALUE_O : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			CTRL_WORD  : OUT STD_LOGIC_VECTOR(CTRL_WORD_OUT-1  DOWNTO 0);
				
			PIPE_STALL : OUT STD_LOGIC;
			PIPE_FWDA  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); 
			PIPE_FWDB  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			PIPE_FWDC  : OUT STD_LOGIC;
			
			SIMULATION_END : OUT STD_LOGIC;
			GP	       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			--T5	       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			--T4	       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

		);

END INSTRUCTION_DECODE;

ARCHITECTURE STRUCTURAL OF INSTRUCTION_DECODE IS
	
	-- DECODER SIGS --
	SIGNAL OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL FUNCT3 : STD_LOGIC_VECTOR(2 DOWNTO 0); 
	SIGNAL FUNCT7 : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL DEC_BUF: STD_LOGIC_VECTOR(CTRL_WORD_TOTAL-1 DOWNTO 0);
	-- IMMEDIATE GENERATOR SIGS --
	SIGNAL IMM_BUF: STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- REGISTER FILE SIGS --
	SIGNAL ONE_HOT: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RS1_BUF: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RS2_BUF: STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- ID ADDER SIGS --
	SIGNAL ADD_BUF: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MUX_BUF: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL JALR   : STD_LOGIC;
	-- APPEND JALR --
	SIGNAL CTRL   : STD_LOGIC_VECTOR(CTRL_WORD_OUT-1 DOWNTO 0);

BEGIN

	-- DECODER -------------------
	OPCODE <= IF_WORD(6  DOWNTO  2);
	FUNCT3 <= IF_WORD(14 DOWNTO 12);
	FUNCT7 <= IF_WORD(31 DOWNTO 30);
	
	DEC: ID_DECODER
		GENERIC MAP( CTRL_WORD_SIZE => CTRL_WORD_TOTAL )
		PORT    MAP(
				MUX_4X1_SEL  => FUNCT7,
				MUX_8X1_SEL  => FUNCT3,
				MUX_32X1_SEL => OPCODE,
				CONTROL_WORD => DEC_BUF
			   );
			   
	-- IMMEDIATE GENERATOR --------
	IMG: ID_IMM_GENERATOR
		PORT    MAP(
			        IMM_TYPE    => DEC_BUF(CTRL_WORD_TOTAL-1 DOWNTO CTRL_WORD_TOTAL-3),
				IF_WORD     => IF_WORD,
				IMMEDIATE   => IMM_BUF
			   );
	-- REGISTER FILE --------------
	ADR: DEC5X32
		 PORT   MAP(
				SEL  => WB_RD_LOAD,
				RES  => ONE_HOT
			   );
					
	REG: REGISTER_FILE
		 PORT   MAP(
				CLK 	    => CLK,
				RST         => RST,
				LOAD_REG    => ONE_HOT,
				DATA_IN     => WB_RD_DATA,
				ADDR_RS1    => IF_WORD(19 DOWNTO 15),
				ADDR_RS2    => IF_WORD(24 DOWNTO 20),
				DATA_RS1    => RS1_BUF,
				DATA_RS2    => RS2_BUF,
				TEST_GP     => GP -- <= FOR TESTS
				--TEST_T5     => T5,
				--TEST_T4     => T4
			   );

	-- ID ADDER -------------------
	JALR <= (DEC_BUF(12) XOR DEC_BUF(11)) AND DEC_BUF(1);
		
	MXC: MUX2X1
		GENERIC MAP( INSIZE => 32 )
		PORT    MAP(
				D0  => IMM_BUF,
				D1  => "00000000000000000000000000000100",
				SEL => JALR, 
				O   => MUX_BUF
			   );
	
    ADD: ID_ADDER
		PORT    MAP(
				PC_VALUE    => PC_VALUE,
				IMMEDIATE   => MUX_BUF,
				OUTPUT      => ADD_BUF
			   );
	-- ID STALL/FWD ---------------
	SFW: STALL_FWD_PREDICT
		 PORT   MAP(
				RS1    	  => IF_WORD(19 DOWNTO 15),
				RS2    	  => IF_WORD(24 DOWNTO 20),
				RD_E   	  => RD_FROM_EXE,
				RD_M   	  => RD_FROM_MEM,
				LOAD_IN_EXE => PIPE_LOAD_E,
				ISMULDIV => ISMULDIV,
				IMGEN  	  => DEC_BUF(CTRL_WORD_TOTAL-1 DOWNTO CTRL_WORD_TOTAL-3),
				STALL  	  => PIPE_STALL,
				FWDA   	  => PIPE_FWDA,
				FWDB   	  => PIPE_FWDB,
				FWDC   	  => PIPE_FWDC
			   );
	
					
	-- CTRL WORD APPEND JALR ------
	CTRL(CTRL_WORD_OUT-1 DOWNTO 1) <= DEC_BUF(CTRL_WORD_TOTAL-4 DOWNTO 0);
	CTRL(0) 		       <= JALR;
	
	-- OUTPUTS --------------------
	RS1_VALUE  <= RS1_BUF;
	RS2_VALUE  <= RS2_BUF;
	RD_ADDR    <= IF_WORD(11 DOWNTO 7);
	IMMEDIATE  <= IMM_BUF;
   	TARGET_AD  <= ADD_BUF;
	PC_VALUE_O <= PC_VALUE;
	CTRL_WORD  <= CTRL;
	-- END TEST
	SIMULATION_END <= AND_REDUCE(OPCODE XNOR "11100"); -- ECALL
	  
END STRUCTURAL;
