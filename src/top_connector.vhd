------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


-- Module will contain the riffa_interface and an ipcore of the user.
ENTITY top_connector IS
		GENERIC
		(
			C_SIMPBUS_AWIDTH			: integer							:= 32;
			C_BRAM_ADDR_0				: std_logic_vector					:= X"00000000";
			C_BRAM_ADDR_1				: std_logic_vector					:= X"00000000";
			C_BRAM_SIZE					: integer							:= 32768;
			C_USE_DOORBELL_RESET		: boolean							:= true;
			C_NUM_OF_INPUTS_TO_CORE 	: integer 							:= 2;
			C_NUM_OF_OUTPUTS_FROM_CORE  : integer 							:= 1;
			ARGUMENT_ZERO_VAL			: std_logic_vector(31 DOWNTO 0) 	:= (OTHERS => '1'); 
			ARGUMENT_ONE_VAL			: std_logic_vector(31 DOWNTO 0) 	:= (OTHERS => '1')
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
			BRAM_Dout_1				: OUT std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);
			BRAM_Din_1				: IN std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0); 
			BRAM_Addr_1				: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) 		
		);
END ENTITY top_connector;


ARCHITECTURE synth OF top_connector IS

	COMPONENT riffa_interface IS
		GENERIC
		(
			C_SIMPBUS_AWIDTH 			: integer;
			C_BRAM_ADDR_0				: std_logic_vector(31 DOWNTO 0);
			C_BRAM_ADDR_1				: std_logic_vector(31 DOWNTO 0);
			C_BRAM_SIZE					: integer;
			C_NUM_OF_INPUTS_TO_CORE		: integer;
			C_NUM_OF_OUTPUTS_FROM_CORE	: integer
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
			BRAM_EN_0				: OUT std_logic;
			BRAM_WEN_0				: OUT std_logic_vector(3 DOWNTO 0);
			BRAM_Dout_0				: OUT std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);
			BRAM_Din_0				: IN std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);  
			BRAM_Addr_0				: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0); 
			
			--BRAM 1 SIGNALS--
			BRAM_EN_1				: OUT std_logic;
			BRAM_WEN_1				: OUT std_logic_vector(3 DOWNTO 0);
			BRAM_Dout_1				: OUT std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);
			BRAM_Din_1				: IN std_logic_vector(C_SIMPBUS_AWIDTH -1  DOWNTO 0);  
			BRAM_Addr_1				: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0); 			
			
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
	END COMPONENT riffa_interface;
	
	--DOORBELL_RESET component declaration
	COMPONENT doorbell_reset IS
		GENERIC(
			ARGUMENT_ZERO_VAL 	: std_logic_vector(31 DOWNTO 0);
			ARGUMENT_ONE_VAL 	: std_logic_vector(31 DOWNTO 0)
		);
		PORT(
			SYS_CLK			: IN std_logic;
			SYS_RST			: IN std_logic;
			RESET			: OUT std_logic;
			DOORBELL		: IN std_logic;
			DOORBELL_ARG	: IN std_logic_vector(31 DOWNTO 0);
			DOORBELL_ERR	: IN std_logic
		);
	END COMPONENT doorbell_reset;
	
----------------DECLARE YOUR CORE AS A COMPONENT HERE--------------------
	COMPONENT test_core IS
		GENERIC(
			C_SIMPBUS_AWIDTH 	: integer := 32
		);
		PORT(
			SYS_CLK			: IN std_logic;
			SYS_RST 		: IN std_logic;
		
			--INPUT SIGNALS
			INPUT_1 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
			INPUT_2 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
			INPUT_3 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
			INPUT_4 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
		
			OUTPUT			: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
			
			--VALID SIGNAL FOR VALID OUTPUT
			VALID			: OUT std_logic;
			
			--START SIGNAL TO START PROCESSING
			START			: IN std_logic;
			
			--RUN TIME OF THE CORE
			RUNTIME 		: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
			
			--FINISHED SIGNAL
			FINISHED 		: OUT std_logic;
			
			--BUSY TO SIGNAL THE CORE TO PAUSE THE PROCESSING
			BUSY			: IN std_logic;
			
			--OUTPUT_CYCLE: Determines after how many cycles the output will be valid
			OUTPUT_CYCLE 	: IN std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0)
		);	
	END COMPONENT test_core;
