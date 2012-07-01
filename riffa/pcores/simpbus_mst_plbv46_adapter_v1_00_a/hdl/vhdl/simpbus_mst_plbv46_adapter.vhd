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
-- Filename:			simpbus_mst_plbv46_adapter.vhd
-- Version:				1.00.a
-- VHDL Standard:		VHDL'93
-- Description:			Top level core design, instantiates plbv46_master_single
--						and plb_master_driver.
-- History:				@mattj: Initial pre-release. Version 0.9.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library plbv46_master_single_v1_01_a;
use plbv46_master_single_v1_01_a.plbv46_master_single;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_FAMILY                     -- Xilinx FPGA family
--   C_MPLB_AWIDTH                -- PLBv46 master: address bus width
--   C_MPLB_DWIDTH                -- PLBv46 master: data bus width
--   C_MPLB_NATIVE_DWIDTH         -- PLBv46 master: internal native data width
--   C_MPLB_P2P                   -- PLBv46 master: point to point interconnect scheme
--   C_MPLB_SMALLEST_SLAVE        -- PLBv46 master: width of the smallest slave
--   C_MPLB_CLK_PERIOD_PS         -- PLBv46 master: bus clock in picoseconds
--
-- Definition of Ports:
--   MPLB_Clk                     -- PLB main bus Clock
--   MPLB_Rst                     -- PLB main bus Reset
--   M_request                    -- Master request
--   M_priority                   -- Master request priority
--   M_busLock                    -- Master buslock
--   M_RNW                        -- Master read/nor write
--   M_BE                         -- Master byte enables
--   M_MSize                      -- Master data bus size
--   M_size                       -- Master transfer size
--   M_type                       -- Master transfer type
--   M_TAttribute                 -- Master transfer attribute
--   M_lockErr                    -- Master lock error indicator
--   M_abort                      -- Master abort bus request indicator
--   M_UABus                      -- Master upper address bus
--   M_ABus                       -- Master address bus
--   M_wrDBus                     -- Master write data bus
--   M_wrBurst                    -- Master burst write transfer indicator
--   M_rdBurst                    -- Master burst read transfer indicator
--   PLB_MAddrAck                 -- PLB reply to master for address acknowledge
--   PLB_MSSize                   -- PLB reply to master for slave data bus size
--   PLB_MRearbitrate             -- PLB reply to master for bus re-arbitrate indicator
--   PLB_MTimeout                 -- PLB reply to master for bus time out indicator
--   PLB_MBusy                    -- PLB reply to master for slave busy indicator
--   PLB_MRdErr                   -- PLB reply to master for slave read error indicator
--   PLB_MWrErr                   -- PLB reply to master for slave write error indicator
--   PLB_MIRQ                     -- PLB reply to master for slave interrupt indicator
--   PLB_MRdDBus                  -- PLB reply to master for read data bus
--   PLB_MRdWdAddr                -- PLB reply to master for read word address
--   PLB_MRdDAck                  -- PLB reply to master for read data acknowledge
--   PLB_MRdBTerm                 -- PLB reply to master for terminate read burst indicator
--   PLB_MWrDAck                  -- PLB reply to master for write data acknowledge
--   PLB_MWrBTerm                 -- PLB reply to master for terminate write burst indicator

--   SIMPBUS_ADDR				-- Bus address for the read/write
--   SIMPBUS_WDATA				-- Write data input
--   SIMPBUS_RDATA				-- Read data output
--   SIMPBUS_BE					-- Read/write byte enables
--   SIMPBUS_RNW				-- Set read not write
--   SIMPBUS_START				-- Start the read/write
--   SIMPBUS_DONE				-- Done with read/write
--   SIMPBUS_ERR				-- Error trying to read/write
------------------------------------------------------------------------------

