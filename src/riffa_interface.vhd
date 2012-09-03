------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.log2;
USE IEEE.math_real.ceil;
USE IEEE.math_real.realmax;

ENTITY riffa_interface IS
------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Port assignments taken from Matt Jacobson's riffa_example
-- Definition of Generics:
--   C_SIMPBUS_AWIDTH			-- SIMPBUS address width
--   C_BRAM_ADDR_0				-- Address of BRAM
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
--   BRAM_EN_0					-- Memory block enable for pixel output data
--   BRAM_WEN_0					-- Memory block write enable for pixel output data
--   BRAM_Dout_0				-- Memory data out for pixel output data
--   BRAM_Din_0					-- Memory data in for pixel output data
--   BRAM_Addr_0				-- Memory address for pixel output data
------------------------------------------------------------------------------
GENERIC(
	C_SIMPBUS_AWIDTH 			: integer := 32;
	C_BRAM_ADDR_0				: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	C_BRAM_ADDR_1				: std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	C_BRAM_SIZE					: integer := 32768;
	C_NUM_OF_INPUTS_TO_CORE		: integer := 4; --CANNOT BE ZERO
	C_NUM_OF_OUTPUTS_FROM_CORE	: integer := 1 --CANNOT BE ZERO
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

	--BRAM 0 SIGNALS--
	BRAM_EN_0					: OUT std_logic;
	BRAM_WEN_0				: OUT std_logic_vector(3 DOWNTO 0);
	BRAM_Dout_0				: OUT std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);	  --Not sure if length should be 32 bits or length of simplebus
	BRAM_Din_0				: IN std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);     --Not sure if length should be 32 bits or length of simplebus
	BRAM_Addr_0				: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);    --Not sure if length should be 32 bits or length of simplebus
	
	--BRAM 1 SIGNALS--
	BRAM_EN_1				: OUT std_logic;
	BRAM_WEN_1				: OUT std_logic_vector(3 DOWNTO 0);
	BRAM_Dout_1				: OUT std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);	  --Not sure if length should be 32 bits or length of simplebus
	BRAM_Din_1				: IN std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);     --Not sure if length should be 32 bits or length of simplebus
	BRAM_Addr_1				: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);    --Not sure if length should be 32 bits or length of simplebus	
	
	---------------CORE INTERFACE SIGNALS-----------------
	--Inputs from PC to CORE
	CORE_INPUTS				: OUT std_logic_vector(C_NUM_OF_INPUTS_TO_CORE*C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	--Signal to start the core processing
	START_PROCESS			: OUT std_logic;
	--FINISHED SIGNAL FROM CORE
	FINISHED				: IN std_logic;
	--VALID SIGNAL FROM CORE TO SIGNAL VALID OUTPUT THAT NEEDS TO BE STORED INTO BRAM
	VALID					: IN std_logic;
	--BUSY SIGNAL GOING TO CORE
	BUSY					: OUT std_logic;	
	--Outputs generated from CORE to Interface
	CORE_OUTPUTS			: IN std_logic_vector(C_NUM_OF_OUTPUTS_FROM_CORE*C_SIMPBUS_AWIDTH - 1 DOWNTO 0)
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

CONSTANT SIMPBUS_ZERO : std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0) := (OTHERS => '0');
CONSTANT C_BRAM_LOG : integer := integer(ceil(log2(real(C_BRAM_SIZE))));
CONSTANT C_NUM_IOS_LOG : integer := integer(ceil(log2(real(realmax(real(C_NUM_OF_INPUTS_TO_CORE),real(C_NUM_OF_OUTPUTS_FROM_CORE))))));

TYPE states IS (
			idle, 
			--INPUT DATA TRANSFER STATE (PC 2 FPGA)
			PC2FPGA_Data_transfer_wait,
			--STORE DATA INTO BUFFERS
			prepare_data,
			--START OF PROCESSING
			start_process_state,
			--PROCESSING STATE
			process_data,
			--SENDING DATA BACK TO PC STATE
			final_dma_transfer,
			--STORE DATA INTO RAM
			store_state,
			wait_for_free_buffer,
			wait_for_buffer_to_process_state,
			--Done states
			interrupt_state,
			interrupt_err_state
			);
SIGNAL state, nstate : states := idle;

