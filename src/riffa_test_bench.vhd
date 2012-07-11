LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY riffa_test_bench IS

END ENTITY riffa_test_bench;

ARCHITECTURE testbench OF riffa_test_bench IS

SIGNAL clk : std_logic;
SIGNAL reset_i, reset : std_logic;

ALIAS slv IS std_logic_vector;
ALIAS usg IS unsigned;
ALIAS sg IS signed;

CONSTANT Clk_period_div_2 	: time := 4ns;
CONSTANT Clk_period			: time := 8ns;

BEGIN

reset <= reset_i;

Clk_generate : PROCESS --Process to generate the clk
BEGIN
	clk <= '0';
	WAIT FOR Clk_period_div_2;
	clk <= '1';
	WAIT FOR Clk_period_div_2;
END PROCESS;

Rst_generate : PROCESS --Process to generate the reset in the beginning
BEGIN
	reset_i <= '1';
	WAIT UNTIL rising_edge(clk);
	reset_i <= '0';
	WAIT;
END PROCESS;



END ARCHITECTURE testbench;
