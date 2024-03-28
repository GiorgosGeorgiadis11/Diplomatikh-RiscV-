-- +===========================================================+
-- |		RISC-V RV32I(M) ISA IMPLEMENTATION  	           |
-- |===========================================================|
-- |student:    Georgios Georgiadis			                   |
-- |supervisor: Kavousianos Xrysovalantis			           |
-- |===========================================================|
-- |		UNIVERSITY OF IOANNINA - 2022      	               |
-- |  		     VCAS LABORATORY			                   |
-- +===========================================================+

-- 4 cycles multiplier
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY MUL_MULTICYCLING IS
	PORT(
		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
        PREVPCS : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        PREVPCC : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        PREVRESULT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CYCLE : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        NEXTPCS : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
        NEXTPCC : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
        NEXTRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        MSBRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );	 
END MUL_MULTICYCLING;

ARCHITECTURE STRUCTURAL OF MUL_MULTICYCLING IS

    TYPE ARR16X32 IS ARRAY(0 TO 8) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL APC : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL ACYCLE0 , ACYCLE1 , ACYCLE2, ACYCLE3: STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL RES1 ,RES2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC : ARR16X32;
    SIGNAL PCS : ARR16X32;
    SIGNAL PCC : ARR16X32;
    SIGNAL RAS,RAC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FIRSTCYCLE : STD_LOGIC;
    SIGNAL OP : STD_LOGIC := '0'; --for add

    BEGIN
    ACYCLE0 <= '0' & A(7 DOWNTO 0);
    ACYCLE1 <= A(15 DOWNTO 8)  & '0';
    ACYCLE2 <= A(23 DOWNTO 16) & '0';
    ACYCLE3 <= A(31 DOWNTO 24) & '0';
    SELECTA :MUX4X1
        GENERIC MAP(INSIZE => 9)
            PORT MAP(
            D0 => ACYCLE0,
            D1 => ACYCLE1,
            D2 => ACYCLE2,
            D3 => ACYCLE3,
            SEL => CYCLE(1 DOWNTO 0),
            O=> APC
            );
    ICOMPUTEPC:FOR I IN 0 TO 8 GENERATE
        JCOMPUTEPC:FOR J IN 0 TO 31 GENERATE
            PC(I)(J) <= APC(I) AND B(J);
        END GENERATE JCOMPUTEPC;
    END GENERATE ICOMPUTEPC;

    FIRSTCYCLE <= NOR_REDUCE(CYCLE(1 DOWNTO 0));
    SELECTPCS :MUX2X1
        GENERIC MAP(INSIZE => 32)
            PORT MAP(
            D0 => PREVPCS,
            D1 => PC(0),
            SEL => FIRSTCYCLE,
            O=> PCS(0)
            );
    SELECTPCC :MUX2X1
        GENERIC MAP(INSIZE => 32)
            PORT MAP(
            D0 => PREVPCC,
            D1 => "00000000000000000000000000000000",
            SEL => FIRSTCYCLE,
            O=> PCC(0)
            );
    
    ICOMPUTEPCCS:FOR I IN 1 TO 8 GENERATE
        JCOMPUTEPCCS:FOR J IN 0 TO 30 GENERATE
            COMPUTEPCCS :EXE_ADDER_SUBBER_CELL 
            PORT MAP(
                A=>PC(I)(J),
                B=>PCS(I-1)(J+1),
                CI=>PCC(I-1)(J),
                OP=>OP,
                S=>PCS(I)(J),
                CO=>PCC(I)(J)
            );
            PCS(I)(31)<=PC(I)(31);
        END GENERATE JCOMPUTEPCCS;
    END GENERATE ICOMPUTEPCCS;

    RAC(0) <= '0';
    ICOMPUTERASRAC:FOR I IN 0 TO 30 GENERATE
        COMPUTERASRAC :EXE_ADDER_SUBBER_CELL 
        PORT MAP(
            A=>PCS(8)(I+1),
            B=>PCC(8)(I),
            CI=>RAC(I),
            OP=>OP,
            S=>RAS(I),
            CO=>RAC(I+1)
        );
    END GENERATE ICOMPUTERASRAC;
    SELECTNEXTPCS :MUX2X1
        GENERIC MAP(INSIZE => 32)
            PORT MAP(
            D0 => PCS(8),
            D1 => PCS(7),
            SEL => FIRSTCYCLE,
            O=> NEXTPCS
            );
    SELECTNEXTPCC :MUX2X1
        GENERIC MAP(INSIZE => 32)
            PORT MAP(
            D0 => PCC(8),
            D1 => PCC(7),
            SEL => FIRSTCYCLE,
            O=> NEXTPCC
            );

    COMPUTERES1:FOR I IN 0 TO 7 GENERATE
        RES1(I+24)<=PCS(I)(0);
    END GENERATE COMPUTERES1;
    RES1(23 DOWNTO 0) <= PREVRESULT(31 DOWNTO 8);
    COMPUTERES2:FOR I IN 1 TO 8 GENERATE
        RES2(I+23)<=PCS(I)(0);
    END GENERATE COMPUTERES2;
    RES2(23 DOWNTO 0) <= PREVRESULT(31 DOWNTO 8);
    SELECTRES :MUX2X1
        GENERIC MAP(INSIZE => 32)
            PORT MAP(
            D0 => RES2,
            D1 => RES1,
            SEL => FIRSTCYCLE,
            O=> RESULT
            );
    SELECTRESFORNEXTRESULT :MUX2X1
        GENERIC MAP(INSIZE => 32)
            PORT MAP(
            D0 => RES2,
            D1 => RES1,
            SEL => FIRSTCYCLE,
            O=> NEXTRESULT
            );
    COMPUTEMSBRESULT:FOR I IN 0 TO 30 GENERATE
        MSBRESULT(I)<=RAS(I);
    END GENERATE COMPUTEMSBRESULT;
    MSBRESULT(31) <= RAC(31);

