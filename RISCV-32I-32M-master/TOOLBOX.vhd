-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	       |
-- |===========================================================|
-- |student:    Deligiannis Nikos			       |
-- |supervisor: Aristides Efthymiou			       |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2019      	       |
-- |  		     VCAS LABORATORY			       |
-- +===========================================================+

-- *** MAIN PACKAGE FILE ***
----------------------------------------------------------------
-- Usage: LIBRARY WORK; USE WORK.TOOLBOX.ALL;
----------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.PIPELINE.ALL;

PACKAGE TOOLBOX IS
-------------------------------------------------------------------------	
-- [0] GENERAL PURPOSE COMPONENTS
-------------------------------------------------------------------------
	-- Defined @ "MUX2X1.vhd" file.
	COMPONENT MUX2X1 IS

		GENERIC ( INSIZE : INTEGER := 10 );
	
		PORT(
			D0  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D1  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			SEL : IN  STD_LOGIC;
			O   : OUT STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0)
		    );

	END COMPONENT MUX2X1;
	
-------------------------------------------------------------------------
	-- Defined @ "MUX2X1_BIT.vhd" file.
	COMPONENT MUX2X1_BIT IS

		PORT( 
			D0  : IN  STD_LOGIC;
			D1  : IN  STD_LOGIC;
			SEL : IN  STD_LOGIC;
			O   : OUT STD_LOGIC
		    );
		 
	END COMPONENT MUX2X1_BIT;
-------------------------------------------------------------------------
	-- Defined @ "MUX4X1.vhd" file.
	COMPONENT MUX4X1 IS 
		
		GENERIC ( INSIZE : INTEGER := 10 );
		
		PORT(	
			D0  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D1  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D2  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D3  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
				
			SEL : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			 
			O : OUT STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0)
		    );

	END COMPONENT MUX4X1;
-------------------------------------------------------------------------
	-- Defined @ "MUX8X1.vhd" file.
	COMPONENT MUX8X1 IS 

		GENERIC ( INSIZE : INTEGER := 10 );
		
		PORT(	
			D0  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D1  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D2  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D3  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D4  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D5  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D6  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D7  : IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			
			SEL : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		 
			O : OUT STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0)
		    );

	END COMPONENT MUX8X1;
	
-------------------------------------------------------------------------
	-- Defined @ "MUX32X1.vhd" file.
	COMPONENT MUX32X1 IS

		GENERIC ( INSIZE : INTEGER := 10 );
		
		PORT(
		
			D0: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D1: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D2: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D3: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D4: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D5: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D6: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D7: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D8: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D9: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D10: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D11: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D12: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D13: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D14: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D15: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D16: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D17: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D18: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D19: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D20: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D21: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D22: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D23: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D24: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D25: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D26: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D27: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D28: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D29: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D30: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			D31: IN  STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0);
			
			SEL: IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				
			O  : OUT STD_LOGIC_VECTOR(INSIZE-1 DOWNTO 0)
		    );
			
	END COMPONENT MUX32X1;
	
-------------------------------------------------------------------------
	-- Defined @ "SIZE_COMPARATOR.vhd" file.
	COMPONENT SIZE_COMPARATOR IS

		PORT( 
			A  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			O   : OUT STD_LOGIC
		    );
		 
	END COMPONENT SIZE_COMPARATOR;
-------------------------------------------------------------------------

	-- Defined @ "DEC5X32.vhd" file.
	COMPONENT DEC5X32 IS 

		PORT(
			SEL : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
			RES : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
			 
	END COMPONENT DEC5X32;	
-------------------------------------------------------------------------
-- [1] INSTRUCTION FETCH COMPONENTS 
-------------------------------------------------------------------------
	-- Defined @ "IF_INSTR.vhd" file.
	COMPONENT IF_INSTRMEM IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			clken		: IN STD_LOGIC  := '1';
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT IF_INSTRMEM;
-------------------------------------------------------------------------
-- [2] INSTRUCTION DECODE COMPONENTS
-------------------------------------------------------------------------
	-- Defined @ "ID_DECODER.vhd" file.
	COMPONENT ID_DECODER IS

		GENERIC ( CTRL_WORD_SIZE : INTEGER := 20 );
	
		PORT(
			MUX_4X1_SEL  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);                    
			MUX_8X1_SEL  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			MUX_32X1_SEL : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
			CONTROL_WORD : OUT STD_LOGIC_VECTOR(CTRL_WORD_SIZE-1 DOWNTO 0)
		    );

	END COMPONENT ID_DECODER;
-------------------------------------------------------------------------
	-- Defined @ "ID_IMM_GENERATOR.vhd" file.
	COMPONENT ID_IMM_GENERATOR IS

		PORT(
			IMM_TYPE  : IN  STD_LOGIC_VECTOR(2  DOWNTO 0);
			IF_WORD   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			IMMEDIATE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)	
		    );
		 
	END COMPONENT ID_IMM_GENERATOR;
