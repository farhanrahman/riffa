LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.riffa_interface;
USE work.project_pak.ALL;
USE work.utility.ALL;
USE work.bram;

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

CONSTANT C_BRAM_SIZE : integer := 16;
CONSTANT C_BRAM_ADDR : std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := X"90000000";

CONSTANT RUNTIME		: std_logic_vector(31 DOWNTO 0) := std_logic_vector(to_unsigned(40,32));
CONSTANT OUTPUT_CYCLE	: std_logic_vector(31 DOWNTO 0) := std_logic_vector(to_unsigned(2,32));

BEGIN

DUT : ENTITY riffa_interface
	GENERIC MAP
	(
		C_SIMPBUS_AWIDTH		=> C_SIMPBUS_AWIDTH,
		C_BRAM_ADDR				=> C_BRAM_ADDR,
		C_BRAM_SIZE				=> C_BRAM_SIZE
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

RAM : ENTITY BRAM
GENERIC MAP(
	C_BRAM_SIZE => C_BRAM_SIZE,
	RUNTIME		=> RUNTIME,
	OUTPUT_CYCLE=> OUTPUT_CYCLE
)
PORT MAP(
	SYS_CLK		=> clk,
	SYS_RST		=> reset,
	BRAM_EN		=> BRAM_EN,
	BRAM_WEN	=> BRAM_WEN,
	BRAM_Dout	=> BRAM_Dout,
	BRAM_Din	=> BRAM_Din,
	BRAM_Addr	=> BRAM_Addr
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

Interrupt_handling : PROCESS
BEGIN
	--Handle the interrupt signals from the FPGA
	INTERRUPT_ACK 	<= '0';
	handle_interrupt(clk,INTERRUPT,INTERRUPT_ERR,INTERRUPT_ACK);
	wait_for(clk, 10);
	REPORT "Test PASSED." SEVERITY failure;
	WAIT;
END PROCESS;


State_Machine_test : PROCESS
CONSTANT bytes_transferred	: integer := 8; --in bytes. Assuming for now 4 inputs of 32 bit width
CONSTANT transfer_length	: std_logic_vector(31 DOWNTO 0) := std_logic_vector(to_unsigned(8,32));
BEGIN
DOORBELL		<= '0';		
DOORBELL_ERR	<= '0';
DOORBELL_LEN	<= (OTHERS => '0');
DOORBELL_ARG	<= (OTHERS => '0');
BUF_REQD		<= '0';

DMA_REQ_ACK 	<= 	'0';
DMA_DONE		<=	'0';
DMA_ERR			<= 	'0';	
BUF_REQ_ACK		<=	'0';
BUF_REQ_ADDR	<= 	(OTHERS => '0');
BUF_REQ_SIZE	<= 	(OTHERS => '0');
BUF_REQ_RDY		<= 	'0';
BUF_REQ_ERR		<= 	'0';

WAIT UNTIL rising_edge(clk);

	--Check for doorbell reset
	send_doorbell_arguments(clk, DOORBELL, transfer_length, ARG_1, DOORBELL_ARG, DOORBELL_ERR, DOORBELL_LEN);
	
	--Wait until the processing has finished and the whole BRAM has been transferred
	--back to the PC
	WHILE (TRUE) LOOP
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
	WAIT;
END PROCESS State_Machine_test;


END ARCHITECTURE testbench;
