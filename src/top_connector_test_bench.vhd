LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.top_connector;
USE work.project_pak.ALL;
USE work.utility.ALL;

ENTITY top_connector_test_bench IS
END ENTITY top_connector_test_bench;

ARCHITECTURE testbench OF top_connector_test_bench IS

SIGNAL clk : std_logic;
SIGNAL reset : std_logic;

ALIAS slv IS std_logic_vector;
ALIAS usg IS unsigned;
ALIAS sg IS signed;

--INTERRUPT SIGNALS
SIGNAL INTERRUPT		: std_logic;										--OUT
SIGNAL INTERRUPT_ERR	: std_logic;										--OUT
SIGNAL INTERRUPT_ACK	: std_logic;										--IN

--DOORBELL SIGNALS
SIGNAL DOORBELL			: std_logic;										--IN
SIGNAL DOORBELL_ERR 	: std_logic;										--IN
SIGNAL DOORBELL_LEN 	: std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);	--IN
SIGNAL DOORBELL_ARG		: std_logic_vector(31 DOWNTO 0);					--IN


--DMA SIGNALS--
SIGNAL DMA_REQ			: std_logic;										--OUT
SIGNAL DMA_REQ_ACK		: std_logic;										--IN
SIGNAL DMA_SRC			: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0); 	--OUT
SIGNAL DMA_DST			: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0); 	--OUT
SIGNAL DMA_LEN			: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0); 	--OUT
SIGNAL DMA_SIG			: std_logic;									 	--OUT
SIGNAL DMA_DONE			: std_logic;										--IN
SIGNAL DMA_ERR			: std_logic;										--IN
	
--PC BUFFER REQUEST SIGNALS--
SIGNAL BUF_REQ			: std_logic;                                    	--OUT
SIGNAL BUF_REQ_ACK		: std_logic;                                     	--IN
SIGNAL BUF_REQ_ADDR		: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0); 	--IN
SIGNAL BUF_REQ_SIZE		: std_logic_vector(4 DOWNTO 0);                  	--IN
SIGNAL BUF_REQ_RDY		: std_logic;                                     	--IN
SIGNAL BUF_REQ_ERR		: std_logic;                                     	--IN


--PC TO FPGA DATA TRANSFER SIGNALS
SIGNAL BUF_REQD			:	std_logic;										--IN
SIGNAL BUF_REQD_ADDR	:	std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);	--OUT
SIGNAL BUF_REQD_SIZE	:	std_logic_vector(4 DOWNTO 0);					--OUT
SIGNAL BUF_REQD_RDY		:	std_logic;										--OUT
SIGNAL BUF_REQD_ERR		:	std_logic;										--OUT

--BRAM SIGNALS FROM AND TO RIFFA_INTERFACE
SIGNAL BRAM_EN			: std_logic;										--OUT
SIGNAL BRAM_WEN			: std_logic_vector(3 DOWNTO 0);						--OUT
SIGNAL BRAM_Dout		: std_logic_vector(31 DOWNTO 0);					--OUT
SIGNAL BRAM_Din			: std_logic_vector(31 DOWNTO 0);					--IN
SIGNAL BRAM_Addr		: std_logic_vector(31 DOWNTO 0);					--OUT

CONSTANT C_NUM_OF_OUTPUTS_FROM_CORE	: integer := 1;

BEGIN