-------------------------------------------------------------------------	
	-- Defined @ "REG_32B_ZERO.vhd" file.
	COMPONENT REG_32B_ZERO IS

		PORT(
			CLK   : IN  STD_LOGIC;
			Q_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );

	END COMPONENT REG_32B_ZERO;
-------------------------------------------------------------------------	
	-- Defined @ "REG_32B_CASUAL.vhd" file.
	COMPONENT REG_32B_CASUAL IS

		PORT(
			LOAD, CLK, RST : IN  STD_LOGIC;
			DATA		   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			Q_OUT 		   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );

	END COMPONENT REG_32B_CASUAL;
-------------------------------------------------------------------------		
	-- Defined @ "REGISTER_FILE.vhd" file.
	COMPONENT REGISTER_FILE IS 

		PORT( 
			CLK,RST  : IN  STD_LOGIC;
			LOAD_REG : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_IN  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_RS1 : IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			ADDR_RS2 : IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			DATA_RS1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_RS2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			TEST_GP  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		--	TEST_T5  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		--	TEST_T4  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
			 
	END COMPONENT REGISTER_FILE;
-------------------------------------------------------------------------
	-- Defined @ "ADDER_2B.vhd" file.
	COMPONENT ADDER_2B IS
			
		PORT( 
			A  : IN STD_LOGIC;
			B  : IN STD_LOGIC;
			CI : IN STD_LOGIC;
			S  : OUT STD_LOGIC;
			CO : OUT STD_LOGIC 
		    );

	END COMPONENT ADDER_2B;
-------------------------------------------------------------------------
	COMPONENT ADDER_2B_MSB IS

		PORT( 
			A  : IN STD_LOGIC;
			B  : IN STD_LOGIC;
			CI : IN STD_LOGIC;
			S  : OUT STD_LOGIC
		    );

	END COMPONENT ADDER_2B_MSB;
-------------------------------------------------------------------------
	-- Defined @ "ID_ADDER.vhd" file
	COMPONENT ID_ADDER IS
	
		 PORT(
			PC_VALUE  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			IMMEDIATE : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OUTPUT 	  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		     );
		 
	END COMPONENT ID_ADDER;
-------------------------------------------------------------------------
	-- Defined @ "STALL_FWD_PREDICT.vhd" file.
	COMPONENT STALL_FWD_PREDICT IS

		PORT( 
			RS1  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
			RS2  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
			RD_E : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
			RD_M : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
				
			LOAD_IN_EXE : IN  STD_LOGIC; 
				
			IMGEN : IN STD_LOGIC_VECTOR(2 DOWNTO  0);
				
			STALL: OUT STD_LOGIC;
			FWDA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			FWDB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); 
			FWDC : OUT STD_LOGIC                     
		    );

	END COMPONENT STALL_FWD_PREDICT;
-------------------------------------------------------------------------	
-- [3] EXE - ALU COMPONENTS
-------------------------------------------------------------------------
	COMPONENT CONTROL_WORD_REGROUP IS 

		PORT(
			CTRL_WORD : IN  STD_LOGIC_VECTOR(18 DOWNTO 0);
			
			TO_EXE_SELECTOR: OUT STD_LOGIC_VECTOR(3 DOWNTO 0); 
			TO_EXE_ALU     : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); 
			TO_OTHERS      : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)  
		    );
			 
	END COMPONENT CONTROL_WORD_REGROUP;
