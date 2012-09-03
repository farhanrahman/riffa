------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dma_handler IS
GENERIC(
	C_SIMPBUS_AWIDTH 	: integer := 32;
	C_BRAM_ADDR			: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	C_BRAM_SIZE			: integer := 32768
);
PORT(
	--SYSTEM CLOCK AND SYSTEM RESET--
	SYS_CLK					: IN std_logic;
	SYS_RST					: IN std_logic;

	--DMA signals
	DMA_REQ					: OUT std_logic;
	DMA_REQ_ACK				: IN std_logic;
	DMA_SRC					: OUT std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	DMA_DST					: OUT std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	DMA_LEN					: OUT std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	DMA_SIG					: OUT std_logic;
	DMA_DONE				: IN std_logic;
	DMA_ERR					: IN std_logic;

	--PC BUFFER REQUEST SIGNALS--
	BUF_REQ					: OUT std_logic;
	BUF_REQ_ACK				: IN std_logic;
	BUF_REQ_ADDR			: IN std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	BUF_REQ_SIZE			: IN std_logic_vector(4 DOWNTO 0);
	BUF_REQ_RDY				: IN std_logic;
	BUF_REQ_ERR				: IN std_logic;

	--Start and End addresses to transfer
	START_ADDR				: IN std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	END_ADDR				: IN std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);

	--Start signal
	START					: IN std_logic;

	--Done Signal
	DONE					: OUT std_logic;
	DONE_ERR				: OUT std_logic;
	
	--START Acknowledge signal
	START_ACK				: OUT std_logic
);
END ENTITY dma_handler;


ARCHITECTURE IMPL OF dma_handler IS

TYPE dma_states IS (
					idle,
					request_buffer, 
					get_buffer, 
					request_dma, 
					wait_for_dma,
					done_state,
					done_err_state
				);
SIGNAL dma_state, dma_nstate : dma_states := idle;

SIGNAL rStart, rEnd, rDes, rLen : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0');
SIGNAL buffReq : std_logic_vector(31 DOWNTO 0);


BEGIN

DMA_SRC <= rStart;
DMA_DST <= rDes;
DMA_LEN <= rLen;
DMA_SIG <= '1';
CombinatorialSignalAssignments : PROCESS (dma_state, BUF_REQ_SIZE)
BEGIN
	--When the state is in the request buffer state
	--drive the BUF_REQ signal high to signal the PC
	--that a buffer is required.
	IF (dma_state = request_buffer) THEN
		BUF_REQ	<= '1';
	ELSE
		BUF_REQ <= '0';
	END IF;

	--Similarly when the state is in the request_dma
	--state then drive the DMA_REQ signal to signal
	--the DMA that a buffer is required
	IF (dma_state = request_dma) THEN
		DMA_REQ <= '1';
--		DMA_SIG <= '0';
	ELSE
		DMA_REQ <= '0';
--		DMA_SIG <= '0';
	END IF;


	--Assignments of signals that the DMA transfer is done
	IF (dma_state = done_state OR dma_state = done_err_state) THEN
		DONE <= '1';
		IF(dma_state = done_err_state) THEN
			DONE_ERR <= '1';
		ELSE
			DONE_ERR <= '0';
		END IF;
	ELSE
		DONE <= '0';
		DONE_ERR <= '0';
	END IF;

	--buffReq <= (to_integer(unsigned(BUF_REQ_SIZE)) => '1', OTHERS => '0');
	FOR i IN buffReq'RANGE LOOP
		IF ( i = to_integer(unsigned(BUF_REQ_SIZE))) THEN
			buffReq(i) <= '1';
		ELSE
			buffReq(i) <= '0';
		END IF;
	END LOOP;
	
	--Start Ack signal assignment
	IF (dma_state /= idle) THEN
		START_ACK <= '1';
	ELSE
		START_ACK <= '0';
	END IF;
END PROCESS;

Combinatorial : PROCESS (dma_state, START, BUF_REQ_ACK, BUF_REQ_RDY, DMA_REQ_ACK, DMA_DONE, DMA_ERR, SYS_RST, rStart, rEnd)
BEGIN
	IF(SYS_RST = '1') THEN
		dma_nstate <= idle;
	ELSE
		dma_nstate <= dma_state;

		CASE (dma_state) IS
			WHEN idle =>
				IF (START = '1') THEN
					dma_nstate <= request_buffer; --Go to state to request for a PC buffer
				END IF;
			WHEN request_buffer =>
				IF (BUF_REQ_ACK = '1') THEN
					dma_nstate <= get_buffer; --If PC has allocated a space then get the buffer allocated
				END IF;
			WHEN get_buffer =>
				IF (BUF_REQ_RDY = '1') THEN
					dma_nstate <= request_dma;
				END IF;
			WHEN request_dma =>
				IF (DMA_REQ_ACK = '1') THEN
					dma_nstate <= wait_for_dma;
				END IF;
			WHEN wait_for_dma =>
				IF (DMA_DONE = '1') THEN
					--check if all data was transferred. If not then go to
					--request_buffer state to start another DMA transfer
					IF (unsigned(rStart)>= unsigned(rEnd)) THEN
						dma_nstate <= done_state;
					ELSE
						dma_nstate <= request_buffer;
					END IF;
				END IF;

				IF (DMA_ERR = '1') THEN
					dma_nstate <= done_err_state;
				END IF;
			WHEN done_state | done_err_state =>
				dma_nstate <= idle;
			WHEN OTHERS => dma_nstate <= idle;
		END CASE;

	END IF;
END PROCESS;

State_clocked : PROCESS
--VARIABLE temp_start : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
BEGIN
	WAIT UNTIL rising_edge(SYS_CLK);

	IF (SYS_RST = '1') THEN
		rStart <= (OTHERS => '0');
		rLen <= (OTHERS => '0');
		rDes <= (OTHERS => '0');
		dma_state <= idle;
	ELSE
		dma_state <= dma_nstate;

		IF (dma_state = idle) THEN
			--temp_start := START_ADDR;
			rStart <= START_ADDR;
			rEnd <= std_logic_vector(resize(unsigned(END_ADDR), C_SIMPBUS_AWIDTH));
			--IF(unsigned(temp_start) > unsigned(END_ADDR)) THEN
			--	rStart 	<= END_ADDR;
			--	rEnd	<= std_logic_vector(resize(unsigned(START_ADDR), C_SIMPBUS_AWIDTH));
			--END IF;
		END IF;

		IF (BUF_REQ_RDY = '1') THEN
			rDes <= BUF_REQ_ADDR;
		END IF;

		IF (dma_state = get_buffer AND BUF_REQ_RDY = '1') THEN
			--rDes <= BUF_REQ_ADDR;
			IF (unsigned(rEnd) - unsigned(rStart) < unsigned(buffReq)) THEN
				IF (unsigned(rEnd) = unsigned(rStart)) THEN
					rLen <= std_logic_vector(to_unsigned(4,C_SIMPBUS_AWIDTH)); --default length of 4 bytes
				ELSE
					rLen <= std_logic_vector(unsigned(rEnd) - unsigned(rStart));
				END IF;
			ELSE
				rLen <= std_logic_vector(unsigned(buffReq));
			END IF;
		END IF;

		IF (dma_state = request_dma AND DMA_REQ_ACK = '1') THEN
			rStart <= std_logic_vector(resize(unsigned(rStart) + unsigned(rLen), C_SIMPBUS_AWIDTH));
		END IF;
	END IF;
END PROCESS;


END ARCHITECTURE IMPL;
