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

-- *** SECONDARY PACKAGE FILE ***
----------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE PIPELINE IS 

----------------------------------------------------------------------------------
	COMPONENT PC_REGISTER IS

		PORT(	
			CLK,RST : IN  STD_LOGIC;
			STALL   : IN  STD_LOGIC;
			NEXT_PC : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
			
	END COMPONENT PC_REGISTER;                    		    -- PC REGISTER
----------------------------------------------------------------------------------
	COMPONENT PIPE_IF_TO_ID_REGISTER IS

		PORT(	
			CLK,RST   : IN  STD_LOGIC;
			FLUSH     : IN  STD_LOGIC;
			STALL     : IN  STD_LOGIC;
				
			I_IF_WORD : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			I_PC_ADDR : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			O_IF_WORD : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			O_PC_ADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );

	END COMPONENT PIPE_IF_TO_ID_REGISTER;			   -- IF -> ID REG
----------------------------------------------------------------------------------
	COMPONENT PIPE_ID_TO_EXE_REGISTER IS

		PORT( 
			CLK,RST : IN  STD_LOGIC;
			FLUSH   : IN  STD_LOGIC;
			STALL   : IN  STD_LOGIC;

			-- MUL/DIV MULTICYCLING IN --
			ISMULDIV: IN  STD_LOGIC;
			COUNTER_MULTICYCLING : IN STD_LOGIC_VECTOR(4  DOWNTO 0);
			CTRL_WORD_FROM_EXE: IN STD_LOGIC_VECTOR(18 DOWNTO 0);
			PCS_FROM_EXE: IN STD_LOGIC_VECTOR(31 DOWNTO 0); --IF MUL/DIV : PCS FROM EXE
			PCC_FROM_EXE: IN STD_LOGIC_VECTOR(31 DOWNTO 0); --IF MUL/DIV : PCC FROM EXE
			RESULT_FROM_EXE: IN STD_LOGIC_VECTOR(31 DOWNTO 0); --IF MUL/DIV : RESULT FROM EXE
			PREVAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			PREVBIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			MUL_DIV_RD_ADDR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

			I_RS1_VAL: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			I_RS2_VAL: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			I_IMM_VAL: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			I_RD_ADDR: IN STD_LOGIC_VECTOR(4  DOWNTO 0);
			I_PC_VAL : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				
			I_TARGET_ADDR: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			I_CTRL_WORD: IN STD_LOGIC_VECTOR(18 DOWNTO 0);
			
			I_FWD_A  : IN STD_LOGIC_VECTOR(1  DOWNTO 0);
			I_FWD_B  : IN STD_LOGIC_VECTOR(1  DOWNTO 0);
				
			O_RS1_VAL: OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --IF MUL/DIV : PCS FOR EXE
			O_RS2_VAL: OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --IF MUL/DIV : PCC FOR EXE 
			O_IMM_VAL: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			O_RD_ADDR: OUT STD_LOGIC_VECTOR(4  DOWNTO 0);
			O_PC_VAL : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				
			O_TARGET_ADDR: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			O_CTRL_WORD : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
				
			O_FWD_A  : OUT STD_LOGIC_VECTOR(1  DOWNTO 0);
			O_FWD_B  : OUT STD_LOGIC_VECTOR(1  DOWNTO 0);
			
			-- MUL/DIV MULTICYCLING OUT --
			RESULT_FOR_EXE: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			PREVAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			PREVBOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			COUNTER_OUT_MULTICYCLING : OUT STD_LOGIC_VECTOR(4  DOWNTO 0)
				
			);
			
	END COMPONENT PIPE_ID_TO_EXE_REGISTER;                    -- ID -> EXE REG
----------------------------------------------------------------------------------
	COMPONENT PIPE_EXE_TO_MEM_REGISTER IS

		PORT(
			CLK,RST    : IN  STD_LOGIC;
			I_FWD_C    : IN  STD_LOGIC;
			I_ALU_RES  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			I_RD_ADDR  : IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			I_RS2_VAL  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP_MEM_WB  : IN  STD_LOGIC_VECTOR(4  DOWNTO 0); 
				
			OP_WB     : OUT STD_LOGIC_VECTOR(3  DOWNTO 0); 
			OP_MEM    : OUT STD_LOGIC_VECTOR(3  DOWNTO 0);
			O_RD_ADDR : OUT STD_LOGIC_VECTOR(4  DOWNTO 0); 
			O_RS2_VAL : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); 
			O_ALU_RES : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); 
			O_FWD_C   : OUT STD_LOGIC
				
		    );
			 
	END COMPONENT PIPE_EXE_TO_MEM_REGISTER;			 -- EXE -> MEM REG