-------------------------------------------------------------------------	
	COMPONENT DECODE_TO_EXECUTE IS 

		PORT( 
			RS1  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			RS2  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			PC_I : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			IMME : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
				
			JALR : IN  STD_LOGIC;
			JUMP : IN  STD_LOGIC;
			PC   : IN  STD_LOGIC;
			IMM  : IN  STD_LOGIC;
			
			A    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			B    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
			 
	END COMPONENT DECODE_TO_EXECUTE;
-------------------------------------------------------------------------	

	COMPONENT PC_PLUS_4 IS

		PORT(
			PC : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			RES: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );

	END COMPONENT PC_PLUS_4;
-------------------------------------------------------------------------
	-- Defined @ "BARREL_CELL.vhd" file.
	COMPONENT BARREL_CELL IS
	
		PORT(
			D0    : IN  STD_LOGIC;
			D1    : IN  STD_LOGIC;
			D2    : IN  STD_LOGIC;
			SEL   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			O     : OUT STD_LOGIC
		    );

	END COMPONENT BARREL_CELL;
-------------------------------------------------------------------------
	-- Defined @ "BARREL_SHIFTER.vhd" file.
	COMPONENT BARREL_SHIFTER IS
	
		PORT(
			VALUE_A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			SHAMT_B : IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
			OPCODE  : IN  STD_LOGIC_VECTOR(1  DOWNTO 0); 
			RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
		 
	END COMPONENT BARREL_SHIFTER;
-------------------------------------------------------------------------
	-- Defined @ "EXE_LOGIC_MODULE.vhd" file.
	COMPONENT EXE_LOGIC_MODULE IS 
	
		PORT(
			A   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP  : IN  STD_LOGIC_VECTOR(1  DOWNTO 0);
			RES : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
			 
	END COMPONENT EXE_LOGIC_MODULE;
-------------------------------------------------------------------------
	-- Defined @ "EXE_ADDER_SUBBER_CELL.vhd" file.
	COMPONENT EXE_ADDER_SUBBER_CELL IS

		PORT(
		    	A  : IN  STD_LOGIC; 
			B  : IN  STD_LOGIC;
			CI : IN  STD_LOGIC;
			OP : IN  STD_LOGIC;
			S  : OUT STD_LOGIC;
			CO : OUT STD_LOGIC
		    );
		 
	END COMPONENT EXE_ADDER_SUBBER_CELL;
-------------------------------------------------------------------------
	COMPONENT EXE_ADDER_SUBBER_CELL_MSB IS 

		PORT(
			A  : IN  STD_LOGIC; 
			B  : IN  STD_LOGIC;
			CI : IN  STD_LOGIC;
			OP : IN  STD_LOGIC; -- O = ADD / 1 = INVERT B
			S  : OUT STD_LOGIC
		    );
			 
	END COMPONENT EXE_ADDER_SUBBER_CELL_MSB;
-------------------------------------------------------------------------
	-- Defined @ "EXE_ADDER_SUBBER.vhd" file.
	COMPONENT EXE_ADDER_SUBBER IS 

		PORT (
			A  : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
			B  : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
			OP : IN  STD_LOGIC; -- OPCODE [0: ADD / 1: SUB]
			S  : OUT STD_LOGIC_VECTOR(32 DOWNTO 0)
		     );
			 
	END COMPONENT EXE_ADDER_SUBBER;
-------------------------------------------------------------------------
	-- Defined @ "EXE_BRANCH_RESOLVE.vhd" file.
	COMPONENT EXE_BRANCH_RESOLVE IS 
		
		PORT( 
			RES  : IN  STD_LOGIC_VECTOR(32 DOWNTO 0);
			EQLT : IN  STD_LOGIC;
			INV  : IN  STD_LOGIC;
			T_NT : OUT STD_LOGIC
		    );

	END COMPONENT EXE_BRANCH_RESOLVE;
-------------------------------------------------------------------------
	-- Defined @ "EXE_SLT_MODULE.vhd" file.
	COMPONENT EXE_SLT_MODULE IS

		PORT( 
			INPUT : IN  STD_LOGIC;
			OUTPUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );

	END COMPONENT EXE_SLT_MODULE;
-------------------------------------------------------------------------
	-- Defined @ "MUL.vhd" file.
	COMPONENT MUL IS

		PORT(
			A 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B 	: IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
			MSBRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    	);

	END COMPONENT MUL;
-------------------------------------------------------------------------
	-- Defined @ "DIV.vhd" file.
	COMPONENT DIV IS

		PORT(
			A 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B 	: IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
			REMAINDER  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    	);

	END COMPONENT DIV;
-------------------------------------------------------------------------
	-- Defined @ "TWOS_COMPLEMENT.vhd" file.
	COMPONENT TWOS_COMPLEMENT IS

		PORT(
			A 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OP 	: IN  STD_LOGIC;
			SIGNE : IN  STD_LOGIC;
			CIN : IN  STD_LOGIC;
          	COUT : OUT  STD_LOGIC;
			RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    	);

	END COMPONENT TWOS_COMPLEMENT;
-------------------------------------------------------------------------
-- [4] MEM 
-------------------------------------------------------------------------
	-- Defined @ "MEM_DATAMEM.vhd" file.
	COMPONENT MEM_DATAMEM IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			byteena		: IN STD_LOGIC_VECTOR (3 DOWNTO 0) :=  (OTHERS => '1');
			clken		: IN STD_LOGIC  := '1';
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT MEM_DATAMEM;
-------------------------------------------------------------------------
	-- Defined @ "MEM_STORE_BYTEEN.vhd" file.
	COMPONENT MEM_STORE_BYTEEN IS

		PORT(	
			ALU_LSBS: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			OPCODE  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			DATA_IN : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			BYTEEN  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		    );

	END COMPONENT MEM_STORE_BYTEEN;
-------------------------------------------------------------------------
	-- Defined @ "MEM_LOADS_MASKING" file.
	COMPONENT MEM_LOADS_MASKING IS

		PORT( 
			ALU_LSBS: IN  STD_LOGIC_VECTOR(1  DOWNTO 0);
			U	: IN  STD_LOGIC;
			OPCODE  : IN  STD_LOGIC_VECTOR(1  DOWNTO 0);
			MEM_VAL : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			OUTPUT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );
			 
	END COMPONENT MEM_LOADS_MASKING;
-------------------------------------------------------------------------
-- [5] WB
-------------------------------------------------------------------------
	COMPONENT MEM_TO_WB IS

		PORT(
			MEM_IN: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			ALU_IN: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			MEMOP : IN  STD_LOGIC_VECTOR(2  DOWNTO 0);

			WB_IN : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		    );

	END COMPONENT MEM_TO_WB;
-------------------------------------------------------------------------

END PACKAGE TOOLBOX;