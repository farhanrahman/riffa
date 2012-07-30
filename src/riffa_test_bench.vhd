LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.riffa_interface;
USE work.project_pak.ALL;
USE work.utility.ALL;

ENTITY riffa_test_bench IS
END ENTITY riffa_test_bench;

ARCHITECTURE testbench OF riffa_test_bench IS

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

SIGNAL START_PROCESS	: std_logic;										--OUT
CONSTANT C_NUM_OF_OUTPUTS_FROM_CORE	: integer := 1;
SIGNAL CORE_OUTPUTS		: std_logic_vector(C_NUM_OF_OUTPUTS_FROM_CORE*C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN

riffa : ENTITY riffa_interface
PORT MAP(
	--SYSTEM CLOCK AND SYSTEM RESET--
	SYS_CLK				=> clk,
	SYS_RST				=> reset,

	--INTERRUPTS SIGNALS TO PC--
	INTERRUPT			=> INTERRUPT, 					--OUT
	INTERRUPT_ERR		=> INTERRUPT_ERR, 				--OUT
	INTERRUPT_ACK		=> INTERRUPT_ACK, 				--IN
	
	--DOORBELL SIGNALS FROM PC--
	DOORBELL			=> DOORBELL, 					--IN
	DOORBELL_ERR		=> DOORBELL_ERR, 				--IN
	DOORBELL_LEN		=> DOORBELL_LEN,				--IN
	DOORBELL_ARG		=> DOORBELL_ARG, 				--IN
	
	--DMA SIGNALS--
	DMA_REQ				=> DMA_REQ,						--OUT
	DMA_REQ_ACK			=> DMA_REQ_ACK,					--IN
	DMA_SRC				=> DMA_SRC,		 				--OUT
	DMA_DST				=> DMA_DST,		 				--OUT
	DMA_LEN				=> DMA_LEN,						--OUT
	DMA_SIG				=> DMA_SIG,						--OUT
	DMA_DONE			=> DMA_DONE,					--IN
	DMA_ERR				=> DMA_ERR,						--IN
	
	--FPGA TO PC BUFFER--
	BUF_REQ				=> BUF_REQ,		    			--OUT
	BUF_REQ_ACK			=> BUF_REQ_ACK,	    			--IN
	BUF_REQ_ADDR		=> BUF_REQ_ADDR,    			--IN
	BUF_REQ_SIZE		=> BUF_REQ_SIZE,    			--IN
	BUF_REQ_RDY			=> BUF_REQ_RDY,	    			--IN
	BUF_REQ_ERR			=> BUF_REQ_ERR,	    			--IN
	
	
	--PC BUFFER REQUEST SIGNALS--
	BUF_REQD			=> BUF_REQD,					--IN
	BUF_REQD_ADDR		=> BUF_REQD_ADDR,				--OUT
	BUF_REQD_SIZE		=> BUF_REQD_SIZE,				--OUT
	BUF_REQD_RDY		=> BUF_REQD_RDY,				--OUT
	BUF_REQD_ERR		=> BUF_REQD_ERR,				--OUT

	--BRAM SIGNALS--
	BRAM_EN				=> BRAM_EN,	 					--OUT
	BRAM_WEN			=> BRAM_WEN, 					--OUT	
	BRAM_Dout			=> BRAM_Dout,					--OUT
	BRAM_Din			=> BRAM_Din, 					--IN	
	BRAM_Addr			=> BRAM_Addr, 					--OUT
	
	--START PROCESS to start core processing
	START_PROCESS		=> START_PROCESS,				--OUT
	
	FINISHED 			=> '0',							--IN
	VALID				=> '0',							--IN
	CORE_OUTPUTS		=>	CORE_OUTPUTS				--OUT
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

--TYPE rec IS
--RECORD
--	reset, start: std_logic;
--END RECORD;
--
--TYPE input_data_array_type IS ARRAY (natural RANGE <>) OF rec;
--
--CONSTANT test_input_data : input_data_array_type := (
--	 ('0','0'),
--     ('0','1')
--);

VARIABLE counter 			: integer := 0;
CONSTANT limit		 		: integer := 32; --cycles wait until BUF_REQD times out
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
