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
-- Filename:			central_notifier.vhd
-- Version:				1.00.a
-- VHDL Standard:		VHDL'93
-- Description:			Top level core design, instantiates central_notifier_impl
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
--   C_ARCH						-- FPGA architecture (e.g. V5, V6)
--   C_SIMPBUS_AWIDTH			-- SIMPBUS address width
--   C_SIMPBUS_DWIDTH			-- SIMPBUS data width
--   C_NUM_CHANNELS				-- Number of RIFFA channels to activate
--   C_INIT_BUS					-- If an initialization bus is required
--   C_DMA_BASE_ADDR			-- PLB address of the DMA Controller
--   C_PCIE_BASE_ADDR			-- PLB address of the PCIE Bridge
--   C_PCIE_IPIF2PCI_LEN		-- Size of the IPIF2PCI BARs
--
-- Definition of Ports:
--   SYS_CLK					-- System clock
--   SYS_RST					-- System reset
--   INTR_PCI					-- Interrupt to PCI Bridge
--   INTR_DMA					-- Interrupt to the DMA Controller

--   SIMPBUS_INIT_ADDR			-- Bus address for the read/write
--   SIMPBUS_INIT_WDATA			-- Write data input
--   SIMPBUS_INIT_RDATA			-- Read data output
--   SIMPBUS_INIT_RNW			-- Set read not write
--   SIMPBUS_INIT_BE            -- Byte enable
--   SIMPBUS_INIT_START			-- Start the read/write
--   SIMPBUS_INIT_DONE			-- Done with read/write
--   SIMPBUS_INIT_ERR			-- Error trying to read/write

--   SIMPBUS_MST_ADDR			-- Bus address for the read/write
--   SIMPBUS_MST_WDATA			-- Write data input
--   SIMPBUS_MST_RDATA			-- Read data output
--   SIMPBUS_MST_BE             -- Byte enable
--   SIMPBUS_MST_RNW			-- Set read not write
--   SIMPBUS_MST_START			-- Start the read/write
--   SIMPBUS_MST_DONE			-- Done with read/write
--   SIMPBUS_MST_ERR			-- Error trying to read/write

--   SIMPBUS_SLV_ADDR			-- Bus address for the read/write
--   SIMPBUS_SLV_WDATA			-- Write data input
--   SIMPBUS_SLV_RDATA			-- Read data output
--   SIMPBUS_SLV_BE             -- Byte enable
--   SIMPBUS_SLV_RNW			-- Set read not write
--   SIMPBUS_SLV_START			-- Start the read/write
--   SIMPBUS_SLV_DONE			-- Done with read/write
--   SIMPBUS_SLV_ERR			-- Error trying to read/write

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
--   BUF_REQ_ACK				-- Request ack for a PC buffer
--   BUF_REQ_ADDR				-- PC buffer address for DMA
--   BUF_REQ_SIZE				-- PC buffer size (log2) for DMA
--   BUF_REQ_RDY				-- PC buffer address/size for DMA is valid
--   BUF_REQ_ERR				-- PC buffer for DMA error
--   BUF_REQD					-- FPGA buffer for DMA requested
--   BUF_REQD_ADDR				-- FPGA buffer address for DMA
--   BUF_REQD_SIZE				-- FPGA buffer size (log2) for DMA
--   BUF_REQD_RDY				-- FPGA buffer address/size for DMA is valid
--   BUF_REQD_ERR				-- FPGA buffer for DMA error
------------------------------------------------------------------------------

