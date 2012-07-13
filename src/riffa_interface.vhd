LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.math_real.log2;
USE ieee.math_real.ceil;

--LIBRARY proc_common_v3_00_a;
--USE proc_common_v3_00_a.proc_common_pkg.ALL;

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
	C_SIMPBUS_AWIDTH 	: integer := 32;
	C_BRAM_ADDR			: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	C_BRAM_SIZE			: integer := 32768
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
	BRAM_Clk				: OUT std_logic;
	BRAM_Rst				: OUT std_logic;
	BRAM_EN					: OUT std_logic;
	BRAM_WEN				: OUT std_logic_vector(3 DOWNTO 0);
	BRAM_Dout				: OUT std_logic_vector(31 DOWNTO 0);
	BRAM_Din				: IN std_logic_vector(31 DOWNTO 0);
	BRAM_Addr				: OUT std_logic_vector(31 DOWNTO 0)
);

--attribute SIGIS : string;
--attribute SIGIS of SYS_CLK     		: signal is "CLK";
--attribute SIGIS of SYS_RST      		: signal is "RST";
--attribute SIGIS of BRAM_Clk      		: signal is "CLK";
--attribute SIGIS of BRAM_Rst      		: signal is "RST";

END ENTITY riffa_interface;


ARCHITECTURE synth OF riffa_interface IS

TYPE states IS (
			idle, 
			--INPUT DATA TRANSFER STATE (PC 2 FPGA)
			PC2FPGA_Data_transfer_wait,
			--PROCESSING STATE
			process_data,
			--SENDING DATA BACK TO PC STATE
			dma_transfer,
			--Done states
			interrupt_state,
			interrupt_err_state
			);
SIGNAL state, nstate : states := idle;

SIGNAL bramAddress 	: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0'); --Pointer to BRAM
SIGNAL bramDataOut 	: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0'); --Data output to bram

ALIAS slv IS std_logic_vector;
ALIAS usg IS unsigned;
ALIAS sg IS signed;

CONSTANT SIMPBUS_ZERO : std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0) := (OTHERS => '0');
CONSTANT C_BRAM_LOG : integer := integer(ceil(log2(real(C_BRAM_SIZE-1))));

BEGIN

--BRAM enable signal
BRAM_EN <= '1'; --Always enable the memory

--Assign BRAM clk and reset signals
BRAM_Clk <= SYS_CLK;
BRAM_Rst <= SYS_RST;

--Assign BRAM address and output signals
BRAM_Addr <= bramAddress;
BRAM_Dout <= bramDataOut;

--PC TO FPGA data transfer signals
BUF_REQD_ADDR <= C_BRAM_ADDR; --Address of BRAM or off-chip RAM
BUF_REQD_SIZE <= slv((to_unsigned(C_BRAM_LOG, 5))); --Size of RAM in exponent of 2
BUF_REQD_ERR <= '0'; --There should be no errors. Should allow the PC to write the arguments to the BRAM


Combinatorial : PROCESS (SYS_RST, DOORBELL, DOORBELL_ERR, BUF_REQD, INTERRUPT_ACK, state)
BEGIN
	IF (SYS_RST = '1') THEN
		nstate <= idle;
	ELSE
		nstate <= state;
		
		CASE state IS
			WHEN idle =>
				IF (BUF_REQD = '1') THEN
					nstate <= PC2FPGA_Data_transfer_wait; --go to wait state until the data is successfully transferred
				END IF;
			WHEN PC2FPGA_Data_transfer_wait =>
				IF (DOORBELL = '1') THEN
					IF (DOORBELL_ERR = '0') THEN
						nstate <= process_data; --go to state where we process the data after getting confirmation from PC
					ELSE
						nstate <= idle; --reset to idle state if there is an error from host
					END IF;
				END IF;
			WHEN interrupt_err_state | interrupt_state =>
				IF (INTERRUPT_ACK = '1') THEN
					nstate <= idle; --go to idle state if PC sends interrupt ack signal back
				END IF;
			WHEN process_data => nstate <= interrupt_state;
			WHEN OTHERS => nstate <= idle;	
		END CASE;
	END IF;

END PROCESS Combinatorial;

AssignCombinatorialOutputs : PROCESS (state)
BEGIN
	
	--Write enable BRAM when waiting for PC to transfer
	--data to FPGA
	IF (state = PC2FPGA_Data_transfer_wait) THEN
		BRAM_WEN <= (OTHERS => '1');
	ELSE
		BRAM_WEN <= (OTHERS => '0');
	END IF;

	--BUF_REQD_RDY is only high if state = wait for PC to transfer data to FPGA	
	IF (state = PC2FPGA_Data_transfer_wait) THEN
		BUF_REQD_RDY <= '1';
	ELSE
		BUF_REQD_RDY <= '0';
	END IF;
	
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

	ELSE
		state <= nstate; -- assign the state to next state
		
		IF (state = PC2FPGA_Data_transfer_wait AND DOORBELL = '1' AND DOORBELL_ERR = '0' AND DOORBELL_LEN /= SIMPBUS_ZERO) THEN
			--REPORT "bramAddress should be: "&integer'image(to_integer(usg(DOORBELL_LEN)*8));
			bramAddress <= slv(usg(bramAddress) + resize(usg(DOORBELL_LEN)*8 - 1,C_SIMPBUS_AWIDTH)); --Increment the pointer with however many bits were transferred
		END IF;
		
	END IF;

END PROCESS State_Assignment;


END ARCHITECTURE synth;