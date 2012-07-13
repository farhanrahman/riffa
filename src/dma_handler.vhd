LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY dma_handler IS
GENERIC(

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
	
	--Start signal
	START					: IN std_logic;
	
	--Done Signal
	DONE					: OUT std_logic;
	DONE_ERR				: OUT std_logic
);
END ENTITY dma_handler;


ARCHITECTURE IMPL OF dma_handler IS

TYPE dma_states IS (
					idle,
					request_buffer, 
					get_buffer, 
					request_dma, 
					wait_for_dma,
					done,
					done_err
				);
SIGNAL dma_state, dma_nstate : dma_states := idle;

BEGIN

DMA_SIG <= '1';

CombinatorialSignalAssignments : PROCESS (dma_state)
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
	ELSE
		DMA_REQ <= '0';
	END IF;
	
	
	--Assignments of signals that the DMA transfer is done
	IF (dma_state = done OR dma_state = done_err) THEN
		DONE <= '1';
		IF(dma_state = done_err) THEN
			DONE_ERR <= '1';
		ELSE
			DONE_ERR <= '0';
		END IF;
	ELSE
		DONE <= '0';
		DONE_ERR <= '0';
	END IF;
	
END PROCESS;

Combinatorial : PROCESS (dma_state, START)

BEGIN
	IF(SYS_RESET = '1') THEN
		dma_nstate <= idle;
	ELSE
		dma_nstate <= dma_state;
		
		CASE (dma_state) IS
			WHEN idle =>
				IF (START = '1') THEN
					dma_nstate <= request_buffer; --Initialise the DMA
				END IF;
			WHEN request_buffer =>
				IF (BUF_REQ_ACK = '1') THEN
					dma_nstate <= get_buffer; --If PC has allocated a space then get the buffer allocated
				END IF;
			WHEN get_buffer =>
				IF (BUF_REQ_RDY = '1') THEN
					dma_state <= request_dma;
				END IF;
			WHEN request_dma =>
				IF (DMA_REQ_ACK = '1') THEN
					dma_nstate <= wait_for_dma;
				END IF;
			WHEN OTHERS => dma_nstate <= idle;
		END CASE;
		
	END IF;
END PROCESS;

State_clocked : PROCESS
BEGIN
	WAIT UNTIL rising_edge(clk);
	dma_state <= dma_nstate;
	
END PROCESS;


END ARCHITECTURE IMPL;



