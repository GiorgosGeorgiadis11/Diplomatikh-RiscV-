-- 32 cycles divisor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY DIV_MULTICYCLING IS
    PORT(
        A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
        PREVPCS : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        PREVRESULT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CYCLE : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        NEXTPCS : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
        NEXTRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        REMAINDER : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
		 
END DIV_MULTICYCLING;

ARCHITECTURE STRUCTURAL OF DIV_MULTICYCLING IS

    TYPE ARR32X32 IS ARRAY(0 TO 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR33X32 IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
    TYPE ARR32X33 IS ARRAY(0 TO 1) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL PCS : ARR33X32;
    SIGNAL PCC : ARR32X33;
    SIGNAL MUX : ARR32X32;
    SIGNAL APC : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL OP : STD_LOGIC := '1'; --for sub
    SIGNAL INITFIRSTCYCLE : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL FIRSTCYCLE : STD_LOGIC;

    CONSTANT GND : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');

    BEGIN
    FIRSTCYCLE <= NOR_REDUCE(CYCLE(4 DOWNTO 0));
    SELECTA: MUX32X1
        GENERIC MAP( INSIZE => 1 )
            PORT    MAP( 
                    D0  => A(31 DOWNTO 31),
                    D1  => A(30 DOWNTO 30),
                    D2  => A(29 DOWNTO 29),
                    D3  => A(28 DOWNTO 28),
                    D4  => A(27 DOWNTO 27),
                    D5  => A(26 DOWNTO 26),
                    D6  => A(25 DOWNTO 25),
                    D7  => A(24 DOWNTO 24),
                    D8  => A(23 DOWNTO 23),
                    D9  => A(22 DOWNTO 22),
                    D10	=> A(21 DOWNTO 21),
                    D11 => A(20 DOWNTO 20),
                    D12 => A(19 DOWNTO 19),
                    D13 => A(18 DOWNTO 18),
                    D14 => A(17 DOWNTO 17),
                    D15 => A(16 DOWNTO 16),
                    D16 => A(15 DOWNTO 15),
                    D17 => A(14 DOWNTO 14),
                    D18 => A(13 DOWNTO 13),
                    D19 => A(12 DOWNTO 12),
                    D20 => A(11 DOWNTO 11),
                    D21 => A(10 DOWNTO 10),
                    D22 => A(9 DOWNTO 9),
                    D23 => A(8 DOWNTO 8),
                    D24 => A(7 DOWNTO 7),
                    D25 => A(6 DOWNTO 6),
                    D26 => A(5 DOWNTO 5),
                    D27 => A(4 DOWNTO 4),
                    D28 => A(3 DOWNTO 3),
                    D29 => A(2 DOWNTO 2),
                    D30 => A(1 DOWNTO 1),
                    D31 => A(0 DOWNTO 0),
                    SEL => CYCLE,
                    O   => APC
                    );
    INITFIRSTCYCLE <= (OTHERS => '0');
    SELECTPCS :MUX2X1
        GENERIC MAP(INSIZE => 32)
            PORT MAP(
            D0 => PREVPCS,
            D1 => INITFIRSTCYCLE,
            SEL => FIRSTCYCLE,
            O=> PCS(0)(32 DOWNTO 1)
            );
    PCS(0)(0)<=APC(0);
    --PCS(1)(0)<=APC(0);
    PCC(0)(0)<='0';
    --PCC(1)(0)<='0';

    ICOMPUTEPCCS:FOR I IN 0 TO 0 GENERATE
        JCOMPUTEPCCS:FOR J IN 0 TO 31 GENERATE
            MUX(I)(J)<=PCS(I)(J) XOR B(J) XOR PCC(I)(J);
            PCC(I)(J+1)<=((B(J) xor PCC(I)(J)) and (not PCS(I)(J))) or (B(J) and PCC(I)(J));
            -- COMPUTERASRAC :EXE_ADDER_SUBBER_CELL 
            --     PORT MAP(
            --         A=>PCS(I)(J),
            --         B=>B(J),
            --         CI=>PCC(I)(J),
            --         OP=>OP,
            --         S=>MUX(I)(J),
            --         CO=>PCC(I)(J+1)
            --     );
        END GENERATE JCOMPUTEPCCS;
        JCOMPUTEMUX:FOR J IN 0 TO 31 GENERATE
            COMPUTEMUX :MUX2X1_BIT
                PORT MAP(
                    D0 => MUX(I)(J),
                    D1 => PCS(I)(J),
                    SEL => PCC(I)(32),
                    O=> PCS(I+1)(J+1)
                );
            END GENERATE JCOMPUTEMUX;   
    END GENERATE ICOMPUTEPCCS;
    NEXTPCS <= PCS(1)(32 DOWNTO 1);

    COMPUTERESULT:FOR I IN 0 TO 0 GENERATE
        RESULT(I)<=NOT PCC(I)(32);
        NEXTRESULT(I)<=NOT PCC(I)(32);
    END GENERATE COMPUTERESULT;
    RESULT(31 DOWNTO 1)<=PREVRESULT(30 DOWNTO 0);
    NEXTRESULT(31 DOWNTO 1)<=PREVRESULT(30 DOWNTO 0);

    COMPUTEREMAINDER:FOR I IN 1 TO 32 GENERATE
        REMAINDER(I-1)<=PCS(1)(I);
    END GENERATE COMPUTEREMAINDER;

END STRUCTURAL;

-- -- 16 cycles divisor
-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_MISC.ALL;

-- LIBRARY WORK;
-- USE WORK.TOOLBOX.ALL;

-- ENTITY DIV_MULTICYCLING IS
--     PORT(
--         A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
--         B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
--         PREVPCS : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
--         PREVRESULT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--         CYCLE : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
--         NEXTPCS : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
--         NEXTRESULT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--         RESULT    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--         REMAINDER : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
--         );
		 
-- END DIV_MULTICYCLING;

-- ARCHITECTURE STRUCTURAL OF DIV_MULTICYCLING IS

--     TYPE ARR32X32 IS ARRAY(0 TO 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
--     TYPE ARR33X32 IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
--     TYPE ARR32X33 IS ARRAY(0 TO 1) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
--     SIGNAL PCS : ARR33X32;
--     SIGNAL PCC : ARR32X33;
--     SIGNAL MUX : ARR32X32;
--     SIGNAL APC : STD_LOGIC_VECTOR(1 DOWNTO 0);
--     SIGNAL OP : STD_LOGIC := '1'; --for sub
--     SIGNAL INITFIRSTCYCLE : STD_LOGIC_VECTOR(31 DOWNTO 0);

--     SIGNAL FIRSTCYCLE : STD_LOGIC;

--     CONSTANT GND : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');

--     BEGIN
--     FIRSTCYCLE <= NOR_REDUCE(CYCLE(3 DOWNTO 0));
--     SELECTA: MUX32X1
--         GENERIC MAP( INSIZE => 2 )
--             PORT    MAP( 
--                     D0  => A(31 DOWNTO 30),
--                     D1  => A(29 DOWNTO 28),
--                     D2  => A(27 DOWNTO 26),
--                     D3  => A(25 DOWNTO 24),
--                     D4  => A(23 DOWNTO 22),
--                     D5  => A(21 DOWNTO 20),
--                     D6  => A(19 DOWNTO 18),
--                     D7  => A(17 DOWNTO 16),
--                     D8  => A(15 DOWNTO 14),
--                     D9  => A(13 DOWNTO 12),
--                     D10	=> A(11 DOWNTO 10),
--                     D11 => A(9 DOWNTO 8),
--                     D12 => A(7 DOWNTO 6),
--                     D13 => A(5 DOWNTO 4),
--                     D14 => A(3 DOWNTO 2),
--                     D15 => A(1 DOWNTO 0),
--                     D16 => GND,
--                     D17 => GND,
--                     D18 => GND,
--                     D19 => GND,
--                     D20 => GND,
--                     D21 => GND,
--                     D22 => GND,
--                     D23 => GND,
--                     D24 => GND,
--                     D25 => GND,
--                     D26 => GND,
--                     D27 => GND,
--                     D28 => GND,
--                     D29 => GND,
--                     D30 => GND,
--                     D31 => GND,
--                     SEL => CYCLE,
--                     O   => APC
--                     );
--     INITFIRSTCYCLE <= (OTHERS => '0');
--     SELECTPCS :MUX2X1
--         GENERIC MAP(INSIZE => 32)
--             PORT MAP(
--             D0 => PREVPCS,
--             D1 => INITFIRSTCYCLE,
--             SEL => FIRSTCYCLE,
--             O=> PCS(0)(32 DOWNTO 1)
--             );
--     PCS(0)(0)<=APC(1);
--     PCS(1)(0)<=APC(0);
--     PCC(0)(0)<='0';
--     PCC(1)(0)<='0';

--     ICOMPUTEPCCS:FOR I IN 0 TO 1 GENERATE
--         JCOMPUTEPCCS:FOR J IN 0 TO 31 GENERATE
--             MUX(I)(J)<=PCS(I)(J) XOR B(J) XOR PCC(I)(J);
--             PCC(I)(J+1)<=((B(J) xor PCC(I)(J)) and (not PCS(I)(J))) or (B(J) and PCC(I)(J));
--             -- COMPUTERASRAC :EXE_ADDER_SUBBER_CELL 
--             --     PORT MAP(
--             --         A=>PCS(I)(J),
--             --         B=>B(J),
--             --         CI=>PCC(I)(J),
--             --         OP=>OP,
--             --         S=>MUX(I)(J),
--             --         CO=>PCC(I)(J+1)
--             --     );
--         END GENERATE JCOMPUTEPCCS;
--         JCOMPUTEMUX:FOR J IN 0 TO 31 GENERATE
--             COMPUTEMUX :MUX2X1_BIT
--                 PORT MAP(
--                     D0 => MUX(I)(J),
--                     D1 => PCS(I)(J),
--                     SEL => PCC(I)(32),
--                     O=> PCS(I+1)(J+1)
--                 );
--             END GENERATE JCOMPUTEMUX;   
--     END GENERATE ICOMPUTEPCCS;
--     NEXTPCS <= PCS(2)(32 DOWNTO 1);

--     COMPUTERESULT:FOR I IN 0 TO 1 GENERATE
--         RESULT(I)<=NOT PCC(1-I)(32);
--         NEXTRESULT(I)<=NOT PCC(1-I)(32);
--     END GENERATE COMPUTERESULT;
--     RESULT(31 DOWNTO 2)<=PREVRESULT(29 DOWNTO 0);
--     NEXTRESULT(31 DOWNTO 2)<=PREVRESULT(29 DOWNTO 0);

--     COMPUTEREMAINDER:FOR I IN 1 TO 32 GENERATE
--         REMAINDER(I-1)<=PCS(2)(I);
--     END GENERATE COMPUTEREMAINDER;

-- END STRUCTURAL;