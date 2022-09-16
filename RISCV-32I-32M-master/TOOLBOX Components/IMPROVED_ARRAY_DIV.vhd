-- This component is the divisor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.TOOLBOX.ALL;

ENTITY IMPROVED_ARRAY_DIV IS

	PORT(
		  A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		  B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
          REMAINDER  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		  RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	    );
		 
END IMPROVED_ARRAY_DIV;

ARCHITECTURE STRUCTURAL OF IMPROVED_ARRAY_DIV IS

    TYPE ARR32X32 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR33X32 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE ARR32X33 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
    SIGNAL PCS : ARR33X32;
    SIGNAL PCC : ARR32X33;
    SIGNAL MUX : ARR32X32;
    SIGNAL OP : STD_LOGIC := '1'; --for sub

    BEGIN
    INITIALIZEPCS:FOR I IN 1 TO 31 GENERATE
            PCS(0)(I)<='0';
            PCS(I)(0)<=A(31-I);
            PCC(I)(0)<='0';
    END GENERATE INITIALIZEPCS;
    PCS(0)(0)<=A(31);
    PCC(0)(0)<='0';

    ICOMPUTEPCCS:FOR I IN 0 TO 31 GENERATE
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

        ALLRESULT : IF I < 31 GENERATE
            JCOMPUTEMUX:FOR J IN 0 TO 30 GENERATE
                COMPUTEMUX :MUX2X1_BIT
                    PORT MAP(
                        D0 => MUX(I)(J),
                        D1 => PCS(I)(J),
                        SEL => PCC(I)(32),
                        O=> PCS(I+1)(J+1)
                    );
            END GENERATE JCOMPUTEMUX;
        END GENERATE ALLRESULT;

        MSBRESULT : IF I = 31 GENERATE
            JCOMPUTEMUX31:FOR J IN 0 TO 31 GENERATE
                COMPUTEMUX31 :MUX2X1_BIT
                    PORT MAP(
                        D0 => MUX(I)(J),
                        D1 => PCS(I)(J),
                        SEL => PCC(I)(32),
                        O=> PCS(I+1)(J)
                    );
            END GENERATE JCOMPUTEMUX31;
        END GENERATE MSBRESULT;    
    END GENERATE ICOMPUTEPCCS;

    COMPUTERESULT:FOR I IN 0 TO 31 GENERATE
        RESULT(I)<=NOT PCC(31-I)(32);
    END GENERATE COMPUTERESULT;

    COMPUTEREMAINDER:FOR I IN 0 TO 31 GENERATE
        REMAINDER(I)<=PCS(32)(I);
    END GENERATE COMPUTEREMAINDER;

END STRUCTURAL;


-- -- This component is the divisor
-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;

-- LIBRARY WORK;
-- USE WORK.TOOLBOX.ALL;

-- ENTITY IMPROVED_ARRAY_DIV IS

-- 	PORT(
-- 		  A : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
-- 		  B : IN  STD_LOGIC_VECTOR(31  DOWNTO 0);
--           REMAINDER  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
-- 		  RESULT  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
-- 	    );
		 
-- END IMPROVED_ARRAY_DIV;

-- ARCHITECTURE STRUCTURAL OF IMPROVED_ARRAY_DIV IS

--     TYPE ARR32X32 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
--     TYPE ARR33X32 IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
--     TYPE ARR32X33 IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(32 DOWNTO 0);
--     SIGNAL PCS : ARR33X32;
--     SIGNAL PCC : ARR32X33;
--     SIGNAL MUX : ARR32X32;
--     SIGNAL OP : STD_LOGIC := '1'; --for sub

--     BEGIN
--     INITIALIZEPCS:FOR I IN 1 TO 31 GENERATE
--             PCS(0)(I)<='0';
--             PCS(I)(0)<=A(31-I);
--             PCC(I)(0)<='0';
--     END GENERATE INITIALIZEPCS;
--     PCS(0)(0)<=A(31);
--     PCC(0)(0)<='0';

--     ICOMPUTEPCCS:FOR I IN 0 TO 31 GENERATE
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

--         ALLRESULT : IF I < 31 GENERATE
--             JCOMPUTEMUX:FOR J IN 0 TO 30 GENERATE
--                 COMPUTEMUX :MUX2X1_BIT
--                     PORT MAP(
--                         D0 => MUX(I)(J),
--                         D1 => PCS(I)(J),
--                         SEL => PCC(I)(32),
--                         O=> PCS(I+1)(J+1)
--                     );
--             END GENERATE JCOMPUTEMUX;
--         END GENERATE ALLRESULT;

--         MSBRESULT : IF I = 31 GENERATE
--             JCOMPUTEMUX31:FOR J IN 0 TO 31 GENERATE
--                 COMPUTEMUX31 :MUX2X1_BIT
--                     PORT MAP(
--                         D0 => MUX(I)(J),
--                         D1 => PCS(I)(J),
--                         SEL => PCC(I)(32),
--                         O=> PCS(I+1)(J)
--                     );
--             END GENERATE JCOMPUTEMUX31;
--         END GENERATE MSBRESULT;    
--     END GENERATE ICOMPUTEPCCS;

--     COMPUTERESULT:FOR I IN 0 TO 31 GENERATE
--         RESULT(I)<=NOT PCC(31-I)(32);
--     END GENERATE COMPUTERESULT;

--     COMPUTEREMAINDER:FOR I IN 0 TO 31 GENERATE
--         REMAINDER(I)<=PCS(32)(I);
--     END GENERATE COMPUTEREMAINDER;

-- END STRUCTURAL;