DUT : ENTITY top_connector
	GENERIC MAP
	(
		C_SIMPBUS_AWIDTH		=> C_SIMPBUS_AWIDTH,
		C_BRAM_SIZE				=> 32768
	)
	PORT MAP
	(
		SYS_CLK					=> clk,
		SYS_RST					=> reset,
		INTERRUPT				=> INTERRUPT,
		INTERRUPT_ERR			=> INTERRUPT_ERR,
		INTERRUPT_ACK			=> INTERRUPT_ACK,
		DOORBELL				=> DOORBELL,
		DOORBELL_ERR			=> DOORBELL_ERR,
		DOORBELL_LEN			=> DOORBELL_LEN,
		DOORBELL_ARG			=> DOORBELL_ARG,
		DMA_REQ					=> DMA_REQ,
		DMA_REQ_ACK				=> DMA_REQ_ACK,
		DMA_SRC					=> DMA_SRC,
		DMA_DST					=> DMA_DST,
		DMA_LEN					=> DMA_LEN,
		DMA_SIG					=> DMA_SIG,
		DMA_DONE				=> DMA_DONE,
		DMA_ERR					=> DMA_ERR,
		BUF_REQ					=> BUF_REQ,
		BUF_REQ_ACK				=> BUF_REQ_ACK,
		BUF_REQ_ADDR			=> BUF_REQ_ADDR,
		BUF_REQ_SIZE			=> BUF_REQ_SIZE,
		BUF_REQ_RDY				=> BUF_REQ_RDY,
		BUF_REQ_ERR				=> BUF_REQ_ERR,
		BUF_REQD				=> BUF_REQD,
		BUF_REQD_ADDR			=> BUF_REQD_ADDR,
		BUF_REQD_SIZE			=> BUF_REQD_SIZE,
		BUF_REQD_RDY			=> BUF_REQD_RDY,
		BUF_REQD_ERR			=> BUF_REQD_ERR,
		BRAM_EN					=> BRAM_EN,
		BRAM_WEN				=> BRAM_WEN,
		BRAM_Dout				=> BRAM_Dout,
		BRAM_Din				=> BRAM_Din,
		BRAM_Addr				=> BRAM_Addr
	);


Clk_generate : PROCESS --Process to generate the clk
BEGIN
	clk <= '0';
	WAIT FOR clk_per/2;
	clk <= '1';
	WAIT FOR clk_per/2;
END PROCESS;

Rst_generate : PROCESS --Process to generate the reset in the beginning
BEGIN
	reset <= '1';
	WAIT UNTIL rising_edge(clk);
	reset <= '0';
	WAIT;
END PROCESS;


State_Machine_test : PROCESS

CONSTANT bytes_transferred	: integer := 16; --in bytes. Assuming for now 4 inputs of 32 bit width

BEGIN
INTERRUPT_ACK 	<= '0';
DOORBELL		<= '0';		
DOORBELL_ERR	<= '0';
DOORBELL_LEN	<= (OTHERS => '0');
DOORBELL_ARG	<= (OTHERS => '0');
BUF_REQD		<= '0';
BRAM_Din 		<= slv(to_unsigned(1024, C_SIMPBUS_AWIDTH));--(OTHERS => '0');

DMA_REQ_ACK 	<= 	'0';
DMA_DONE		<=	'0';
DMA_ERR			<= 	'0';	
BUF_REQ_ACK		<=	'0';
BUF_REQ_ADDR	<= 	(OTHERS => '0');
BUF_REQ_SIZE	<= 	(OTHERS => '0');
BUF_REQ_RDY		<= 	'0';
BUF_REQ_ERR		<= 	'0';

WAIT UNTIL rising_edge(clk);

	--First send the data.
	send_data(clk,BUF_REQD,BUF_REQD_RDY);

	--Send a doorbell with number of bytes transferred
	send_doorbell(clk,DOORBELL,DOORBELL_LEN,bytes_transferred);

	--Wait until the processing has finished and the whole BRAM has been transferred
	--back to the PC
	WHILE (usg(DMA_SRC) /= to_unsigned(32768, C_SIMPBUS_AWIDTH)) LOOP
		handle_dma_normal(
					BUF_REQ,
					clk,
					BUF_REQ_ACK,
					BUF_REQ_SIZE,
					BUF_REQ_ADDR,
					BUF_REQ_RDY,
					DMA_REQ,
					DMA_REQ_ACK,
					DMA_ERR,
					DMA_DONE
		);
	END LOOP;
	
	--Handle the interrupt signals from the FPGA
	handle_interrupt(clk,INTERRUPT,INTERRUPT_ERR,INTERRUPT_ACK);
	
END PROCESS State_Machine_test;


END ARCHITECTURE testbench;