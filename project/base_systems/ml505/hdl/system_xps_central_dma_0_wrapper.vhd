-------------------------------------------------------------------------------
-- system_xps_central_dma_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library xps_central_dma_v2_03_a;
use xps_central_dma_v2_03_a.all;

entity system_xps_central_dma_0_wrapper is
  port (
    SPLB_Clk : in std_logic;
    SPLB_Rst : in std_logic;
    MPLB_Clk : in std_logic;
    MPLB_Rst : in std_logic;
    SPLB_ABus : in std_logic_vector(0 to 31);
    SPLB_BE : in std_logic_vector(0 to 7);
    SPLB_UABus : in std_logic_vector(0 to 31);
    SPLB_PAValid : in std_logic;
    SPLB_SAValid : in std_logic;
    SPLB_rdPrim : in std_logic;
    SPLB_wrPrim : in std_logic;
    SPLB_masterID : in std_logic_vector(0 to 1);
    SPLB_abort : in std_logic;
    SPLB_busLock : in std_logic;
    SPLB_RNW : in std_logic;
    SPLB_MSize : in std_logic_vector(0 to 1);
    SPLB_size : in std_logic_vector(0 to 3);
    SPLB_type : in std_logic_vector(0 to 2);
    SPLB_lockErr : in std_logic;
    SPLB_wrDBus : in std_logic_vector(0 to 63);
    SPLB_wrBurst : in std_logic;
    SPLB_rdBurst : in std_logic;
    SPLB_wrPendReq : in std_logic;
    SPLB_rdPendReq : in std_logic;
    SPLB_wrPendPri : in std_logic_vector(0 to 1);
    SPLB_rdPendPri : in std_logic_vector(0 to 1);
    SPLB_reqPri : in std_logic_vector(0 to 1);
    SPLB_TAttribute : in std_logic_vector(0 to 15);
    Sl_addrAck : out std_logic;
    Sl_SSize : out std_logic_vector(0 to 1);
    Sl_wait : out std_logic;
    Sl_rearbitrate : out std_logic;
    Sl_wrDAck : out std_logic;
    Sl_wrComp : out std_logic;
    Sl_wrBTerm : out std_logic;
    Sl_rdDBus : out std_logic_vector(0 to 63);
    Sl_rdWdAddr : out std_logic_vector(0 to 3);
    Sl_rdDAck : out std_logic;
    Sl_rdComp : out std_logic;
    Sl_rdBTerm : out std_logic;
    Sl_MBusy : out std_logic_vector(0 to 2);
    Sl_MWrErr : out std_logic_vector(0 to 2);
    Sl_MRdErr : out std_logic_vector(0 to 2);
    Sl_MIRQ : out std_logic_vector(0 to 2);
    IP2INTC_Irpt : out std_logic;
    MPLB_MAddrAck : in std_logic;
    MPLB_MSSize : in std_logic_vector(0 to 1);
    MPLB_MRearbitrate : in std_logic;
    MPLB_MTimeout : in std_logic;
    MPLB_MBusy : in std_logic;
    MPLB_MRdErr : in std_logic;
    MPLB_MWrErr : in std_logic;
    MPLB_MIRQ : in std_logic;
    MPLB_MRdDBus : in std_logic_vector(0 to 63);
    MPLB_MRdWdAddr : in std_logic_vector(0 to 3);
    MPLB_MRdDAck : in std_logic;
    MPLB_MRdBTerm : in std_logic;
    MPLB_MWrDAck : in std_logic;
    MPLB_MWrBTerm : in std_logic;
    M_request : out std_logic;
    M_priority : out std_logic_vector(0 to 1);
    M_busLock : out std_logic;
    M_RNW : out std_logic;
    M_BE : out std_logic_vector(0 to 7);
    M_MSize : out std_logic_vector(0 to 1);
    M_size : out std_logic_vector(0 to 3);
    M_type : out std_logic_vector(0 to 2);
    M_TAttribute : out std_logic_vector(0 to 15);
    M_lockErr : out std_logic;
    M_abort : out std_logic;
    M_UABus : out std_logic_vector(0 to 31);
    M_ABus : out std_logic_vector(0 to 31);
    M_wrDBus : out std_logic_vector(0 to 63);
    M_wrBurst : out std_logic;
    M_rdBurst : out std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of system_xps_central_dma_0_wrapper : entity is "xps_central_dma_v2_03_a";

end system_xps_central_dma_0_wrapper;

architecture STRUCTURE of system_xps_central_dma_0_wrapper is

  component xps_central_dma is
    generic (
      C_FIFO_DEPTH : INTEGER;
      C_RD_BURST_SIZE : INTEGER;
      C_WR_BURST_SIZE : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_SPLB_DWIDTH : INTEGER;
      C_SPLB_AWIDTH : INTEGER;
      C_SPLB_NUM_MASTERS : INTEGER;
      C_SPLB_MID_WIDTH : INTEGER;
      C_SPLB_P2P : INTEGER;
      C_SPLB_NATIVE_DWIDTH : INTEGER;
      C_MPLB_NATIVE_DWIDTH : INTEGER;
      C_SPLB_SUPPORT_BURSTS : INTEGER;
      C_MPLB_AWIDTH : INTEGER;
      C_MPLB_DWIDTH : INTEGER;
      C_FAMILY : STRING
    );
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      SPLB_ABus : in std_logic_vector(0 to (C_SPLB_AWIDTH-1));
      SPLB_BE : in std_logic_vector(0 to ((C_SPLB_DWIDTH/8)-1));
      SPLB_UABus : in std_logic_vector(0 to 31);
      SPLB_PAValid : in std_logic;
      SPLB_SAValid : in std_logic;
      SPLB_rdPrim : in std_logic;
      SPLB_wrPrim : in std_logic;
      SPLB_masterID : in std_logic_vector(0 to (C_SPLB_MID_WIDTH-1));
      SPLB_abort : in std_logic;
      SPLB_busLock : in std_logic;
      SPLB_RNW : in std_logic;
      SPLB_MSize : in std_logic_vector(0 to 1);
      SPLB_size : in std_logic_vector(0 to 3);
      SPLB_type : in std_logic_vector(0 to 2);
      SPLB_lockErr : in std_logic;
      SPLB_wrDBus : in std_logic_vector(0 to (C_SPLB_DWIDTH-1));
      SPLB_wrBurst : in std_logic;
      SPLB_rdBurst : in std_logic;
      SPLB_wrPendReq : in std_logic;
      SPLB_rdPendReq : in std_logic;
      SPLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB_reqPri : in std_logic_vector(0 to 1);
      SPLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to (C_SPLB_DWIDTH-1));
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MWrErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MRdErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MIRQ : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      IP2INTC_Irpt : out std_logic;
      MPLB_MAddrAck : in std_logic;
      MPLB_MSSize : in std_logic_vector(0 to 1);
      MPLB_MRearbitrate : in std_logic;
      MPLB_MTimeout : in std_logic;
      MPLB_MBusy : in std_logic;
      MPLB_MRdErr : in std_logic;
      MPLB_MWrErr : in std_logic;
      MPLB_MIRQ : in std_logic;
      MPLB_MRdDBus : in std_logic_vector(0 to (C_MPLB_DWIDTH-1));
      MPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      MPLB_MRdDAck : in std_logic;
      MPLB_MRdBTerm : in std_logic;
      MPLB_MWrDAck : in std_logic;
      MPLB_MWrBTerm : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to ((C_MPLB_DWIDTH/8)-1));
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      M_ABus : out std_logic_vector(0 to (C_MPLB_AWIDTH-1));
      M_wrDBus : out std_logic_vector(0 to (C_MPLB_DWIDTH-1));
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic
    );
  end component;

