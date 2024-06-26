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
---------------------------------------------------------------
-- PART#5 STALL AND FORWARD "PREDICTOR"
-- " In some cases, to speed up things and avoid loosing 
--   some clock cycles, "forwarding" is required. In others,
--   a Stall signal must be generated and IF and ID stages 
--   have to halt for 1 clock cycle due to the nature of true
--   dependency RAW. 
---------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;

USE WORK.TOOLBOX.ALL;

ENTITY STALL_FWD_PREDICT IS

	PORT( 
		RS1  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); -- RS1 comming from ID
		RS2  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); -- RS2 comming from ID
		RD_E : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); -- RD  comming from EXE
		RD_M : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); -- RD  comming from MEM
			
		LOAD_IN_EXE : IN  STD_LOGIC; -- 1 if command at EXE is Load
		ISMULDIV : IN STD_LOGIC; -- 1 if command at EXE is mul or div
			
		-- Local (ID) Signal
		IMGEN : IN STD_LOGIC_VECTOR(2 DOWNTO  0); -- Used to detect B/U/R/S/J - Commands
			
		STALL: OUT STD_LOGIC;
		FWDA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- bit#1 rs1, bit#0 rs2
		FWDB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- bit#1 rs1, bit#0 rs2
		FWDC : OUT STD_LOGIC                     -- This forward path concerns only rs2
	    );

END STALL_FWD_PREDICT;

ARCHITECTURE RTL OF STALL_FWD_PREDICT IS
	
	SIGNAL MUST_STALL : STD_LOGIC;
		
	SIGNAL BUF_A: STD_LOGIC;
	SIGNAL BUF_B: STD_LOGIC;
	SIGNAL BUF_C: STD_LOGIC;
	SIGNAL BUF_D: STD_LOGIC;
	
	SIGNAL SELECT_RS1 : STD_LOGIC;
	SIGNAL SELECT_RS2 : STD_LOGIC;
	
	SIGNAL ITS_STORE    : STD_LOGIC;
	SIGNAL ITS_R        : STD_LOGIC;
	SIGNAL ITS_LUI_AUIPC: STD_LOGIC;
	SIGNAL ITS_JAL      : STD_LOGIC;
	SIGNAL ITS_BRANCH   : STD_LOGIC;
	
	SIGNAL OR_A : STD_LOGIC; -- Used for stalls and fwda,
	SIGNAL OR_B : STD_LOGIC; -- fwdc.
	SIGNAL OR_C : STD_LOGIC; -- Used only for
	SIGNAL OR_D : STD_LOGIC; -- fwdb.
	
	BEGIN

	BUF_A <= AND_REDUCE(RS1 XNOR RD_E) AND OR_REDUCE(RS1); -- RS1 == RD of EXE stage AND RS1 != x0
	BUF_B <= AND_REDUCE(RS2 XNOR RD_E) AND OR_REDUCE(RS2); -- RS2 == RD of EXE stage AND RS2 != x0
	BUF_C <= AND_REDUCE(RS1 XNOR RD_M) AND OR_REDUCE(RS1); -- RS1 == RD of MEM stage AND RS1 != x0
	BUF_D <= AND_REDUCE(RS2 XNOR RD_M) AND OR_REDUCE(RS2); -- RS2 == RD of MEM stage AND RS2 != x0
	
	ITS_STORE     <= AND_REDUCE(IMGEN XNOR "001"); -- ID_DECODER gives IMGEN 001 for STORE
	ITS_R         <= AND_REDUCE(IMGEN XNOR "111"); -- ID_DECODER gives IMGEN 111 for R
	ITS_LUI_AUIPC <= AND_REDUCE(IMGEN XNOR "011"); -- ID_DECODER gives IMGEN 011 for U 
	ITS_JAL       <= AND_REDUCE(IMGEN XNOR "100"); -- ID_DECODER gives IMGEN 100 for JAL 
	ITS_BRANCH    <= AND_REDUCE(IMGEN XNOR "010"); -- ID_DECODER gives IMGEN 010 for Branch
	
	SELECT_RS1 <= ITS_LUI_AUIPC   OR ITS_JAL; 
	SELECT_RS2 <= ITS_R           OR ITS_BRANCH OR ITS_STORE;
	                                                                                 
	EXE_MUX_RS1: MUX2X1_BIT														      
			PORT MAP(															     
					D0  => BUF_A,      -- If it is AUIPC or LUI or JAL
					D1  => '0',        -- then there is no RS1
					SEL => SELECT_RS1, 
					O   => OR_A
				);
	EXE_MUX_RS2: MUX2X1_BIT
			PORT MAP(
					D0  => '0',        -- If it is NOT R or Branch
					D1  => BUF_B,	   -- then there is no RS2. If it is Store
					SEL => SELECT_RS2, -- then RS2 has its own FWD path in MEM
					O   => OR_B        -- fwdc.
				);
					  
	MEM_MUX_RS1: MUX2X1_BIT
			PORT MAP(
					D0  => BUF_C,		-- These Muxes concern the FWDB path
					D1  => '0', 		 
					SEL => SELECT_RS1,  
 					O   => OR_C
				);
					  
	MEM_MUX_RS2: MUX2X1_BIT
			PORT MAP(
					D0  => '0',
					D1  => BUF_D,
					SEL => SELECT_RS2,
					O   => OR_D
				);
	
	MUST_STALL <= (OR_A OR OR_B) AND LOAD_IN_EXE;
	
	STALL <=  MUST_STALL OR ISMULDIV;
	FWDA  <= OR_A  & OR_B;
	FWDB  <= OR_C  & OR_D;
	-- This signal is not latched in the ID->EXE Pipeline register hence it must be aware of the stall scenario.
	FWDC  <=  LOAD_IN_EXE AND ITS_STORE AND BUF_B
		  AND NOT MUST_STALL; -- Just in case load affects RS1 register aswell.
	
END RTL;