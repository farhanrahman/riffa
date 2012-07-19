LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.log2;
USE IEEE.math_real.ceil;

ENTITY test_core IS
	GENERIC(
		C_SIMPBUS_AWIDTH 	: integer := 32;
		OUTPUT_CYCLE		: integer := 10 --CYCLES AFTER WHICH OUTPUT IS VALID (CANNOT BE 0)
	);
	PORT(
		SYS_CLK	: IN std_logic;
		SYS_RST : IN std_logic;
	
		--INPUT SIGNALS
		INPUT_1 : IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		INPUT_2 : IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		INPUT_3 : IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		INPUT_4 : IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
	
		OUTPUT	: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		
		--VALID SIGNAL FOR VALID OUTPUT
		VALID	: OUT std_logic
	);
END test_core;

ARCHITECTURE synth OF test_core IS

CONSTANT OUTPUT_CYCLE_BITS : integer := integer(ceil(log2(real(OUTPUT_CYCLE))));

TYPE core_state_type IS (idle, output_state);
SIGNAL core_state, core_nstate : core_state_type := idle;

SIGNAL output_counter : std_logic_vector(OUTPUT_CYCLE_BITS - 1 DOWNTO 0) := (OTHERS => '0');

SIGNAL rOutput : std_logic_vector(OUTPUT_CYCLE_BITS - 1 DOWNTO 0) := (OTHERS => '0');

ALIAS slv IS std_logic_vector;
ALIAS usg IS unsigned;
ALIAS sg IS signed;

BEGIN

OUTPUT <= rOutput;

Combinatorial_Assignments : PROCESS (core_state)
BEGIN
	IF (core_state = output_state) THEN
		VALID <= '1';
	ELSE
		VALID <= '0';
	END IF;
END PROCESS;

Nstate_assignment : PROCESS (core_state, SYS_RST, output_counter)
BEGIN
	IF (SYS_RST = '1') THEN
		core_nstate <= idle;
	ELSE
		core_nstate <= core_state;
		CASE (core_state) IS
			WHEN idle =>
				IF (usg(output_counter) = 0) THEN
					core_nstate <= output_state;
				END IF;
			WHEN output_state =>
				core_nstate <= idle;
		END CASE;		
	END IF;
END PROCESS;

State_assignment : PROCESS
BEGIN
	WAIT UNTIL rising_edge(SYS_CLK);
	IF (SYS_RST = '1') THEN
		core_state <= idle;
		output_counter <= slv(to_unsigned(OUTPUT_CYCLE, OUTPUT_CYCLE_BITS));
		rOutput <= (OTHERS => '0');
	ELSE
		core_state <= core_nstate;
		IF (core_state = idle) THEN
			IF (usg(output_counter) = 0) THEN
				output_counter <= slv(to_unsigned(OUTPUT_CYCLE, OUTPUT_CYCLE_BITS));
			ELSE
				output_counter <= slv(usg(output_counter) - 1);
			END IF;
		END IF;
		
		IF (core_state = output_state) THEN
			rOutput <= slv(usg(rOutput) + 1);--slv(resize((usg(INPUT_1)+usg(INPUT_1)+usg(INPUT_2)+usg(INPUT_3)), C_SIMPBUS_AWIDTH));
		END IF;
	END IF;
END PROCESS;

END ARCHITECTURE synth;
