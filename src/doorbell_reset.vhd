------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--Block used to respond to doorbell arguments that will
--reset the system. This makes it possible for the user
--to reset the system without having to reprogram the
--device.
ENTITY doorbell_reset IS
GENERIC(
	ARGUMENT_ZERO_VAL 	: std_logic_vector(31 DOWNTO 0) := (OTHERS => '1');
	ARGUMENT_ONE_VAL 	: std_logic_vector(31 DOWNTO 0) := (OTHERS => '1')
);
PORT(
	SYS_CLK			: IN std_logic;
	SYS_RST			: IN std_logic;
	RESET			: OUT std_logic;
	DOORBELL		: IN std_logic;
	DOORBELL_ARG	: IN std_logic_vector(31 DOWNTO 0);
	DOORBELL_ERR	: IN std_logic
);
END ENTITY doorbell_reset;

ARCHITECTURE synth OF doorbell_reset IS

--DOORBELL_RESET states and state type declaration
TYPE dr_state_type IS (
					idle, 
					s1, 
					s2, 
					reset_high
				);
SIGNAL dr_state 	: dr_state_type := (idle);
SIGNAL dr_nstate 	: dr_state_type := (idle);

--Internal reset signal triggered high depending on consecutive doorbell arguments
--equal to ARGUMENT_ZERO_VAL and ARGUMENT_ONE_VAL respectively.
SIGNAL RESET_INTERNAL : std_logic := '0';

BEGIN

RESET <= SYS_RST OR RESET_INTERNAL;

--idle (check doorbell) -> s1 (check arg0) -> s2 (check arg1) -> reset_high -> idle
Next_state_assignment : PROCESS (dr_state, SYS_RST, DOORBELL, DOORBELL_ERR, DOORBELL_ARG)
BEGIN
	IF (SYS_RST = '1') THEN
		dr_nstate <= idle;
	ELSE
		dr_nstate <= dr_state;
		CASE(dr_state) IS
			WHEN idle =>
				IF (DOORBELL = '1' AND DOORBELL_ERR = '0') THEN
					dr_nstate <= s1;
				END IF;
			WHEN s1 =>
				IF (DOORBELL_ARG = ARGUMENT_ZERO_VAL) THEN
					dr_nstate <= s2;
				ELSE
					dr_nstate <= idle;
				END IF;
			WHEN s2 =>
				IF (DOORBELL_ARG = ARGUMENT_ONE_VAL) THEN
					dr_nstate <= reset_high;
				ELSE
					dr_nstate <= idle;
				END IF;
			WHEN reset_high =>
				dr_nstate <= idle;
		END CASE;
	END IF;
END PROCESS;

Comb_output : PROCESS (dr_state)
BEGIN
	IF (dr_state = reset_high) THEN
		RESET_INTERNAL <= '1';
	ELSE
		RESET_INTERNAL <= '0';
	END IF;
END PROCESS;

State_assign : PROCESS
BEGIN
	WAIT UNTIL rising_edge(SYS_CLK);
	dr_state <= dr_nstate;
END PROCESS;

END ARCHITECTURE synth;