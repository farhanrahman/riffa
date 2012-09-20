------------------------------------------------------------------------------
--	Copyright (c) 2012, Matthew Jacobsen, Imperial College London
--	All rights reserved.
--	
--	Redistribution and use in source and binary forms, with or without
--	modification, are permitted provided that the following conditions are met: 
--	
--	1. Redistributions of source code must retain the above copyright notice, this
--	   list of conditions and the following disclaimer. 
--	2. Redistributions in binary form must reproduce the above copyright notice,
--	   this list of conditions and the following disclaimer in the documentation
--	   and/or other materials provided with the distribution. 
--	
--	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
--	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--	The views and conclusions contained in the software and documentation are those
--	of the authors and should not be interpreted as representing official policies, 
--	either expressed or implied, of the FreeBSD Project.
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Filename:			riffa.vhd
-- Version:				1.00.a
-- VHDL Standard:		VHDL'93
-- Description:			Top level core design, instantiates riffa_impl
--						and passes all signals through.
-- History:				@mattj: Initial pre-release. Version 0.9.
--						@farhanrahman: Updated code for multiple dma transfers and double
--										buffering. Version 0.9.1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
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

ENTITY riffa IS
  generic
  (
	C_SIMPBUS_AWIDTH			: integer							:= 32;
	C_BRAM_ADDR_0				: std_logic_vector					:= X"00000000";
	C_BRAM_ADDR_1				: std_logic_vector					:= X"00000000";
	C_BRAM_SIZE					: integer							:= 32768;
	C_USE_DOORBELL_RESET		: boolean							:= true;
	C_NUM_OF_INPUTS_TO_CORE 	: integer 							:= 2;
	C_NUM_OF_OUTPUTS_FROM_CORE  : integer 							:= 1;
	DOORBELL_ARGUMENT_ZERO_VAL	: std_logic_vector(31 DOWNTO 0) 	:= (OTHERS => '1'); 
	DOORBELL_ARGUMENT_ONE_VAL	: std_logic_vector(31 DOWNTO 0) 	:= (OTHERS => '1')	
  );
  port
  (
	SYS_CLK						: in std_logic;
	SYS_RST						: in std_logic;

	INTERRUPT					: out std_logic;
	INTERRUPT_ERR				: out std_logic;
	INTERRUPT_ACK				: in std_logic;
	DOORBELL					: in std_logic;
	DOORBELL_ERR				: in std_logic;
	DOORBELL_LEN				: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG				: in std_logic_vector(31 downto 0);
	DMA_REQ						: out std_logic;
	DMA_REQ_ACK					: in std_logic;
	DMA_SRC						: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST						: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN						: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG						: out std_logic;
	DMA_DONE					: in std_logic;
	DMA_ERR						: in std_logic;
	BUF_REQ						: out std_logic;
	BUF_REQ_ACK					: in std_logic;
	BUF_REQ_ADDR				: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE				: in std_logic_vector(4 downto 0);
	BUF_REQ_RDY					: in std_logic;
	BUF_REQ_ERR					: in std_logic;
	BUF_REQD					: in std_logic;
	BUF_REQD_ADDR				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE				: out std_logic_vector(4 downto 0);
	BUF_REQD_RDY				: out std_logic;
	BUF_REQD_ERR				: out std_logic;

	BRAM_Clk_0					: out std_logic;
	BRAM_Rst_0					: out std_logic;
	BRAM_EN_0					: out std_logic;
	BRAM_WEN_0					: out std_logic_vector(0 to 3);
	BRAM_Dout_0					: out std_logic_vector(0 to 31);
	BRAM_Din_0					: in std_logic_vector(0 to 31);
	BRAM_Addr_0					: out std_logic_vector(0 to 31);
	
	BRAM_Clk_1					: out std_logic;
	BRAM_Rst_1					: out std_logic;	
	BRAM_EN_1					: out std_logic;
	BRAM_WEN_1					: out std_logic_vector(0 to 3);
	BRAM_Dout_1					: out std_logic_vector(0 to 31);
	BRAM_Din_1					: in std_logic_vector(0 to 31); 
	BRAM_Addr_1					: out std_logic_vector(0 to 31) 			
  );

  attribute SIGIS : string;
  attribute SIGIS of SYS_CLK     		: signal is "CLK";
  attribute SIGIS of SYS_RST      		: signal is "RST";
  attribute SIGIS of BRAM_Clk_0      	: signal is "CLK";
  attribute SIGIS of BRAM_Rst_0      	: signal is "RST";
  attribute SIGIS of BRAM_Clk_1      	: signal is "CLK";
  attribute SIGIS of BRAM_Rst_1      	: signal is "RST"; 
  
END ENTITY riffa;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

ARCHITECTURE IMP OF riffa IS
  
  ------------------------------------------
  -- Component declaration for top_connector
  ------------------------------------------
	COMPONENT top_connector IS
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
	END COMPONENT top_connector;
BEGIN
  ------------------------------------------
  -- instantiate top_connector
  ------------------------------------------
	TOP_CONNECTOR_I : COMPONENT top_connector
	GENERIC MAP
	(
		C_SIMPBUS_AWIDTH				=> C_SIMPBUS_AWIDTH,
		C_BRAM_ADDR_0					=> C_BRAM_ADDR_0,
		C_BRAM_ADDR_1					=> C_BRAM_ADDR_1,
		C_BRAM_SIZE						=> C_BRAM_SIZE,
		C_USE_DOORBELL_RESET		    => C_USE_DOORBELL_RESET,		
		C_NUM_OF_INPUTS_TO_CORE 	    => C_NUM_OF_INPUTS_TO_CORE, 	
		C_NUM_OF_OUTPUTS_FROM_CORE      => C_NUM_OF_OUTPUTS_FROM_CORE,  
		ARGUMENT_ZERO_VAL			    => DOORBELL_ARGUMENT_ZERO_VAL,			
		ARGUMENT_ONE_VAL				=> DOORBELL_ARGUMENT_ONE_VAL				
	)
	PORT MAP
	(
		SYS_CLK					=> SYS_CLK,
		SYS_RST					=> SYS_RST,
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
		BRAM_Addr_1				=> BRAM_Addr_1		
	);

	BRAM_Clk_0 <= SYS_CLK;
	BRAM_Rst_0 <= SYS_RST;
	BRAM_Clk_1 <= SYS_CLK;
	BRAM_Rst_1 <= SYS_RST;
END IMP;
