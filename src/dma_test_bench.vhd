------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.project_pak.ALL;
USE work.dma_handler;

ENTITY dma_test_bench IS
	GENERIC(
		C_SIMPBUS_AWIDTH : integer := 32
	);
END ENTITY dma_test_bench;

ARCHITECTURE test OF dma_test_bench IS

SIGNAL 	clk, reset : std_logic := '0';

--DMA SIGNALS

SIGNAL 	DMA_REQ					: std_logic;										--OUT
SIGNAL 	DMA_REQ_ACK				: std_logic;										--IN
SIGNAL 	DMA_SRC					: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);	--OUT
SIGNAL 	DMA_DST					: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);    --OUT
SIGNAL 	DMA_LEN					: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);    --OUT
SIGNAL 	DMA_SIG					: std_logic;                                        --OUT
SIGNAL 	DMA_DONE				: std_logic;                                        --IN
SIGNAL 	DMA_ERR					: std_logic;                                        --IN


--BUFFER REQUEST

SIGNAL 	BUF_REQ					: std_logic;										--OUT
SIGNAL 	BUF_REQ_ACK				: std_logic;										--IN
SIGNAL 	BUF_REQ_ADDR			: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);	--IN
SIGNAL 	BUF_REQ_SIZE			: std_logic_vector(4 DOWNTO 0);                  	--IN
SIGNAL 	BUF_REQ_RDY				: std_logic;                                     	--IN
SIGNAL 	BUF_REQ_ERR				: std_logic;                                     	--IN

--Start and End addresses to transfer
SIGNAL 	START_ADDR				: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);	--IN
SIGNAL 	END_ADDR				: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);	--IN
	
--Start signal
SIGNAL	START					: std_logic;										--IN
SIGNAL  START_ACK				: std_logic;										--OUT
	
--Done Signal
SIGNAL 	DONE					: std_logic;										--IN
SIGNAL 	DONE_ERR				: std_logic;										--IN

ALIAS slv IS std_logic_vector;
ALIAS usg IS unsigned;

BEGIN


DMA : ENTITY dma_handler
GENERIC MAP(
	C_SIMPBUS_AWIDTH => C_SIMPBUS_AWIDTH
)
PORT MAP(
	--SYSTEM CLOCK AND SYSTEM RESET--
	SYS_CLK					=> 	clk,			--IN
	SYS_RST					=> 	reset,			--IN

	--DMA signals
	DMA_REQ					=>	DMA_REQ,		--OUT
	DMA_REQ_ACK				=>	DMA_REQ_ACK,	--IN
	DMA_SRC					=>	DMA_SRC,		--OUT
	DMA_DST					=>	DMA_DST,		--OUT
	DMA_LEN					=>	DMA_LEN,		--OUT
--	DMA_SIG					=>	DMA_SIG,		--OUT
	DMA_DONE				=>	DMA_DONE,		--IN
	DMA_ERR					=>	DMA_ERR,		--IN
	
	--PC BUFFER REQUEST SIGNALS--
	BUF_REQ					=> 	BUF_REQ,		--OUT
	BUF_REQ_ACK				=> 	BUF_REQ_ACK,	--IN
	BUF_REQ_ADDR			=> 	BUF_REQ_ADDR,	--IN
	BUF_REQ_SIZE			=> 	BUF_REQ_SIZE,	--IN
	BUF_REQ_RDY				=> 	BUF_REQ_RDY,	--IN
	BUF_REQ_ERR				=> 	BUF_REQ_ERR,	--IN
		
	--Start and End addresses t	o transfer
	START_ADDR				=> 	START_ADDR,		--IN
	END_ADDR				=> 	END_ADDR,		--IN
		
	--Start signal	
	START					=> 	START,			--IN
		
	--Done Signal	
	DONE					=> 	DONE,			--OUT
	DONE_ERR				=> 	DONE_ERR,		--OUT
	
	--Start Ack
	START_ACK				=> START_ACK
);

Clk_generate : PROCESS
BEGIN
	clk <='0';
	WAIT FOR clk_per/2;
	clk <='1';
	WAIT FOR clk_per/2;
END PROCESS;

Rst_generate : PROCESS
BEGIN
	reset <= '1';
	WAIT UNTIL rising_edge(clk);
	reset <= '0';
	WAIT;
END PROCESS;

DMA_test : PROCESS
BEGIN
	DMA_REQ_ACK 	<= 	'0';
	DMA_DONE		<=	'0';
	DMA_ERR			<= 	'0';	
	BUF_REQ_ACK		<=	'0';
	BUF_REQ_ADDR	<= 	(OTHERS => '0');
	BUF_REQ_SIZE	<= 	(OTHERS => '0');
	BUF_REQ_RDY		<= 	'0';
	BUF_REQ_ERR		<= 	'0';
	START_ADDR		<= 	(OTHERS => '0');
	END_ADDR	    <= 	(OTHERS => '0');
	START 			<= 	'0';
	WAIT UNTIL rising_edge(clk);
	--END_ADDR(4) <= '1'; --(4 => '1', OTHERS => '0')
	START <= '1';

	WAIT UNTIL rising_edge(BUF_REQ);
	START <= '0';
	BUF_REQ_ACK <= '1';
	
	BUF_REQ_SIZE 	<= slv(to_unsigned(11, 5));
	BUF_REQ_ADDR(3) <= '0'; --(3 => '1', OTHERS => '0'); 
	
	WAIT UNTIL rising_edge(clk);
	BUF_REQ_ACK <= '0';
	BUF_REQ_RDY <= '1';
	
	WAIT UNTIL rising_edge(DMA_REQ);
	DMA_REQ_ACK <= '1';
	
	WAIT UNTIL rising_edge(clk);
	DMA_REQ_ACK <= '0';
	
	WAIT UNTIL rising_edge(clk);
	WAIT UNTIL rising_edge(clk);

	DMA_ERR 	<= '0';
	DMA_DONE 	<= '1';
	
	WHILE DONE /= '1' LOOP
		WAIT UNTIL rising_edge(clk);
		IF DONE_ERR = '1' THEN
			REPORT "DONE_ERR = '1'!. Test FAILED" SEVERITY failure;
		END IF;
	END LOOP;
	
	DMA_DONE <= '0';
	
	WAIT UNTIL rising_edge(clk);
	WAIT UNTIL rising_edge(clk);
	WAIT UNTIL rising_edge(clk);
	
	IF (BUF_REQ = '1') THEN
			REPORT "Asking for another transfer..should not happen in this test" SEVERITY failure;
	END IF;
	
	REPORT "TEST PASSED"SEVERITY failure;
	
END PROCESS;

END ARCHITECTURE test;