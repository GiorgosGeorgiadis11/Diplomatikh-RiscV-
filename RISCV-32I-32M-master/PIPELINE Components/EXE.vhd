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
	-- MUL/DIV SIGS ----------------------------
	SIGNAL A_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL B_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SIGNE : STD_LOGIC;
	SIGNAL COUT_MULH : STD_LOGIC;
	SIGNAL SIGNNOTMULH : STD_LOGIC;
	SIGNAL OPMULHSU : STD_LOGIC;
	SIGNAL OPMULDIVA : STD_LOGIC;
	SIGNAL OPMULDIVB : STD_LOGIC;
	SIGNAL DIV_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL REM_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MUL_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MULH_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- SLT SIG --------------------------------------
	SIGNAL SLT_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- 8X1 MUX ALU ----------------------------------
	SIGNAL ADD_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SUB_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LOG_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL BAS_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MUL_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MULH_RES   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DIV_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL REM_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
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
	-- TWO_COMPLEMENT ---------------------------------
	OPMULHSU <= (OP(8) AND OP(9));
	MUX_MULDIVOPA: MUX2X1_BIT
		PORT MAP(
				D0  => OP(9),
				D1  => '0',
				SEL => OPMULHSU,
				O   => OPMULDIVA
			);
	MUX_MULDIVOPB: MUX2X1_BIT
		PORT MAP(
				D0  => OP(9),
				D1  => '1',
				SEL => OPMULHSU,
				O   => OPMULDIVB
			);
	TWO_COMPLEMENT_A: TWOS_COMPLEMENT
		PORT MAP(
			A  => A,
			OP  =>   OPMULDIVA,
			SIGNE => A(31),
			CIN => '1',
			RESULT   => A_COMPLEMENT
		);
	TWO_COMPLEMENT_B: TWOS_COMPLEMENT
		PORT MAP(
			A  => B,
			OP  =>   OPMULDIVB,
			SIGNE => B(31),
			CIN => '1',
			RESULT   => B_COMPLEMENT
		);

	SIGNNOTMULH<=A(31) XOR B(31);
	MUX_SIGN: MUX2X1_BIT
		PORT MAP(
				D0  => SIGNNOTMULH,
				D1  => A(31),
				SEL => OPMULHSU,
				O   => SIGNE
			);

	-- MUL ---------------------------------
	i_MUL: MUL
		PORT MAP(
				A => A_COMPLEMENT,
				B => B_COMPLEMENT,
				MSBRESULT => MULH_COMPLEMENT,
				RESULT => MUL_COMPLEMENT
			);

	TWO_COMPLEMENT_MUL_RES: TWOS_COMPLEMENT
		PORT MAP(
			A  => MUL_COMPLEMENT,
			OP  =>   OPMULDIVA,
			SIGNE => SIGNE,
			CIN => '1',
			COUT => COUT_MULH,
			RESULT   => MUL_RES
		);
	TWO_COMPLEMENT_MULH_RES: TWOS_COMPLEMENT
			PORT MAP(
				A  => MULH_COMPLEMENT,
				OP  =>   OPMULDIVA,
				SIGNE => SIGNE,
				CIN => COUT_MULH,
				RESULT   => MULH_RES
			);
	-- DIV ---------------------------------
	i_DIV: DIV
		PORT MAP(
			A => A_COMPLEMENT,
			B => B_COMPLEMENT,
			REMAINDER => REM_COMPLEMENT,
			RESULT => DIV_COMPLEMENT
		);

	TWO_COMPLEMENT_DIV_RES: TWOS_COMPLEMENT
		PORT MAP(
			A  => DIV_COMPLEMENT,
			OP  =>   OPMULDIVA,
			SIGNE => SIGNE,
			CIN => '1',
			RESULT   => DIV_RES
		);
	TWO_COMPLEMENT_REM_RES: TWOS_COMPLEMENT
			PORT MAP(
				A  => REM_COMPLEMENT,
				OP  =>   OPMULDIVA,
				SIGNE => SIGNE,
				CIN => '1',
				RESULT   => REM_RES
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
				D5  => MULH_RES,
				D6  => DIV_RES,
				D7  => REM_RES,
				SEL => OP(7 DOWNTO 5),
				O   => ALU_RES
			   );

	
	TNT <= BRANCH_RES AND OP(2);
	RES <= ALU_RES;
		
END STRUCTURAL;