----------------------------------------------------------------------------------
	
	COMPONENT PIPE_MEM_TO_WB_REGISTER IS

		PORT(	
			CLK,RST   : IN  STD_LOGIC;
			I_MEM_RES : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			I_ALU_RES : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP_WB     : IN  STD_LOGIC_VECTOR(3  DOWNTO 0);
			I_RD_ADDR : IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
				
			O_MEM_RES : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			O_ALU_RES : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			O_RD_ADDR : OUT STD_LOGIC_VECTOR(4  DOWNTO 0);
			OP_WB_LOG : OUT STD_LOGIC_VECTOR(3  DOWNTO 0)
				
		   );

	END COMPONENT PIPE_MEM_TO_WB_REGISTER;                    -- MEM -> WB REG
----------------------------------------------------------------------------------
	COMPONENT INSTRUCTION_FETCH IS

		PORT(
			GLB_CLK: IN  STD_LOGIC;
			STALL  : IN  STD_LOGIC;
			PC     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			MEMWORD: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			PC_ADD : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
			
	END COMPONENT INSTRUCTION_FETCH;
-----------------------------------------------------------------------------------
	COMPONENT INSTRUCTION_DECODE IS 
		
		GENERIC ( CTRL_WORD_TOTAL : INTEGER := 20; CTRL_WORD_OUT : INTEGER := 18);
		PORT 	( 	
				CLK,RST    : IN  STD_LOGIC;						--\
				WB_RD_LOAD : IN  STD_LOGIC_VECTOR(4  DOWNTO 0); --| Register File inputs.
				WB_RD_DATA : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); --/ 	
				PC_VALUE   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); -- Feed from
				IF_WORD    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); -- Instruction Fetch
					
				RD_FROM_EXE: IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
				RD_FROM_MEM: IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
				PIPE_LOAD_E: IN  STD_LOGIC;
				ISMULDIV   : IN STD_LOGIC;

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
				GP 	       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
				--T5	       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				--T4	       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);

	END COMPONENT INSTRUCTION_DECODE;
	
-----------------------------------------------------------------------------------
	COMPONENT EXE IS
		PORT(
			A  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP : IN  STD_LOGIC_VECTOR(9  DOWNTO 0); 
			RES: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			TNT: OUT STD_LOGIC
				
		    );

	END COMPONENT EXE;
-----------------------------------------------------------------------------------
	COMPONENT EXE_MUL_DIV IS
		PORT(
			MULTICYCLING : IN STD_LOGIC;
			A  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP : IN  STD_LOGIC_VECTOR(9  DOWNTO 0);
			CYCLE : IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			PREVPCS : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			PREVPCC : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			PREVRESULT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ISMULDIV : OUT STD_LOGIC;
			NEXTPCS : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
			NEXTPCC : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
			NEXTRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RES    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
				
			);

	END COMPONENT EXE_MUL_DIV;
-----------------------------------------------------------------------------------
	COMPONENT MEMORY IS

		PORT(
			CLK    		 : IN  STD_LOGIC;
			OPCODE_PIPE  	 : IN  STD_LOGIC_VECTOR(3  DOWNTO 0); 
			OPCODE_BYPSS 	 : IN  STD_LOGIC_VECTOR(2  DOWNTO 0); 
			ALU_RES_PIPE 	 : IN  STD_LOGIC_VECTOR(1  DOWNTO 0); 
			ALU_RES_BYPSS    : IN  STD_LOGIC_VECTOR(1  DOWNTO 0); 
			WR_ADR 		 : IN  STD_LOGIC_VECTOR(6  DOWNTO 0); 
			WR_DAT 		 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0); 
			
			MEM_RES: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
		 
	END COMPONENT MEMORY;
-----------------------------------------------------------------------------------
	COMPONENT WRITE_BACK IS

		PORT(
			WB_OP : IN  STD_LOGIC;
			WB_ADR: IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			WB_DAT: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			RD_ADR: OUT STD_LOGIC_VECTOR(4  DOWNTO 0);
			RD_DAT: OUT STD_LOGIC_vECTOR(31 DOWNTO 0)
		    );

	END COMPONENT WRITE_BACK;
-----------------------------------------------------------------------------------

END PACKAGE PIPELINE;