SIGNAL bramAddress 	: std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0'); --Pointer to BRAM
SIGNAL bramDataOut 	: std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0'); --Data output to bram

--DMA INTERFACING SIGNALS
SIGNAL DONE, DONE_ERR		 		: std_logic := '0';
SIGNAL START, r_start				: std_logic := '0';
SIGNAL START_ADDR, r_start_addr		: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL END_ADDR, r_end_addr			: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL START_ACK					: std_logic := '0';

TYPE buffer_type IS ARRAY (0 TO C_NUM_OF_INPUTS_TO_CORE-1) OF std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
--
SIGNAL input_buffer : buffer_type;
SIGNAL store_counter : std_logic_vector(C_NUM_IOS_LOG - 1 DOWNTO 0) := (OTHERS => '0');
SIGNAL output_store_counter : std_logic_vector(C_NUM_IOS_LOG - 1 DOWNTO 0) := (OTHERS => '0');
CONSTANT store_counter_zero : std_logic_vector(C_NUM_IOS_LOG - 1 DOWNTO 0) := (OTHERS => '0');
CONSTANT BYTE_INCR : integer := C_SIMPBUS_AWIDTH/8;
CONSTANT BYTE_INCR_USG : unsigned := to_unsigned(BYTE_INCR,C_SIMPBUS_AWIDTH);

SIGNAL core_inputs_1 : std_logic_vector(C_NUM_OF_INPUTS_TO_CORE*C_SIMPBUS_AWIDTH-1 DOWNTO 0);

--BRAM multiplexing switch
TYPE bram_switch_type IS (bram_0, bram_1);
SIGNAL bram_switch : bram_switch_type := (bram_0);

BEGIN

--BRAM enable signals
BRAM_EN_0 <= '1'; --Always enable bram_0
BRAM_EN_1 <= '1'; --Always enable bram_1
--Assign BRAM 0 and BRAM 1 output signals
BRAM_Dout_0 <= bramDataOut;
BRAM_Dout_1 <= bramDataOut;

--PC TO FPGA data transfer signals
BUF_REQD_ADDR 	<= C_BRAM_ADDR_0; --Address of BRAM or off-chip RAM
BUF_REQD_SIZE 	<= std_logic_vector((to_unsigned(C_BRAM_LOG, 5))); --Size of RAM in exponent of 2
BUF_REQD_ERR 	<= '0'; --There should be no errors. Should allow the PC to write the arguments to the BRAM

--Drive signal with registered output for dma_handler
START_ADDR 	<= r_start_addr;
END_ADDR 	<= r_end_addr;
START 		<= r_start;

--Core outputs assignments
CORE_INPUTS <= core_inputs_1;

DMA : COMPONENT dma_handler
GENERIC MAP(
	C_SIMPBUS_AWIDTH 		=> C_SIMPBUS_AWIDTH,
	C_BRAM_ADDR				=> C_BRAM_ADDR_0,	
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
	
	--Start and End addresses to transfer
	START_ADDR				=>	START_ADDR,		--IN
	END_ADDR				=>	END_ADDR,		--IN

	--Start signal	
	START					=> 	START,			--IN
		
	--Done Signal	
	DONE					=> 	DONE,			--OUT
	DONE_ERR				=> 	DONE_ERR,		--OUT
	
	--Start ack signal
	START_ACK				=> START_ACK		--OUT
);


