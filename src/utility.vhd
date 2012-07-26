LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.All;
USE work.project_pak.ALL;

PACKAGE utility IS
	--Simulates sending of data from PC to FPGA
	PROCEDURE send_data(
				SIGNAL clk 				: IN std_logic;
				SIGNAL BUF_REQD 		: OUT std_logic;
				SIGNAL BUF_REQD_RDY		: IN std_logic
	);
	
	--Simulates doorbell send with doorbell length set to 
	--bytes_transferred number of bytes.
	PROCEDURE send_doorbell(
				SIGNAL clk 					: IN std_logic;
				SIGNAL DOORBELL 			: OUT std_logic;
				SIGNAL DOORBELL_LEN 		: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				CONSTANT bytes_transferred	: integer
	);
	
	--Procedure used to handle the dma without any error
	--i.e. the DMA_ERR signal will be kept low at the end
	--of successfull dma transfer. Alternatively the DMA_ERR
	--signal can be kept high at the end by using the
	--handle_dma_with_err function.
	PROCEDURE handle_dma_normal(
				SIGNAL BUF_REQ 		: IN std_logic;
				SIGNAL clk			: IN std_logic;
				SIGNAL BUF_REQ_ACK 	: OUT std_logic;
				SIGNAL BUF_REQ_SIZE	: OUT std_logic_vector(4 DOWNTO 0);
				SIGNAL BUF_REQ_ADDR : OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				SIGNAL BUF_REQ_RDY	: OUT std_logic;
				SIGNAl DMA_REQ		: IN std_logic;
				SIGNAL DMA_REQ_ACK	: OUT std_logic;
				SIGNAL DMA_ERR		: OUT std_logic;
				SIGNAL DMA_DONE		: OUT std_logic;
				CONSTANT buf_size	: integer
	);
	
	--Procedure used to handle dma transfer but with an error
	--at the end i.e. DMA_ERR will be kept high along with
	--DMA_DONE at the end of a dma transfer.
	PROCEDURE handle_dma_with_err(
				SIGNAL BUF_REQ 		: IN std_logic;
				SIGNAL clk			: IN std_logic;
				SIGNAL BUF_REQ_ACK 	: OUT std_logic;
				SIGNAL BUF_REQ_SIZE	: OUT std_logic_vector(4 DOWNTO 0);
				SIGNAL BUF_REQ_ADDR : OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				SIGNAL BUF_REQ_RDY	: OUT std_logic;
				SIGNAl DMA_REQ		: IN std_logic;
				SIGNAL DMA_REQ_ACK	: OUT std_logic;
				SIGNAL DMA_ERR		: OUT std_logic;
				SIGNAL DMA_DONE		: OUT std_logic
	);	

	
	PROCEDURE handle_dma(
				SIGNAL BUF_REQ 		: IN std_logic;
				SIGNAL clk			: IN std_logic;
				SIGNAL BUF_REQ_ACK 	: OUT std_logic;
				SIGNAL BUF_REQ_SIZE	: OUT std_logic_vector(4 DOWNTO 0);
				SIGNAL BUF_REQ_ADDR : OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				SIGNAL BUF_REQ_RDY	: OUT std_logic;
				SIGNAl DMA_REQ		: IN std_logic;
				SIGNAL DMA_REQ_ACK	: OUT std_logic;
				SIGNAL DMA_ERR		: OUT std_logic;
				SIGNAL DMA_DONE		: OUT std_logic
	);	
	
	PROCEDURE flag_dma_done (
				SIGNAL clk 		: IN std_logic;
				SIGNAL DMA_DONE : OUT std_logic;
				SIGNAL DMA_ERR	: OUT std_logic
	);	
	
	PROCEDURE flag_dma_done_with_err(
				SIGNAL clk 		: IN std_logic;
				SIGNAL DMA_DONE : OUT std_logic;
				SIGNAL DMA_ERR	: OUT std_logic
	);	
END PACKAGE utility;