entity central_notifier is
  generic
  (
    C_ARCH							: string					:= "V5";
	C_SIMPBUS_AWIDTH				: integer					:= 32;
	C_SIMPBUS_DWIDTH				: integer					:= 32;
	C_NUM_CHANNELS					: integer					:= 16;
	C_INIT_BUS						: integer					:= 1;
    C_DMA_BASE_ADDR					: std_logic_vector			:= X"00000000";
	C_PCIE_BASE_ADDR				: std_logic_vector			:= X"00000000";
	C_PCIE_IPIF2PCI_LEN				: integer					:= 0
  );
  port
  (
    SYS_CLK						: in std_logic;
    SYS_RST						: in std_logic;
    INTR_PCI					: out std_logic;
	INTR_DMA					: in std_logic;

	INIT_START					: out std_logic;
	INIT_DONE					: in std_logic;

	SIMPBUS_INIT_ADDR			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	SIMPBUS_INIT_WDATA			: in std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
	SIMPBUS_INIT_RDATA			: out std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
	SIMPBUS_INIT_BE				: in std_logic_vector(C_SIMPBUS_DWIDTH/8-1 downto 0);
	SIMPBUS_INIT_RNW			: in std_logic;
	SIMPBUS_INIT_START			: in std_logic;
	SIMPBUS_INIT_DONE			: out std_logic;
	SIMPBUS_INIT_ERR			: out std_logic;

	SIMPBUS_MST_ADDR			: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	SIMPBUS_MST_WDATA			: out std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
	SIMPBUS_MST_RDATA			: in std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
	SIMPBUS_MST_BE				: out std_logic_vector(C_SIMPBUS_DWIDTH/8-1 downto 0);
	SIMPBUS_MST_RNW				: out std_logic;
	SIMPBUS_MST_START			: out std_logic;
	SIMPBUS_MST_DONE			: in std_logic;
	SIMPBUS_MST_ERR				: in std_logic;

	SIMPBUS_SLV_ADDR			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	SIMPBUS_SLV_WDATA			: in std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
	SIMPBUS_SLV_RDATA			: out std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
	SIMPBUS_SLV_BE				: in std_logic_vector(C_SIMPBUS_DWIDTH/8-1 downto 0);
	SIMPBUS_SLV_RNW				: in std_logic;
	SIMPBUS_SLV_START			: in std_logic;
	SIMPBUS_SLV_DONE			: out std_logic;
	SIMPBUS_SLV_ERR				: out std_logic;
	
	INTERRUPT_00				: in std_logic;
	INTERRUPT_ERR_00			: in std_logic;
	INTERRUPT_ACK_00			: out std_logic;
	DOORBELL_00					: out std_logic;
	DOORBELL_ERR_00				: out std_logic;
	DOORBELL_LEN_00				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_00				: out std_logic_vector(31 downto 0);
	DMA_REQ_00					: in std_logic;
	DMA_REQ_ACK_00				: out std_logic;
	DMA_SRC_00					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_00					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_00					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_00					: in std_logic;
	DMA_DONE_00					: out std_logic;
	DMA_ERR_00					: out std_logic;
	BUF_REQ_00					: in std_logic;
	BUF_REQ_ACK_00				: out std_logic;
	BUF_REQ_ADDR_00				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_00				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_00				: out std_logic;
	BUF_REQ_ERR_00				: out std_logic;
	BUF_REQD_00					: out std_logic;
	BUF_REQD_ADDR_00			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_00			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_00				: in std_logic;
	BUF_REQD_ERR_00				: in std_logic;

	INTERRUPT_01				: in std_logic;
	INTERRUPT_ERR_01			: in std_logic;
	INTERRUPT_ACK_01			: out std_logic;
	DOORBELL_01					: out std_logic;
	DOORBELL_ERR_01				: out std_logic;
	DOORBELL_LEN_01				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_01				: out std_logic_vector(31 downto 0);
	DMA_REQ_01					: in std_logic;
	DMA_REQ_ACK_01				: out std_logic;
	DMA_SRC_01					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_01					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_01					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_01					: in std_logic;
	DMA_DONE_01					: out std_logic;
	DMA_ERR_01					: out std_logic;
	BUF_REQ_01					: in std_logic;
	BUF_REQ_ACK_01				: out std_logic;
	BUF_REQ_ADDR_01				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_01				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_01				: out std_logic;
	BUF_REQ_ERR_01				: out std_logic;
	BUF_REQD_01					: out std_logic;
	BUF_REQD_ADDR_01			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_01			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_01				: in std_logic;
	BUF_REQD_ERR_01				: in std_logic;

	INTERRUPT_02				: in std_logic;
	INTERRUPT_ERR_02			: in std_logic;
	INTERRUPT_ACK_02			: out std_logic;
	DOORBELL_02					: out std_logic;
	DOORBELL_ERR_02				: out std_logic;
	DOORBELL_LEN_02				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_02				: out std_logic_vector(31 downto 0);
	DMA_REQ_02					: in std_logic;
	DMA_REQ_ACK_02				: out std_logic;
	DMA_SRC_02					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_02					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_02					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_02					: in std_logic;
	DMA_DONE_02					: out std_logic;
	DMA_ERR_02					: out std_logic;
	BUF_REQ_02					: in std_logic;
	BUF_REQ_ACK_02				: out std_logic;
	BUF_REQ_ADDR_02				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_02				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_02				: out std_logic;
	BUF_REQ_ERR_02				: out std_logic;
	BUF_REQD_02					: out std_logic;
	BUF_REQD_ADDR_02			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_02			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_02				: in std_logic;
	BUF_REQD_ERR_02				: in std_logic;

	INTERRUPT_03				: in std_logic;
	INTERRUPT_ERR_03			: in std_logic;
	INTERRUPT_ACK_03			: out std_logic;
	DOORBELL_03					: out std_logic;
	DOORBELL_ERR_03				: out std_logic;
	DOORBELL_LEN_03				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_03				: out std_logic_vector(31 downto 0);
	DMA_REQ_03					: in std_logic;
	DMA_REQ_ACK_03				: out std_logic;
	DMA_SRC_03					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_03					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_03					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_03					: in std_logic;
	DMA_DONE_03					: out std_logic;
	DMA_ERR_03					: out std_logic;
	BUF_REQ_03					: in std_logic;
	BUF_REQ_ACK_03				: out std_logic;
	BUF_REQ_ADDR_03				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_03				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_03				: out std_logic;
	BUF_REQ_ERR_03				: out std_logic;
	BUF_REQD_03					: out std_logic;
	BUF_REQD_ADDR_03			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_03			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_03				: in std_logic;
	BUF_REQD_ERR_03				: in std_logic;

	INTERRUPT_04				: in std_logic;
	INTERRUPT_ERR_04			: in std_logic;
	INTERRUPT_ACK_04			: out std_logic;
	DOORBELL_04					: out std_logic;
	DOORBELL_ERR_04				: out std_logic;
	DOORBELL_LEN_04				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_04				: out std_logic_vector(31 downto 0);
	DMA_REQ_04					: in std_logic;
	DMA_REQ_ACK_04				: out std_logic;
	DMA_SRC_04					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_04					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_04					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_04					: in std_logic;
	DMA_DONE_04					: out std_logic;
	DMA_ERR_04					: out std_logic;
	BUF_REQ_04					: in std_logic;
	BUF_REQ_ACK_04				: out std_logic;
	BUF_REQ_ADDR_04				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_04				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_04				: out std_logic;
	BUF_REQ_ERR_04				: out std_logic;
	BUF_REQD_04					: out std_logic;
	BUF_REQD_ADDR_04			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_04			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_04				: in std_logic;
	BUF_REQD_ERR_04				: in std_logic;

	INTERRUPT_05				: in std_logic;
	INTERRUPT_ERR_05			: in std_logic;
	INTERRUPT_ACK_05			: out std_logic;
	DOORBELL_05					: out std_logic;
	DOORBELL_ERR_05				: out std_logic;
	DOORBELL_LEN_05				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_05				: out std_logic_vector(31 downto 0);
	DMA_REQ_05					: in std_logic;
	DMA_REQ_ACK_05				: out std_logic;
	DMA_SRC_05					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_05					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_05					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_05					: in std_logic;
	DMA_DONE_05					: out std_logic;
	DMA_ERR_05					: out std_logic;
	BUF_REQ_05					: in std_logic;
	BUF_REQ_ACK_05				: out std_logic;
	BUF_REQ_ADDR_05				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_05				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_05				: out std_logic;
	BUF_REQ_ERR_05				: out std_logic;
	BUF_REQD_05					: out std_logic;
	BUF_REQD_ADDR_05			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_05			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_05				: in std_logic;
	BUF_REQD_ERR_05				: in std_logic;

	INTERRUPT_06				: in std_logic;
	INTERRUPT_ERR_06			: in std_logic;
	INTERRUPT_ACK_06			: out std_logic;
	DOORBELL_06					: out std_logic;
	DOORBELL_ERR_06				: out std_logic;
	DOORBELL_LEN_06				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_06				: out std_logic_vector(31 downto 0);
	DMA_REQ_06					: in std_logic;
	DMA_REQ_ACK_06				: out std_logic;
	DMA_SRC_06					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_06					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_06					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_06					: in std_logic;
	DMA_DONE_06					: out std_logic;
	DMA_ERR_06					: out std_logic;
	BUF_REQ_06					: in std_logic;
	BUF_REQ_ACK_06				: out std_logic;
	BUF_REQ_ADDR_06				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_06				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_06				: out std_logic;
	BUF_REQ_ERR_06				: out std_logic;
	BUF_REQD_06					: out std_logic;
	BUF_REQD_ADDR_06			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_06			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_06				: in std_logic;
	BUF_REQD_ERR_06				: in std_logic;

	INTERRUPT_07				: in std_logic;
	INTERRUPT_ERR_07			: in std_logic;
	INTERRUPT_ACK_07			: out std_logic;
	DOORBELL_07					: out std_logic;
	DOORBELL_ERR_07				: out std_logic;
	DOORBELL_LEN_07				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_07				: out std_logic_vector(31 downto 0);
	DMA_REQ_07					: in std_logic;
	DMA_REQ_ACK_07				: out std_logic;
	DMA_SRC_07					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_07					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_07					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_07					: in std_logic;
	DMA_DONE_07					: out std_logic;
	DMA_ERR_07					: out std_logic;
	BUF_REQ_07					: in std_logic;
	BUF_REQ_ACK_07				: out std_logic;
	BUF_REQ_ADDR_07				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_07				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_07				: out std_logic;
	BUF_REQ_ERR_07				: out std_logic;
	BUF_REQD_07					: out std_logic;
	BUF_REQD_ADDR_07			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_07			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_07				: in std_logic;
	BUF_REQD_ERR_07				: in std_logic;

	INTERRUPT_08				: in std_logic;
	INTERRUPT_ERR_08			: in std_logic;
	INTERRUPT_ACK_08			: out std_logic;
	DOORBELL_08					: out std_logic;
	DOORBELL_ERR_08				: out std_logic;
	DOORBELL_LEN_08				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_08				: out std_logic_vector(31 downto 0);
	DMA_REQ_08					: in std_logic;
	DMA_REQ_ACK_08				: out std_logic;
	DMA_SRC_08					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_08					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_08					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_08					: in std_logic;
	DMA_DONE_08					: out std_logic;
	DMA_ERR_08					: out std_logic;
	BUF_REQ_08					: in std_logic;
	BUF_REQ_ACK_08				: out std_logic;
	BUF_REQ_ADDR_08				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_08				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_08				: out std_logic;
	BUF_REQ_ERR_08				: out std_logic;
	BUF_REQD_08					: out std_logic;
	BUF_REQD_ADDR_08			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_08			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_08				: in std_logic;
	BUF_REQD_ERR_08				: in std_logic;

	INTERRUPT_09				: in std_logic;
	INTERRUPT_ERR_09			: in std_logic;
	INTERRUPT_ACK_09			: out std_logic;
	DOORBELL_09					: out std_logic;
	DOORBELL_ERR_09				: out std_logic;
	DOORBELL_LEN_09				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_09				: out std_logic_vector(31 downto 0);
	DMA_REQ_09					: in std_logic;
	DMA_REQ_ACK_09				: out std_logic;
	DMA_SRC_09					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_09					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_09					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_09					: in std_logic;
	DMA_DONE_09					: out std_logic;
	DMA_ERR_09					: out std_logic;
	BUF_REQ_09					: in std_logic;
	BUF_REQ_ACK_09				: out std_logic;
	BUF_REQ_ADDR_09				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_09				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_09				: out std_logic;
	BUF_REQ_ERR_09				: out std_logic;
	BUF_REQD_09					: out std_logic;
	BUF_REQD_ADDR_09			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_09			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_09				: in std_logic;
	BUF_REQD_ERR_09				: in std_logic;

	INTERRUPT_10				: in std_logic;
	INTERRUPT_ERR_10			: in std_logic;
	INTERRUPT_ACK_10			: out std_logic;
	DOORBELL_10					: out std_logic;
	DOORBELL_ERR_10				: out std_logic;
	DOORBELL_LEN_10				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_10				: out std_logic_vector(31 downto 0);
	DMA_REQ_10					: in std_logic;
	DMA_REQ_ACK_10				: out std_logic;
	DMA_SRC_10					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_10					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_10					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_10					: in std_logic;
	DMA_DONE_10					: out std_logic;
	DMA_ERR_10					: out std_logic;
	BUF_REQ_10					: in std_logic;
	BUF_REQ_ACK_10				: out std_logic;
	BUF_REQ_ADDR_10				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_10				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_10				: out std_logic;
	BUF_REQ_ERR_10				: out std_logic;
	BUF_REQD_10					: out std_logic;
	BUF_REQD_ADDR_10			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_10			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_10				: in std_logic;
	BUF_REQD_ERR_10				: in std_logic;

	INTERRUPT_11				: in std_logic;
	INTERRUPT_ERR_11			: in std_logic;
	INTERRUPT_ACK_11			: out std_logic;
	DOORBELL_11					: out std_logic;
	DOORBELL_ERR_11				: out std_logic;
	DOORBELL_LEN_11				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_11				: out std_logic_vector(31 downto 0);
	DMA_REQ_11					: in std_logic;
	DMA_REQ_ACK_11				: out std_logic;
	DMA_SRC_11					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_11					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_11					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_11					: in std_logic;
	DMA_DONE_11					: out std_logic;
	DMA_ERR_11					: out std_logic;
	BUF_REQ_11					: in std_logic;
	BUF_REQ_ACK_11				: out std_logic;
	BUF_REQ_ADDR_11				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_11				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_11				: out std_logic;
	BUF_REQ_ERR_11				: out std_logic;
	BUF_REQD_11					: out std_logic;
	BUF_REQD_ADDR_11			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_11			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_11				: in std_logic;
	BUF_REQD_ERR_11				: in std_logic;

	INTERRUPT_12				: in std_logic;
	INTERRUPT_ERR_12			: in std_logic;
	INTERRUPT_ACK_12			: out std_logic;
	DOORBELL_12					: out std_logic;
	DOORBELL_ERR_12				: out std_logic;
	DOORBELL_LEN_12				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_12				: out std_logic_vector(31 downto 0);
	DMA_REQ_12					: in std_logic;
	DMA_REQ_ACK_12				: out std_logic;
	DMA_SRC_12					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_12					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_12					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_12					: in std_logic;
	DMA_DONE_12					: out std_logic;
	DMA_ERR_12					: out std_logic;
	BUF_REQ_12					: in std_logic;
	BUF_REQ_ACK_12				: out std_logic;
	BUF_REQ_ADDR_12				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_12				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_12				: out std_logic;
	BUF_REQ_ERR_12				: out std_logic;
	BUF_REQD_12					: out std_logic;
	BUF_REQD_ADDR_12			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_12			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_12				: in std_logic;
	BUF_REQD_ERR_12				: in std_logic;

	INTERRUPT_13				: in std_logic;
	INTERRUPT_ERR_13			: in std_logic;
	INTERRUPT_ACK_13			: out std_logic;
	DOORBELL_13					: out std_logic;
	DOORBELL_ERR_13				: out std_logic;
	DOORBELL_LEN_13				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_13				: out std_logic_vector(31 downto 0);
	DMA_REQ_13					: in std_logic;
	DMA_REQ_ACK_13				: out std_logic;
	DMA_SRC_13					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_13					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_13					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_13					: in std_logic;
	DMA_DONE_13					: out std_logic;
	DMA_ERR_13					: out std_logic;
	BUF_REQ_13					: in std_logic;
	BUF_REQ_ACK_13				: out std_logic;
	BUF_REQ_ADDR_13				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_13				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_13				: out std_logic;
	BUF_REQ_ERR_13				: out std_logic;
	BUF_REQD_13					: out std_logic;
	BUF_REQD_ADDR_13			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_13			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_13				: in std_logic;
	BUF_REQD_ERR_13				: in std_logic;

	INTERRUPT_14				: in std_logic;
	INTERRUPT_ERR_14			: in std_logic;
	INTERRUPT_ACK_14			: out std_logic;
	DOORBELL_14					: out std_logic;
	DOORBELL_ERR_14				: out std_logic;
	DOORBELL_LEN_14				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_14				: out std_logic_vector(31 downto 0);
	DMA_REQ_14					: in std_logic;
	DMA_REQ_ACK_14				: out std_logic;
	DMA_SRC_14					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_14					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_14					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_14					: in std_logic;
	DMA_DONE_14					: out std_logic;
	DMA_ERR_14					: out std_logic;
	BUF_REQ_14					: in std_logic;
	BUF_REQ_ACK_14				: out std_logic;
	BUF_REQ_ADDR_14				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_14				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_14				: out std_logic;
	BUF_REQ_ERR_14				: out std_logic;
	BUF_REQD_14					: out std_logic;
	BUF_REQD_ADDR_14			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_14			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_14				: in std_logic;
	BUF_REQD_ERR_14				: in std_logic;

	INTERRUPT_15				: in std_logic;
	INTERRUPT_ERR_15			: in std_logic;
	INTERRUPT_ACK_15			: out std_logic;
	DOORBELL_15					: out std_logic;
	DOORBELL_ERR_15				: out std_logic;
	DOORBELL_LEN_15				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DOORBELL_ARG_15				: out std_logic_vector(31 downto 0);
	DMA_REQ_15					: in std_logic;
	DMA_REQ_ACK_15				: out std_logic;
	DMA_SRC_15					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_DST_15					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_LEN_15					: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	DMA_SIG_15					: in std_logic;
	DMA_DONE_15					: out std_logic;
	DMA_ERR_15					: out std_logic;
	BUF_REQ_15					: in std_logic;
	BUF_REQ_ACK_15				: out std_logic;
	BUF_REQ_ADDR_15				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQ_SIZE_15				: out std_logic_vector(4 downto 0);
	BUF_REQ_RDY_15				: out std_logic;
	BUF_REQ_ERR_15				: out std_logic;
	BUF_REQD_15					: out std_logic;
	BUF_REQD_ADDR_15			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
	BUF_REQD_SIZE_15			: in std_logic_vector(4 downto 0);
	BUF_REQD_RDY_15				: in std_logic;
	BUF_REQD_ERR_15				: in std_logic
  );

  attribute SIGIS : string;
  attribute SIGIS of SYS_CLK      : signal is "CLK";
  attribute SIGIS of SYS_RST      : signal is "RST";

