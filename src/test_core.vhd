------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.log2;
USE IEEE.math_real.ceil;

ENTITY test_core IS
	GENERIC(
		C_SIMPBUS_AWIDTH 	: integer := 32
		--OUTPUT_CYCLE		: integer := 10 --CYCLES AFTER WHICH OUTPUT IS VALID (CANNOT BE 0)
	);
	PORT(
		SYS_CLK			: IN std_logic;
		SYS_RST 		: IN std_logic;
	
		--INPUT SIGNALS
		INPUT_1 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		INPUT_2 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		INPUT_3 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		INPUT_4 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
	
		OUTPUT			: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		
		--VALID SIGNAL FOR VALID OUTPUT
		VALID			: OUT std_logic;
		
		--START SIGNAL TO START PROCESSING
		START			: IN std_logic;
		
		--RUN TIME OF THE CORE
		RUNTIME 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		
		--FINISHED SIGNAL
		FINISHED 		: OUT std_logic;
		
		--BUSY TO SIGNAL THE CORE TO PAUSE THE PROCESSING
		BUSY			: IN std_logic;
		
		--OUTPUT_CYCLE: Determines after how many cycles the output will be valid
		OUTPUT_CYCLE 	: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0)
	);
END test_core;

ARCHITECTURE synth OF test_core IS

--Core state type and state signals
TYPE core_state_type IS (
				idle,
				setup,
				--PROCESSING STATES
				output_state,
				wait_state,
				paused_state);
SIGNAL core_state, core_nstate : core_state_type := idle;

--Counter used to count down to output every "OUTPUT_CYCLE" cycles
SIGNAL output_counter : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0');

--Output of core currently limited to only one
SIGNAL rOutput : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0');

--Registered output run_time for input signal RUNTIME
SIGNAL run_time : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0');

--Registered signal to drive output signal FINISHED
SIGNAL finished1 : std_logic := '0';

BEGIN

--Dataflow signal assignments
OUTPUT <= rOutput;
FINISHED <= finished1;

Combinatorial_Assignments : PROCESS (core_state)
BEGIN
	IF (core_state = output_state) THEN
		VALID <= '1';
	ELSE
		VALID <= '0';
	END IF;
END PROCESS;

Nstate_assignment : PROCESS (core_state, SYS_RST, output_counter, START, finished1, BUSY)
BEGIN
	IF (SYS_RST = '1') THEN
		core_nstate <= idle;
	ELSE
		core_nstate <= core_state;
		CASE (core_state) IS
			WHEN idle =>
				IF (START = '1') THEN
					core_nstate <= setup;
				END IF;
			WHEN setup =>
				core_nstate <= wait_state;
			WHEN wait_state =>
				IF (finished1 = '1') THEN
					IF (BUSY = '0') THEN
						core_nstate <= idle;
					END IF;
				ELSE
					IF (unsigned(output_counter) = 0) THEN
						IF (BUSY = '1') THEN
							core_nstate <= paused_state;
						ELSE
							core_nstate <= output_state;
						END IF;					
					END IF;
				END IF;
			WHEN paused_state =>
				IF (BUSY /= '1') THEN
					core_nstate <= output_state;
				END IF;
			WHEN output_state =>
				core_nstate <= wait_state;
			WHEN OTHERS =>
				core_nstate <= idle;
		END CASE;		
	END IF;
END PROCESS;

State_assignment : PROCESS
VARIABLE v_output_counter : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
BEGIN
	WAIT UNTIL rising_edge(SYS_CLK);
	IF (SYS_RST = '1') THEN
		core_state <= idle;
		output_counter <= (OTHERS => '0');
		rOutput <= (OTHERS => '0');
		run_time <= (OTHERS => '0');
		finished1 <= '0';
	ELSE
		core_state <= core_nstate;
		finished1 <= '0';
		IF (core_state = setup) THEN
			IF (unsigned(RUNTIME) <= 1) THEN
				run_time <= std_logic_vector(to_unsigned(1,C_SIMPBUS_AWIDTH));
			ELSE
				run_time <= std_logic_vector(unsigned(RUNTIME) - 1); --Initialise run_time to the input RUNTIME
			END IF;
			--output_counter = max(1, OUTPUT_CYCLE-2)
			IF (to_unsigned(2, C_SIMPBUS_AWIDTH) <= unsigned(OUTPUT_CYCLE)) THEN
				v_output_counter := std_logic_vector(unsigned(OUTPUT_CYCLE) - 2);
			ELSE
				v_output_counter := std_logic_vector(to_unsigned(1,C_SIMPBUS_AWIDTH));
			END IF;
			
			output_counter <= v_output_counter;
		END IF;
		
		IF (core_state = wait_state) THEN
		--Wait in this state until the counter has reached desired value.
			IF (unsigned(output_counter) = 0) THEN
				output_counter <= v_output_counter;
			ELSE
				output_counter <= std_logic_vector(unsigned(output_counter) - 1);
			END IF;
		END IF;
		
		IF (core_nstate = output_state) THEN
		--Output is simply a counter
			rOutput <= std_logic_vector(unsigned(rOutput) + 1);
		END IF;
		
		IF (core_state /= idle AND core_state /= setup AND core_state /= paused_state) THEN
		--Only keep track of run_time when the state is not any of idle, setup or paused states
			IF (unsigned(run_time) /= 0) THEN
				run_time <= std_logic_vector(unsigned(run_time) - 1);
			END IF;
			
		--Only check for run_time while in the processing states
			IF (unsigned(run_time) = 0) THEN
				finished1 <= '1';
			ELSE
				finished1 <= '0';
			END IF;			
		END IF;
	END IF;
END PROCESS;

END ARCHITECTURE synth;