entity simpbus_mst_plbv46_adapter is
  generic
  (
    C_FAMILY                       : string               := "virtex5";
    C_MPLB_AWIDTH                  : integer              := 32;
    C_MPLB_DWIDTH                  : integer              := 128;
    C_MPLB_NATIVE_DWIDTH           : integer              := 32;
    C_MPLB_P2P                     : integer              := 0;
    C_MPLB_SMALLEST_SLAVE          : integer              := 32;
    C_MPLB_CLK_PERIOD_PS           : integer              := 10000
  );
  port
  (
	SIMPBUS_ADDR				: in std_logic_vector(0 to C_MPLB_AWIDTH-1);
	SIMPBUS_WDATA				: in std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH-1);
	SIMPBUS_RDATA				: out std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH-1);
	SIMPBUS_BE					: in std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH/8-1);
	SIMPBUS_RNW					: in std_logic;
	SIMPBUS_START				: in std_logic;
	SIMPBUS_DONE				: out std_logic;
	SIMPBUS_ERR					: out std_logic;

    MPLB_Clk                       : in  std_logic;
    MPLB_Rst                       : in  std_logic;
    M_request                      : out std_logic;
    M_priority                     : out std_logic_vector(0 to 1);
    M_busLock                      : out std_logic;
    M_RNW                          : out std_logic;
    M_BE                           : out std_logic_vector(0 to C_MPLB_DWIDTH/8-1);
    M_MSize                        : out std_logic_vector(0 to 1);
    M_size                         : out std_logic_vector(0 to 3);
    M_type                         : out std_logic_vector(0 to 2);
    M_TAttribute                   : out std_logic_vector(0 to 15);
    M_lockErr                      : out std_logic;
    M_abort                        : out std_logic;
    M_UABus                        : out std_logic_vector(0 to 31);
    M_ABus                         : out std_logic_vector(0 to 31);
    M_wrDBus                       : out std_logic_vector(0 to C_MPLB_DWIDTH-1);
    M_wrBurst                      : out std_logic;
    M_rdBurst                      : out std_logic;
    PLB_MAddrAck                   : in  std_logic;
    PLB_MSSize                     : in  std_logic_vector(0 to 1);
    PLB_MRearbitrate               : in  std_logic;
    PLB_MTimeout                   : in  std_logic;
    PLB_MBusy                      : in  std_logic;
    PLB_MRdErr                     : in  std_logic;
    PLB_MWrErr                     : in  std_logic;
    PLB_MIRQ                       : in  std_logic;
    PLB_MRdDBus                    : in  std_logic_vector(0 to (C_MPLB_DWIDTH-1));
    PLB_MRdWdAddr                  : in  std_logic_vector(0 to 3);
    PLB_MRdDAck                    : in  std_logic;
    PLB_MRdBTerm                   : in  std_logic;
    PLB_MWrDAck                    : in  std_logic;
    PLB_MWrBTerm                   : in  std_logic
  );

  attribute SIGIS : string;
  attribute SIGIS of MPLB_Clk      : signal is "CLK";
  attribute SIGIS of MPLB_Rst      : signal is "RST";

