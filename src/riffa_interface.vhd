LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.math_real.log2;
USE ieee.math_real.ceil;

ENTITY riffa_interface IS
------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Port assignments taken from Matt Jacobson's riffa_example
-- Definition of Generics:
--   C_SIMPBUS_AWIDTH			-- SIMPBUS address width
--   C_BRAM_ADDR				-- Address of BRAM
--   C_BRAM_SIZE				-- Size of BRAM

-- Definition of Ports:
--   SYS_CLK					-- System main clock
--   SYS_RST					-- System reset

--   INTERRUPT					-- Interrupt to PC
--   INTERRUPT_ERR				-- Interrupt to PC, error signal
--   INTERRUPT_ACK				-- Interrupt to PC acknowledgement
--   DOORBELL					-- Doorbell from PC
--   DOORBELL_ERR				-- Doorbell from PC, error signal
--   DOORBELL_LEN				-- Doorbell from PC, length of received data
--   DOORBELL_ARG				-- Args from PC to FPGA, received on doorbell
--   DMA_REQ					-- DMA request
--   DMA_REQ_ACK				-- DMA acknowledgement
--   DMA_SRC					-- DMA source address
--   DMA_DST					-- DMA destination address
--   DMA_LEN					-- DMA length
--   DMA_SIG					-- DMA signal after transfer
--   DMA_DONE					-- DMA complete signal
--   DMA_ERR					-- DMA error signal
--   BUF_REQ					-- Request a PC buffer for DMA
--   BUF_REQ_ACK				-- Request ack for a PC buffer for DMA
--   BUF_REQ_ADDR				-- PC buffer address for DMA
--   BUF_REQ_SIZE				-- PC buffer size (log2) for DMA
--   BUF_REQ_RDY				-- PC buffer address/size for DMA is valid
--   BUF_REQ_ERR				-- PC buffer for DMA error
--   BUF_REQD					-- FPGA buffer for DMA requested
--   BUF_REQD_ADDR				-- FPGA buffer address for DMA
--   BUF_REQD_SIZE				-- FPGA buffer size (log2) for DMA
--   BUF_REQD_RDY				-- FPGA buffer address/size for DMA is valid
--   BUF_REQD_ERR				-- FPGA buffer for DMA error

--   BRAM_Clk					-- Memory clock for pixel output data
--   BRAM_Rst					-- Memory reset signal for pixel output data
--   BRAM_EN					-- Memory block enable for pixel output data
--   BRAM_WEN					-- Memory block write enable for pixel output data
--   BRAM_Dout					-- Memory data out for pixel output data
--   BRAM_Din					-- Memory data in for pixel output data
--   BRAM_Addr					-- Memory address for pixel output data
------------------------------------------------------------------------------
GENERIC(
	C_SIMPBUS_AWIDTH 			: integer := 32;
	C_BRAM_ADDR					: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	C_BRAM_SIZE					: integer := 32768
);

PORT(
	--SYSTEM CLOCK AND SYSTEM RESET--
	SYS_CLK					: IN std_logic;
	SYS_RST					: IN std_logic;

	--INTERRUPTS SIGNALS TO PC--
	INTERRUPT				: OUT std_logic;
	INTERRUPT_ERR			: OUT std_logic;
	INTERRUPT_ACK			: IN std_logic;
	
	--DOORBELL SIGNALS FROM PC--
	DOORBELL				: IN std_logic;
	DOORBELL_ERR			: IN std_logic;
	DOORBELL_LEN			: IN std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG			: IN std_logic_vector(31 DOWNTO 0);
	
	--DMA SIGNALS--
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
	--FPGA BUFFER REQUEST SIGNALS--
	BUF_REQD				: IN std_logic;
	BUF_REQD_ADDR			: OUT std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	BUF_REQD_SIZE			: OUT std_logic_vector(4 DOWNTO 0);
	BUF_REQD_RDY			: OUT std_logic;
	BUF_REQD_ERR			: OUT std_logic;

	--BRAM SIGNALS--
	BRAM_EN					: OUT std_logic;
	BRAM_WEN				: OUT std_logic_vector(3 DOWNTO 0);
	BRAM_Dout				: OUT std_logic_vector(31 DOWNTO 0);
	BRAM_Din				: IN std_logic_vector(31 DOWNTO 0);
	BRAM_Addr				: OUT std_logic_vector(31 DOWNTO 0)
);

END ENTITY riffa_interface;


ARCHITECTURE synth OF riffa_interface IS

	COMPONENT dma_handler IS
		GENERIC(
			C_SIMPBUS_AWIDTH 	: integer;
			C_BRAM_ADDR			: std_logic_vector(31 DOWNTO 0);
			C_BRAM_SIZE			: integer
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
	END COMPONENT dma_handler;

TYPE states IS (
			idle,
			--ARGUMENTS STORAGE STATES
			store_arg_0,
			store_arg_1,
			--SENDING DATA BACK TO PC STATE
			dma_transfer,
			--DONE STATE
			interrupt_state,
			interrupt_err_state
			);
SIGNAL state, nstate : states := idle;

SIGNAL bramAddress 	: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0'); --Pointer to BRAM
SIGNAL bramDataOut 	: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0'); --Data output to bram


CONSTANT SIMPBUS_ZERO : std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0) := (OTHERS => '0');
CONSTANT C_BRAM_LOG : integer := integer(ceil(log2(real(C_BRAM_SIZE-1))));


--DMA INTERFACING SIGNALS
SIGNAL DONE, DONE_ERR		 		: std_logic := '0';
SIGNAL START, r_start				: std_logic := '0';
SIGNAL START_ADDR, r_start_addr		: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL END_ADDR, r_end_addr			: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0) := (OTHERS => '0');

