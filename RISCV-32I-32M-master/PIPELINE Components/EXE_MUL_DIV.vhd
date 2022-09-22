LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;	
USE IEEE.STD_LOGIC_MISC.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY EXE_MUL_DIV IS 

	PORT(
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
		RES  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			
	    );

END EXE_MUL_DIV;

ARCHITECTURE STRUCTURAL OF EXE_MUL_DIV IS 
	-- MUL/DIV SIGS ----------------------------
	SIGNAL A_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL B_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SIGNE : STD_LOGIC;
	SIGNAL COUT_MULH : STD_LOGIC;
	SIGNAL SIGNNOTMULH : STD_LOGIC;
	SIGNAL OPMULHSU : STD_LOGIC;
	SIGNAL OPMULDIVA : STD_LOGIC;
    SIGNAL NOTOPMULDIVA : STD_LOGIC;
	SIGNAL OPMULDIVB : STD_LOGIC;
    SIGNAL MUSTTWOCOMPLEMENTA : STD_LOGIC;
	SIGNAL MUSTTWOCOMPLEMENTB : STD_LOGIC;

	SIGNAL START_MULTICYCLING : STD_LOGIC;
	SIGNAL END_MULTICYCLING : STD_LOGIC;
	SIGNAL END_MULTICYCLING_DIV : STD_LOGIC;
	SIGNAL END_MULTICYCLING_MUL : STD_LOGIC;
	SIGNAL END_CYCLE :STD_LOGIC;

	SIGNAL NEXTPCSMUL : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL NEXTPCSDIV : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL NEXTRESULTMUL : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL NEXTRESULTDIV : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL DIV_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL REM_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MUL_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MULH_COMPLEMENT : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL MUL_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MULH_RES   : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DIV_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL REM_RES    : STD_LOGIC_VECTOR(31 DOWNTO 0);


	BEGIN
		
	
	END_MULTICYCLING_MUL <= AND_REDUCE(CYCLE(1 DOWNTO 0)); -- 4 CYCLES MULTIPLICATION
	--END_MULTICYCLING_MUL <= CYCLE(0); -- 2 CYCLES MULTIPLICATION
	END_MULTICYCLING_DIV <= AND_REDUCE(CYCLE(4 DOWNTO 0)); -- 32 CYCLES DIVISION
	--END_MULTICYCLING_DIV <= AND_REDUCE(CYCLE(3 DOWNTO 0)); -- 16 CYCLES DIVISION

	END_MULTICYCLING_CYCLE: MUX2X1_BIT
		PORT MAP(
				D0  => END_MULTICYCLING_MUL,
				D1  => END_MULTICYCLING_DIV,
				SEL => OP(6),
				O   => END_CYCLE
			);
	END_MULTICYCLING <= NOT (END_CYCLE AND OP(7));
    START_MULTICYCLING <= NOR_REDUCE(CYCLE(4 DOWNTO 0));

	-- TWO_COMPLEMENT ---------------------------------
	ISMULDIV <= END_MULTICYCLING AND OP(7);
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

    --MUL ---------------------------------
	i_MUL: MUL_MULTICYCLING
		PORT MAP(
				A => A_COMPLEMENT,
                B => B_COMPLEMENT,
				PREVPCS => PREVPCS,
                PREVPCC => PREVPCC,
                PREVRESULT => PREVRESULT,
                CYCLE => CYCLE,
                NEXTPCS => NEXTPCSMUL,
                NEXTPCC => NEXTPCC,
				NEXTRESULT => NEXTRESULTMUL,
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
	i_DIV: DIV_MULTICYCLING
		PORT MAP(
			A => A_COMPLEMENT,
            B => B_COMPLEMENT,
            PREVPCS => PREVPCS,
            PREVRESULT => PREVRESULT,
            CYCLE => CYCLE,
            NEXTPCS => NEXTPCSDIV,
			NEXTRESULT => NEXTRESULTDIV,
            RESULT => DIV_COMPLEMENT,
            REMAINDER => REM_COMPLEMENT
            
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
	
	NEXTPCS_MUX: MUX2X1
        GENERIC MAP( INSIZE => 32 )
        PORT    MAP( 
                D0  => NEXTPCSMUL,
                D1  => NEXTPCSDIV,
                SEL => OP(6),
                O   => NEXTPCS
                );
	NEXTRESULT_MUX: MUX2X1
		GENERIC MAP( INSIZE => 32 )
		PORT    MAP( 
				D0  => NEXTRESULTMUL,
				D1  => NEXTRESULTDIV,
				SEL => OP(6),
				O   => NEXTRESULT
				);		
				
	ALU_MUX: MUX4X1
		GENERIC MAP( INSIZE => 32 )
		PORT    MAP( 
				D0  => MUL_RES,
				D1  => MULH_RES,
				D2  => DIV_RES,
				D3  => REM_RES,
				SEL => OP(6 DOWNTO 5),
				O   => RES
				);		
END STRUCTURAL;