END STRUCTURAL;



-- 2 cycles multiplier
-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_MISC.ALL;

-- LIBRARY WORK;
-- USE WORK.TOOLBOX.ALL;

-- ENTITY MUL_MULTICYCLING IS
-- 	PORT(
-- 		A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
-- 		B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
--         PREVPCS : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
--         PREVPCC : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
--         PREVRESULT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--         CYCLE : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
--         NEXTPCS : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
--         NEXTPCC : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
--         NEXTRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
-- 		RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--         MSBRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
-- 	    );	 
-- END MUL_MULTICYCLING;

-- ARCHITECTURE STRUCTURAL OF MUL_MULTICYCLING IS

--     TYPE ARR16X32 IS ARRAY(0 TO 16) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
--     SIGNAL APC : STD_LOGIC_VECTOR(16 DOWNTO 0);
--     SIGNAL ACYCLE0 : STD_LOGIC_VECTOR(16 DOWNTO 0);
--     SIGNAL ACYCLE1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
--     SIGNAL RES1 ,RES2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
--     SIGNAL PC : ARR16X32;
--     SIGNAL PCS : ARR16X32;
--     SIGNAL PCC : ARR16X32;
--     SIGNAL FIRSTCYCLE : STD_LOGIC;
--     SIGNAL RAS,RAC : STD_LOGIC_VECTOR(31 DOWNTO 0);
--     SIGNAL OP : STD_LOGIC := '0'; --for add

--     BEGIN
--     ACYCLE0 <= '0' & A(15 DOWNTO 0);
--     ACYCLE1 <= A(31 DOWNTO 16) & '0';
--     SELECTA :MUX2X1
--         GENERIC MAP(INSIZE => 17)
--             PORT MAP(
--             D0 => ACYCLE0,
--             D1 => ACYCLE1,
--             SEL => CYCLE(0),
--             O=> APC
--             );
--     ICOMPUTEPC:FOR I IN 0 TO 16 GENERATE
--         JCOMPUTEPC:FOR J IN 0 TO 31 GENERATE
--             PC(I)(J) <= APC(I) AND B(J);
--         END GENERATE JCOMPUTEPC;
--     END GENERATE ICOMPUTEPC;
--     FIRSTCYCLE <= NOR_REDUCE(CYCLE(1 DOWNTO 0));

--     SELECTPCS :MUX2X1
--         GENERIC MAP(INSIZE => 32)
--             PORT MAP(
--             D0 => PREVPCS,
--             D1 => PC(0),
--             SEL => FIRSTCYCLE,
--             O=> PCS(0)
--             );
--     SELECTPCC :MUX2X1
--         GENERIC MAP(INSIZE => 32)
--             PORT MAP(
--             D0 => PREVPCC,
--             D1 => "00000000000000000000000000000000",
--             SEL => FIRSTCYCLE,
--             O=> PCC(0)
--             );
    
--     ICOMPUTEPCCS:FOR I IN 1 TO 16 GENERATE
--         JCOMPUTEPCCS:FOR J IN 0 TO 30 GENERATE
--             COMPUTEPCCS :EXE_ADDER_SUBBER_CELL 
--             PORT MAP(
--                 A=>PC(I)(J),
--                 B=>PCS(I-1)(J+1),
--                 CI=>PCC(I-1)(J),
--                 OP=>OP,
--                 S=>PCS(I)(J),
--                 CO=>PCC(I)(J)
--             );
--             PCS(I)(31)<=PC(I)(31);
--         END GENERATE JCOMPUTEPCCS;
--     END GENERATE ICOMPUTEPCCS;

--     RAC(0) <= '0';
--     ICOMPUTERASRAC:FOR I IN 0 TO 30 GENERATE
--         COMPUTERASRAC :EXE_ADDER_SUBBER_CELL 
--         PORT MAP(
--             A=>PCS(16)(I+1),
--             B=>PCC(16)(I),
--             CI=>RAC(I),
--             OP=>OP,
--             S=>RAS(I),
--             CO=>RAC(I+1)
--         );
--     END GENERATE ICOMPUTERASRAC;
--     NEXTPCS <= PCS(15);
--     NEXTPCC <= PCC(15);

--     COMPUTERES1:FOR I IN 0 TO 15 GENERATE
--         RES1(I+16)<=PCS(I)(0);
--     END GENERATE COMPUTERES1;
--     RES1(15 DOWNTO 0) <= PREVRESULT(31 DOWNTO 16);
--     COMPUTERES2:FOR I IN 1 TO 16 GENERATE
--         RES2(I+15)<=PCS(I)(0);
--     END GENERATE COMPUTERES2;
--     RES2(15 DOWNTO 0) <= PREVRESULT(31 DOWNTO 16);
--     SELECTRES :MUX2X1
--         GENERIC MAP(INSIZE => 32)
--             PORT MAP(
--             D0 => RES2,
--             D1 => RES1,
--             SEL => FIRSTCYCLE,
--             O=> RESULT
--             );
--     SELECTRESFORNEXTRESULT :MUX2X1
--         GENERIC MAP(INSIZE => 32)
--             PORT MAP(
--             D0 => RES2,
--             D1 => RES1,
--             SEL => FIRSTCYCLE,
--             O=> NEXTRESULT
--             );
--     COMPUTEMSBRESULT:FOR I IN 0 TO 30 GENERATE
--         MSBRESULT(I)<=RAS(I);
--     END GENERATE COMPUTEMSBRESULT;
--     MSBRESULT(31) <= RAC(31);

-- END STRUCTURAL;