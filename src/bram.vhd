------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--Synthesis of bram for simulation purposes

ENTITY bram IS
GENERIC(
	C_BRAM_SIZE : integer := 32768;
	RUNTIME		: std_logic_vector(31 DOWNTO 0);
	OUTPUT_CYCLE: std_logic_vector(31 DOWNTO 0)
);
PORT(
	SYS_CLK			: IN std_logic;
	SYS_RST			: IN std_logic;
	BRAM_EN			: IN std_logic;
	BRAM_WEN		: IN std_logic_vector(3 DOWNTO 0);	
	BRAM_Dout		: IN std_logic_vector(31 DOWNTO 0);
	BRAM_Din		: OUT std_logic_vector(31 DOWNTO 0);
	BRAM_Addr		: IN std_logic_vector(31 DOWNTO 0)
);
END ENTITY bram;

ARCHITECTURE synth OF bram IS
TYPE bram_byte IS ARRAY (natural RANGE <>) OF std_logic_vector(7 DOWNTO 0);

CONSTANT NUM_OF_WORDS : integer := C_BRAM_SIZE / 4;

--Initialised data for simulation
SIGNAL bram : bram_byte (0 TO C_BRAM_SIZE-1) := 
(
	OTHERS => (OTHERS => '0')
);

CONSTANT BRAM_WEN_ALL_1 : std_logic_vector(3 DOWNTO 0) := (OTHERS => '1');

SIGNAL BRAM_Addr_Clamped : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');

BEGIN

COMB : PROCESS (BRAM_Addr)
BEGIN
	IF (unsigned(BRAM_Addr) >= to_unsigned(C_BRAM_SIZE-4,32)) THEN
		BRAM_Addr_Clamped <= std_logic_vector(to_unsigned(C_BRAM_SIZE-4, 32));
	ELSE
		BRAM_Addr_Clamped <= BRAM_Addr;
	END IF;
END PROCESS;

REG : PROCESS
BEGIN
	WAIT UNTIL rising_edge(SYS_CLK);
	
	IF (SYS_RST = '1') THEN
		--WORD 0
		bram(0) <= RUNTIME(7 DOWNTO 0);
		bram(1) <= RUNTIME(15 DOWNTO 8);
		bram(2) <= RUNTIME(23 DOWNTO 16);
		bram(3) <= RUNTIME(31 DOWNTO 24);
		
		--WORD 1
		bram(4) <= OUTPUT_CYCLE(7 DOWNTO 0);
		bram(5) <= OUTPUT_CYCLE(15 DOWNTO 8);
		bram(6) <= OUTPUT_CYCLE(23 DOWNTO 16);
		bram(7) <= OUTPUT_CYCLE(31 DOWNTO 24);
		
	END IF;
	
	IF (BRAM_WEN = BRAM_WEN_ALL_1 AND BRAM_EN = '1') THEN
		bram(to_integer(unsigned(BRAM_Addr_Clamped)+to_unsigned(3,32))) <= BRAM_Dout(31 DOWNTO 24);
		bram(to_integer(unsigned(BRAM_Addr_Clamped)+to_unsigned(2,32))) <= BRAM_Dout(23 DOWNTO 16);
		bram(to_integer(unsigned(BRAM_Addr_Clamped)+to_unsigned(1,32))) <= BRAM_Dout(15 DOWNTO 8);
		bram(to_integer(unsigned(BRAM_Addr_Clamped)+to_unsigned(0,32))) <= BRAM_Dout(7 DOWNTO 0);
	END IF;
END PROCESS;

BRAM_Din <= (bram(to_integer(unsigned(BRAM_Addr_Clamped))+3))
			&(bram(to_integer(unsigned(BRAM_Addr_Clamped)+2)))
			&(bram(to_integer(unsigned(BRAM_Addr_Clamped)+1)))
			&(bram(to_integer(unsigned(BRAM_Addr_Clamped)+0)));

END ARCHITECTURE synth;