begin

  xps_central_dma_0 : xps_central_dma
    generic map (
      C_FIFO_DEPTH => 32,
      C_RD_BURST_SIZE => 16,
      C_WR_BURST_SIZE => 16,
      C_BASEADDR => X"80200000",
      C_HIGHADDR => X"8020ffff",
      C_SPLB_DWIDTH => 64,
      C_SPLB_AWIDTH => 32,
      C_SPLB_NUM_MASTERS => 3,
      C_SPLB_MID_WIDTH => 2,
      C_SPLB_P2P => 0,
      C_SPLB_NATIVE_DWIDTH => 32,
      C_MPLB_NATIVE_DWIDTH => 32,
      C_SPLB_SUPPORT_BURSTS => 0,
      C_MPLB_AWIDTH => 32,
      C_MPLB_DWIDTH => 64,
      C_FAMILY => "virtex5"
    )
    port map (
      SPLB_Clk => SPLB_Clk,
      SPLB_Rst => SPLB_Rst,
      MPLB_Clk => MPLB_Clk,
      MPLB_Rst => MPLB_Rst,
      SPLB_ABus => SPLB_ABus,
      SPLB_BE => SPLB_BE,
      SPLB_UABus => SPLB_UABus,
      SPLB_PAValid => SPLB_PAValid,
      SPLB_SAValid => SPLB_SAValid,
      SPLB_rdPrim => SPLB_rdPrim,
      SPLB_wrPrim => SPLB_wrPrim,
      SPLB_masterID => SPLB_masterID,
      SPLB_abort => SPLB_abort,
      SPLB_busLock => SPLB_busLock,
      SPLB_RNW => SPLB_RNW,
      SPLB_MSize => SPLB_MSize,
      SPLB_size => SPLB_size,
      SPLB_type => SPLB_type,
      SPLB_lockErr => SPLB_lockErr,
      SPLB_wrDBus => SPLB_wrDBus,
      SPLB_wrBurst => SPLB_wrBurst,
      SPLB_rdBurst => SPLB_rdBurst,
      SPLB_wrPendReq => SPLB_wrPendReq,
      SPLB_rdPendReq => SPLB_rdPendReq,
      SPLB_wrPendPri => SPLB_wrPendPri,
      SPLB_rdPendPri => SPLB_rdPendPri,
      SPLB_reqPri => SPLB_reqPri,
      SPLB_TAttribute => SPLB_TAttribute,
      Sl_addrAck => Sl_addrAck,
      Sl_SSize => Sl_SSize,
      Sl_wait => Sl_wait,
      Sl_rearbitrate => Sl_rearbitrate,
      Sl_wrDAck => Sl_wrDAck,
      Sl_wrComp => Sl_wrComp,
      Sl_wrBTerm => Sl_wrBTerm,
      Sl_rdDBus => Sl_rdDBus,
      Sl_rdWdAddr => Sl_rdWdAddr,
      Sl_rdDAck => Sl_rdDAck,
      Sl_rdComp => Sl_rdComp,
      Sl_rdBTerm => Sl_rdBTerm,
      Sl_MBusy => Sl_MBusy,
      Sl_MWrErr => Sl_MWrErr,
      Sl_MRdErr => Sl_MRdErr,
      Sl_MIRQ => Sl_MIRQ,
      IP2INTC_Irpt => IP2INTC_Irpt,
      MPLB_MAddrAck => MPLB_MAddrAck,
      MPLB_MSSize => MPLB_MSSize,
      MPLB_MRearbitrate => MPLB_MRearbitrate,
      MPLB_MTimeout => MPLB_MTimeout,
      MPLB_MBusy => MPLB_MBusy,
      MPLB_MRdErr => MPLB_MRdErr,
      MPLB_MWrErr => MPLB_MWrErr,
      MPLB_MIRQ => MPLB_MIRQ,
      MPLB_MRdDBus => MPLB_MRdDBus,
      MPLB_MRdWdAddr => MPLB_MRdWdAddr,
      MPLB_MRdDAck => MPLB_MRdDAck,
      MPLB_MRdBTerm => MPLB_MRdBTerm,
      MPLB_MWrDAck => MPLB_MWrDAck,
      MPLB_MWrBTerm => MPLB_MWrBTerm,
      M_request => M_request,
      M_priority => M_priority,
      M_busLock => M_busLock,
      M_RNW => M_RNW,
      M_BE => M_BE,
      M_MSize => M_MSize,
      M_size => M_size,
      M_type => M_type,
      M_TAttribute => M_TAttribute,
      M_lockErr => M_lockErr,
      M_abort => M_abort,
      M_UABus => M_UABus,
      M_ABus => M_ABus,
      M_wrDBus => M_wrDBus,
      M_wrBurst => M_wrBurst,
      M_rdBurst => M_rdBurst
    );

end architecture STRUCTURE;

