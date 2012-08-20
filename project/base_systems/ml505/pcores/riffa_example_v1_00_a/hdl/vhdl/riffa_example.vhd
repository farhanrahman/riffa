------------------------------------------------------------------------------
--	Copyright (c) 2012, Matthew Jacobsen
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
-- Filename:			riffa_example.vhd
-- Version:				1.00.a
-- VHDL Standard:		VHDL'93
-- Description:			Top level core design, instantiates riffa_example_impl
--						and passes all signals through.
-- History:				@mattj: Initial pre-release. Version 0.9.
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

entity riffa_example is
  generic
  (
	C_SIMPBUS_AWIDTH			: integer					:= 32;
	C_BRAM_ADDR					: std_logic_vector			:= X"00000000";
	C_BRAM_SIZE					: integer					:= 32768
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

	BRAM_Clk					: out std_logic;
	BRAM_Rst					: out std_logic;
	BRAM_EN						: out std_logic;
	BRAM_WEN					: out std_logic_vector(0 to 3);
	BRAM_Dout					: out std_logic_vector(0 to 31);
	BRAM_Din					: in std_logic_vector(0 to 31);
	BRAM_Addr					: out std_logic_vector(0 to 31)
  );

  attribute SIGIS : string;
  attribute SIGIS of SYS_CLK     		: signal is "CLK";
  attribute SIGIS of SYS_RST      		: signal is "RST";
  attribute SIGIS of BRAM_Clk      		: signal is "CLK";
  attribute SIGIS of BRAM_Rst      		: signal is "RST";
  
end entity riffa_example;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of riffa_example is

  ------------------------------------------
  -- Component declaration for verilog riffa_example_impl
  ------------------------------------------
	component riffa_example_impl is
		generic
		(
			C_SIMPBUS_AWIDTH			: integer					:= 32;
			C_BRAM_ADDR					: std_logic_vector			:= X"00000000";
			C_BRAM_SIZE					: integer					:= 32768
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

			MEM_EN						: out std_logic;
			MEM_WEN						: out std_logic_vector(3 downto 0);
			MEM_DATA_OUT				: out std_logic_vector(31 downto 0);
			MEM_DATA_IN					: in std_logic_vector(31 downto 0);
			MEM_ADDR					: out std_logic_vector(31 downto 0)
		);
	end component riffa_example_impl;
begin
  ------------------------------------------
  -- instantiate riffa_example_impl
  ------------------------------------------
	RIFFA_EXAMPLE_I : component riffa_example_impl
	generic map
	(
		C_SIMPBUS_AWIDTH		=> C_SIMPBUS_AWIDTH,
		C_BRAM_ADDR				=> C_BRAM_ADDR,
		C_BRAM_SIZE				=> C_BRAM_SIZE
	)
	port map
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
		
		MEM_EN					=> BRAM_EN,
		MEM_WEN					=> BRAM_WEN,
		MEM_DATA_OUT			=> BRAM_Dout,
		MEM_DATA_IN				=> BRAM_Din,
		MEM_ADDR				=> BRAM_Addr
	);

	BRAM_Clk <= SYS_CLK;
	BRAM_Rst <= SYS_RST;

end IMP;