Combinatorial : PROCESS (SYS_RST, DOORBELL, DOORBELL_ERR, BUF_REQD, INTERRUPT_ACK, DONE, DONE_ERR, state, bramAddress, store_counter, output_store_counter, VALID, FINISHED, bram_switch, START_ACK)
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
						nstate <= prepare_data; --go to state where we set up the input data to the core
					ELSE
						nstate <= idle; --reset to idle state if there is an error from host
					END IF;
				END IF;
			WHEN prepare_data =>
				--Go to next state (process_data) if bramAddress reached the beginning of the BRAM
				--or all slots of the input_buffer has been assigned
				IF (bramAddress = C_BRAM_ADDR_0 OR store_counter = store_counter_zero) THEN
					nstate <= start_process_state;
				END IF;
			WHEN start_process_state =>
				nstate <= process_data;
			WHEN process_data =>
				IF (VALID = '1') THEN
					--If the current BRAM buffer is full and the dma_handler is busy doing a dma transfer of the already full buffer
					--then go to wait_for_free_buffer state, else go to store_state.
					IF (bram_switch = bram_0) THEN
						IF (bramAddress = std_logic_vector(unsigned(C_BRAM_ADDR_0) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH) ) AND START_ACK = '1') THEN
							--Go to wait state for free buffer if current buffer is full and dma_handler
							--is still busy in transferring the full buffer
							nstate <= wait_for_free_buffer;
						ELSE
							nstate <= store_state; --Go to store_state if a free buffer is available. It is safe to increment address to next free buffer
						END IF;
					ELSE
						--Same logic as above except for alternate buffer
						IF (bramAddress = std_logic_vector(unsigned(C_BRAM_ADDR_1) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH) ) AND START_ACK = '1') THEN
							nstate <= wait_for_free_buffer;
						ELSE
							nstate <= store_state; --Go to store_state if a free buffer is available
						END IF;					
					END IF;		
				END IF;
				
				--Go to the final dma transfer state once the FINISHED signal is received
				IF (FINISHED = '1') THEN
					nstate <= final_dma_transfer;
				END IF;
			WHEN wait_for_free_buffer =>
				IF (DONE = '1') THEN
					IF(DONE_ERR = '1') THEN
						nstate <= interrupt_err_state; --Flag error if there was an error
					ELSE
						nstate <= store_state; --Resume storing data once dma transfer is complete
					END IF;
				END IF;
			WHEN wait_for_buffer_to_process_state =>
				IF (DONE = '1') THEN
					IF(DONE_ERR = '1') THEN
						nstate <= interrupt_err_state; --Flag error if there was an error
					ELSE
						nstate <= process_data; --Go back to process state when dma transfer completes
					END IF;
				END IF;				
			WHEN store_state =>
				IF (bram_switch = bram_0) THEN
					IF (bramAddress = std_logic_vector(unsigned(C_BRAM_ADDR_0) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH) - to_unsigned(BYTE_INCR, C_SIMPBUS_AWIDTH) ) AND START_ACK = '1') THEN
						IF (output_store_counter = store_counter_zero) THEN
							nstate <= wait_for_buffer_to_process_state;
						ELSE
							nstate <= wait_for_free_buffer;
						END IF;
					ELSIF (output_store_counter = store_counter_zero) THEN
						nstate <= process_data;
					END IF;
				ELSE
					IF (bramAddress = std_logic_vector(unsigned(C_BRAM_ADDR_1) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH) - to_unsigned(BYTE_INCR, C_SIMPBUS_AWIDTH) ) AND START_ACK = '1') THEN
						IF (output_store_counter = store_counter_zero) THEN
							nstate <= wait_for_buffer_to_process_state;
						ELSE
							nstate <= wait_for_free_buffer;
						END IF;
					ELSIF (output_store_counter = store_counter_zero) THEN
						nstate <= process_data;							
					END IF;						
				END IF;
			WHEN final_dma_transfer =>
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

