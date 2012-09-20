-------------------------------------------------------------------------------
-- system_plbv46_pcie_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library plbv46_pcie_v4_07_a;
use plbv46_pcie_v4_07_a.all;

entity system_plbv46_pcie_0_wrapper is
  port (
    MPLB_Clk : in std_logic;
    MPLB_Rst : in std_logic;
    PLB_MTimeout : in std_logic;
    PLB_MIRQ : in std_logic;
    PLB_MAddrAck : in std_logic;
    PLB_MSSize : in std_logic_vector(0 to 1);
    PLB_MRearbitrate : in std_logic;
    PLB_MBusy : in std_logic;
    PLB_MRdErr : in std_logic;
    PLB_MWrErr : in std_logic;
    PLB_MWrDAck : in std_logic;
    PLB_MRdDBus : in std_logic_vector(0 to 63);
    PLB_MRdWdAddr : in std_logic_vector(0 to 3);
    PLB_MRdDAck : in std_logic;
    PLB_MRdBTerm : in std_logic;
    PLB_MWrBTerm : in std_logic;
    M_request : out std_logic;
    M_priority : out std_logic_vector(0 to 1);
    M_buslock : out std_logic;
    M_RNW : out std_logic;
    M_BE : out std_logic_vector(0 to 7);
    M_MSize : out std_logic_vector(0 to 1);
    M_size : out std_logic_vector(0 to 3);
    M_type : out std_logic_vector(0 to 2);
    M_lockErr : out std_logic;
    M_abort : out std_logic;
    M_TAttribute : out std_logic_vector(0 to 15);
    M_UABus : out std_logic_vector(0 to 31);
    M_ABus : out std_logic_vector(0 to 31);
    M_wrDBus : out std_logic_vector(0 to 63);
    M_wrBurst : out std_logic;
    M_rdBurst : out std_logic;
    SPLB_Clk : in std_logic;
    SPLB_Rst : in std_logic;
    PLB_ABus : in std_logic_vector(0 to 31);
    PLB_UABus : in std_logic_vector(0 to 31);
    PLB_PAValid : in std_logic;
    PLB_SAValid : in std_logic;
    PLB_rdPrim : in std_logic;
    PLB_wrPrim : in std_logic;
    PLB_masterID : in std_logic_vector(0 to 1);
    PLB_abort : in std_logic;
    PLB_busLock : in std_logic;
    PLB_RNW : in std_logic;
    PLB_BE : in std_logic_vector(0 to 7);
    PLB_MSize : in std_logic_vector(0 to 1);
    PLB_size : in std_logic_vector(0 to 3);
    PLB_type : in std_logic_vector(0 to 2);
    PLB_lockErr : in std_logic;
    PLB_wrDBus : in std_logic_vector(0 to 63);
    PLB_wrBurst : in std_logic;
    PLB_rdBurst : in std_logic;
    PLB_wrPendReq : in std_logic;
    PLB_rdPendReq : in std_logic;
    PLB_wrPendPri : in std_logic_vector(0 to 1);
    PLB_rdPendPri : in std_logic_vector(0 to 1);
    PLB_reqPri : in std_logic_vector(0 to 1);
    PLB_TAttribute : in std_logic_vector(0 to 15);
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
    REFCLK : in std_logic;
    Bridge_Clk : out std_logic;
    RXN : in std_logic_vector(0 to 0);
    RXP : in std_logic_vector(0 to 0);
    TXN : out std_logic_vector(0 to 0);
    TXP : out std_logic_vector(0 to 0);
    IP2INTC_Irpt : out std_logic;
    MSI_request : in std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of system_plbv46_pcie_0_wrapper : entity is "plbv46_pcie_v4_07_a";

end system_plbv46_pcie_0_wrapper;

architecture STRUCTURE of system_plbv46_pcie_0_wrapper is

  component plbv46_pcie is
    generic (
      C_FAMILY : STRING;
      C_SUBFAMILY : STRING;
      C_IPIFBAR_NUM : INTEGER;
      C_INCLUDE_BAROFFSET_REG : INTEGER;
      C_PCIBAR_NUM : INTEGER;
      C_NO_OF_LANES : INTEGER;
      C_DEVICE_ID : std_logic_vector;
      C_VENDOR_ID : std_logic_vector;
      C_CLASS_CODE : std_logic_vector;
      C_REF_CLK_FREQ : integer;
      C_REV_ID : std_logic_vector;
      C_SUBSYSTEM_ID : std_logic_vector;
      C_SUBSYSTEM_VENDOR_ID : std_logic_vector;
      C_COMP_TIMEOUT : INTEGER;
      C_INCLUDE_RC : INTEGER;
      C_MPLB_AWIDTH : INTEGER;
      C_MPLB_DWIDTH : INTEGER;
      C_MPLB_SMALLEST_SLAVE : INTEGER;
      C_MPLB_NATIVE_DWIDTH : INTEGER;
      C_SPLB_MID_WIDTH : INTEGER;
      C_SPLB_NUM_MASTERS : INTEGER;
      C_SPLB_SMALLEST_MASTER : INTEGER;
      C_SPLB_AWIDTH : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_SPLB_DWIDTH : INTEGER;
      C_SPLB_NATIVE_DWIDTH : INTEGER;
      C_IPIFBAR_0 : std_logic_vector;
      C_IPIFBAR_1 : std_logic_vector;
      C_IPIFBAR_2 : std_logic_vector;
      C_IPIFBAR_3 : std_logic_vector;
      C_IPIFBAR_4 : std_logic_vector;
      C_IPIFBAR_5 : std_logic_vector;
      C_IPIFBAR_HIGHADDR_0 : std_logic_vector;
      C_IPIFBAR_HIGHADDR_1 : std_logic_vector;
      C_IPIFBAR_HIGHADDR_2 : std_logic_vector;
      C_IPIFBAR_HIGHADDR_3 : std_logic_vector;
      C_IPIFBAR_HIGHADDR_4 : std_logic_vector;
      C_IPIFBAR_HIGHADDR_5 : std_logic_vector;
      C_IPIFBAR2PCIBAR_0 : std_logic_vector;
      C_IPIFBAR2PCIBAR_1 : std_logic_vector;
      C_IPIFBAR2PCIBAR_2 : std_logic_vector;
      C_IPIFBAR2PCIBAR_3 : std_logic_vector;
      C_IPIFBAR2PCIBAR_4 : std_logic_vector;
      C_IPIFBAR2PCIBAR_5 : std_logic_vector;
      C_IPIFBAR_AS_0 : INTEGER;
      C_IPIFBAR_AS_1 : INTEGER;
      C_IPIFBAR_AS_2 : INTEGER;
      C_IPIFBAR_AS_3 : INTEGER;
      C_IPIFBAR_AS_4 : INTEGER;
      C_IPIFBAR_AS_5 : INTEGER;
      C_IPIFBAR_SPACE_TYPE_0 : INTEGER;
      C_IPIFBAR_SPACE_TYPE_1 : INTEGER;
      C_IPIFBAR_SPACE_TYPE_2 : INTEGER;
      C_IPIFBAR_SPACE_TYPE_3 : INTEGER;
      C_IPIFBAR_SPACE_TYPE_4 : INTEGER;
      C_IPIFBAR_SPACE_TYPE_5 : INTEGER;
      C_ECAM_BASEADDR : std_logic_vector;
      C_ECAM_HIGHADDR : std_logic_vector;
      C_PCIBAR2IPIFBAR_0 : std_logic_vector;
      C_PCIBAR2IPIFBAR_1 : std_logic_vector;
      C_PCIBAR2IPIFBAR_2 : std_logic_vector;
      C_PCIBAR_LEN_0 : INTEGER;
      C_PCIBAR_LEN_1 : INTEGER;
      C_PCIBAR_LEN_2 : INTEGER;
      C_PCIBAR_AS : INTEGER;
      C_PCIE_CAP_SLOT_IMPLEMENTED : INTEGER
    );
    port (
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MBusy : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to (C_MPLB_DWIDTH-1));
      PLB_MRdWdAddr : in std_logic_vector(0 to 3);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_buslock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to ((C_MPLB_DWIDTH/8)-1));
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_UABus : out std_logic_vector(0 to 31);
      M_ABus : out std_logic_vector(0 to (C_MPLB_AWIDTH-1));
      M_wrDBus : out std_logic_vector(0 to (C_MPLB_DWIDTH-1));
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to (C_SPLB_MID_WIDTH-1));
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to ((C_SPLB_DWIDTH/8)-1));
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to (C_SPLB_DWIDTH-1));
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
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
      REFCLK : in std_logic;
      Bridge_Clk : out std_logic;
      RXN : in std_logic_vector((C_NO_OF_LANES-1) to 0);
      RXP : in std_logic_vector((C_NO_OF_LANES-1) to 0);
      TXN : out std_logic_vector((C_NO_OF_LANES-1) to 0);
      TXP : out std_logic_vector((C_NO_OF_LANES-1) to 0);
      IP2INTC_Irpt : out std_logic;
      MSI_request : in std_logic
    );
  end component;