---------------COMPONENT DECLARATION END----------------------------------

	
	SIGNAL CORE_INPUTS : std_logic_vector(C_NUM_OF_INPUTS_TO_CORE*C_SIMPBUS_AWIDTH-1 DOWNTO 0); --Inputs to the core organised in a contigous std_logic_vector
	
	TYPE buffer_type IS ARRAY (natural RANGE <>) OF std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0); --Buffer type (array of std_logic_vectors) array size = C_NUM_OF_INPUTS_TO_CORE

	SIGNAL input_buffer 	: buffer_type(0 TO C_NUM_OF_INPUTS_TO_CORE-1);
	SIGNAL output_buffer 	: buffer_type(0 TO C_NUM_OF_OUTPUTS_FROM_CORE - 1);
	
	--Valid signal from core to signal that the output is ready to be stored in the RAM
	SIGNAL VALID : std_logic := '0';
	
	--FINISHED signal: flagged high when processing has finished
	SIGNAL FINISHED : std_logic := '0';
	
	--BUSY SIGNAL FROM INTERFACE TO CORE
	SIGNAL BUSY	: std_logic := '0';
	
	--START signal from interface to core to start processing
	SIGNAL START : std_logic := '0';
	
	SIGNAL CORE_OUTPUTS		: std_logic_vector(C_NUM_OF_OUTPUTS_FROM_CORE*C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0');
	
	--DOORBELL RESET SIGNALS--
	SIGNAL RESET : std_logic := '0';

BEGIN

	--riffa_interface instantiation. The riffa_interface handles the data transfer
	--between the PC and FPGA and vice versa.
	RIFFA_INTERFACE_I : COMPONENT riffa_interface
	GENERIC MAP
	(
		C_SIMPBUS_AWIDTH			=> C_SIMPBUS_AWIDTH,
		C_BRAM_ADDR_0				=> C_BRAM_ADDR_0,
		C_BRAM_ADDR_1				=> C_BRAM_ADDR_1,
		C_BRAM_SIZE					=> C_BRAM_SIZE,
		C_NUM_OF_INPUTS_TO_CORE 	=> C_NUM_OF_INPUTS_TO_CORE,
		C_NUM_OF_OUTPUTS_FROM_CORE 	=> C_NUM_OF_OUTPUTS_FROM_CORE
	)
	PORT MAP
	(
		SYS_CLK					=> SYS_CLK,
		SYS_RST					=> RESET,
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
		BRAM_EN_0				=> BRAM_EN_0,
		BRAM_WEN_0				=> BRAM_WEN_0,
		BRAM_Dout_0				=> BRAM_Dout_0,
		BRAM_Din_0				=> BRAM_Din_0,
		BRAM_Addr_0				=> BRAM_Addr_0,
		BRAM_EN_1				=> BRAM_EN_1,
		BRAM_WEN_1				=> BRAM_WEN_1,
		BRAM_Dout_1				=> BRAM_Dout_1,
		BRAM_Din_1				=> BRAM_Din_1,
		BRAM_Addr_1				=> BRAM_Addr_1,
		CORE_INPUTS				=> CORE_INPUTS,
		START_PROCESS			=> START,
		FINISHED				=> FINISHED,
		VALID					=> VALID,
		BUSY					=> BUSY,
		CORE_OUTPUTS			=> CORE_OUTPUTS
		
	);

	--Assign the input buffers from the outputs of riffa_interface
	Input_Buff_Assign : FOR i IN input_buffer'RANGE GENERATE
		input_buffer(i) <= CORE_INPUTS(((i+1)*C_SIMPBUS_AWIDTH-1) DOWNTO (((i+1)*C_SIMPBUS_AWIDTH-1)-C_SIMPBUS_AWIDTH + 1));
	END GENERATE;
	
	--Assign output_buffer from core to riffa_interface
	Output_Buff_Assignment : FOR i IN output_buffer'RANGE GENERATE
		CORE_OUTPUTS(((i+1)*C_SIMPBUS_AWIDTH-1) DOWNTO (((i+1)*C_SIMPBUS_AWIDTH-1)-C_SIMPBUS_AWIDTH + 1)) <= output_buffer(i);
	END GENERATE;	
	
	--Instantiation of DOORBELL_RESET if user wants to use doorbell_reset in design
	RST_ASSIGN : BLOCK
	BEGIN
		DR_INSTANTIATION : IF (C_USE_DOORBELL_RESET = true) GENERATE
			DR : COMPONENT doorbell_reset
				GENERIC MAP(
					ARGUMENT_ZERO_VAL 	=>	ARGUMENT_ZERO_VAL, 				
					ARGUMENT_ONE_VAL 	=>	ARGUMENT_ONE_VAL 				
				)
				PORT MAP(
					SYS_CLK			=> SYS_CLK,			
					SYS_RST			=> SYS_RST,			
					RESET			=> RESET,			
					DOORBELL		=> DOORBELL,		
					DOORBELL_ARG	=> DOORBELL_ARG,	
					DOORBELL_ERR	=> DOORBELL_ERR				
				);
		END GENERATE;
		
		DEFAULT_RST_ASSIGN : IF (C_USE_DOORBELL_RESET = false) GENERATE
			RESET <= SYS_RST;
		END GENERATE;
	END BLOCK RST_ASSIGN;
	
----------INSTANTIATE AND CONNECT YOUR CORE HERE. DECLARE IT AS A COMPONENT----------
	TEST_CORE_1 : COMPONENT test_core
		GENERIC MAP(
			C_SIMPBUS_AWIDTH 	=> C_SIMPBUS_AWIDTH
		)
		PORT MAP(
			SYS_CLK				=> SYS_CLK,
			SYS_RST 			=> RESET,
			INPUT_1 			=> input_buffer(0),
			INPUT_2 			=> input_buffer(1),
			INPUT_3 			=> input_buffer(0),
			INPUT_4 			=> input_buffer(1),
			OUTPUT				=> output_buffer(0),
			VALID				=> VALID,
			START				=> START,
			RUNTIME				=> input_buffer(0),
			FINISHED			=> FINISHED,
			BUSY				=> BUSY,
			OUTPUT_CYCLE		=> input_buffer(1)
		);
		--output_buffer(1) <= output_buffer(0);
		--output_buffer(2) <= output_buffer(0);
		--output_buffer(3) <= output_buffer(0);
		--output_buffer(4) <= output_buffer(0);
END ARCHITECTURE synth;