AssignCombinatorialOutputs : PROCESS (state, input_buffer, output_store_counter, CORE_OUTPUTS, bram_switch, bramAddress)
VARIABLE s : integer;
BEGIN
	
	--Write enable BRAM when waiting for PC to transfer
	--data to FPGA or when in the store state to store
	--data into the RAM
	IF (state = store_state) THEN
		IF (bram_switch = bram_0) THEN
			BRAM_WEN_0 <= (OTHERS => '1');
			BRAM_WEN_1 <= (OTHERS => '0');
		ELSE
			BRAM_WEN_0 <= (OTHERS => '0');
			BRAM_WEN_1 <= (OTHERS => '1');
		END IF;
	ELSE
		BRAM_WEN_0 <= (OTHERS => '0');
		BRAM_WEN_1 <= (OTHERS => '0');
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

	
	--CORE INPUT ASSIGNMENTS
	FOR i IN input_buffer'RANGE LOOP
		core_inputs_1(((i+1)*C_SIMPBUS_AWIDTH-1) DOWNTO (((i+1)*C_SIMPBUS_AWIDTH-1)-C_SIMPBUS_AWIDTH + 1)) <= input_buffer(i);
	END LOOP;
	
	--Process start assignments
	IF (state = start_process_state) THEN
		START_PROCESS <= '1';
	ELSE
		START_PROCESS <= '0';
	END IF;
	
	--The BUSY signal will only be high when all the buffers are full and
	--the core has to stop outputting data until one of the buffers is empty.
	--BUSY signal is also high when storing data into the RAM
	IF (state = wait_for_free_buffer OR state = store_state OR state = wait_for_buffer_to_process_state) THEN
		BUSY <= '1';
	ELSE
		BUSY <= '0';
	END IF;

	s := to_integer(unsigned(output_store_counter));
	bramDataOut <= CORE_OUTPUTS(((s+1)*C_SIMPBUS_AWIDTH-1) DOWNTO (((s+1)*C_SIMPBUS_AWIDTH-1)-C_SIMPBUS_AWIDTH + 1));
	
	--BRAM Address signal assignments
	IF (bram_switch = bram_0) THEN
		BRAM_Addr_0 <= bramAddress;
		BRAM_Addr_1 <= C_BRAM_ADDR_1;
	ELSE
		BRAM_Addr_0 <= C_BRAM_ADDR_0;
		BRAM_Addr_1 <= bramAddress;
	END IF;
	
END PROCESS;

State_Assignment : PROCESS
BEGIN
WAIT UNTIL rising_edge(SYS_CLK);
	IF(SYS_RST = '1') THEN --Synchronous reset signal
		state <= idle;
--		bramDataOut <= (OTHERS => '0');
		bramAddress <= C_BRAM_ADDR_0;
		r_start_addr <= (OTHERS => '0');
		r_end_addr	<= (OTHERS => '0');
		r_start <= '0';
		FOR i IN input_buffer'RANGE LOOP
			input_buffer(i) <= (OTHERS => '0');
		END LOOP;
		store_counter <= (OTHERS => '0');
		output_store_counter <= (OTHERS => '0');
		bram_switch <= bram_0; --initialise the bram_switch to bram_0 always.
	ELSE
		state <= nstate; -- assign the state to next state
		
		IF (DOORBELL = '1' AND DOORBELL_ERR = '0' AND DOORBELL_LEN /= SIMPBUS_ZERO) THEN
			 --Increment the pointer with however many bits were transferred
			store_counter <= std_logic_vector(to_unsigned(C_NUM_OF_INPUTS_TO_CORE-1,C_NUM_IOS_LOG));
			--Increment bramAddress with however many bytes were transferred since BRAM is byte addressible
			bramAddress <= std_logic_vector(resize(unsigned(C_BRAM_ADDR_0) + unsigned(DOORBELL_LEN) - BYTE_INCR_USG, C_SIMPBUS_AWIDTH));
		END IF;
		
		IF (state = prepare_data) THEN
			--Set the input_buffer for every input to the core.
			--Uses store_counter as a sort of counter to iterate
			--through the input_buffer.
			input_buffer(to_integer(unsigned(store_counter))) <= BRAM_Din_0;
			
			--Decrement bramAddress
			IF (bramAddress /= C_BRAM_ADDR_0) THEN
				--Decrement bramAddress by clamping it to C_BRAM_ADDR_0 if necessary
				bramAddress <= std_logic_vector(unsigned(bramAddress) - BYTE_INCR);
			END IF;
			
			--Decrement store_counter
			IF (store_counter /= store_counter_zero) THEN
				store_counter <= std_logic_vector(unsigned(store_counter) - 1);
			END IF;
		END IF;
		