end entity central_notifier;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of central_notifier is

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations
  ------------------------------------------
  signal Channel					: std_logic_vector(3 downto 0);
  signal Interrupt					: std_logic;
  signal InterruptErr				: std_logic;
  signal InterruptAck				: std_logic;
  signal Doorbell					: std_logic;
  signal DoorbellErr				: std_logic;
  signal DoorbellLen				: std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
  signal DoorbellArg				: std_logic_vector(31 downto 0);
  signal DmaReq						: std_logic;
  signal DmaReqAck					: std_logic;
  signal DmaSrc						: std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
  signal DmaDst						: std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
  signal DmaLen						: std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
  signal DmaSig						: std_logic;
  signal DmaDone					: std_logic;
  signal DmaErr						: std_logic;
  signal BufReq						: std_logic;
  signal BufReqAck					: std_logic;
  signal BufReqAddr					: std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
  signal BufReqSize					: std_logic_vector(4 downto 0);
  signal BufReqRdy					: std_logic;
  signal BufReqErr					: std_logic;
  signal BufReqd					: std_logic;
  signal BufReqdAddr				: std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
  signal BufReqdSize				: std_logic_vector(4 downto 0);
  signal BufReqdRdy					: std_logic;
  signal BufReqdErr					: std_logic;
  
 ------------------------------------------
  -- Component declaration for verilog central_notifier_impl
  ------------------------------------------
  component central_notifier_impl is
    generic
    (
		C_ARCH							: string					:= "V5";
		C_SIMPBUS_AWIDTH				: integer					:= 32;
		C_SIMPBUS_DWIDTH				: integer					:= 32;
		C_NUM_CHANNELS					: integer					:= 0;
		C_INIT_BUS						: integer					:= 1;
		C_DMA_BASE_ADDR					: std_logic_vector			:= X"00000000";
		C_PCIE_BASE_ADDR				: std_logic_vector		 	:= X"00000000";
		C_PCIE_IPIF2PCI_LEN				: integer					:= 0
    );
    port
    (
		SYS_CLK						: in std_logic;
		SYS_RST						: in std_logic;
		INTR_PCI					: out std_logic;
		INTR_DMA					: in std_logic;

		INIT_START					: out std_logic;
		INIT_DONE					: in std_logic;

		SIMPBUS_INIT_ADDR			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		SIMPBUS_INIT_WDATA			: in std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
		SIMPBUS_INIT_RDATA			: out std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
		SIMPBUS_INIT_BE				: in std_logic_vector(C_SIMPBUS_DWIDTH/8-1 downto 0);
		SIMPBUS_INIT_RNW			: in std_logic;
		SIMPBUS_INIT_START			: in std_logic;
		SIMPBUS_INIT_DONE			: out std_logic;
		SIMPBUS_INIT_ERR			: out std_logic;

		SIMPBUS_MST_ADDR			: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		SIMPBUS_MST_WDATA			: out std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
		SIMPBUS_MST_RDATA			: in std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
		SIMPBUS_MST_BE				: out std_logic_vector(C_SIMPBUS_DWIDTH/8-1 downto 0);
		SIMPBUS_MST_RNW				: out std_logic;
		SIMPBUS_MST_START			: out std_logic;
		SIMPBUS_MST_DONE			: in std_logic;
		SIMPBUS_MST_ERR				: in std_logic;

		SIMPBUS_SLV_ADDR			: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		SIMPBUS_SLV_WDATA			: in std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
		SIMPBUS_SLV_RDATA			: out std_logic_vector(C_SIMPBUS_DWIDTH-1 downto 0);
		SIMPBUS_SLV_BE				: in std_logic_vector(C_SIMPBUS_DWIDTH/8-1 downto 0);
		SIMPBUS_SLV_RNW				: in std_logic;
		SIMPBUS_SLV_START			: in std_logic;
		SIMPBUS_SLV_DONE			: out std_logic;
		SIMPBUS_SLV_ERR				: out std_logic;

		CHANNEL						: out std_logic_vector(3 downto 0);
		INTERRUPT					: in std_logic;
		INTERRUPT_ERR				: in std_logic;
		INTERRUPT_ACK				: out std_logic;
		DOORBELL					: out std_logic;
		DOORBELL_ERR				: out std_logic;
		DOORBELL_LEN				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		DOORBELL_ARG				: out std_logic_vector(31 downto 0);
		DMA_REQ						: in std_logic;
		DMA_REQ_ACK					: out std_logic;
		DMA_SRC						: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		DMA_DST						: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		DMA_LEN						: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		DMA_SIG						: in std_logic;
		DMA_DONE					: out std_logic;
		DMA_ERR						: out std_logic;
		BUF_REQ						: in std_logic;
		BUF_REQ_ACK					: out std_logic;
		BUF_REQ_ADDR				: out std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		BUF_REQ_SIZE				: out std_logic_vector(4 downto 0);
		BUF_REQ_RDY					: out std_logic;
		BUF_REQ_ERR					: out std_logic;
		BUF_REQD					: out std_logic;
		BUF_REQD_ADDR				: in std_logic_vector(C_SIMPBUS_AWIDTH-1 downto 0);
		BUF_REQD_SIZE				: in std_logic_vector(4 downto 0);
		BUF_REQD_RDY				: in std_logic;
		BUF_REQD_ERR				: in std_logic
    );
  end component central_notifier_impl;