--PACKAGE BODY CONTAINS IMPLEMENTATION OF FUNCTIONS AND PROCEDURES
--The package body contains functions that aren't listed in the package
--definition. These functions are used internally for testing purposes.
PACKAGE BODY utility IS

	PROCEDURE send_data(
				SIGNAL clk 				: IN std_logic;
				--BUF_REQD is set high if the PC wants to send data to the FPGA
				SIGNAL BUF_REQD 		: OUT std_logic;
				--Once the FPGA responds with a location allocated the BUF_REQD_RDY
				--signal will be flaged high.
				SIGNAL BUF_REQD_RDY		: IN std_logic
	)IS			
	VARIABLE counter : integer := 0;
	
	 --According to RIFFA software specifications, the driver will wait
	 --until 32 clock cycles after which it will return an error that the
	 --dma_transfer failed. This 32 cycle wait is until the BUF_REQD_RDY signal
	 --is received by the PC.
	CONSTANT limit	: integer := 32;
	BEGIN
		BUF_REQD <= '1';
		--Loop and increment counter until the BUF_REQD_RDY signal
		--is received from the FPGA. Report failure if cycle wait
		--exceeds limit number of cycles.
		WHILE BUF_REQD_RDY /= '1' LOOP
			WAIT UNTIL rising_edge(clk);
			counter := counter + 1;
			IF (counter > limit) THEN
				REPORT "counter = "&integer'image(counter)&" has reached maximum limit of "&integer'image(limit)&" cycles" SEVERITY failure;
			END IF;
		END LOOP;

		BUF_REQD <= '0';	
	END;
	
	--1) Wait a clock cycle
	--2) Flag doorbell signal high with doorbell_len set to bytes_transferred
	--3) Wait a clock cycle
	--4) Drive doorbell signal low.
	PROCEDURE send_doorbell(
				SIGNAL clk 					: IN std_logic;
				SIGNAL DOORBELL 			: OUT std_logic;
				SIGNAL DOORBELL_LEN 		: OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				CONSTANT bytes_transferred	: integer
	) IS
	
	BEGIN
	
		WAIT UNTIL rising_edge(clk);
		DOORBELL <= '1';
		DOORBELL_LEN <= std_logic_vector(to_unsigned(bytes_transferred,C_SIMPBUS_AWIDTH));

		WAIT UNTIL rising_edge(clk);
		DOORBELL <= '0';
		DOORBELL_LEN <= (OTHERS => '0');

	END;

	--
	PROCEDURE handle_dma_normal(
				SIGNAL BUF_REQ 		: IN std_logic;
				SIGNAL clk			: IN std_logic;
				SIGNAL BUF_REQ_ACK 	: OUT std_logic;
				SIGNAL BUF_REQ_SIZE	: OUT std_logic_vector(4 DOWNTO 0);
				SIGNAL BUF_REQ_ADDR : OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				SIGNAL BUF_REQ_RDY	: OUT std_logic;
				SIGNAl DMA_REQ		: IN std_logic;
				SIGNAL DMA_REQ_ACK	: OUT std_logic;
				SIGNAL DMA_ERR		: OUT std_logic;
				SIGNAL DMA_DONE		: OUT std_logic;
				CONSTANT buf_size	: integer
	) IS

	BEGIN
		WAIT UNTIL rising_edge(BUF_REQ);
		WAIT UNTIL rising_edge(clk);
		BUF_REQ_ACK <= '1';

		BUF_REQ_SIZE 	<= std_logic_vector(to_unsigned(buf_size, 5));
		BUF_REQ_ADDR(3) <= '1'; --(3 => '1', OTHERS => '0'); 

		WAIT UNTIL rising_edge(clk);
		BUF_REQ_ACK <= '0';
		BUF_REQ_RDY <= '1';

		WAIT UNTIL rising_edge(DMA_REQ);
		DMA_REQ_ACK <= '1';

		WAIT UNTIL rising_edge(clk);
		DMA_REQ_ACK <= '0';
					
		DMA_ERR 	<= '0';
		DMA_DONE 	<= '1';
			
		WAIT UNTIL rising_edge(clk);

		DMA_DONE <= '0';
	END;
	
	PROCEDURE handle_dma_with_err(
				SIGNAL BUF_REQ 		: IN std_logic;
				SIGNAL clk			: IN std_logic;
				SIGNAL BUF_REQ_ACK 	: OUT std_logic;
				SIGNAL BUF_REQ_SIZE	: OUT std_logic_vector(4 DOWNTO 0);
				SIGNAL BUF_REQ_ADDR : OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				SIGNAL BUF_REQ_RDY	: OUT std_logic;
				SIGNAl DMA_REQ		: IN std_logic;
				SIGNAL DMA_REQ_ACK	: OUT std_logic;
				SIGNAL DMA_ERR		: OUT std_logic;
				SIGNAL DMA_DONE		: OUT std_logic
	) IS

	BEGIN
		WAIT UNTIL rising_edge(BUF_REQ);
		WAIT UNTIL rising_edge(clk);
		BUF_REQ_ACK <= '1';

		BUF_REQ_SIZE 	<= std_logic_vector(to_unsigned(11, 5));
		BUF_REQ_ADDR(3) <= '1'; --(3 => '1', OTHERS => '0'); 

		WAIT UNTIL rising_edge(clk);
		BUF_REQ_ACK <= '0';
		BUF_REQ_RDY <= '1';

		WAIT UNTIL rising_edge(DMA_REQ);
		DMA_REQ_ACK <= '1';

		WAIT UNTIL rising_edge(clk);
		DMA_REQ_ACK <= '0';
					
		DMA_ERR 	<= '1';
		DMA_DONE 	<= '1';
			
		WAIT UNTIL rising_edge(clk);

		DMA_DONE <= '0';
		DMA_ERR <= '0';
	END;	
	
	PROCEDURE handle_dma(
				SIGNAL BUF_REQ 		: IN std_logic;
				SIGNAL clk			: IN std_logic;
				SIGNAL BUF_REQ_ACK 	: OUT std_logic;
				SIGNAL BUF_REQ_SIZE	: OUT std_logic_vector(4 DOWNTO 0);
				SIGNAL BUF_REQ_ADDR : OUT std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0);
				SIGNAL BUF_REQ_RDY	: OUT std_logic;
				SIGNAl DMA_REQ		: IN std_logic;
				SIGNAL DMA_REQ_ACK	: OUT std_logic;
				SIGNAL DMA_ERR		: OUT std_logic;
				SIGNAL DMA_DONE		: OUT std_logic
	) IS
	
	BEGIN
		WAIT UNTIL rising_edge(BUF_REQ);
		WAIT UNTIL rising_edge(clk);
		BUF_REQ_ACK <= '1';

		BUF_REQ_SIZE 	<= std_logic_vector(to_unsigned(11, 5));
		BUF_REQ_ADDR(3) <= '1'; --(3 => '1', OTHERS => '0'); 

		WAIT UNTIL rising_edge(clk);
		BUF_REQ_ACK <= '0';
		BUF_REQ_RDY <= '1';

		WAIT UNTIL rising_edge(DMA_REQ);
		DMA_REQ_ACK <= '1';

		WAIT UNTIL rising_edge(clk);
		DMA_REQ_ACK <= '0';
	END;
	
	PROCEDURE flag_dma_done (
				SIGNAL clk 		: IN std_logic;
				SIGNAL DMA_DONE : OUT std_logic;
				SIGNAL DMA_ERR	: OUT std_logic
	) IS
	
	BEGIN
		
		DMA_ERR 	<= '0';
		DMA_DONE 	<= '1';
			
		WAIT UNTIL rising_edge(clk);

		DMA_DONE <= '0';			
	END;
	
	PROCEDURE flag_dma_done_with_err(
				SIGNAL clk 		: IN std_logic;
				SIGNAL DMA_DONE : OUT std_logic;
				SIGNAL DMA_ERR	: OUT std_logic
	) IS
	
	BEGIN
		DMA_ERR 	<= '1';
		DMA_DONE 	<= '1';
			
		WAIT UNTIL rising_edge(clk);

		DMA_DONE <= '0';
		DMA_ERR <= '0';
	END;		
	
END utility;