--#TODO: Needs changing from here for double buffering--		
		
		--If state is in the final_dma_transfer then initiate the final_dma_transfer upto
		--the point where the data has been stored. If the contents of bram needs 
		--to be sent back to the PC because its full then do the dma transfer of
		--the whole bram.
		IF (state = final_dma_transfer) THEN
			IF (bram_switch = bram_0) THEN
				r_start_addr <= C_BRAM_ADDR_0;
			ELSE
				r_start_addr <= C_BRAM_ADDR_1;
			END IF;
			
			r_end_addr <= bramAddress;
			
			IF (START_ACK = '1') THEN
				r_start <= '0'; --assert start signal low once START_ACK received
			ELSE
				r_start <= '1'; --else keep it high
			END IF;
			
			IF (DONE = '1') THEN
				bramAddress <= C_BRAM_ADDR_0; --Initialise bramAddress to point to the first bram
				bram_switch <= bram_0; --Change the switch back to bram_0 as well
			END IF;
		END IF;
		
		--Handle dma transfer when one of the buffer is full
		IF (state = wait_for_free_buffer OR state = wait_for_buffer_to_process_state) THEN
			IF (START_ACK = '1') THEN
				r_start <= '0'; --assert start signal low once START_ACK received
			ELSE
				r_start <= '1'; --else keep it high
			END IF;

			IF (DONE = '1') THEN
			--If buffer is free initiate another dma transfer
			--of the buffer that is now full.
				r_start <= '1';			
				IF (bram_switch = bram_0) THEN
					bramAddress <= C_BRAM_ADDR_1; --Switch to bram_1
					bram_switch <= bram_1; --Change the switch to bram_1 as well
					r_start_addr <= C_BRAM_ADDR_0;
					r_end_addr <= std_logic_vector(unsigned(C_BRAM_ADDR_0) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH));						
				ELSE
					bramAddress <= C_BRAM_ADDR_0;
					bram_switch <= bram_0;
					r_start_addr <= C_BRAM_ADDR_1;
					r_end_addr <= std_logic_vector(unsigned(C_BRAM_ADDR_1) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH));					
				END IF;
			END IF;			
		END IF;
		
		--The other case when dma transfer is happening parallely
		IF (r_start = '1') THEN
			IF (START_ACK = '1') THEN
				r_start <= '0'; --assert start signal low once START_ACK received
			ELSE
				r_start <= '1'; --else keep it high
			END IF;			
		END IF;
		
		--Reset the store_counter to C_NUM_OF_OUTPUTS_FROM_CORE before going to store_state
		--Only reset the counter if transitioning from process_data state to store_state
		--OR process_data state to wait_for_free_buffer state
		IF (state = process_data AND nstate = store_state) OR (state = process_data AND nstate = wait_for_free_buffer) THEN
			output_store_counter <= std_logic_vector(to_unsigned(C_NUM_OF_OUTPUTS_FROM_CORE-1,C_NUM_IOS_LOG));
		END IF;
		
		--If in the store state, decrement the store_counter and store the incoming data
		--Also increment the BRAM address
		IF (state = store_state) THEN
			--Decrement store_counter
			IF (output_store_counter /= store_counter_zero) THEN
				output_store_counter <= std_logic_vector(unsigned(output_store_counter) - 1);
			END IF;

			--Increment bramAddress, switch to free buffer if needed
			IF (bram_switch = bram_0) THEN
				--If first bram is full switch to next 
				IF (bramAddress = std_logic_vector(unsigned(C_BRAM_ADDR_0) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH) - to_unsigned(BYTE_INCR, C_SIMPBUS_AWIDTH) ) ) THEN
					IF (START_ACK = '0') THEN
						bramAddress <= C_BRAM_ADDR_1;
						bram_switch <= bram_1;
						r_start <= '1';
						r_start_addr <= C_BRAM_ADDR_0;
						r_end_addr <= std_logic_vector(unsigned(C_BRAM_ADDR_0) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH));
					END IF;
				ELSE
					bramAddress <= std_logic_vector(unsigned(bramAddress) + BYTE_INCR);
				END IF;
			ELSE
				IF (bramAddress = std_logic_vector(unsigned(C_BRAM_ADDR_1) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH) - to_unsigned(BYTE_INCR, C_SIMPBUS_AWIDTH) ) ) THEN			
					IF (START_ACK = '0') THEN					
						bramAddress <= C_BRAM_ADDR_0;
						bram_switch <= bram_0;
						r_start <= '1';
						r_start_addr <= C_BRAM_ADDR_1;
						r_end_addr <= std_logic_vector(unsigned(C_BRAM_ADDR_1) + to_unsigned(C_BRAM_SIZE, C_SIMPBUS_AWIDTH));
					END IF;
				ELSE
					bramAddress <= std_logic_vector(unsigned(bramAddress) + BYTE_INCR);
				END IF;				
			END IF;
		END IF;
		
	END IF;

END PROCESS State_Assignment;


END ARCHITECTURE synth;