begin

  plbv46_pcie_0 : plbv46_pcie
    generic map (
      C_FAMILY => "virtex6",
      C_SUBFAMILY => "lx",
      C_IPIFBAR_NUM => 6,
      C_INCLUDE_BAROFFSET_REG => 1,
      C_PCIBAR_NUM => 1,
      C_NO_OF_LANES => 1,
      C_DEVICE_ID => X"0509",
      C_VENDOR_ID => X"10EE",
      C_CLASS_CODE => X"058000",
      C_REF_CLK_FREQ => 2,
      C_REV_ID => X"00",
      C_SUBSYSTEM_ID => X"0000",
      C_SUBSYSTEM_VENDOR_ID => X"0000",
      C_COMP_TIMEOUT => 1,
      C_INCLUDE_RC => 0,
      C_MPLB_AWIDTH => 32,
      C_MPLB_DWIDTH => 64,
      C_MPLB_SMALLEST_SLAVE => 32,
      C_MPLB_NATIVE_DWIDTH => 64,
      C_SPLB_MID_WIDTH => 2,
      C_SPLB_NUM_MASTERS => 3,
      C_SPLB_SMALLEST_MASTER => 32,
      C_SPLB_AWIDTH => 32,
      C_BASEADDR => X"85c00000",
      C_HIGHADDR => X"85c0ffff",
      C_SPLB_DWIDTH => 64,
      C_SPLB_NATIVE_DWIDTH => 64,
      C_IPIFBAR_0 => X"A0000000",
      C_IPIFBAR_1 => X"A0400000",
      C_IPIFBAR_2 => X"A0800000",
      C_IPIFBAR_3 => X"A0C00000",
      C_IPIFBAR_4 => X"A1000000",
      C_IPIFBAR_5 => X"A1400000",
      C_IPIFBAR_HIGHADDR_0 => X"A03FFFFF",
      C_IPIFBAR_HIGHADDR_1 => X"A07FFFFF",
      C_IPIFBAR_HIGHADDR_2 => X"A0BFFFFF",
      C_IPIFBAR_HIGHADDR_3 => X"A0FFFFFF",
      C_IPIFBAR_HIGHADDR_4 => X"A13FFFFF",
      C_IPIFBAR_HIGHADDR_5 => X"A17FFFFF",
      C_IPIFBAR2PCIBAR_0 => X"00000000",
      C_IPIFBAR2PCIBAR_1 => X"00000000",
      C_IPIFBAR2PCIBAR_2 => X"00000000",
      C_IPIFBAR2PCIBAR_3 => X"00000000",
      C_IPIFBAR2PCIBAR_4 => X"00000000",
      C_IPIFBAR2PCIBAR_5 => X"00000000",
      C_IPIFBAR_AS_0 => 0,
      C_IPIFBAR_AS_1 => 0,
      C_IPIFBAR_AS_2 => 0,
      C_IPIFBAR_AS_3 => 0,
      C_IPIFBAR_AS_4 => 0,
      C_IPIFBAR_AS_5 => 0,
      C_IPIFBAR_SPACE_TYPE_0 => 1,
      C_IPIFBAR_SPACE_TYPE_1 => 1,
      C_IPIFBAR_SPACE_TYPE_2 => 1,
      C_IPIFBAR_SPACE_TYPE_3 => 1,
      C_IPIFBAR_SPACE_TYPE_4 => 1,
      C_IPIFBAR_SPACE_TYPE_5 => 1,
      C_ECAM_BASEADDR => X"FFFFFFFF",
      C_ECAM_HIGHADDR => X"00000000",
      C_PCIBAR2IPIFBAR_0 => X"80000000",
      C_PCIBAR2IPIFBAR_1 => X"FFFFFFFF",
      C_PCIBAR2IPIFBAR_2 => X"FFFFFFFF",
      C_PCIBAR_LEN_0 => 13,
      C_PCIBAR_LEN_1 => 16,
      C_PCIBAR_LEN_2 => 16,
      C_PCIBAR_AS => 1,
      C_PCIE_CAP_SLOT_IMPLEMENTED => 1
    )
    port map (
      MPLB_Clk => MPLB_Clk,
      MPLB_Rst => MPLB_Rst,
      PLB_MTimeout => PLB_MTimeout,
      PLB_MIRQ => PLB_MIRQ,
      PLB_MAddrAck => PLB_MAddrAck,
      PLB_MSSize => PLB_MSSize,
      PLB_MRearbitrate => PLB_MRearbitrate,
      PLB_MBusy => PLB_MBusy,
      PLB_MRdErr => PLB_MRdErr,
      PLB_MWrErr => PLB_MWrErr,
      PLB_MWrDAck => PLB_MWrDAck,
      PLB_MRdDBus => PLB_MRdDBus,
      PLB_MRdWdAddr => PLB_MRdWdAddr,
      PLB_MRdDAck => PLB_MRdDAck,
      PLB_MRdBTerm => PLB_MRdBTerm,
      PLB_MWrBTerm => PLB_MWrBTerm,
      M_request => M_request,
      M_priority => M_priority,
      M_buslock => M_buslock,
      M_RNW => M_RNW,
      M_BE => M_BE,
      M_MSize => M_MSize,
      M_size => M_size,
      M_type => M_type,
      M_lockErr => M_lockErr,
      M_abort => M_abort,
      M_TAttribute => M_TAttribute,
      M_UABus => M_UABus,
      M_ABus => M_ABus,
      M_wrDBus => M_wrDBus,
      M_wrBurst => M_wrBurst,
      M_rdBurst => M_rdBurst,
      SPLB_Clk => SPLB_Clk,
      SPLB_Rst => SPLB_Rst,
      PLB_ABus => PLB_ABus,
      PLB_UABus => PLB_UABus,
      PLB_PAValid => PLB_PAValid,
      PLB_SAValid => PLB_SAValid,
      PLB_rdPrim => PLB_rdPrim,
      PLB_wrPrim => PLB_wrPrim,
      PLB_masterID => PLB_masterID,
      PLB_abort => PLB_abort,
      PLB_busLock => PLB_busLock,
      PLB_RNW => PLB_RNW,
      PLB_BE => PLB_BE,
      PLB_MSize => PLB_MSize,
      PLB_size => PLB_size,
      PLB_type => PLB_type,
      PLB_lockErr => PLB_lockErr,
      PLB_wrDBus => PLB_wrDBus,
      PLB_wrBurst => PLB_wrBurst,
      PLB_rdBurst => PLB_rdBurst,
      PLB_wrPendReq => PLB_wrPendReq,
      PLB_rdPendReq => PLB_rdPendReq,
      PLB_wrPendPri => PLB_wrPendPri,
      PLB_rdPendPri => PLB_rdPendPri,
      PLB_reqPri => PLB_reqPri,
      PLB_TAttribute => PLB_TAttribute,
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
      REFCLK => REFCLK,
      Bridge_Clk => Bridge_Clk,
      RXN => RXN,
      RXP => RXP,
      TXN => TXN,
      TXP => TXP,
      IP2INTC_Irpt => IP2INTC_Irpt,
      MSI_request => MSI_request
    );

end architecture STRUCTURE;

