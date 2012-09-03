------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.test_core;
USE work.project_pak.ALL;
USE work.utility.ALL;

ENTITY test_core_test_bench IS

END ENTITY test_core_test_bench;

ARCHITECTURE test_bench OF test_core_test_bench IS

SIGNAL SYS_CLK, SYS_RST : std_logic := '0';

SIGNAL INPUT_1, INPUT_2, INPUT_3, INPUT_4 : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);

SIGNAL OUTPUT : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);

SIGNAL VALID : std_logic := '0';

SIGNAL START : std_logic := '0';

SIGNAL RUNTIME : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);

SIGNAL FINISHED : std_logic := '0';

SIGNAL BUSY : std_logic := '0';

SIGNAL OUTPUT_CYCLE : std_logic_vector(C_SIMPBUS_AWIDTH - 1  DOWNTO 0);

BEGIN

DUT : ENTITY test_core
	GENERIC MAP(
		C_SIMPBUS_AWIDTH 	=> C_SIMPBUS_AWIDTH
	)
	PORT MAP(
		SYS_CLK			=> SYS_CLK,
		SYS_RST 		=> SYS_RST,
		INPUT_1 		=> INPUT_1,
		INPUT_2 		=> INPUT_2,
		INPUT_3 		=> INPUT_3,
		INPUT_4 		=> INPUT_4,
		OUTPUT			=> OUTPUT,
		VALID			=> VALID,
		START			=> START,
		RUNTIME 		=> RUNTIME,
		FINISHED 		=> FINISHED,
		BUSY			=> BUSY,
		OUTPUT_CYCLE 	=> OUTPUT_CYCLE
	);
	
Clk_gen : PROCESS
BEGIN
	SYS_CLK <= '1';
	WAIT FOR clk_per/2;
	SYS_CLK <= '0';
	WAIT FOR clk_per/2;
END PROCESS;

Rst_gen : PROCESS
BEGIN
	SYS_RST <= '1';
	WAIT UNTIL rising_edge(SYS_CLK);
	SYS_RST <= '0';
	WAIT;
END PROCESS;	

tb : PROCESS
BEGIN
	--Initialisation of input signals
	INPUT_1 <= (OTHERS => '0');
	INPUT_2 <= (OTHERS => '0');
	INPUT_3 <= (OTHERS => '0');
	INPUT_4 <= (OTHERS => '0');
	
	OUTPUT_CYCLE <= std_logic_vector(to_unsigned(10,C_SIMPBUS_AWIDTH));
	RUNTIME <= std_logic_vector(to_unsigned(30, C_SIMPBUS_AWIDTH));
	BUSY <= '0';
	
	toggle_start(SYS_CLK, START);
	WAIT UNTIL rising_edge(FINISHED);
	wait_for(SYS_CLK,5);
	
	--BUSY signal test
	
	BUSY <= '1';
	
	toggle_start(SYS_CLK, START);
	wait_for(SYS_CLK,20);
	
	BUSY <= '0';
	
	WAIT UNTIL rising_edge(FINISHED);
	wait_for(SYS_CLK,5);
	
	REPORT "TEST FINISHED." SEVERITY failure;
END PROCESS;

END ARCHITECTURE test_bench;
