LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.riffa_interface;

ENTITY riffa_test_bench IS
	GENERIC(
		C_SIMPBUS_AWIDTH : integer := 32
	);
END ENTITY riffa_test_bench;

ARCHITECTURE testbench OF riffa_test_bench IS

SIGNAL clk : std_logic;
SIGNAL reset : std_logic;

ALIAS slv IS std_logic_vector;
ALIAS usg IS unsigned;
ALIAS sg IS signed;

CONSTANT Clk_div_2 	: time := 4 ns;
CONSTANT Clk_period	: time := 8 ns;

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
SIGNAL BRAM_Clk			: std_logic; 										--OUT
SIGNAL BRAM_Rst			: std_logic;										--OUT
SIGNAL BRAM_EN			: std_logic;										--OUT
SIGNAL BRAM_WEN			: std_logic_vector(3 DOWNTO 0);						--OUT
SIGNAL BRAM_Dout		: std_logic_vector(31 DOWNTO 0);					--OUT
SIGNAL BRAM_Din			: std_logic_vector(31 DOWNTO 0);					--IN
SIGNAL BRAM_Addr		: std_logic_vector(31 DOWNTO 0);					--OUT

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
	BRAM_Clk			=> BRAM_Clk, 					--OUT	
	BRAM_Rst			=> BRAM_Rst, 					--OUT	
	BRAM_EN				=> BRAM_EN,	 					--OUT
	BRAM_WEN			=> BRAM_WEN, 					--OUT	
	BRAM_Dout			=> BRAM_Dout,					--OUT
	BRAM_Din			=> BRAM_Din, 					--IN	
	BRAM_Addr			=> BRAM_Addr 					--OUT
);


Clk_generate : PROCESS --Process to generate the clk
BEGIN
	clk <= '0';
	WAIT FOR Clk_div_2;
	clk <= '1';
	WAIT FOR Clk_div_2;
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
CONSTANT limit		 		: integer :=  32;
CONSTANT bytes_transferred	: integer := 16;
BEGIN
INTERRUPT_ACK 	<= '0';
DOORBELL		<= '0';		
DOORBELL_ERR	<= '0';
DOORBELL_LEN	<= (OTHERS => '0');
DOORBELL_ARG	<= (OTHERS => '0');
BUF_REQD		<= '0';
BRAM_Din 		<= (OTHERS => '0');

DMA_REQ_ACK 	<= 	'0';
DMA_DONE		<=	'0';
DMA_ERR			<= 	'0';	
BUF_REQ_ACK		<=	'0';
BUF_REQ_ADDR	<= 	(OTHERS => '0');
BUF_REQ_SIZE	<= 	(OTHERS => '0');
BUF_REQ_RDY		<= 	'0';
BUF_REQ_ERR		<= 	'0';

WAIT UNTIL rising_edge(clk);

BUF_REQD <= '1';

WHILE BUF_REQD_RDY /= '1' LOOP
	WAIT UNTIL rising_edge(clk);
	counter := counter + 1;
	IF (counter > limit) THEN
		REPORT "counter = "&integer'image(counter)&" has reached maximum limit of "&integer'image(limit)&" cycles" SEVERITY failure;
	END IF;
END LOOP;

BUF_REQD <= '0';

WAIT UNTIL rising_edge(clk);
DOORBELL <= '1';
DOORBELL_LEN <= slv(to_unsigned(bytes_transferred,C_SIMPBUS_AWIDTH));

WAIT UNTIL rising_edge(clk);
DOORBELL <= '0';
DOORBELL_LEN <= (OTHERS => '0');


--DMA STUFF
WAIT UNTIL rising_edge(BUF_REQ);
WAIT UNTIL rising_edge(clk);
BUF_REQ_ACK <= '1';

BUF_REQ_SIZE 	<= slv(to_unsigned(11, 5));
BUF_REQ_ADDR(3) <= '1'; --(3 => '1', OTHERS => '0'); 

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
	
WAIT UNTIL rising_edge(clk);

DMA_DONE <= '0';

WAIT UNTIL rising_edge(INTERRUPT);

IF (INTERRUPT_ERR = '1') THEN
	WAIT UNTIL rising_edge(clk);
	INTERRUPT_ACK <= '1';
	WAIT UNTIL rising_edge(clk);
	INTERRUPT_ACK <= '0';
	REPORT "Error occured in hardware" SEVERITY failure;
ELSE
	WAIT UNTIL rising_edge(clk);
	INTERRUPT_ACK <= '1';
	WAIT UNTIL rising_edge(clk);
	INTERRUPT_ACK <= '0';
	REPORT "Test PASSED." SEVERITY failure;
END IF;

END PROCESS State_Machine_test;


END ARCHITECTURE testbench;