end entity simpbus_mst_plbv46_adapter;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of simpbus_mst_plbv46_adapter is

  ------------------------------------------
  -- Width of the master data bus (32 only)
  ------------------------------------------
  constant USER_MST_DWIDTH                : integer              := C_MPLB_NATIVE_DWIDTH;

  constant IPIF_MST_DWIDTH                : integer              := C_MPLB_NATIVE_DWIDTH;

  ------------------------------------------
  -- Width of the master address bus (32 only)
  ------------------------------------------
  constant USER_MST_AWIDTH                : integer              := C_MPLB_AWIDTH;


  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations
  ------------------------------------------
  signal ipif_IP2Bus_MstRd_Req          : std_logic;
  signal ipif_IP2Bus_MstWr_Req          : std_logic;
  signal ipif_IP2Bus_Mst_Addr           : std_logic_vector(0 to C_MPLB_AWIDTH-1);
  signal ipif_IP2Bus_Mst_BE             : std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH/8-1);
  signal ipif_IP2Bus_Mst_Lock           : std_logic;
  signal ipif_IP2Bus_Mst_Reset          : std_logic;
  signal ipif_Bus2IP_Mst_CmdAck         : std_logic;
  signal ipif_Bus2IP_Mst_Cmplt          : std_logic;
  signal ipif_Bus2IP_Mst_Error          : std_logic;
  signal ipif_Bus2IP_Mst_Rearbitrate    : std_logic;
  signal ipif_Bus2IP_Mst_Cmd_Timeout    : std_logic;
  signal ipif_Bus2IP_MstRd_d            : std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH-1);
  signal ipif_Bus2IP_MstRd_src_rdy_n    : std_logic;
  signal ipif_IP2Bus_MstWr_d            : std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH-1);
  signal ipif_Bus2IP_MstWr_dst_rdy_n    : std_logic;

  ------------------------------------------
  -- Component declaration for verilog plb_master_driver
  ------------------------------------------
  component plb_master_driver is
    generic
    (
		C_MST_AWIDTH                   : integer              := 32;
		C_MST_DWIDTH                   : integer              := 32
    );
    port
    (
		ADDR				: in std_logic_vector(0 to C_MST_AWIDTH-1);
		WRITE_DATA			: in std_logic_vector(0 to C_MST_DWIDTH-1);
		READ_DATA			: out std_logic_vector(0 to C_MST_DWIDTH-1);
		BE					: in std_logic_vector(0 to C_MST_DWIDTH/8-1);
		RNW					: in std_logic;
		START				: in std_logic;
		DONE				: out std_logic;
		ERR					: out std_logic;

		Bus2IP_Clk                       : in  std_logic;
		Bus2IP_Reset                       : in  std_logic;
		IP2Bus_MstRd_Req               : out std_logic;
		IP2Bus_MstWr_Req               : out std_logic;
		IP2Bus_Mst_Addr                : out std_logic_vector(0 to C_MST_AWIDTH-1);
		IP2Bus_Mst_BE                  : out std_logic_vector(0 to C_MST_DWIDTH/8-1);
		IP2Bus_Mst_Lock                : out std_logic;
		IP2Bus_Mst_Reset               : out std_logic;
		Bus2IP_Mst_CmdAck              : in  std_logic;
		Bus2IP_Mst_Cmplt               : in  std_logic;
		Bus2IP_Mst_Error               : in  std_logic;
		Bus2IP_Mst_Rearbitrate         : in  std_logic;
		Bus2IP_Mst_Cmd_Timeout         : in  std_logic;
		Bus2IP_MstRd_d                 : in  std_logic_vector(0 to C_MST_DWIDTH-1);
		Bus2IP_MstRd_src_rdy_n         : in  std_logic;
		IP2Bus_MstWr_d                 : out std_logic_vector(0 to C_MST_DWIDTH-1);
		Bus2IP_MstWr_dst_rdy_n         : in  std_logic
    );
  end component plb_master_driver;

