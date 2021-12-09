-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	       |
-- |===========================================================|
-- |student:    Deligiannis Nikos			       |
-- |supervisor: Aristides Efthymiou			       |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2019      	       |
-- |  		     VCAS LABORATORY			       |
-- +===========================================================+

-- *** 3/5: ARITHMETIC AND LOGIC UNIT (EXE-ALU) MODULE DESIGN ***
----------------------------------------------------------------------
-- OP: 87 - 65 - 4 - 3 - 2 - 1 - 0 (9 Bits)
--     ||   ||   |   |   |   |   |
--     BAS  ALU INV EQ 	 |  SLT  LUI
--     LOG  OP 		LT   |
--     ADD				BRANCH
--     OP
----------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;	

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY EXE IS 

	PORT(
		A  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		OP : IN  STD_LOGIC_VECTOR(9  DOWNTO 0); 
		RES: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		TNT: OUT STD_LOGIC
			
	    );

END EXE;

ARCHITECTURE STRUCTURAL OF EXE IS 
	
	-- ADDER/SUBBER SIGS ----------------------------
	SIGNAL ADDER_A_MSB: STD_LOGIC;
	SIGNAL ADDER_B_MSB: STD_LOGIC;
	SIGNAL ADDER_RES  : STD_LOGIC_VECTOR(32 DOWNTO 0);	
	SIGNAL A_EXTENDED : STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL B_EXTENDED : STD_LOGIC_VECTOR(32 DOWNTO 0);
	-- SLT SIG --------------------------------------
	SIGNAL SLT_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- 8X1 MUX ALU ----------------------------------
	SIGNAL ADD_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SUB_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LOG_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL BAS_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MUL_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- CARRIERS -------------------------------------
	SIGNAL ALU_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL BRANCH_RES : STD_LOGIC; 
	--GND--------------------------------------------
	CONSTANT GND      : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	
	BEGIN
		
	-- ADDER/SUBBER ---------------------------------
	MUX_A: MUX2X1_BIT
	        PORT MAP(
		                D0  => A(31),
				D1  =>   '0',
				SEL => OP(9),
				O   => ADDER_A_MSB
			);
	MUX_B: MUX2X1_BIT
		PORT MAP(
				D0  => B(31),
				D1  =>   '0',
				SEL => OP(9),
				O   => ADDER_B_MSB
			);

	A_EXTENDED <= ADDER_A_MSB & A;
	B_EXTENDED <= ADDER_B_MSB & B;

	ADSB: EXE_ADDER_SUBBER
		PORT MAP(
				A  => A_EXTENDED,
				B  => B_EXTENDED,
				OP => OP(5),
				S  => ADDER_RES
			);
	-- MUL ---------------------------------
	i_MUL: MUL
		PORT MAP(
				A => A,
				B => B,
				RESULT => MUL_RES
			);
	-- BRANCH RESOLVER ------------------------------
	BRANCH: EXE_BRANCH_RESOLVE
		PORT MAP(
			  	RES => ADDER_RES,
				EQLT=> OP(3),
				INV => OP(4),
				T_NT=> BRANCH_RES
			);
				  
	-- SLT ------------------------------------------
	SLTU: EXE_SLT_MODULE
		PORT MAP(
				INPUT  => ADDER_RES(32),
				OUTPUT => SLT_RES
			);
				  
	-- LOGIC MODULE ---------------------------------
	LOGIC: EXE_LOGIC_MODULE
		PORT MAP(
				A  => A,
				B  => B,
				OP => OP(9 DOWNTO 8),
				RES=> LOG_RES
			);
	
	-- BARREL SHIFTER -------------------------------
	SHIFT: BARREL_SHIFTER
		PORT MAP(
				VALUE_A => A,
				SHAMT_B => B(4 DOWNTO 0), -- 5 LSBS = SHAMT
				OPCODE  => OP(9 DOWNTO 8),
				RESULT  => BAS_RES
			);
				  
	-- ALU RESULT MUX -------------------------------
	LUI_MUX: MUX2X1
		GENERIC MAP( INSIZE => 32 )
		PORT    MAP(
			   	D0  => ADDER_RES(31 DOWNTO 0),
				D1  => B,
				SEL => OP(0),
				O   => ADD_RES
			   );
	SLT_MUX: MUX2X1
		GENERIC MAP( INSIZE => 32 )
		PORT    MAP(
			   	D0  => ADDER_RES(31 DOWNTO 0),
				D1  => SLT_RES,
				SEL => OP(1),
				O   => SUB_RES
			   );
	ALU_MUX: MUX8X1
		GENERIC MAP( INSIZE => 32 )
		PORT    MAP( 
			   	D0  => ADD_RES,
				D1  => SUB_RES,
				D2  => LOG_RES,
				D3  => BAS_RES,
				D4  => MUL_RES,
				D5  => GND,
				D6  => GND,
				D7  => GND,
				SEL => OP(7 DOWNTO 5),
				O   => ALU_RES
			   );

	
	TNT <= BRANCH_RES AND OP(2);
	RES <= ALU_RES;
		
END STRUCTURAL;