begin
  ------------------------------------------
  -- instantiate central_notifier_impl
  ------------------------------------------
  CENTRAL_NOTIFIER_I : component central_notifier_impl
    generic map
    (
		C_ARCH					=> C_ARCH,
		C_SIMPBUS_AWIDTH		=> C_SIMPBUS_AWIDTH,
		C_SIMPBUS_DWIDTH		=> C_SIMPBUS_DWIDTH,
		C_NUM_CHANNELS			=> C_NUM_CHANNELS,
		C_INIT_BUS				=> C_INIT_BUS,
		C_DMA_BASE_ADDR			=> C_DMA_BASE_ADDR,
		C_PCIE_BASE_ADDR		=> C_PCIE_BASE_ADDR,
		C_PCIE_IPIF2PCI_LEN		=> C_PCIE_IPIF2PCI_LEN
    )
    port map
    (
		SYS_CLK					=> SYS_CLK,		
		SYS_RST					=> SYS_RST,		
		INTR_PCI				=> INTR_PCI,
		INTR_DMA				=> INTR_DMA,

		INIT_START				=> INIT_START,
		INIT_DONE				=> INIT_DONE,

		SIMPBUS_INIT_ADDR		=> SIMPBUS_INIT_ADDR,		
		SIMPBUS_INIT_WDATA		=> SIMPBUS_INIT_WDATA,
		SIMPBUS_INIT_RDATA		=> SIMPBUS_INIT_RDATA,
		SIMPBUS_INIT_BE			=> SIMPBUS_INIT_BE,
		SIMPBUS_INIT_RNW		=> SIMPBUS_INIT_RNW,
		SIMPBUS_INIT_START		=> SIMPBUS_INIT_START,
		SIMPBUS_INIT_DONE		=> SIMPBUS_INIT_DONE,
		SIMPBUS_INIT_ERR		=> SIMPBUS_INIT_ERR,

		SIMPBUS_MST_ADDR		=> SIMPBUS_MST_ADDR,		
		SIMPBUS_MST_WDATA		=> SIMPBUS_MST_WDATA,
		SIMPBUS_MST_RDATA		=> SIMPBUS_MST_RDATA,
		SIMPBUS_MST_BE			=> SIMPBUS_MST_BE,
		SIMPBUS_MST_RNW			=> SIMPBUS_MST_RNW,
		SIMPBUS_MST_START		=> SIMPBUS_MST_START,
		SIMPBUS_MST_DONE		=> SIMPBUS_MST_DONE,
		SIMPBUS_MST_ERR			=> SIMPBUS_MST_ERR,

		SIMPBUS_SLV_ADDR		=> SIMPBUS_SLV_ADDR,		
		SIMPBUS_SLV_WDATA		=> SIMPBUS_SLV_WDATA,
		SIMPBUS_SLV_RDATA		=> SIMPBUS_SLV_RDATA,
		SIMPBUS_SLV_BE			=> SIMPBUS_SLV_BE,
		SIMPBUS_SLV_RNW			=> SIMPBUS_SLV_RNW,
		SIMPBUS_SLV_START		=> SIMPBUS_SLV_START,
		SIMPBUS_SLV_DONE		=> SIMPBUS_SLV_DONE,
		SIMPBUS_SLV_ERR			=> SIMPBUS_SLV_ERR,

		CHANNEL					=> Channel,
		INTERRUPT				=> Interrupt,
		INTERRUPT_ERR			=> InterruptErr,
		INTERRUPT_ACK			=> InterruptAck,
		DOORBELL				=> Doorbell,
		DOORBELL_ERR			=> DoorbellErr,
		DOORBELL_LEN			=> DoorbellLen,
		DOORBELL_ARG			=> DoorbellArg,
		DMA_REQ					=> DmaReq,
		DMA_REQ_ACK				=> DmaReqAck,
		DMA_SRC					=> DmaSrc,
		DMA_DST					=> DmaDst,
		DMA_LEN					=> DmaLen,
		DMA_SIG					=> DmaSig,
		DMA_DONE				=> DmaDone,
		DMA_ERR					=> DmaErr,
		BUF_REQ					=> BufReq,
		BUF_REQ_ACK				=> BufReqAck,
		BUF_REQ_ADDR			=> BufReqAddr,
		BUF_REQ_SIZE			=> BufReqSize,
		BUF_REQ_RDY				=> BufReqRdy,
		BUF_REQ_ERR				=> BufReqErr,
		BUF_REQD				=> BufReqd,
		BUF_REQD_ADDR			=> BufReqdAddr,
		BUF_REQD_SIZE			=> BufReqdSize,
		BUF_REQD_RDY			=> BufReqdRdy,
		BUF_REQD_ERR			=> BufReqdErr
    );
		
  ------------------------------------------
  -- connect internal signals
  ------------------------------------------
    Interrupt <=	INTERRUPT_00 when Channel = "0000" else
					INTERRUPT_01 when Channel = "0001" else
					INTERRUPT_02 when Channel = "0010" else
					INTERRUPT_03 when Channel = "0011" else
					INTERRUPT_04 when Channel = "0100" else
					INTERRUPT_05 when Channel = "0101" else
					INTERRUPT_06 when Channel = "0110" else
					INTERRUPT_07 when Channel = "0111" else
					INTERRUPT_08 when Channel = "1000" else
					INTERRUPT_09 when Channel = "1001" else
					INTERRUPT_10 when Channel = "1010" else
					INTERRUPT_11 when Channel = "1011" else
					INTERRUPT_12 when Channel = "1100" else
					INTERRUPT_13 when Channel = "1101" else
					INTERRUPT_14 when Channel = "1110" else
					INTERRUPT_15 when Channel = "1111" else
					'X';

    InterruptErr <=	INTERRUPT_ERR_00 when Channel = "0000" else
					INTERRUPT_ERR_01 when Channel = "0001" else
					INTERRUPT_ERR_02 when Channel = "0010" else
					INTERRUPT_ERR_03 when Channel = "0011" else
					INTERRUPT_ERR_04 when Channel = "0100" else
					INTERRUPT_ERR_05 when Channel = "0101" else
					INTERRUPT_ERR_06 when Channel = "0110" else
					INTERRUPT_ERR_07 when Channel = "0111" else
					INTERRUPT_ERR_08 when Channel = "1000" else
					INTERRUPT_ERR_09 when Channel = "1001" else
					INTERRUPT_ERR_10 when Channel = "1010" else
					INTERRUPT_ERR_11 when Channel = "1011" else
					INTERRUPT_ERR_12 when Channel = "1100" else
					INTERRUPT_ERR_13 when Channel = "1101" else
					INTERRUPT_ERR_14 when Channel = "1110" else
					INTERRUPT_ERR_15 when Channel = "1111" else
					'X';

    INTERRUPT_ACK_00 <=	InterruptAck when Channel = "0000" else 'X';
	INTERRUPT_ACK_01 <=	InterruptAck when Channel = "0001" else 'X';
	INTERRUPT_ACK_02 <=	InterruptAck when Channel = "0010" else 'X';
	INTERRUPT_ACK_03 <=	InterruptAck when Channel = "0011" else 'X';
	INTERRUPT_ACK_04 <=	InterruptAck when Channel = "0100" else 'X';
	INTERRUPT_ACK_05 <=	InterruptAck when Channel = "0101" else 'X';
	INTERRUPT_ACK_06 <=	InterruptAck when Channel = "0110" else 'X';
	INTERRUPT_ACK_07 <=	InterruptAck when Channel = "0111" else 'X';
	INTERRUPT_ACK_08 <=	InterruptAck when Channel = "1000" else 'X';
	INTERRUPT_ACK_09 <=	InterruptAck when Channel = "1001" else 'X';
	INTERRUPT_ACK_10 <=	InterruptAck when Channel = "1010" else 'X';
	INTERRUPT_ACK_11 <=	InterruptAck when Channel = "1011" else 'X';
	INTERRUPT_ACK_12 <=	InterruptAck when Channel = "1100" else 'X';
	INTERRUPT_ACK_13 <=	InterruptAck when Channel = "1101" else 'X';
	INTERRUPT_ACK_14 <=	InterruptAck when Channel = "1110" else 'X';
	INTERRUPT_ACK_15 <=	InterruptAck when Channel = "1111" else 'X';

    DOORBELL_00 <=	Doorbell when Channel = "0000" else 'X';
	DOORBELL_01 <=	Doorbell when Channel = "0001" else 'X';
	DOORBELL_02 <=	Doorbell when Channel = "0010" else 'X';
	DOORBELL_03 <=	Doorbell when Channel = "0011" else 'X';
	DOORBELL_04 <=	Doorbell when Channel = "0100" else 'X';
	DOORBELL_05 <=	Doorbell when Channel = "0101" else 'X';
	DOORBELL_06 <=	Doorbell when Channel = "0110" else 'X';
	DOORBELL_07 <=	Doorbell when Channel = "0111" else 'X';
	DOORBELL_08 <=	Doorbell when Channel = "1000" else 'X';
	DOORBELL_09 <=	Doorbell when Channel = "1001" else 'X';
	DOORBELL_10 <=	Doorbell when Channel = "1010" else 'X';
	DOORBELL_11 <=	Doorbell when Channel = "1011" else 'X';
	DOORBELL_12 <=	Doorbell when Channel = "1100" else 'X';
	DOORBELL_13 <=	Doorbell when Channel = "1101" else 'X';
	DOORBELL_14 <=	Doorbell when Channel = "1110" else 'X';
	DOORBELL_15 <=	Doorbell when Channel = "1111" else 'X';

    DOORBELL_ERR_00  <=	DoorbellErr when Channel = "0000" else 'X';
	DOORBELL_ERR_01  <=	DoorbellErr when Channel = "0001" else 'X';
	DOORBELL_ERR_02  <=	DoorbellErr when Channel = "0010" else 'X';
	DOORBELL_ERR_03  <=	DoorbellErr when Channel = "0011" else 'X';
	DOORBELL_ERR_04  <=	DoorbellErr when Channel = "0100" else 'X';
	DOORBELL_ERR_05  <=	DoorbellErr when Channel = "0101" else 'X';
	DOORBELL_ERR_06  <=	DoorbellErr when Channel = "0110" else 'X';
	DOORBELL_ERR_07  <=	DoorbellErr when Channel = "0111" else 'X';
	DOORBELL_ERR_08  <=	DoorbellErr when Channel = "1000" else 'X';
	DOORBELL_ERR_09  <=	DoorbellErr when Channel = "1001" else 'X';
	DOORBELL_ERR_10  <=	DoorbellErr when Channel = "1010" else 'X';
	DOORBELL_ERR_11  <=	DoorbellErr when Channel = "1011" else 'X';
	DOORBELL_ERR_12  <=	DoorbellErr when Channel = "1100" else 'X';
	DOORBELL_ERR_13  <=	DoorbellErr when Channel = "1101" else 'X';
	DOORBELL_ERR_14  <=	DoorbellErr when Channel = "1110" else 'X';
	DOORBELL_ERR_15  <=	DoorbellErr when Channel = "1111" else 'X';

    DOORBELL_LEN_00  <=	DoorbellLen when Channel = "0000" else (others => 'X');
	DOORBELL_LEN_01  <=	DoorbellLen when Channel = "0001" else (others => 'X');
	DOORBELL_LEN_02  <=	DoorbellLen when Channel = "0010" else (others => 'X');
	DOORBELL_LEN_03  <=	DoorbellLen when Channel = "0011" else (others => 'X');
	DOORBELL_LEN_04  <=	DoorbellLen when Channel = "0100" else (others => 'X');
	DOORBELL_LEN_05  <=	DoorbellLen when Channel = "0101" else (others => 'X');
	DOORBELL_LEN_06  <=	DoorbellLen when Channel = "0110" else (others => 'X');
	DOORBELL_LEN_07  <=	DoorbellLen when Channel = "0111" else (others => 'X');
	DOORBELL_LEN_08  <=	DoorbellLen when Channel = "1000" else (others => 'X');
	DOORBELL_LEN_09  <=	DoorbellLen when Channel = "1001" else (others => 'X');
	DOORBELL_LEN_10  <=	DoorbellLen when Channel = "1010" else (others => 'X');
	DOORBELL_LEN_11  <=	DoorbellLen when Channel = "1011" else (others => 'X');
	DOORBELL_LEN_12  <=	DoorbellLen when Channel = "1100" else (others => 'X');
	DOORBELL_LEN_13  <=	DoorbellLen when Channel = "1101" else (others => 'X');
	DOORBELL_LEN_14  <=	DoorbellLen when Channel = "1110" else (others => 'X');
	DOORBELL_LEN_15  <=	DoorbellLen when Channel = "1111" else (others => 'X');

    DOORBELL_ARG_00  <=	DoorbellArg when Channel = "0000" else (others => 'X');
	DOORBELL_ARG_01  <=	DoorbellArg when Channel = "0001" else (others => 'X');
	DOORBELL_ARG_02  <=	DoorbellArg when Channel = "0010" else (others => 'X');
	DOORBELL_ARG_03  <=	DoorbellArg when Channel = "0011" else (others => 'X');
	DOORBELL_ARG_04  <=	DoorbellArg when Channel = "0100" else (others => 'X');
	DOORBELL_ARG_05  <=	DoorbellArg when Channel = "0101" else (others => 'X');
	DOORBELL_ARG_06  <=	DoorbellArg when Channel = "0110" else (others => 'X');
	DOORBELL_ARG_07  <=	DoorbellArg when Channel = "0111" else (others => 'X');
	DOORBELL_ARG_08  <=	DoorbellArg when Channel = "1000" else (others => 'X');
	DOORBELL_ARG_09  <=	DoorbellArg when Channel = "1001" else (others => 'X');
	DOORBELL_ARG_10  <=	DoorbellArg when Channel = "1010" else (others => 'X');
	DOORBELL_ARG_11  <=	DoorbellArg when Channel = "1011" else (others => 'X');
	DOORBELL_ARG_12  <=	DoorbellArg when Channel = "1100" else (others => 'X');
	DOORBELL_ARG_13  <=	DoorbellArg when Channel = "1101" else (others => 'X');
	DOORBELL_ARG_14  <=	DoorbellArg when Channel = "1110" else (others => 'X');
	DOORBELL_ARG_15  <=	DoorbellArg when Channel = "1111" else (others => 'X');

    DmaReq <=		DMA_REQ_00 when Channel = "0000" else
					DMA_REQ_01 when Channel = "0001" else
					DMA_REQ_02 when Channel = "0010" else
					DMA_REQ_03 when Channel = "0011" else
					DMA_REQ_04 when Channel = "0100" else
					DMA_REQ_05 when Channel = "0101" else
					DMA_REQ_06 when Channel = "0110" else
					DMA_REQ_07 when Channel = "0111" else
					DMA_REQ_08 when Channel = "1000" else
					DMA_REQ_09 when Channel = "1001" else
					DMA_REQ_10 when Channel = "1010" else
					DMA_REQ_11 when Channel = "1011" else
					DMA_REQ_12 when Channel = "1100" else
					DMA_REQ_13 when Channel = "1101" else
					DMA_REQ_14 when Channel = "1110" else
					DMA_REQ_15 when Channel = "1111" else
					'X';

    DMA_REQ_ACK_00  <=	DmaReqAck when Channel = "0000" else 'X';
	DMA_REQ_ACK_01  <=	DmaReqAck when Channel = "0001" else 'X';
	DMA_REQ_ACK_02  <=	DmaReqAck when Channel = "0010" else 'X';
	DMA_REQ_ACK_03  <=	DmaReqAck when Channel = "0011" else 'X';
	DMA_REQ_ACK_04  <=	DmaReqAck when Channel = "0100" else 'X';
	DMA_REQ_ACK_05  <=	DmaReqAck when Channel = "0101" else 'X';
	DMA_REQ_ACK_06  <=	DmaReqAck when Channel = "0110" else 'X';
	DMA_REQ_ACK_07  <=	DmaReqAck when Channel = "0111" else 'X';
	DMA_REQ_ACK_08  <=	DmaReqAck when Channel = "1000" else 'X';
	DMA_REQ_ACK_09  <=	DmaReqAck when Channel = "1001" else 'X';
	DMA_REQ_ACK_10  <=	DmaReqAck when Channel = "1010" else 'X';
	DMA_REQ_ACK_11  <=	DmaReqAck when Channel = "1011" else 'X';
	DMA_REQ_ACK_12  <=	DmaReqAck when Channel = "1100" else 'X';
	DMA_REQ_ACK_13  <=	DmaReqAck when Channel = "1101" else 'X';
	DMA_REQ_ACK_14  <=	DmaReqAck when Channel = "1110" else 'X';
	DMA_REQ_ACK_15  <=	DmaReqAck when Channel = "1111" else 'X';

    DmaSrc <=		DMA_SRC_00 when Channel = "0000" else
					DMA_SRC_01 when Channel = "0001" else
					DMA_SRC_02 when Channel = "0010" else
					DMA_SRC_03 when Channel = "0011" else
					DMA_SRC_04 when Channel = "0100" else
					DMA_SRC_05 when Channel = "0101" else
					DMA_SRC_06 when Channel = "0110" else
					DMA_SRC_07 when Channel = "0111" else
					DMA_SRC_08 when Channel = "1000" else
					DMA_SRC_09 when Channel = "1001" else
					DMA_SRC_10 when Channel = "1010" else
					DMA_SRC_11 when Channel = "1011" else
					DMA_SRC_12 when Channel = "1100" else
					DMA_SRC_13 when Channel = "1101" else
					DMA_SRC_14 when Channel = "1110" else
					DMA_SRC_15 when Channel = "1111" else
					(others => 'X');

    DmaDst <=		DMA_DST_00 when Channel = "0000" else
					DMA_DST_01 when Channel = "0001" else
					DMA_DST_02 when Channel = "0010" else
					DMA_DST_03 when Channel = "0011" else
					DMA_DST_04 when Channel = "0100" else
					DMA_DST_05 when Channel = "0101" else
					DMA_DST_06 when Channel = "0110" else
					DMA_DST_07 when Channel = "0111" else
					DMA_DST_08 when Channel = "1000" else
					DMA_DST_09 when Channel = "1001" else
					DMA_DST_10 when Channel = "1010" else
					DMA_DST_11 when Channel = "1011" else
					DMA_DST_12 when Channel = "1100" else
					DMA_DST_13 when Channel = "1101" else
					DMA_DST_14 when Channel = "1110" else
					DMA_DST_15 when Channel = "1111" else
					(others => 'X');

    DmaLen <=		DMA_LEN_00 when Channel = "0000" else
					DMA_LEN_01 when Channel = "0001" else
					DMA_LEN_02 when Channel = "0010" else
					DMA_LEN_03 when Channel = "0011" else
					DMA_LEN_04 when Channel = "0100" else
					DMA_LEN_05 when Channel = "0101" else
					DMA_LEN_06 when Channel = "0110" else
					DMA_LEN_07 when Channel = "0111" else
					DMA_LEN_08 when Channel = "1000" else
					DMA_LEN_09 when Channel = "1001" else
					DMA_LEN_10 when Channel = "1010" else
					DMA_LEN_11 when Channel = "1011" else
					DMA_LEN_12 when Channel = "1100" else
					DMA_LEN_13 when Channel = "1101" else
					DMA_LEN_14 when Channel = "1110" else
					DMA_LEN_15 when Channel = "1111" else
					(others => 'X');

    DmaSig <=		DMA_SIG_00 when Channel = "0000" else
					DMA_SIG_01 when Channel = "0001" else
					DMA_SIG_02 when Channel = "0010" else
					DMA_SIG_03 when Channel = "0011" else
					DMA_SIG_04 when Channel = "0100" else
					DMA_SIG_05 when Channel = "0101" else
					DMA_SIG_06 when Channel = "0110" else
					DMA_SIG_07 when Channel = "0111" else
					DMA_SIG_08 when Channel = "1000" else
					DMA_SIG_09 when Channel = "1001" else
					DMA_SIG_10 when Channel = "1010" else
					DMA_SIG_11 when Channel = "1011" else
					DMA_SIG_12 when Channel = "1100" else
					DMA_SIG_13 when Channel = "1101" else
					DMA_SIG_14 when Channel = "1110" else
					DMA_SIG_15 when Channel = "1111" else
					'X';

    DMA_DONE_00  <=	DmaDone when Channel = "0000" else 'X';
	DMA_DONE_01  <=	DmaDone when Channel = "0001" else 'X';
	DMA_DONE_02  <=	DmaDone when Channel = "0010" else 'X';
	DMA_DONE_03  <=	DmaDone when Channel = "0011" else 'X';
	DMA_DONE_04  <=	DmaDone when Channel = "0100" else 'X';
	DMA_DONE_05  <=	DmaDone when Channel = "0101" else 'X';
	DMA_DONE_06  <=	DmaDone when Channel = "0110" else 'X';
	DMA_DONE_07  <=	DmaDone when Channel = "0111" else 'X';
	DMA_DONE_08  <=	DmaDone when Channel = "1000" else 'X';
	DMA_DONE_09  <=	DmaDone when Channel = "1001" else 'X';
	DMA_DONE_10  <=	DmaDone when Channel = "1010" else 'X';
	DMA_DONE_11  <=	DmaDone when Channel = "1011" else 'X';
	DMA_DONE_12  <=	DmaDone when Channel = "1100" else 'X';
	DMA_DONE_13  <=	DmaDone when Channel = "1101" else 'X';
	DMA_DONE_14  <=	DmaDone when Channel = "1110" else 'X';
	DMA_DONE_15  <=	DmaDone when Channel = "1111" else 'X';

    DMA_ERR_00  <=	DmaErr when Channel = "0000" else 'X';
	DMA_ERR_01  <=	DmaErr when Channel = "0001" else 'X';
	DMA_ERR_02  <=	DmaErr when Channel = "0010" else 'X';
	DMA_ERR_03  <=	DmaErr when Channel = "0011" else 'X';
	DMA_ERR_04  <=	DmaErr when Channel = "0100" else 'X';
	DMA_ERR_05  <=	DmaErr when Channel = "0101" else 'X';
	DMA_ERR_06  <=	DmaErr when Channel = "0110" else 'X';
	DMA_ERR_07  <=	DmaErr when Channel = "0111" else 'X';
	DMA_ERR_08  <=	DmaErr when Channel = "1000" else 'X';
	DMA_ERR_09  <=	DmaErr when Channel = "1001" else 'X';
	DMA_ERR_10  <=	DmaErr when Channel = "1010" else 'X';
	DMA_ERR_11  <=	DmaErr when Channel = "1011" else 'X';
	DMA_ERR_12  <=	DmaErr when Channel = "1100" else 'X';
	DMA_ERR_13  <=	DmaErr when Channel = "1101" else 'X';
	DMA_ERR_14  <=	DmaErr when Channel = "1110" else 'X';
	DMA_ERR_15  <=	DmaErr when Channel = "1111" else 'X';

    BufReq <=		BUF_REQ_00 when Channel = "0000" else
					BUF_REQ_01 when Channel = "0001" else
					BUF_REQ_02 when Channel = "0010" else
					BUF_REQ_03 when Channel = "0011" else
					BUF_REQ_04 when Channel = "0100" else
					BUF_REQ_05 when Channel = "0101" else
					BUF_REQ_06 when Channel = "0110" else
					BUF_REQ_07 when Channel = "0111" else
					BUF_REQ_08 when Channel = "1000" else
					BUF_REQ_09 when Channel = "1001" else
					BUF_REQ_10 when Channel = "1010" else
					BUF_REQ_11 when Channel = "1011" else
					BUF_REQ_12 when Channel = "1100" else
					BUF_REQ_13 when Channel = "1101" else
					BUF_REQ_14 when Channel = "1110" else
					BUF_REQ_15 when Channel = "1111" else
					'X';

    BUF_REQ_ACK_00  <=	BufReqAck when Channel = "0000" else 'X';
	BUF_REQ_ACK_01  <=	BufReqAck when Channel = "0001" else 'X';
	BUF_REQ_ACK_02  <=	BufReqAck when Channel = "0010" else 'X';
	BUF_REQ_ACK_03  <=	BufReqAck when Channel = "0011" else 'X';
	BUF_REQ_ACK_04  <=	BufReqAck when Channel = "0100" else 'X';
	BUF_REQ_ACK_05  <=	BufReqAck when Channel = "0101" else 'X';
	BUF_REQ_ACK_06  <=	BufReqAck when Channel = "0110" else 'X';
	BUF_REQ_ACK_07  <=	BufReqAck when Channel = "0111" else 'X';
	BUF_REQ_ACK_08  <=	BufReqAck when Channel = "1000" else 'X';
	BUF_REQ_ACK_09  <=	BufReqAck when Channel = "1001" else 'X';
	BUF_REQ_ACK_10  <=	BufReqAck when Channel = "1010" else 'X';
	BUF_REQ_ACK_11  <=	BufReqAck when Channel = "1011" else 'X';
	BUF_REQ_ACK_12  <=	BufReqAck when Channel = "1100" else 'X';
	BUF_REQ_ACK_13  <=	BufReqAck when Channel = "1101" else 'X';
	BUF_REQ_ACK_14  <=	BufReqAck when Channel = "1110" else 'X';
	BUF_REQ_ACK_15  <=	BufReqAck when Channel = "1111" else 'X';

    BUF_REQ_ADDR_00  <=	BufReqAddr when Channel = "0000" else (others => 'X');
	BUF_REQ_ADDR_01  <=	BufReqAddr when Channel = "0001" else (others => 'X');
	BUF_REQ_ADDR_02  <=	BufReqAddr when Channel = "0010" else (others => 'X');
	BUF_REQ_ADDR_03  <=	BufReqAddr when Channel = "0011" else (others => 'X');
	BUF_REQ_ADDR_04  <=	BufReqAddr when Channel = "0100" else (others => 'X');
	BUF_REQ_ADDR_05  <=	BufReqAddr when Channel = "0101" else (others => 'X');
	BUF_REQ_ADDR_06  <=	BufReqAddr when Channel = "0110" else (others => 'X');
	BUF_REQ_ADDR_07  <=	BufReqAddr when Channel = "0111" else (others => 'X');
	BUF_REQ_ADDR_08  <=	BufReqAddr when Channel = "1000" else (others => 'X');
	BUF_REQ_ADDR_09  <=	BufReqAddr when Channel = "1001" else (others => 'X');
	BUF_REQ_ADDR_10  <=	BufReqAddr when Channel = "1010" else (others => 'X');
	BUF_REQ_ADDR_11  <=	BufReqAddr when Channel = "1011" else (others => 'X');
	BUF_REQ_ADDR_12  <=	BufReqAddr when Channel = "1100" else (others => 'X');
	BUF_REQ_ADDR_13  <=	BufReqAddr when Channel = "1101" else (others => 'X');
	BUF_REQ_ADDR_14  <=	BufReqAddr when Channel = "1110" else (others => 'X');
	BUF_REQ_ADDR_15  <=	BufReqAddr when Channel = "1111" else (others => 'X');

    BUF_REQ_SIZE_00  <=	BufReqSize when Channel = "0000" else (others => 'X');
	BUF_REQ_SIZE_01  <=	BufReqSize when Channel = "0001" else (others => 'X');
	BUF_REQ_SIZE_02  <=	BufReqSize when Channel = "0010" else (others => 'X');
	BUF_REQ_SIZE_03  <=	BufReqSize when Channel = "0011" else (others => 'X');
	BUF_REQ_SIZE_04  <=	BufReqSize when Channel = "0100" else (others => 'X');
	BUF_REQ_SIZE_05  <=	BufReqSize when Channel = "0101" else (others => 'X');
	BUF_REQ_SIZE_06  <=	BufReqSize when Channel = "0110" else (others => 'X');
	BUF_REQ_SIZE_07  <=	BufReqSize when Channel = "0111" else (others => 'X');
	BUF_REQ_SIZE_08  <=	BufReqSize when Channel = "1000" else (others => 'X');
	BUF_REQ_SIZE_09  <=	BufReqSize when Channel = "1001" else (others => 'X');
	BUF_REQ_SIZE_10  <=	BufReqSize when Channel = "1010" else (others => 'X');
	BUF_REQ_SIZE_11  <=	BufReqSize when Channel = "1011" else (others => 'X');
	BUF_REQ_SIZE_12  <=	BufReqSize when Channel = "1100" else (others => 'X');
	BUF_REQ_SIZE_13  <=	BufReqSize when Channel = "1101" else (others => 'X');
	BUF_REQ_SIZE_14  <=	BufReqSize when Channel = "1110" else (others => 'X');
	BUF_REQ_SIZE_15  <=	BufReqSize when Channel = "1111" else (others => 'X');

    BUF_REQ_RDY_00  <=	BufReqRdy when Channel = "0000" else 'X';
	BUF_REQ_RDY_01  <=	BufReqRdy when Channel = "0001" else 'X';
	BUF_REQ_RDY_02  <=	BufReqRdy when Channel = "0010" else 'X';
	BUF_REQ_RDY_03  <=	BufReqRdy when Channel = "0011" else 'X';
	BUF_REQ_RDY_04  <=	BufReqRdy when Channel = "0100" else 'X';
	BUF_REQ_RDY_05  <=	BufReqRdy when Channel = "0101" else 'X';
	BUF_REQ_RDY_06  <=	BufReqRdy when Channel = "0110" else 'X';
	BUF_REQ_RDY_07  <=	BufReqRdy when Channel = "0111" else 'X';
	BUF_REQ_RDY_08  <=	BufReqRdy when Channel = "1000" else 'X';
	BUF_REQ_RDY_09  <=	BufReqRdy when Channel = "1001" else 'X';
	BUF_REQ_RDY_10  <=	BufReqRdy when Channel = "1010" else 'X';
	BUF_REQ_RDY_11  <=	BufReqRdy when Channel = "1011" else 'X';
	BUF_REQ_RDY_12  <=	BufReqRdy when Channel = "1100" else 'X';
	BUF_REQ_RDY_13  <=	BufReqRdy when Channel = "1101" else 'X';
	BUF_REQ_RDY_14  <=	BufReqRdy when Channel = "1110" else 'X';
	BUF_REQ_RDY_15  <=	BufReqRdy when Channel = "1111" else 'X';

	BUF_REQ_ERR_00  <=	BufReqErr when Channel = "0000" else 'X';
	BUF_REQ_ERR_01  <=	BufReqErr when Channel = "0001" else 'X';
	BUF_REQ_ERR_02  <=	BufReqErr when Channel = "0010" else 'X';
	BUF_REQ_ERR_03  <=	BufReqErr when Channel = "0011" else 'X';
	BUF_REQ_ERR_04  <=	BufReqErr when Channel = "0100" else 'X';
	BUF_REQ_ERR_05  <=	BufReqErr when Channel = "0101" else 'X';
	BUF_REQ_ERR_06  <=	BufReqErr when Channel = "0110" else 'X';
	BUF_REQ_ERR_07  <=	BufReqErr when Channel = "0111" else 'X';
	BUF_REQ_ERR_08  <=	BufReqErr when Channel = "1000" else 'X';
	BUF_REQ_ERR_09  <=	BufReqErr when Channel = "1001" else 'X';
	BUF_REQ_ERR_10  <=	BufReqErr when Channel = "1010" else 'X';
	BUF_REQ_ERR_11  <=	BufReqErr when Channel = "1011" else 'X';
	BUF_REQ_ERR_12  <=	BufReqErr when Channel = "1100" else 'X';
	BUF_REQ_ERR_13  <=	BufReqErr when Channel = "1101" else 'X';
	BUF_REQ_ERR_14  <=	BufReqErr when Channel = "1110" else 'X';
	BUF_REQ_ERR_15  <=	BufReqErr when Channel = "1111" else 'X';

    BUF_REQD_00  <=	BufReqd when Channel = "0000" else 'X';
	BUF_REQD_01  <=	BufReqd when Channel = "0001" else 'X';
	BUF_REQD_02  <=	BufReqd when Channel = "0010" else 'X';
	BUF_REQD_03  <=	BufReqd when Channel = "0011" else 'X';
	BUF_REQD_04  <=	BufReqd when Channel = "0100" else 'X';
	BUF_REQD_05  <=	BufReqd when Channel = "0101" else 'X';
	BUF_REQD_06  <=	BufReqd when Channel = "0110" else 'X';
	BUF_REQD_07  <=	BufReqd when Channel = "0111" else 'X';
	BUF_REQD_08  <=	BufReqd when Channel = "1000" else 'X';
	BUF_REQD_09  <=	BufReqd when Channel = "1001" else 'X';
	BUF_REQD_10  <=	BufReqd when Channel = "1010" else 'X';
	BUF_REQD_11  <=	BufReqd when Channel = "1011" else 'X';
	BUF_REQD_12  <=	BufReqd when Channel = "1100" else 'X';
	BUF_REQD_13  <=	BufReqd when Channel = "1101" else 'X';
	BUF_REQD_14  <=	BufReqd when Channel = "1110" else 'X';
	BUF_REQD_15  <=	BufReqd when Channel = "1111" else 'X';

    BufReqdAddr <=	BUF_REQD_ADDR_00 when Channel = "0000" else
					BUF_REQD_ADDR_01 when Channel = "0001" else
					BUF_REQD_ADDR_02 when Channel = "0010" else
					BUF_REQD_ADDR_03 when Channel = "0011" else
					BUF_REQD_ADDR_04 when Channel = "0100" else
					BUF_REQD_ADDR_05 when Channel = "0101" else
					BUF_REQD_ADDR_06 when Channel = "0110" else
					BUF_REQD_ADDR_07 when Channel = "0111" else
					BUF_REQD_ADDR_08 when Channel = "1000" else
					BUF_REQD_ADDR_09 when Channel = "1001" else
					BUF_REQD_ADDR_10 when Channel = "1010" else
					BUF_REQD_ADDR_11 when Channel = "1011" else
					BUF_REQD_ADDR_12 when Channel = "1100" else
					BUF_REQD_ADDR_13 when Channel = "1101" else
					BUF_REQD_ADDR_14 when Channel = "1110" else
					BUF_REQD_ADDR_15 when Channel = "1111" else
					(others => 'X');

    BufReqdSize <=	BUF_REQD_SIZE_00 when Channel = "0000" else
					BUF_REQD_SIZE_01 when Channel = "0001" else
					BUF_REQD_SIZE_02 when Channel = "0010" else
					BUF_REQD_SIZE_03 when Channel = "0011" else
					BUF_REQD_SIZE_04 when Channel = "0100" else
					BUF_REQD_SIZE_05 when Channel = "0101" else
					BUF_REQD_SIZE_06 when Channel = "0110" else
					BUF_REQD_SIZE_07 when Channel = "0111" else
					BUF_REQD_SIZE_08 when Channel = "1000" else
					BUF_REQD_SIZE_09 when Channel = "1001" else
					BUF_REQD_SIZE_10 when Channel = "1010" else
					BUF_REQD_SIZE_11 when Channel = "1011" else
					BUF_REQD_SIZE_12 when Channel = "1100" else
					BUF_REQD_SIZE_13 when Channel = "1101" else
					BUF_REQD_SIZE_14 when Channel = "1110" else
					BUF_REQD_SIZE_15 when Channel = "1111" else
					(others => 'X');

    BufReqdRdy <=	BUF_REQD_RDY_00 when Channel = "0000" else
					BUF_REQD_RDY_01 when Channel = "0001" else
					BUF_REQD_RDY_02 when Channel = "0010" else
					BUF_REQD_RDY_03 when Channel = "0011" else
					BUF_REQD_RDY_04 when Channel = "0100" else
					BUF_REQD_RDY_05 when Channel = "0101" else
					BUF_REQD_RDY_06 when Channel = "0110" else
					BUF_REQD_RDY_07 when Channel = "0111" else
					BUF_REQD_RDY_08 when Channel = "1000" else
					BUF_REQD_RDY_09 when Channel = "1001" else
					BUF_REQD_RDY_10 when Channel = "1010" else
					BUF_REQD_RDY_11 when Channel = "1011" else
					BUF_REQD_RDY_12 when Channel = "1100" else
					BUF_REQD_RDY_13 when Channel = "1101" else
					BUF_REQD_RDY_14 when Channel = "1110" else
					BUF_REQD_RDY_15 when Channel = "1111" else
					'X';

    BufReqdErr <=	BUF_REQD_ERR_00 when Channel = "0000" else
					BUF_REQD_ERR_01 when Channel = "0001" else
					BUF_REQD_ERR_02 when Channel = "0010" else
					BUF_REQD_ERR_03 when Channel = "0011" else
					BUF_REQD_ERR_04 when Channel = "0100" else
					BUF_REQD_ERR_05 when Channel = "0101" else
					BUF_REQD_ERR_06 when Channel = "0110" else
					BUF_REQD_ERR_07 when Channel = "0111" else
					BUF_REQD_ERR_08 when Channel = "1000" else
					BUF_REQD_ERR_09 when Channel = "1001" else
					BUF_REQD_ERR_10 when Channel = "1010" else
					BUF_REQD_ERR_11 when Channel = "1011" else
					BUF_REQD_ERR_12 when Channel = "1100" else
					BUF_REQD_ERR_13 when Channel = "1101" else
					BUF_REQD_ERR_14 when Channel = "1110" else
					BUF_REQD_ERR_15 when Channel = "1111" else
					'X';
  
end IMP;