begin

  ------------------------------------------
  -- instantiate plbv46_master_single
  ------------------------------------------
  PLBV46_MASTER_SINGLE_I : entity plbv46_master_single_v1_01_a.plbv46_master_single
    generic map
    (
      C_MPLB_AWIDTH                  => C_MPLB_AWIDTH,
      C_MPLB_DWIDTH                  => C_MPLB_DWIDTH,
      C_MPLB_NATIVE_DWIDTH           => IPIF_MST_DWIDTH,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      MPLB_Clk                       => MPLB_Clk,
      MPLB_Rst                       => MPLB_Rst,
      M_request                      => M_request,
      M_priority                     => M_priority,
      M_busLock                      => M_busLock,
      M_RNW                          => M_RNW,
      M_BE                           => M_BE,
      M_MSize                        => M_MSize,
      M_size                         => M_size,
      M_type                         => M_type,
      M_TAttribute                   => M_TAttribute,
      M_lockErr                      => M_lockErr,
      M_abort                        => M_abort,
      M_UABus                        => M_UABus,
      M_ABus                         => M_ABus,
      M_wrDBus                       => M_wrDBus,
      M_wrBurst                      => M_wrBurst,
      M_rdBurst                      => M_rdBurst,
      PLB_MAddrAck                   => PLB_MAddrAck,
      PLB_MSSize                     => PLB_MSSize,
      PLB_MRearbitrate               => PLB_MRearbitrate,
      PLB_MTimeout                   => PLB_MTimeout,
      PLB_MBusy                      => PLB_MBusy,
      PLB_MRdErr                     => PLB_MRdErr,
      PLB_MWrErr                     => PLB_MWrErr,
      PLB_MIRQ                       => PLB_MIRQ,
      PLB_MRdDBus                    => PLB_MRdDBus,
      PLB_MRdWdAddr                  => PLB_MRdWdAddr,
      PLB_MRdDAck                    => PLB_MRdDAck,
      PLB_MRdBTerm                   => PLB_MRdBTerm,
      PLB_MWrDAck                    => PLB_MWrDAck,
      PLB_MWrBTerm                   => PLB_MWrBTerm,
      IP2Bus_MstRd_Req               => ipif_IP2Bus_MstRd_Req,
      IP2Bus_MstWr_Req               => ipif_IP2Bus_MstWr_Req,
      IP2Bus_Mst_Addr                => ipif_IP2Bus_Mst_Addr,
      IP2Bus_Mst_BE                  => ipif_IP2Bus_Mst_BE,
      IP2Bus_Mst_Lock                => ipif_IP2Bus_Mst_Lock,
      IP2Bus_Mst_Reset               => ipif_IP2Bus_Mst_Reset,
      Bus2IP_Mst_CmdAck              => ipif_Bus2IP_Mst_CmdAck,
      Bus2IP_Mst_Cmplt               => ipif_Bus2IP_Mst_Cmplt,
      Bus2IP_Mst_Error               => ipif_Bus2IP_Mst_Error,
      Bus2IP_Mst_Rearbitrate         => ipif_Bus2IP_Mst_Rearbitrate,
      Bus2IP_Mst_Cmd_Timeout         => ipif_Bus2IP_Mst_Cmd_Timeout,
      Bus2IP_MstRd_d                 => ipif_Bus2IP_MstRd_d,
      Bus2IP_MstRd_src_rdy_n         => ipif_Bus2IP_MstRd_src_rdy_n,
      IP2Bus_MstWr_d                 => ipif_IP2Bus_MstWr_d,
      Bus2IP_MstWr_dst_rdy_n         => ipif_Bus2IP_MstWr_dst_rdy_n
    );

  ------------------------------------------
  -- instantiate plb_master_driver
  ------------------------------------------
  PLB_MASTER_DRIVER_I : component plb_master_driver
    generic map
    (
      C_MST_AWIDTH                   => USER_MST_AWIDTH,
      C_MST_DWIDTH                   => USER_MST_DWIDTH
    )
    port map
    (
	  ADDR					=> SIMPBUS_ADDR,
	  WRITE_DATA			=> SIMPBUS_WDATA,
	  READ_DATA				=> SIMPBUS_RDATA,
	  RNW					=> SIMPBUS_RNW,
	  BE					=> SIMPBUS_BE,
	  START					=> SIMPBUS_START,
	  DONE					=> SIMPBUS_DONE,
	  ERR					=> SIMPBUS_ERR,

      Bus2IP_Clk                     => MPLB_Clk,
      Bus2IP_Reset                   => MPLB_Rst,
      IP2Bus_MstRd_Req               => ipif_IP2Bus_MstRd_Req,
      IP2Bus_MstWr_Req               => ipif_IP2Bus_MstWr_Req,
      IP2Bus_Mst_Addr                => ipif_IP2Bus_Mst_Addr,
      IP2Bus_Mst_BE                  => ipif_IP2Bus_Mst_BE,
      IP2Bus_Mst_Lock                => ipif_IP2Bus_Mst_Lock,
      IP2Bus_Mst_Reset               => ipif_IP2Bus_Mst_Reset,
      Bus2IP_Mst_CmdAck              => ipif_Bus2IP_Mst_CmdAck,
      Bus2IP_Mst_Cmplt               => ipif_Bus2IP_Mst_Cmplt,
      Bus2IP_Mst_Error               => ipif_Bus2IP_Mst_Error,
      Bus2IP_Mst_Rearbitrate         => ipif_Bus2IP_Mst_Rearbitrate,
      Bus2IP_Mst_Cmd_Timeout         => ipif_Bus2IP_Mst_Cmd_Timeout,
      Bus2IP_MstRd_d                 => ipif_Bus2IP_MstRd_d,
      Bus2IP_MstRd_src_rdy_n         => ipif_Bus2IP_MstRd_src_rdy_n,
      IP2Bus_MstWr_d                 => ipif_IP2Bus_MstWr_d,
      Bus2IP_MstWr_dst_rdy_n         => ipif_Bus2IP_MstWr_dst_rdy_n
    );

end IMP;