--Start acknowledge signal from dma_handler block
SIGNAL START_ACK	: std_logic := '0';

BEGIN

--BRAM enable signal
BRAM_EN <= '1'; --Always enable the memory

--Assign BRAM address and output signals
BRAM_Addr <= bramAddress;
BRAM_Dout <= bramDataOut;

--PC TO FPGA data transfer signals
BUF_REQD_ADDR 	<= C_BRAM_ADDR; --Address of BRAM or off-chip RAM
BUF_REQD_SIZE 	<= std_logic_vector((to_unsigned(C_BRAM_LOG, 5))); --Size of RAM in exponent of 2
BUF_REQD_ERR 	<= '0'; --There should be no errors. Should allow the PC to write the arguments to the BRAM

--Drive signal with registered output
START_ADDR 	<= r_start_addr;
END_ADDR 	<= r_end_addr;
START 		<= r_start;

DMA : COMPONENT dma_handler
GENERIC MAP(
	C_SIMPBUS_AWIDTH 		=> C_SIMPBUS_AWIDTH,
	C_BRAM_ADDR				=> C_BRAM_ADDR,	
	C_BRAM_SIZE				=> C_BRAM_SIZE	
)
PORT MAP(
	--SYSTEM CLOCK AND SYSTEM RESET--
	SYS_CLK					=> 	SYS_CLK,		--IN
	SYS_RST					=> 	SYS_RST,		--IN

	--DMA signals
	DMA_REQ					=>	DMA_REQ,		--OUT
	DMA_REQ_ACK				=>	DMA_REQ_ACK,	--IN
	DMA_SRC					=>	DMA_SRC,		--OUT
	DMA_DST					=>	DMA_DST,		--OUT
	DMA_LEN					=>	DMA_LEN,		--OUT
	DMA_SIG					=>	DMA_SIG,		--OUT
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
	
	--Start ACK signal
	START_ACK				=> START_ACK		--OUT
);


Combinatorial : PROCESS (SYS_RST, DOORBELL, DOORBELL_ERR, DOORBELL_LEN, INTERRUPT_ACK, DONE, DONE_ERR, state)
BEGIN
	IF (SYS_RST = '1') THEN
		nstate <= idle;
	ELSE
		nstate <= state;
		
		CASE state IS
			WHEN idle =>
				IF (DOORBELL = '1' AND DOORBELL_LEN = SIMPBUS_ZERO AND DOORBELL_ERR = '0') THEN
					nstate <= store_arg_0; --go to wait state until the data is successfully transferred
				END IF;
			WHEN store_arg_0 =>
				nstate <= store_arg_1;
			WHEN store_arg_1 =>
				nstate <= dma_transfer;
			WHEN dma_transfer =>
				IF (DONE = '1') THEN
					IF (DONE_ERR = '1') THEN
						nstate <= interrupt_err_state;
					ELSE
						nstate <= interrupt_state;
					END IF;
				END IF;
			WHEN interrupt_err_state | interrupt_state =>
				IF (INTERRUPT_ACK = '1') THEN
					nstate <= idle; --go to idle state if PC sends interrupt ack signal back
				END IF;
			WHEN OTHERS => nstate <= idle;	
		END CASE;
	END IF;

END PROCESS Combinatorial;

AssignCombinatorialOutputs : PROCESS (state)
BEGIN
	
	--The BRAM is not used for storing data in this hardware
	BRAM_WEN <= (OTHERS => '0');


	--BUF_REQD_RDY is always 0 indicating that hardware doesn't respond to
	--PC trying to send data to the FPGA.
	BUF_REQD_RDY <= '0';

	--Interrupt assignments
	IF (state = interrupt_state OR state = interrupt_err_state) THEN
		INTERRUPT <= '1'; --Flag interrupt signals
		IF(state = interrupt_err_state) THEN
			INTERRUPT_ERR <= '1'; --Flag interrupt error signal to output
		ELSE
			INTERRUPT_ERR <= '0'; --If there are no errors then flag error interrupt low
		END IF;
	ELSE
		INTERRUPT <= '0';
		INTERRUPT_ERR <= '0';
	END IF;

END PROCESS;

State_Assignment : PROCESS
BEGIN
WAIT UNTIL rising_edge(SYS_CLK);
	IF(SYS_RST = '1') THEN --Synchronous reset signal
		state <= idle;
		bramDataOut <= (OTHERS => '0');
		bramAddress <= C_BRAM_ADDR;
		r_start_addr <= (OTHERS => '0');
		r_end_addr	<= (OTHERS => '0');
		r_start <= '0';
	ELSE
		state <= nstate; -- assign the state to next state
		r_start_addr <= C_BRAM_ADDR;
		r_end_addr	<= (OTHERS => '0');
		r_start <= '0';
		
		IF (state = store_arg_0) THEN
			bramAddress <= std_logic_vector(resize(unsigned(C_BRAM_ADDR) + unsigned(DOORBELL_ARG), C_SIMPBUS_AWIDTH));
		END IF;
		
		--Initiate DMA transfer of length = ARG_0
		IF (state = dma_transfer) THEN
			r_start_addr <= C_BRAM_ADDR;
			IF (unsigned(bramAddress) <= unsigned(C_BRAM_ADDR) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH)) THEN
				r_end_addr <= bramAddress;
			ELSE
				r_end_addr <= std_logic_vector(unsigned(C_BRAM_ADDR) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH));
			END IF;

			IF (START_ACK = '1') THEN
				r_start <= '0'; --start DMA transfer
			ELSE
				r_start <= '1';
			END IF;
			IF (DONE = '1') THEN
				bramAddress <= r_start_addr;
			END IF;
		END IF;		
		
	END IF;

END PROCESS State_Assignment;


END ARCHITECTURE synth;
