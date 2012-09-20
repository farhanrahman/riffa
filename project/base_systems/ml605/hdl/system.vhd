-------------------------------------------------------------------------------
-- system.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system is
  port (
    fpga_0_clk_1_sys_clk_p_pin : in std_logic;
    fpga_0_clk_1_sys_clk_n_pin : in std_logic;
    fpga_0_rst_1_sys_rst_pin : in std_logic;
    fpga_0_PCIe_Bridge_RXN_pin : in std_logic;
    fpga_0_PCIe_Bridge_RXP_pin : in std_logic;
    fpga_0_PCIe_Bridge_TXN_pin : out std_logic;
    fpga_0_PCIe_Bridge_TXP_pin : out std_logic;
    fpga_0_PCIe_Diff_Clk_P_pin : in std_logic;
    fpga_0_PCIe_Diff_Clk_N_pin : in std_logic;
    fpga_0_PCIe_perstn : in std_logic
  );
end system;

architecture STRUCTURE of system is

  component system_pcie_diff_clk_0_wrapper is
    port (
      IBUF_DS_P : in std_logic_vector(0 to 0);
      IBUF_DS_N : in std_logic_vector(0 to 0);
      IBUF_OUT : out std_logic_vector(0 to 0);
      OBUF_IN : in std_logic_vector(0 to 0);
      OBUF_DS_P : out std_logic_vector(0 to 0);
      OBUF_DS_N : out std_logic_vector(0 to 0);
      IOBUF_DS_P : inout std_logic_vector(0 to 0);
      IOBUF_DS_N : inout std_logic_vector(0 to 0);
      IOBUF_IO_T : in std_logic_vector(0 to 0);
      IOBUF_IO_I : in std_logic_vector(0 to 0);
      IOBUF_IO_O : out std_logic_vector(0 to 0)
    );
  end component;

  component system_mb_plb_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 4);
      MPLB_Rst : out std_logic_vector(0 to 2);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 95);
      M_UABus : in std_logic_vector(0 to 95);
      M_BE : in std_logic_vector(0 to 23);
      M_RNW : in std_logic_vector(0 to 2);
      M_abort : in std_logic_vector(0 to 2);
      M_busLock : in std_logic_vector(0 to 2);
      M_TAttribute : in std_logic_vector(0 to 47);
      M_lockErr : in std_logic_vector(0 to 2);
      M_MSize : in std_logic_vector(0 to 5);
      M_priority : in std_logic_vector(0 to 5);
      M_rdBurst : in std_logic_vector(0 to 2);
      M_request : in std_logic_vector(0 to 2);
      M_size : in std_logic_vector(0 to 11);
      M_type : in std_logic_vector(0 to 8);
      M_wrBurst : in std_logic_vector(0 to 2);
      M_wrDBus : in std_logic_vector(0 to 191);
      Sl_addrAck : in std_logic_vector(0 to 4);
      Sl_MRdErr : in std_logic_vector(0 to 14);
      Sl_MWrErr : in std_logic_vector(0 to 14);
      Sl_MBusy : in std_logic_vector(0 to 14);
      Sl_rdBTerm : in std_logic_vector(0 to 4);
      Sl_rdComp : in std_logic_vector(0 to 4);
      Sl_rdDAck : in std_logic_vector(0 to 4);
      Sl_rdDBus : in std_logic_vector(0 to 319);
      Sl_rdWdAddr : in std_logic_vector(0 to 19);
      Sl_rearbitrate : in std_logic_vector(0 to 4);
      Sl_SSize : in std_logic_vector(0 to 9);
      Sl_wait : in std_logic_vector(0 to 4);
      Sl_wrBTerm : in std_logic_vector(0 to 4);
      Sl_wrComp : in std_logic_vector(0 to 4);
      Sl_wrDAck : in std_logic_vector(0 to 4);
      Sl_MIRQ : in std_logic_vector(0 to 14);
      PLB_MIRQ : out std_logic_vector(0 to 2);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 7);
      PLB_MAddrAck : out std_logic_vector(0 to 2);
      PLB_MTimeout : out std_logic_vector(0 to 2);
      PLB_MBusy : out std_logic_vector(0 to 2);
      PLB_MRdErr : out std_logic_vector(0 to 2);
      PLB_MWrErr : out std_logic_vector(0 to 2);
      PLB_MRdBTerm : out std_logic_vector(0 to 2);
      PLB_MRdDAck : out std_logic_vector(0 to 2);
      PLB_MRdDBus : out std_logic_vector(0 to 191);
      PLB_MRdWdAddr : out std_logic_vector(0 to 11);
      PLB_MRearbitrate : out std_logic_vector(0 to 2);
      PLB_MWrBTerm : out std_logic_vector(0 to 2);
      PLB_MWrDAck : out std_logic_vector(0 to 2);
      PLB_MSSize : out std_logic_vector(0 to 5);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 1);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 4);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 63);
      PLB_wrPrim : out std_logic_vector(0 to 4);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 2);
      PLB_SMWrErr : out std_logic_vector(0 to 2);
      PLB_SMBusy : out std_logic_vector(0 to 2);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 63);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component system_proc_sys_reset_0_wrapper is
    port (
      Slowest_sync_clk : in std_logic;
      Ext_Reset_In : in std_logic;
      Aux_Reset_In : in std_logic;
      MB_Debug_Sys_Rst : in std_logic;
      Core_Reset_Req_0 : in std_logic;
      Chip_Reset_Req_0 : in std_logic;
      System_Reset_Req_0 : in std_logic;
      Core_Reset_Req_1 : in std_logic;
      Chip_Reset_Req_1 : in std_logic;
      System_Reset_Req_1 : in std_logic;
      Dcm_locked : in std_logic;
      RstcPPCresetcore_0 : out std_logic;
      RstcPPCresetchip_0 : out std_logic;
      RstcPPCresetsys_0 : out std_logic;
      RstcPPCresetcore_1 : out std_logic;
      RstcPPCresetchip_1 : out std_logic;
      RstcPPCresetsys_1 : out std_logic;
      MB_Reset : out std_logic;
      Bus_Struct_Reset : out std_logic_vector(0 to 0);
      Peripheral_Reset : out std_logic_vector(0 to 0);
      Interconnect_aresetn : out std_logic_vector(0 to 0);
      Peripheral_aresetn : out std_logic_vector(0 to 0)
    );
  end component;

  component system_clock_generator_0_wrapper is
    port (
      CLKIN : in std_logic;
      CLKOUT0 : out std_logic;
      CLKOUT1 : out std_logic;
      CLKOUT2 : out std_logic;
      CLKOUT3 : out std_logic;
      CLKOUT4 : out std_logic;
      CLKOUT5 : out std_logic;
      CLKOUT6 : out std_logic;
      CLKOUT7 : out std_logic;
      CLKOUT8 : out std_logic;
      CLKOUT9 : out std_logic;
      CLKOUT10 : out std_logic;
      CLKOUT11 : out std_logic;
      CLKOUT12 : out std_logic;
      CLKOUT13 : out std_logic;
      CLKOUT14 : out std_logic;
      CLKOUT15 : out std_logic;
      CLKFBIN : in std_logic;
      CLKFBOUT : out std_logic;
      PSCLK : in std_logic;
      PSEN : in std_logic;
      PSINCDEC : in std_logic;
      PSDONE : out std_logic;
      RST : in std_logic;
      LOCKED : out std_logic
    );
  end component;

  component system_plbv46_pcie_0_wrapper is
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
  end component;

  component system_xps_central_dma_0_wrapper is
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
  end component;

  component system_central_notifier_0_wrapper is
    port (
      SYS_CLK : in std_logic;
      SYS_RST : in std_logic;
      INTR_PCI : out std_logic;
      INTR_DMA : in std_logic;
      INIT_START : out std_logic;
      INIT_DONE : in std_logic;
      SIMPBUS_INIT_ADDR : in std_logic_vector(31 downto 0);
      SIMPBUS_INIT_WDATA : in std_logic_vector(31 downto 0);
      SIMPBUS_INIT_RDATA : out std_logic_vector(31 downto 0);
      SIMPBUS_INIT_BE : in std_logic_vector(3 downto 0);
      SIMPBUS_INIT_RNW : in std_logic;
      SIMPBUS_INIT_START : in std_logic;
      SIMPBUS_INIT_DONE : out std_logic;
      SIMPBUS_INIT_ERR : out std_logic;
      SIMPBUS_MST_ADDR : out std_logic_vector(31 downto 0);
      SIMPBUS_MST_WDATA : out std_logic_vector(31 downto 0);
      SIMPBUS_MST_RDATA : in std_logic_vector(31 downto 0);
      SIMPBUS_MST_BE : out std_logic_vector(3 downto 0);
      SIMPBUS_MST_RNW : out std_logic;
      SIMPBUS_MST_START : out std_logic;
      SIMPBUS_MST_DONE : in std_logic;
      SIMPBUS_MST_ERR : in std_logic;
      SIMPBUS_SLV_ADDR : in std_logic_vector(31 downto 0);
      SIMPBUS_SLV_WDATA : in std_logic_vector(31 downto 0);
      SIMPBUS_SLV_RDATA : out std_logic_vector(31 downto 0);
      SIMPBUS_SLV_BE : in std_logic_vector(3 downto 0);
      SIMPBUS_SLV_RNW : in std_logic;
      SIMPBUS_SLV_START : in std_logic;
      SIMPBUS_SLV_DONE : out std_logic;
      SIMPBUS_SLV_ERR : out std_logic;
      INTERRUPT_00 : in std_logic;
      INTERRUPT_ERR_00 : in std_logic;
      INTERRUPT_ACK_00 : out std_logic;
      DOORBELL_00 : out std_logic;
      DOORBELL_ERR_00 : out std_logic;
      DOORBELL_LEN_00 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_00 : out std_logic_vector(31 downto 0);
      DMA_REQ_00 : in std_logic;
      DMA_REQ_ACK_00 : out std_logic;
      DMA_SRC_00 : in std_logic_vector(31 downto 0);
      DMA_DST_00 : in std_logic_vector(31 downto 0);
      DMA_LEN_00 : in std_logic_vector(31 downto 0);
      DMA_SIG_00 : in std_logic;
      DMA_DONE_00 : out std_logic;
      DMA_ERR_00 : out std_logic;
      BUF_REQ_00 : in std_logic;
      BUF_REQ_ACK_00 : out std_logic;
      BUF_REQ_ADDR_00 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_00 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_00 : out std_logic;
      BUF_REQ_ERR_00 : out std_logic;
      BUF_REQD_00 : out std_logic;
      BUF_REQD_ADDR_00 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_00 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_00 : in std_logic;
      BUF_REQD_ERR_00 : in std_logic;
      INTERRUPT_01 : in std_logic;
      INTERRUPT_ERR_01 : in std_logic;
      INTERRUPT_ACK_01 : out std_logic;
      DOORBELL_01 : out std_logic;
      DOORBELL_ERR_01 : out std_logic;
      DOORBELL_LEN_01 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_01 : out std_logic_vector(31 downto 0);
      DMA_REQ_01 : in std_logic;
      DMA_REQ_ACK_01 : out std_logic;
      DMA_SRC_01 : in std_logic_vector(31 downto 0);
      DMA_DST_01 : in std_logic_vector(31 downto 0);
      DMA_LEN_01 : in std_logic_vector(31 downto 0);
      DMA_SIG_01 : in std_logic;
      DMA_DONE_01 : out std_logic;
      DMA_ERR_01 : out std_logic;
      BUF_REQ_01 : in std_logic;
      BUF_REQ_ACK_01 : out std_logic;
      BUF_REQ_ADDR_01 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_01 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_01 : out std_logic;
      BUF_REQ_ERR_01 : out std_logic;
      BUF_REQD_01 : out std_logic;
      BUF_REQD_ADDR_01 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_01 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_01 : in std_logic;
      BUF_REQD_ERR_01 : in std_logic;
      INTERRUPT_02 : in std_logic;
      INTERRUPT_ERR_02 : in std_logic;
      INTERRUPT_ACK_02 : out std_logic;
      DOORBELL_02 : out std_logic;
      DOORBELL_ERR_02 : out std_logic;
      DOORBELL_LEN_02 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_02 : out std_logic_vector(31 downto 0);
      DMA_REQ_02 : in std_logic;
      DMA_REQ_ACK_02 : out std_logic;
      DMA_SRC_02 : in std_logic_vector(31 downto 0);
      DMA_DST_02 : in std_logic_vector(31 downto 0);
      DMA_LEN_02 : in std_logic_vector(31 downto 0);
      DMA_SIG_02 : in std_logic;
      DMA_DONE_02 : out std_logic;
      DMA_ERR_02 : out std_logic;
      BUF_REQ_02 : in std_logic;
      BUF_REQ_ACK_02 : out std_logic;
      BUF_REQ_ADDR_02 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_02 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_02 : out std_logic;
      BUF_REQ_ERR_02 : out std_logic;
      BUF_REQD_02 : out std_logic;
      BUF_REQD_ADDR_02 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_02 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_02 : in std_logic;
      BUF_REQD_ERR_02 : in std_logic;
      INTERRUPT_03 : in std_logic;
      INTERRUPT_ERR_03 : in std_logic;
      INTERRUPT_ACK_03 : out std_logic;
      DOORBELL_03 : out std_logic;
      DOORBELL_ERR_03 : out std_logic;
      DOORBELL_LEN_03 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_03 : out std_logic_vector(31 downto 0);
      DMA_REQ_03 : in std_logic;
      DMA_REQ_ACK_03 : out std_logic;
      DMA_SRC_03 : in std_logic_vector(31 downto 0);
      DMA_DST_03 : in std_logic_vector(31 downto 0);
      DMA_LEN_03 : in std_logic_vector(31 downto 0);
      DMA_SIG_03 : in std_logic;
      DMA_DONE_03 : out std_logic;
      DMA_ERR_03 : out std_logic;
      BUF_REQ_03 : in std_logic;
      BUF_REQ_ACK_03 : out std_logic;
      BUF_REQ_ADDR_03 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_03 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_03 : out std_logic;
      BUF_REQ_ERR_03 : out std_logic;
      BUF_REQD_03 : out std_logic;
      BUF_REQD_ADDR_03 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_03 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_03 : in std_logic;
      BUF_REQD_ERR_03 : in std_logic;
      INTERRUPT_04 : in std_logic;
      INTERRUPT_ERR_04 : in std_logic;
      INTERRUPT_ACK_04 : out std_logic;
      DOORBELL_04 : out std_logic;
      DOORBELL_ERR_04 : out std_logic;
      DOORBELL_LEN_04 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_04 : out std_logic_vector(31 downto 0);
      DMA_REQ_04 : in std_logic;
      DMA_REQ_ACK_04 : out std_logic;
      DMA_SRC_04 : in std_logic_vector(31 downto 0);
      DMA_DST_04 : in std_logic_vector(31 downto 0);
      DMA_LEN_04 : in std_logic_vector(31 downto 0);
      DMA_SIG_04 : in std_logic;
      DMA_DONE_04 : out std_logic;
      DMA_ERR_04 : out std_logic;
      BUF_REQ_04 : in std_logic;
      BUF_REQ_ACK_04 : out std_logic;
      BUF_REQ_ADDR_04 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_04 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_04 : out std_logic;
      BUF_REQ_ERR_04 : out std_logic;
      BUF_REQD_04 : out std_logic;
      BUF_REQD_ADDR_04 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_04 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_04 : in std_logic;
      BUF_REQD_ERR_04 : in std_logic;
      INTERRUPT_05 : in std_logic;
      INTERRUPT_ERR_05 : in std_logic;
      INTERRUPT_ACK_05 : out std_logic;
      DOORBELL_05 : out std_logic;
      DOORBELL_ERR_05 : out std_logic;
      DOORBELL_LEN_05 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_05 : out std_logic_vector(31 downto 0);
      DMA_REQ_05 : in std_logic;
      DMA_REQ_ACK_05 : out std_logic;
      DMA_SRC_05 : in std_logic_vector(31 downto 0);
      DMA_DST_05 : in std_logic_vector(31 downto 0);
      DMA_LEN_05 : in std_logic_vector(31 downto 0);
      DMA_SIG_05 : in std_logic;
      DMA_DONE_05 : out std_logic;
      DMA_ERR_05 : out std_logic;
      BUF_REQ_05 : in std_logic;
      BUF_REQ_ACK_05 : out std_logic;
      BUF_REQ_ADDR_05 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_05 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_05 : out std_logic;
      BUF_REQ_ERR_05 : out std_logic;
      BUF_REQD_05 : out std_logic;
      BUF_REQD_ADDR_05 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_05 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_05 : in std_logic;
      BUF_REQD_ERR_05 : in std_logic;
      INTERRUPT_06 : in std_logic;
      INTERRUPT_ERR_06 : in std_logic;
      INTERRUPT_ACK_06 : out std_logic;
      DOORBELL_06 : out std_logic;
      DOORBELL_ERR_06 : out std_logic;
      DOORBELL_LEN_06 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_06 : out std_logic_vector(31 downto 0);
      DMA_REQ_06 : in std_logic;
      DMA_REQ_ACK_06 : out std_logic;
      DMA_SRC_06 : in std_logic_vector(31 downto 0);
      DMA_DST_06 : in std_logic_vector(31 downto 0);
      DMA_LEN_06 : in std_logic_vector(31 downto 0);
      DMA_SIG_06 : in std_logic;
      DMA_DONE_06 : out std_logic;
      DMA_ERR_06 : out std_logic;
      BUF_REQ_06 : in std_logic;
      BUF_REQ_ACK_06 : out std_logic;
      BUF_REQ_ADDR_06 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_06 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_06 : out std_logic;
      BUF_REQ_ERR_06 : out std_logic;
      BUF_REQD_06 : out std_logic;
      BUF_REQD_ADDR_06 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_06 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_06 : in std_logic;
      BUF_REQD_ERR_06 : in std_logic;
      INTERRUPT_07 : in std_logic;
      INTERRUPT_ERR_07 : in std_logic;
      INTERRUPT_ACK_07 : out std_logic;
      DOORBELL_07 : out std_logic;
      DOORBELL_ERR_07 : out std_logic;
      DOORBELL_LEN_07 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_07 : out std_logic_vector(31 downto 0);
      DMA_REQ_07 : in std_logic;
      DMA_REQ_ACK_07 : out std_logic;
      DMA_SRC_07 : in std_logic_vector(31 downto 0);
      DMA_DST_07 : in std_logic_vector(31 downto 0);
      DMA_LEN_07 : in std_logic_vector(31 downto 0);
      DMA_SIG_07 : in std_logic;
      DMA_DONE_07 : out std_logic;
      DMA_ERR_07 : out std_logic;
      BUF_REQ_07 : in std_logic;
      BUF_REQ_ACK_07 : out std_logic;
      BUF_REQ_ADDR_07 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_07 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_07 : out std_logic;
      BUF_REQ_ERR_07 : out std_logic;
      BUF_REQD_07 : out std_logic;
      BUF_REQD_ADDR_07 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_07 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_07 : in std_logic;
      BUF_REQD_ERR_07 : in std_logic;
      INTERRUPT_08 : in std_logic;
      INTERRUPT_ERR_08 : in std_logic;
      INTERRUPT_ACK_08 : out std_logic;
      DOORBELL_08 : out std_logic;
      DOORBELL_ERR_08 : out std_logic;
      DOORBELL_LEN_08 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_08 : out std_logic_vector(31 downto 0);
      DMA_REQ_08 : in std_logic;
      DMA_REQ_ACK_08 : out std_logic;
      DMA_SRC_08 : in std_logic_vector(31 downto 0);
      DMA_DST_08 : in std_logic_vector(31 downto 0);
      DMA_LEN_08 : in std_logic_vector(31 downto 0);
      DMA_SIG_08 : in std_logic;
      DMA_DONE_08 : out std_logic;
      DMA_ERR_08 : out std_logic;
      BUF_REQ_08 : in std_logic;
      BUF_REQ_ACK_08 : out std_logic;
      BUF_REQ_ADDR_08 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_08 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_08 : out std_logic;
      BUF_REQ_ERR_08 : out std_logic;
      BUF_REQD_08 : out std_logic;
      BUF_REQD_ADDR_08 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_08 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_08 : in std_logic;
      BUF_REQD_ERR_08 : in std_logic;
      INTERRUPT_09 : in std_logic;
      INTERRUPT_ERR_09 : in std_logic;
      INTERRUPT_ACK_09 : out std_logic;
      DOORBELL_09 : out std_logic;
      DOORBELL_ERR_09 : out std_logic;
      DOORBELL_LEN_09 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_09 : out std_logic_vector(31 downto 0);
      DMA_REQ_09 : in std_logic;
      DMA_REQ_ACK_09 : out std_logic;
      DMA_SRC_09 : in std_logic_vector(31 downto 0);
      DMA_DST_09 : in std_logic_vector(31 downto 0);
      DMA_LEN_09 : in std_logic_vector(31 downto 0);
      DMA_SIG_09 : in std_logic;
      DMA_DONE_09 : out std_logic;
      DMA_ERR_09 : out std_logic;
      BUF_REQ_09 : in std_logic;
      BUF_REQ_ACK_09 : out std_logic;
      BUF_REQ_ADDR_09 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_09 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_09 : out std_logic;
      BUF_REQ_ERR_09 : out std_logic;
      BUF_REQD_09 : out std_logic;
      BUF_REQD_ADDR_09 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_09 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_09 : in std_logic;
      BUF_REQD_ERR_09 : in std_logic;
      INTERRUPT_10 : in std_logic;
      INTERRUPT_ERR_10 : in std_logic;
      INTERRUPT_ACK_10 : out std_logic;
      DOORBELL_10 : out std_logic;
      DOORBELL_ERR_10 : out std_logic;
      DOORBELL_LEN_10 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_10 : out std_logic_vector(31 downto 0);
      DMA_REQ_10 : in std_logic;
      DMA_REQ_ACK_10 : out std_logic;
      DMA_SRC_10 : in std_logic_vector(31 downto 0);
      DMA_DST_10 : in std_logic_vector(31 downto 0);
      DMA_LEN_10 : in std_logic_vector(31 downto 0);
      DMA_SIG_10 : in std_logic;
      DMA_DONE_10 : out std_logic;
      DMA_ERR_10 : out std_logic;
      BUF_REQ_10 : in std_logic;
      BUF_REQ_ACK_10 : out std_logic;
      BUF_REQ_ADDR_10 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_10 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_10 : out std_logic;
      BUF_REQ_ERR_10 : out std_logic;
      BUF_REQD_10 : out std_logic;
      BUF_REQD_ADDR_10 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_10 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_10 : in std_logic;
      BUF_REQD_ERR_10 : in std_logic;
      INTERRUPT_11 : in std_logic;
      INTERRUPT_ERR_11 : in std_logic;
      INTERRUPT_ACK_11 : out std_logic;
      DOORBELL_11 : out std_logic;
      DOORBELL_ERR_11 : out std_logic;
      DOORBELL_LEN_11 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_11 : out std_logic_vector(31 downto 0);
      DMA_REQ_11 : in std_logic;
      DMA_REQ_ACK_11 : out std_logic;
      DMA_SRC_11 : in std_logic_vector(31 downto 0);
      DMA_DST_11 : in std_logic_vector(31 downto 0);
      DMA_LEN_11 : in std_logic_vector(31 downto 0);
      DMA_SIG_11 : in std_logic;
      DMA_DONE_11 : out std_logic;
      DMA_ERR_11 : out std_logic;
      BUF_REQ_11 : in std_logic;
      BUF_REQ_ACK_11 : out std_logic;
      BUF_REQ_ADDR_11 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_11 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_11 : out std_logic;
      BUF_REQ_ERR_11 : out std_logic;
      BUF_REQD_11 : out std_logic;
      BUF_REQD_ADDR_11 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_11 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_11 : in std_logic;
      BUF_REQD_ERR_11 : in std_logic;
      INTERRUPT_12 : in std_logic;
      INTERRUPT_ERR_12 : in std_logic;
      INTERRUPT_ACK_12 : out std_logic;
      DOORBELL_12 : out std_logic;
      DOORBELL_ERR_12 : out std_logic;
      DOORBELL_LEN_12 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_12 : out std_logic_vector(31 downto 0);
      DMA_REQ_12 : in std_logic;
      DMA_REQ_ACK_12 : out std_logic;
      DMA_SRC_12 : in std_logic_vector(31 downto 0);
      DMA_DST_12 : in std_logic_vector(31 downto 0);
      DMA_LEN_12 : in std_logic_vector(31 downto 0);
      DMA_SIG_12 : in std_logic;
      DMA_DONE_12 : out std_logic;
      DMA_ERR_12 : out std_logic;
      BUF_REQ_12 : in std_logic;
      BUF_REQ_ACK_12 : out std_logic;
      BUF_REQ_ADDR_12 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_12 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_12 : out std_logic;
      BUF_REQ_ERR_12 : out std_logic;
      BUF_REQD_12 : out std_logic;
      BUF_REQD_ADDR_12 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_12 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_12 : in std_logic;
      BUF_REQD_ERR_12 : in std_logic;
      INTERRUPT_13 : in std_logic;
      INTERRUPT_ERR_13 : in std_logic;
      INTERRUPT_ACK_13 : out std_logic;
      DOORBELL_13 : out std_logic;
      DOORBELL_ERR_13 : out std_logic;
      DOORBELL_LEN_13 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_13 : out std_logic_vector(31 downto 0);
      DMA_REQ_13 : in std_logic;
      DMA_REQ_ACK_13 : out std_logic;
      DMA_SRC_13 : in std_logic_vector(31 downto 0);
      DMA_DST_13 : in std_logic_vector(31 downto 0);
      DMA_LEN_13 : in std_logic_vector(31 downto 0);
      DMA_SIG_13 : in std_logic;
      DMA_DONE_13 : out std_logic;
      DMA_ERR_13 : out std_logic;
      BUF_REQ_13 : in std_logic;
      BUF_REQ_ACK_13 : out std_logic;
      BUF_REQ_ADDR_13 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_13 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_13 : out std_logic;
      BUF_REQ_ERR_13 : out std_logic;
      BUF_REQD_13 : out std_logic;
      BUF_REQD_ADDR_13 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_13 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_13 : in std_logic;
      BUF_REQD_ERR_13 : in std_logic;
      INTERRUPT_14 : in std_logic;
      INTERRUPT_ERR_14 : in std_logic;
      INTERRUPT_ACK_14 : out std_logic;
      DOORBELL_14 : out std_logic;
      DOORBELL_ERR_14 : out std_logic;
      DOORBELL_LEN_14 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_14 : out std_logic_vector(31 downto 0);
      DMA_REQ_14 : in std_logic;
      DMA_REQ_ACK_14 : out std_logic;
      DMA_SRC_14 : in std_logic_vector(31 downto 0);
      DMA_DST_14 : in std_logic_vector(31 downto 0);
      DMA_LEN_14 : in std_logic_vector(31 downto 0);
      DMA_SIG_14 : in std_logic;
      DMA_DONE_14 : out std_logic;
      DMA_ERR_14 : out std_logic;
      BUF_REQ_14 : in std_logic;
      BUF_REQ_ACK_14 : out std_logic;
      BUF_REQ_ADDR_14 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_14 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_14 : out std_logic;
      BUF_REQ_ERR_14 : out std_logic;
      BUF_REQD_14 : out std_logic;
      BUF_REQD_ADDR_14 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_14 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_14 : in std_logic;
      BUF_REQD_ERR_14 : in std_logic;
      INTERRUPT_15 : in std_logic;
      INTERRUPT_ERR_15 : in std_logic;
      INTERRUPT_ACK_15 : out std_logic;
      DOORBELL_15 : out std_logic;
      DOORBELL_ERR_15 : out std_logic;
      DOORBELL_LEN_15 : out std_logic_vector(31 downto 0);
      DOORBELL_ARG_15 : out std_logic_vector(31 downto 0);
      DMA_REQ_15 : in std_logic;
      DMA_REQ_ACK_15 : out std_logic;
      DMA_SRC_15 : in std_logic_vector(31 downto 0);
      DMA_DST_15 : in std_logic_vector(31 downto 0);
      DMA_LEN_15 : in std_logic_vector(31 downto 0);
      DMA_SIG_15 : in std_logic;
      DMA_DONE_15 : out std_logic;
      DMA_ERR_15 : out std_logic;
      BUF_REQ_15 : in std_logic;
      BUF_REQ_ACK_15 : out std_logic;
      BUF_REQ_ADDR_15 : out std_logic_vector(31 downto 0);
      BUF_REQ_SIZE_15 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_15 : out std_logic;
      BUF_REQ_ERR_15 : out std_logic;
      BUF_REQD_15 : out std_logic;
      BUF_REQD_ADDR_15 : in std_logic_vector(31 downto 0);
      BUF_REQD_SIZE_15 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_15 : in std_logic;
      BUF_REQD_ERR_15 : in std_logic
    );
  end component;

  component system_bram_block_0_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component system_xps_bram_if_cntlr_0_wrapper is
    port (
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
      BRAM_Rst : out std_logic;
      BRAM_Clk : out std_logic;
      BRAM_EN : out std_logic;
      BRAM_WEN : out std_logic_vector(0 to 3);
      BRAM_Addr : out std_logic_vector(0 to 31);
      BRAM_Din : in std_logic_vector(0 to 31);
      BRAM_Dout : out std_logic_vector(0 to 31)
    );
  end component;

  component system_simpbus_slv_plbv46_adapter_0_wrapper is
    port (
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
      SIMPBUS_ADDR : out std_logic_vector(0 to 31);
      SIMPBUS_WDATA : out std_logic_vector(0 to 31);
      SIMPBUS_RDATA : in std_logic_vector(0 to 31);
      SIMPBUS_BE : out std_logic_vector(0 to 3);
      SIMPBUS_RNW : out std_logic;
      SIMPBUS_START : out std_logic;
      SIMPBUS_DONE : in std_logic;
      SIMPBUS_ERR : in std_logic
    );
  end component;

  component system_simpbus_mst_plbv46_adapter_0_wrapper is
    port (
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
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
      M_rdBurst : out std_logic;
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MBusy : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 63);
      PLB_MRdWdAddr : in std_logic_vector(0 to 3);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      SIMPBUS_ADDR : in std_logic_vector(0 to 31);
      SIMPBUS_WDATA : in std_logic_vector(0 to 31);
      SIMPBUS_RDATA : out std_logic_vector(0 to 31);
      SIMPBUS_BE : in std_logic_vector(0 to 3);
      SIMPBUS_RNW : in std_logic;
      SIMPBUS_START : in std_logic;
      SIMPBUS_DONE : out std_logic;
      SIMPBUS_ERR : out std_logic
    );
  end component;

  component system_riffa_0_wrapper is
    port (
      SYS_CLK : in std_logic;
      SYS_RST : in std_logic;
      INTERRUPT : out std_logic;
      INTERRUPT_ERR : out std_logic;
      INTERRUPT_ACK : in std_logic;
      DOORBELL : in std_logic;
      DOORBELL_ERR : in std_logic;
      DOORBELL_LEN : in std_logic_vector(31 downto 0);
      DOORBELL_ARG : in std_logic_vector(31 downto 0);
      DMA_REQ : out std_logic;
      DMA_REQ_ACK : in std_logic;
      DMA_SRC : out std_logic_vector(31 downto 0);
      DMA_DST : out std_logic_vector(31 downto 0);
      DMA_LEN : out std_logic_vector(31 downto 0);
      DMA_SIG : out std_logic;
      DMA_DONE : in std_logic;
      DMA_ERR : in std_logic;
      BUF_REQ : out std_logic;
      BUF_REQ_ACK : in std_logic;
      BUF_REQ_ADDR : in std_logic_vector(31 downto 0);
      BUF_REQ_SIZE : in std_logic_vector(4 downto 0);
      BUF_REQ_RDY : in std_logic;
      BUF_REQ_ERR : in std_logic;
      BUF_REQD : in std_logic;
      BUF_REQD_ADDR : out std_logic_vector(31 downto 0);
      BUF_REQD_SIZE : out std_logic_vector(4 downto 0);
      BUF_REQD_RDY : out std_logic;
      BUF_REQD_ERR : out std_logic;
      BRAM_Rst_0 : out std_logic;
      BRAM_Clk_0 : out std_logic;
      BRAM_EN_0 : out std_logic;
      BRAM_WEN_0 : out std_logic_vector(0 to 3);
      BRAM_Addr_0 : out std_logic_vector(0 to 31);
      BRAM_Din_0 : in std_logic_vector(0 to 31);
      BRAM_Dout_0 : out std_logic_vector(0 to 31);
      BRAM_Rst_1 : out std_logic;
      BRAM_Clk_1 : out std_logic;
      BRAM_EN_1 : out std_logic;
      BRAM_WEN_1 : out std_logic_vector(0 to 3);
      BRAM_Addr_1 : out std_logic_vector(0 to 31);
      BRAM_Din_1 : in std_logic_vector(0 to 31);
      BRAM_Dout_1 : out std_logic_vector(0 to 31)
    );
  end component;

  component system_bram_block_1_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component system_xps_bram_if_cntlr_1_wrapper is
    port (
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
      BRAM_Rst : out std_logic;
      BRAM_Clk : out std_logic;
      BRAM_EN : out std_logic;
      BRAM_WEN : out std_logic_vector(0 to 3);
      BRAM_Addr : out std_logic_vector(0 to 31);
      BRAM_Din : in std_logic_vector(0 to 31);
      BRAM_Dout : out std_logic_vector(0 to 31)
    );
  end component;

  component IBUFGDS is
    port (
      I : in std_logic;
      IB : in std_logic;
      O : out std_logic
    );
  end component;

  -- Internal signals

  signal CLK_S : std_logic;
  signal Dcm_all_locked : std_logic;
  signal PCIe_Bridge_MSI_request_0 : std_logic;
  signal PCIe_Diff_Clk : std_logic_vector(0 to 0);
  signal PCIe_Diff_Clk_N : std_logic_vector(0 to 0);
  signal PCIe_Diff_Clk_P : std_logic_vector(0 to 0);
  signal PCIe_perstn : std_logic;
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_ADDR : std_logic_vector(0 to 31);
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_BE : std_logic_vector(0 to 3);
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_DONE : std_logic;
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_ERR : std_logic;
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_RDATA : std_logic_vector(31 downto 0);
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_RNW : std_logic;
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_START : std_logic;
  signal central_notifier_0_SIMPBUS_MST_SIMPBUS_WDATA : std_logic_vector(0 to 31);
  signal clk_125_0000MHz : std_logic;
  signal mb_plb_MPLB_Rst : std_logic_vector(0 to 2);
  signal mb_plb_M_ABus : std_logic_vector(0 to 95);
  signal mb_plb_M_BE : std_logic_vector(0 to 23);
  signal mb_plb_M_MSize : std_logic_vector(0 to 5);
  signal mb_plb_M_RNW : std_logic_vector(0 to 2);
  signal mb_plb_M_TAttribute : std_logic_vector(0 to 47);
  signal mb_plb_M_UABus : std_logic_vector(0 to 95);
  signal mb_plb_M_abort : std_logic_vector(0 to 2);
  signal mb_plb_M_busLock : std_logic_vector(0 to 2);
  signal mb_plb_M_lockErr : std_logic_vector(0 to 2);
  signal mb_plb_M_priority : std_logic_vector(0 to 5);
  signal mb_plb_M_rdBurst : std_logic_vector(0 to 2);
  signal mb_plb_M_request : std_logic_vector(0 to 2);
  signal mb_plb_M_size : std_logic_vector(0 to 11);
  signal mb_plb_M_type : std_logic_vector(0 to 8);
  signal mb_plb_M_wrBurst : std_logic_vector(0 to 2);
  signal mb_plb_M_wrDBus : std_logic_vector(0 to 191);
  signal mb_plb_PLB_ABus : std_logic_vector(0 to 31);
  signal mb_plb_PLB_BE : std_logic_vector(0 to 7);
  signal mb_plb_PLB_MAddrAck : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MBusy : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MIRQ : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MRdBTerm : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MRdDAck : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MRdDBus : std_logic_vector(0 to 191);
  signal mb_plb_PLB_MRdErr : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MRdWdAddr : std_logic_vector(0 to 11);
  signal mb_plb_PLB_MRearbitrate : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MSSize : std_logic_vector(0 to 5);
  signal mb_plb_PLB_MSize : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MTimeout : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MWrBTerm : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MWrDAck : std_logic_vector(0 to 2);
  signal mb_plb_PLB_MWrErr : std_logic_vector(0 to 2);
  signal mb_plb_PLB_PAValid : std_logic;
  signal mb_plb_PLB_RNW : std_logic;
  signal mb_plb_PLB_SAValid : std_logic;
  signal mb_plb_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb_plb_PLB_UABus : std_logic_vector(0 to 31);
  signal mb_plb_PLB_abort : std_logic;
  signal mb_plb_PLB_busLock : std_logic;
  signal mb_plb_PLB_lockErr : std_logic;
  signal mb_plb_PLB_masterID : std_logic_vector(0 to 1);
  signal mb_plb_PLB_rdBurst : std_logic;
  signal mb_plb_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb_plb_PLB_rdPendReq : std_logic;
  signal mb_plb_PLB_rdPrim : std_logic_vector(0 to 4);
  signal mb_plb_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb_plb_PLB_size : std_logic_vector(0 to 3);
  signal mb_plb_PLB_type : std_logic_vector(0 to 2);
  signal mb_plb_PLB_wrBurst : std_logic;
  signal mb_plb_PLB_wrDBus : std_logic_vector(0 to 63);
  signal mb_plb_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb_plb_PLB_wrPendReq : std_logic;
  signal mb_plb_PLB_wrPrim : std_logic_vector(0 to 4);
  signal mb_plb_SPLB_Rst : std_logic_vector(0 to 4);
  signal mb_plb_Sl_MBusy : std_logic_vector(0 to 14);
  signal mb_plb_Sl_MIRQ : std_logic_vector(0 to 14);
  signal mb_plb_Sl_MRdErr : std_logic_vector(0 to 14);
  signal mb_plb_Sl_MWrErr : std_logic_vector(0 to 14);
  signal mb_plb_Sl_SSize : std_logic_vector(0 to 9);
  signal mb_plb_Sl_addrAck : std_logic_vector(0 to 4);
  signal mb_plb_Sl_rdBTerm : std_logic_vector(0 to 4);
  signal mb_plb_Sl_rdComp : std_logic_vector(0 to 4);
  signal mb_plb_Sl_rdDAck : std_logic_vector(0 to 4);
  signal mb_plb_Sl_rdDBus : std_logic_vector(0 to 319);
  signal mb_plb_Sl_rdWdAddr : std_logic_vector(0 to 19);
  signal mb_plb_Sl_rearbitrate : std_logic_vector(0 to 4);
  signal mb_plb_Sl_wait : std_logic_vector(0 to 4);
  signal mb_plb_Sl_wrBTerm : std_logic_vector(0 to 4);
  signal mb_plb_Sl_wrComp : std_logic_vector(0 to 4);
  signal mb_plb_Sl_wrDAck : std_logic_vector(0 to 4);
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal net_gnd5 : std_logic_vector(4 downto 0);
  signal net_gnd10 : std_logic_vector(0 to 9);
  signal net_gnd32 : std_logic_vector(0 to 31);
  signal pgassign1 : std_logic_vector(0 to 0);
  signal pgassign2 : std_logic_vector(0 to 0);
  signal pgassign3 : std_logic_vector(0 to 0);
  signal pgassign4 : std_logic_vector(0 to 0);
  signal riffa_0_BRAMPORT_0_BRAM_Addr : std_logic_vector(0 to 31);
  signal riffa_0_BRAMPORT_0_BRAM_Clk : std_logic;
  signal riffa_0_BRAMPORT_0_BRAM_Din : std_logic_vector(0 to 31);
  signal riffa_0_BRAMPORT_0_BRAM_Dout : std_logic_vector(0 to 31);
  signal riffa_0_BRAMPORT_0_BRAM_EN : std_logic;
  signal riffa_0_BRAMPORT_0_BRAM_Rst : std_logic;
  signal riffa_0_BRAMPORT_0_BRAM_WEN : std_logic_vector(0 to 3);
  signal riffa_0_BRAMPORT_1_BRAM_Addr : std_logic_vector(0 to 31);
  signal riffa_0_BRAMPORT_1_BRAM_Clk : std_logic;
  signal riffa_0_BRAMPORT_1_BRAM_Din : std_logic_vector(0 to 31);
  signal riffa_0_BRAMPORT_1_BRAM_Dout : std_logic_vector(0 to 31);
  signal riffa_0_BRAMPORT_1_BRAM_EN : std_logic;
  signal riffa_0_BRAMPORT_1_BRAM_Rst : std_logic;
  signal riffa_0_BRAMPORT_1_BRAM_WEN : std_logic_vector(0 to 3);
  signal riffa_0_CHANNEL_BUF_REQ : std_logic;
  signal riffa_0_CHANNEL_BUF_REQD : std_logic;
  signal riffa_0_CHANNEL_BUF_REQD_ADDR : std_logic_vector(31 downto 0);
  signal riffa_0_CHANNEL_BUF_REQD_ERR : std_logic;
  signal riffa_0_CHANNEL_BUF_REQD_RDY : std_logic;
  signal riffa_0_CHANNEL_BUF_REQD_SIZE : std_logic_vector(4 downto 0);
  signal riffa_0_CHANNEL_BUF_REQ_ACK : std_logic;
  signal riffa_0_CHANNEL_BUF_REQ_ADDR : std_logic_vector(31 downto 0);
  signal riffa_0_CHANNEL_BUF_REQ_ERR : std_logic;
  signal riffa_0_CHANNEL_BUF_REQ_RDY : std_logic;
  signal riffa_0_CHANNEL_BUF_REQ_SIZE : std_logic_vector(4 downto 0);
  signal riffa_0_CHANNEL_DMA_DONE : std_logic;
  signal riffa_0_CHANNEL_DMA_DST : std_logic_vector(31 downto 0);
  signal riffa_0_CHANNEL_DMA_ERR : std_logic;
  signal riffa_0_CHANNEL_DMA_LEN : std_logic_vector(31 downto 0);
  signal riffa_0_CHANNEL_DMA_REQ : std_logic;
  signal riffa_0_CHANNEL_DMA_REQ_ACK : std_logic;
  signal riffa_0_CHANNEL_DMA_SIG : std_logic;
  signal riffa_0_CHANNEL_DMA_SRC : std_logic_vector(31 downto 0);
  signal riffa_0_CHANNEL_DOORBELL : std_logic;
  signal riffa_0_CHANNEL_DOORBELL_ARG : std_logic_vector(31 downto 0);
  signal riffa_0_CHANNEL_DOORBELL_ERR : std_logic;
  signal riffa_0_CHANNEL_DOORBELL_LEN : std_logic_vector(31 downto 0);
  signal riffa_0_CHANNEL_INTERRUPT : std_logic;
  signal riffa_0_CHANNEL_INTERRUPT_ACK : std_logic;
  signal riffa_0_CHANNEL_INTERRUPT_ERR : std_logic;
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_ADDR : std_logic_vector(31 downto 0);
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_BE : std_logic_vector(3 downto 0);
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_DONE : std_logic;
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_ERR : std_logic;
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_RDATA : std_logic_vector(0 to 31);
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_RNW : std_logic;
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_START : std_logic;
  signal simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_WDATA : std_logic_vector(31 downto 0);
  signal sys_bus_reset : std_logic_vector(0 to 0);
  signal sys_rst_s : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Addr : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Clk : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Din : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Dout : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_EN : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Rst : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_WEN : std_logic_vector(0 to 3);
  signal xps_bram_if_cntlr_1_PORTA_BRAM_Addr : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_1_PORTA_BRAM_Clk : std_logic;
  signal xps_bram_if_cntlr_1_PORTA_BRAM_Din : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_1_PORTA_BRAM_Dout : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_1_PORTA_BRAM_EN : std_logic;
  signal xps_bram_if_cntlr_1_PORTA_BRAM_Rst : std_logic;
  signal xps_bram_if_cntlr_1_PORTA_BRAM_WEN : std_logic_vector(0 to 3);
  signal xps_central_dma_0_IP2INTC_Irpt : std_logic;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system_pcie_diff_clk_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_mb_plb_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_proc_sys_reset_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_clock_generator_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_plbv46_pcie_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_xps_central_dma_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_central_notifier_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_bram_block_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_xps_bram_if_cntlr_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_simpbus_slv_plbv46_adapter_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_simpbus_mst_plbv46_adapter_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_riffa_0_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_bram_block_1_wrapper : component is "user_black_box";
  attribute BOX_TYPE of system_xps_bram_if_cntlr_1_wrapper : component is "user_black_box";

begin

  -- Internal assignments

  sys_rst_s <= fpga_0_rst_1_sys_rst_pin;
  PCIe_Diff_Clk_P(0) <= fpga_0_PCIe_Diff_Clk_P_pin;
  PCIe_Diff_Clk_N(0) <= fpga_0_PCIe_Diff_Clk_N_pin;
  PCIe_perstn <= fpga_0_PCIe_perstn;
  pgassign1(0) <= fpga_0_PCIe_Bridge_RXN_pin;
  pgassign2(0) <= fpga_0_PCIe_Bridge_RXP_pin;
  fpga_0_PCIe_Bridge_TXN_pin <= pgassign3(0);
  fpga_0_PCIe_Bridge_TXP_pin <= pgassign4(0);
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd10(0 to 9) <= B"0000000000";
  net_gnd32(0 to 31) <= B"00000000000000000000000000000000";
  net_gnd4(3 downto 0) <= B"0000";
  net_gnd5(4 downto 0) <= B"00000";

  PCIe_Diff_Clk_0 : system_pcie_diff_clk_0_wrapper
    port map (
      IBUF_DS_P => PCIe_Diff_Clk_P(0 to 0),
      IBUF_DS_N => PCIe_Diff_Clk_N(0 to 0),
      IBUF_OUT => PCIe_Diff_Clk(0 to 0),
      OBUF_IN => net_gnd1(0 to 0),
      OBUF_DS_P => open,
      OBUF_DS_N => open,
      IOBUF_DS_P => open,
      IOBUF_DS_N => open,
      IOBUF_IO_T => net_gnd1(0 to 0),
      IOBUF_IO_I => net_gnd1(0 to 0),
      IOBUF_IO_O => open
    );

  mb_plb : system_mb_plb_wrapper
    port map (
      PLB_Clk => clk_125_0000MHz,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb_plb_SPLB_Rst,
      MPLB_Rst => mb_plb_MPLB_Rst,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb_plb_M_ABus,
      M_UABus => mb_plb_M_UABus,
      M_BE => mb_plb_M_BE,
      M_RNW => mb_plb_M_RNW,
      M_abort => mb_plb_M_abort,
      M_busLock => mb_plb_M_busLock,
      M_TAttribute => mb_plb_M_TAttribute,
      M_lockErr => mb_plb_M_lockErr,
      M_MSize => mb_plb_M_MSize,
      M_priority => mb_plb_M_priority,
      M_rdBurst => mb_plb_M_rdBurst,
      M_request => mb_plb_M_request,
      M_size => mb_plb_M_size,
      M_type => mb_plb_M_type,
      M_wrBurst => mb_plb_M_wrBurst,
      M_wrDBus => mb_plb_M_wrDBus,
      Sl_addrAck => mb_plb_Sl_addrAck,
      Sl_MRdErr => mb_plb_Sl_MRdErr,
      Sl_MWrErr => mb_plb_Sl_MWrErr,
      Sl_MBusy => mb_plb_Sl_MBusy,
      Sl_rdBTerm => mb_plb_Sl_rdBTerm,
      Sl_rdComp => mb_plb_Sl_rdComp,
      Sl_rdDAck => mb_plb_Sl_rdDAck,
      Sl_rdDBus => mb_plb_Sl_rdDBus,
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr,
      Sl_rearbitrate => mb_plb_Sl_rearbitrate,
      Sl_SSize => mb_plb_Sl_SSize,
      Sl_wait => mb_plb_Sl_wait,
      Sl_wrBTerm => mb_plb_Sl_wrBTerm,
      Sl_wrComp => mb_plb_Sl_wrComp,
      Sl_wrDAck => mb_plb_Sl_wrDAck,
      Sl_MIRQ => mb_plb_Sl_MIRQ,
      PLB_MIRQ => mb_plb_PLB_MIRQ,
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MAddrAck => mb_plb_PLB_MAddrAck,
      PLB_MTimeout => mb_plb_PLB_MTimeout,
      PLB_MBusy => mb_plb_PLB_MBusy,
      PLB_MRdErr => mb_plb_PLB_MRdErr,
      PLB_MWrErr => mb_plb_PLB_MWrErr,
      PLB_MRdBTerm => mb_plb_PLB_MRdBTerm,
      PLB_MRdDAck => mb_plb_PLB_MRdDAck,
      PLB_MRdDBus => mb_plb_PLB_MRdDBus,
      PLB_MRdWdAddr => mb_plb_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb_plb_PLB_MRearbitrate,
      PLB_MWrBTerm => mb_plb_PLB_MWrBTerm,
      PLB_MWrDAck => mb_plb_PLB_MWrDAck,
      PLB_MSSize => mb_plb_PLB_MSSize,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_masterID => mb_plb_PLB_masterID,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_rdPrim => mb_plb_PLB_rdPrim,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrPrim => mb_plb_PLB_wrPrim,
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  proc_sys_reset_0 : system_proc_sys_reset_0_wrapper
    port map (
      Slowest_sync_clk => clk_125_0000MHz,
      Ext_Reset_In => sys_rst_s,
      Aux_Reset_In => PCIe_perstn,
      MB_Debug_Sys_Rst => net_gnd0,
      Core_Reset_Req_0 => net_gnd0,
      Chip_Reset_Req_0 => net_gnd0,
      System_Reset_Req_0 => net_gnd0,
      Core_Reset_Req_1 => net_gnd0,
      Chip_Reset_Req_1 => net_gnd0,
      System_Reset_Req_1 => net_gnd0,
      Dcm_locked => Dcm_all_locked,
      RstcPPCresetcore_0 => open,
      RstcPPCresetchip_0 => open,
      RstcPPCresetsys_0 => open,
      RstcPPCresetcore_1 => open,
      RstcPPCresetchip_1 => open,
      RstcPPCresetsys_1 => open,
      MB_Reset => open,
      Bus_Struct_Reset => sys_bus_reset(0 to 0),
      Peripheral_Reset => open,
      Interconnect_aresetn => open,
      Peripheral_aresetn => open
    );

  clock_generator_0 : system_clock_generator_0_wrapper
    port map (
      CLKIN => CLK_S,
      CLKOUT0 => clk_125_0000MHz,
      CLKOUT1 => open,
      CLKOUT2 => open,
      CLKOUT3 => open,
      CLKOUT4 => open,
      CLKOUT5 => open,
      CLKOUT6 => open,
      CLKOUT7 => open,
      CLKOUT8 => open,
      CLKOUT9 => open,
      CLKOUT10 => open,
      CLKOUT11 => open,
      CLKOUT12 => open,
      CLKOUT13 => open,
      CLKOUT14 => open,
      CLKOUT15 => open,
      CLKFBIN => net_gnd0,
      CLKFBOUT => open,
      PSCLK => net_gnd0,
      PSEN => net_gnd0,
      PSINCDEC => net_gnd0,
      PSDONE => open,
      RST => sys_rst_s,
      LOCKED => Dcm_all_locked
    );

  plbv46_pcie_0 : system_plbv46_pcie_0_wrapper
    port map (
      MPLB_Clk => clk_125_0000MHz,
      MPLB_Rst => mb_plb_MPLB_Rst(0),
      PLB_MTimeout => mb_plb_PLB_MTimeout(0),
      PLB_MIRQ => mb_plb_PLB_MIRQ(0),
      PLB_MAddrAck => mb_plb_PLB_MAddrAck(0),
      PLB_MSSize => mb_plb_PLB_MSSize(0 to 1),
      PLB_MRearbitrate => mb_plb_PLB_MRearbitrate(0),
      PLB_MBusy => mb_plb_PLB_MBusy(0),
      PLB_MRdErr => mb_plb_PLB_MRdErr(0),
      PLB_MWrErr => mb_plb_PLB_MWrErr(0),
      PLB_MWrDAck => mb_plb_PLB_MWrDAck(0),
      PLB_MRdDBus => mb_plb_PLB_MRdDBus(0 to 63),
      PLB_MRdWdAddr => mb_plb_PLB_MRdWdAddr(0 to 3),
      PLB_MRdDAck => mb_plb_PLB_MRdDAck(0),
      PLB_MRdBTerm => mb_plb_PLB_MRdBTerm(0),
      PLB_MWrBTerm => mb_plb_PLB_MWrBTerm(0),
      M_request => mb_plb_M_request(0),
      M_priority => mb_plb_M_priority(0 to 1),
      M_buslock => mb_plb_M_busLock(0),
      M_RNW => mb_plb_M_RNW(0),
      M_BE => mb_plb_M_BE(0 to 7),
      M_MSize => mb_plb_M_MSize(0 to 1),
      M_size => mb_plb_M_size(0 to 3),
      M_type => mb_plb_M_type(0 to 2),
      M_lockErr => mb_plb_M_lockErr(0),
      M_abort => mb_plb_M_abort(0),
      M_TAttribute => mb_plb_M_TAttribute(0 to 15),
      M_UABus => mb_plb_M_UABus(0 to 31),
      M_ABus => mb_plb_M_ABus(0 to 31),
      M_wrDBus => mb_plb_M_wrDBus(0 to 63),
      M_wrBurst => mb_plb_M_wrBurst(0),
      M_rdBurst => mb_plb_M_rdBurst(0),
      SPLB_Clk => clk_125_0000MHz,
      SPLB_Rst => mb_plb_SPLB_Rst(0),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(0),
      PLB_wrPrim => mb_plb_PLB_wrPrim(0),
      PLB_masterID => mb_plb_PLB_masterID,
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(0),
      Sl_SSize => mb_plb_Sl_SSize(0 to 1),
      Sl_wait => mb_plb_Sl_wait(0),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(0),
      Sl_wrDAck => mb_plb_Sl_wrDAck(0),
      Sl_wrComp => mb_plb_Sl_wrComp(0),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(0),
      Sl_rdDBus => mb_plb_Sl_rdDBus(0 to 63),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(0 to 3),
      Sl_rdDAck => mb_plb_Sl_rdDAck(0),
      Sl_rdComp => mb_plb_Sl_rdComp(0),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(0),
      Sl_MBusy => mb_plb_Sl_MBusy(0 to 2),
      Sl_MWrErr => mb_plb_Sl_MWrErr(0 to 2),
      Sl_MRdErr => mb_plb_Sl_MRdErr(0 to 2),
      Sl_MIRQ => mb_plb_Sl_MIRQ(0 to 2),
      REFCLK => PCIe_Diff_Clk(0),
      Bridge_Clk => open,
      RXN => pgassign1(0 to 0),
      RXP => pgassign2(0 to 0),
      TXN => pgassign3(0 to 0),
      TXP => pgassign4(0 to 0),
      IP2INTC_Irpt => open,
      MSI_request => PCIe_Bridge_MSI_request_0
    );

  xps_central_dma_0 : system_xps_central_dma_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHz,
      SPLB_Rst => mb_plb_SPLB_Rst(1),
      MPLB_Clk => clk_125_0000MHz,
      MPLB_Rst => mb_plb_MPLB_Rst(1),
      SPLB_ABus => mb_plb_PLB_ABus,
      SPLB_BE => mb_plb_PLB_BE,
      SPLB_UABus => mb_plb_PLB_UABus,
      SPLB_PAValid => mb_plb_PLB_PAValid,
      SPLB_SAValid => mb_plb_PLB_SAValid,
      SPLB_rdPrim => mb_plb_PLB_rdPrim(1),
      SPLB_wrPrim => mb_plb_PLB_wrPrim(1),
      SPLB_masterID => mb_plb_PLB_masterID,
      SPLB_abort => mb_plb_PLB_abort,
      SPLB_busLock => mb_plb_PLB_busLock,
      SPLB_RNW => mb_plb_PLB_RNW,
      SPLB_MSize => mb_plb_PLB_MSize,
      SPLB_size => mb_plb_PLB_size,
      SPLB_type => mb_plb_PLB_type,
      SPLB_lockErr => mb_plb_PLB_lockErr,
      SPLB_wrDBus => mb_plb_PLB_wrDBus,
      SPLB_wrBurst => mb_plb_PLB_wrBurst,
      SPLB_rdBurst => mb_plb_PLB_rdBurst,
      SPLB_wrPendReq => mb_plb_PLB_wrPendReq,
      SPLB_rdPendReq => mb_plb_PLB_rdPendReq,
      SPLB_wrPendPri => mb_plb_PLB_wrPendPri,
      SPLB_rdPendPri => mb_plb_PLB_rdPendPri,
      SPLB_reqPri => mb_plb_PLB_reqPri,
      SPLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(1),
      Sl_SSize => mb_plb_Sl_SSize(2 to 3),
      Sl_wait => mb_plb_Sl_wait(1),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(1),
      Sl_wrDAck => mb_plb_Sl_wrDAck(1),
      Sl_wrComp => mb_plb_Sl_wrComp(1),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(1),
      Sl_rdDBus => mb_plb_Sl_rdDBus(64 to 127),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(4 to 7),
      Sl_rdDAck => mb_plb_Sl_rdDAck(1),
      Sl_rdComp => mb_plb_Sl_rdComp(1),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(1),
      Sl_MBusy => mb_plb_Sl_MBusy(3 to 5),
      Sl_MWrErr => mb_plb_Sl_MWrErr(3 to 5),
      Sl_MRdErr => mb_plb_Sl_MRdErr(3 to 5),
      Sl_MIRQ => mb_plb_Sl_MIRQ(3 to 5),
      IP2INTC_Irpt => xps_central_dma_0_IP2INTC_Irpt,
      MPLB_MAddrAck => mb_plb_PLB_MAddrAck(1),
      MPLB_MSSize => mb_plb_PLB_MSSize(2 to 3),
      MPLB_MRearbitrate => mb_plb_PLB_MRearbitrate(1),
      MPLB_MTimeout => mb_plb_PLB_MTimeout(1),
      MPLB_MBusy => mb_plb_PLB_MBusy(1),
      MPLB_MRdErr => mb_plb_PLB_MRdErr(1),
      MPLB_MWrErr => mb_plb_PLB_MWrErr(1),
      MPLB_MIRQ => mb_plb_PLB_MIRQ(1),
      MPLB_MRdDBus => mb_plb_PLB_MRdDBus(64 to 127),
      MPLB_MRdWdAddr => mb_plb_PLB_MRdWdAddr(4 to 7),
      MPLB_MRdDAck => mb_plb_PLB_MRdDAck(1),
      MPLB_MRdBTerm => mb_plb_PLB_MRdBTerm(1),
      MPLB_MWrDAck => mb_plb_PLB_MWrDAck(1),
      MPLB_MWrBTerm => mb_plb_PLB_MWrBTerm(1),
      M_request => mb_plb_M_request(1),
      M_priority => mb_plb_M_priority(2 to 3),
      M_busLock => mb_plb_M_busLock(1),
      M_RNW => mb_plb_M_RNW(1),
      M_BE => mb_plb_M_BE(8 to 15),
      M_MSize => mb_plb_M_MSize(2 to 3),
      M_size => mb_plb_M_size(4 to 7),
      M_type => mb_plb_M_type(3 to 5),
      M_TAttribute => mb_plb_M_TAttribute(16 to 31),
      M_lockErr => mb_plb_M_lockErr(1),
      M_abort => mb_plb_M_abort(1),
      M_UABus => mb_plb_M_UABus(32 to 63),
      M_ABus => mb_plb_M_ABus(32 to 63),
      M_wrDBus => mb_plb_M_wrDBus(64 to 127),
      M_wrBurst => mb_plb_M_wrBurst(1),
      M_rdBurst => mb_plb_M_rdBurst(1)
    );

  central_notifier_0 : system_central_notifier_0_wrapper
    port map (
      SYS_CLK => clk_125_0000MHz,
      SYS_RST => sys_bus_reset(0),
      INTR_PCI => PCIe_Bridge_MSI_request_0,
      INTR_DMA => xps_central_dma_0_IP2INTC_Irpt,
      INIT_START => open,
      INIT_DONE => net_gnd0,
      SIMPBUS_INIT_ADDR => net_gnd32(0 to 31),
      SIMPBUS_INIT_WDATA => net_gnd32(0 to 31),
      SIMPBUS_INIT_RDATA => open,
      SIMPBUS_INIT_BE => net_gnd4,
      SIMPBUS_INIT_RNW => net_gnd0,
      SIMPBUS_INIT_START => net_gnd0,
      SIMPBUS_INIT_DONE => open,
      SIMPBUS_INIT_ERR => open,
      SIMPBUS_MST_ADDR => central_notifier_0_SIMPBUS_MST_SIMPBUS_ADDR(0 to 31),
      SIMPBUS_MST_WDATA => central_notifier_0_SIMPBUS_MST_SIMPBUS_WDATA(0 to 31),
      SIMPBUS_MST_RDATA => central_notifier_0_SIMPBUS_MST_SIMPBUS_RDATA,
      SIMPBUS_MST_BE => central_notifier_0_SIMPBUS_MST_SIMPBUS_BE(0 to 3),
      SIMPBUS_MST_RNW => central_notifier_0_SIMPBUS_MST_SIMPBUS_RNW,
      SIMPBUS_MST_START => central_notifier_0_SIMPBUS_MST_SIMPBUS_START,
      SIMPBUS_MST_DONE => central_notifier_0_SIMPBUS_MST_SIMPBUS_DONE,
      SIMPBUS_MST_ERR => central_notifier_0_SIMPBUS_MST_SIMPBUS_ERR,
      SIMPBUS_SLV_ADDR => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_ADDR,
      SIMPBUS_SLV_WDATA => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_WDATA,
      SIMPBUS_SLV_RDATA => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_RDATA(0 to 31),
      SIMPBUS_SLV_BE => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_BE,
      SIMPBUS_SLV_RNW => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_RNW,
      SIMPBUS_SLV_START => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_START,
      SIMPBUS_SLV_DONE => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_DONE,
      SIMPBUS_SLV_ERR => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_ERR,
      INTERRUPT_00 => riffa_0_CHANNEL_INTERRUPT,
      INTERRUPT_ERR_00 => riffa_0_CHANNEL_INTERRUPT_ERR,
      INTERRUPT_ACK_00 => riffa_0_CHANNEL_INTERRUPT_ACK,
      DOORBELL_00 => riffa_0_CHANNEL_DOORBELL,
      DOORBELL_ERR_00 => riffa_0_CHANNEL_DOORBELL_ERR,
      DOORBELL_LEN_00 => riffa_0_CHANNEL_DOORBELL_LEN,
      DOORBELL_ARG_00 => riffa_0_CHANNEL_DOORBELL_ARG,
      DMA_REQ_00 => riffa_0_CHANNEL_DMA_REQ,
      DMA_REQ_ACK_00 => riffa_0_CHANNEL_DMA_REQ_ACK,
      DMA_SRC_00 => riffa_0_CHANNEL_DMA_SRC,
      DMA_DST_00 => riffa_0_CHANNEL_DMA_DST,
      DMA_LEN_00 => riffa_0_CHANNEL_DMA_LEN,
      DMA_SIG_00 => riffa_0_CHANNEL_DMA_SIG,
      DMA_DONE_00 => riffa_0_CHANNEL_DMA_DONE,
      DMA_ERR_00 => riffa_0_CHANNEL_DMA_ERR,
      BUF_REQ_00 => riffa_0_CHANNEL_BUF_REQ,
      BUF_REQ_ACK_00 => riffa_0_CHANNEL_BUF_REQ_ACK,
      BUF_REQ_ADDR_00 => riffa_0_CHANNEL_BUF_REQ_ADDR,
      BUF_REQ_SIZE_00 => riffa_0_CHANNEL_BUF_REQ_SIZE,
      BUF_REQ_RDY_00 => riffa_0_CHANNEL_BUF_REQ_RDY,
      BUF_REQ_ERR_00 => riffa_0_CHANNEL_BUF_REQ_ERR,
      BUF_REQD_00 => riffa_0_CHANNEL_BUF_REQD,
      BUF_REQD_ADDR_00 => riffa_0_CHANNEL_BUF_REQD_ADDR,
      BUF_REQD_SIZE_00 => riffa_0_CHANNEL_BUF_REQD_SIZE,
      BUF_REQD_RDY_00 => riffa_0_CHANNEL_BUF_REQD_RDY,
      BUF_REQD_ERR_00 => riffa_0_CHANNEL_BUF_REQD_ERR,
      INTERRUPT_01 => net_gnd0,
      INTERRUPT_ERR_01 => net_gnd0,
      INTERRUPT_ACK_01 => open,
      DOORBELL_01 => open,
      DOORBELL_ERR_01 => open,
      DOORBELL_LEN_01 => open,
      DOORBELL_ARG_01 => open,
      DMA_REQ_01 => net_gnd0,
      DMA_REQ_ACK_01 => open,
      DMA_SRC_01 => net_gnd32(0 to 31),
      DMA_DST_01 => net_gnd32(0 to 31),
      DMA_LEN_01 => net_gnd32(0 to 31),
      DMA_SIG_01 => net_gnd0,
      DMA_DONE_01 => open,
      DMA_ERR_01 => open,
      BUF_REQ_01 => net_gnd0,
      BUF_REQ_ACK_01 => open,
      BUF_REQ_ADDR_01 => open,
      BUF_REQ_SIZE_01 => open,
      BUF_REQ_RDY_01 => open,
      BUF_REQ_ERR_01 => open,
      BUF_REQD_01 => open,
      BUF_REQD_ADDR_01 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_01 => net_gnd5,
      BUF_REQD_RDY_01 => net_gnd0,
      BUF_REQD_ERR_01 => net_gnd0,
      INTERRUPT_02 => net_gnd0,
      INTERRUPT_ERR_02 => net_gnd0,
      INTERRUPT_ACK_02 => open,
      DOORBELL_02 => open,
      DOORBELL_ERR_02 => open,
      DOORBELL_LEN_02 => open,
      DOORBELL_ARG_02 => open,
      DMA_REQ_02 => net_gnd0,
      DMA_REQ_ACK_02 => open,
      DMA_SRC_02 => net_gnd32(0 to 31),
      DMA_DST_02 => net_gnd32(0 to 31),
      DMA_LEN_02 => net_gnd32(0 to 31),
      DMA_SIG_02 => net_gnd0,
      DMA_DONE_02 => open,
      DMA_ERR_02 => open,
      BUF_REQ_02 => net_gnd0,
      BUF_REQ_ACK_02 => open,
      BUF_REQ_ADDR_02 => open,
      BUF_REQ_SIZE_02 => open,
      BUF_REQ_RDY_02 => open,
      BUF_REQ_ERR_02 => open,
      BUF_REQD_02 => open,
      BUF_REQD_ADDR_02 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_02 => net_gnd5,
      BUF_REQD_RDY_02 => net_gnd0,
      BUF_REQD_ERR_02 => net_gnd0,
      INTERRUPT_03 => net_gnd0,
      INTERRUPT_ERR_03 => net_gnd0,
      INTERRUPT_ACK_03 => open,
      DOORBELL_03 => open,
      DOORBELL_ERR_03 => open,
      DOORBELL_LEN_03 => open,
      DOORBELL_ARG_03 => open,
      DMA_REQ_03 => net_gnd0,
      DMA_REQ_ACK_03 => open,
      DMA_SRC_03 => net_gnd32(0 to 31),
      DMA_DST_03 => net_gnd32(0 to 31),
      DMA_LEN_03 => net_gnd32(0 to 31),
      DMA_SIG_03 => net_gnd0,
      DMA_DONE_03 => open,
      DMA_ERR_03 => open,
      BUF_REQ_03 => net_gnd0,
      BUF_REQ_ACK_03 => open,
      BUF_REQ_ADDR_03 => open,
      BUF_REQ_SIZE_03 => open,
      BUF_REQ_RDY_03 => open,
      BUF_REQ_ERR_03 => open,
      BUF_REQD_03 => open,
      BUF_REQD_ADDR_03 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_03 => net_gnd5,
      BUF_REQD_RDY_03 => net_gnd0,
      BUF_REQD_ERR_03 => net_gnd0,
      INTERRUPT_04 => net_gnd0,
      INTERRUPT_ERR_04 => net_gnd0,
      INTERRUPT_ACK_04 => open,
      DOORBELL_04 => open,
      DOORBELL_ERR_04 => open,
      DOORBELL_LEN_04 => open,
      DOORBELL_ARG_04 => open,
      DMA_REQ_04 => net_gnd0,
      DMA_REQ_ACK_04 => open,
      DMA_SRC_04 => net_gnd32(0 to 31),
      DMA_DST_04 => net_gnd32(0 to 31),
      DMA_LEN_04 => net_gnd32(0 to 31),
      DMA_SIG_04 => net_gnd0,
      DMA_DONE_04 => open,
      DMA_ERR_04 => open,
      BUF_REQ_04 => net_gnd0,
      BUF_REQ_ACK_04 => open,
      BUF_REQ_ADDR_04 => open,
      BUF_REQ_SIZE_04 => open,
      BUF_REQ_RDY_04 => open,
      BUF_REQ_ERR_04 => open,
      BUF_REQD_04 => open,
      BUF_REQD_ADDR_04 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_04 => net_gnd5,
      BUF_REQD_RDY_04 => net_gnd0,
      BUF_REQD_ERR_04 => net_gnd0,
      INTERRUPT_05 => net_gnd0,
      INTERRUPT_ERR_05 => net_gnd0,
      INTERRUPT_ACK_05 => open,
      DOORBELL_05 => open,
      DOORBELL_ERR_05 => open,
      DOORBELL_LEN_05 => open,
      DOORBELL_ARG_05 => open,
      DMA_REQ_05 => net_gnd0,
      DMA_REQ_ACK_05 => open,
      DMA_SRC_05 => net_gnd32(0 to 31),
      DMA_DST_05 => net_gnd32(0 to 31),
      DMA_LEN_05 => net_gnd32(0 to 31),
      DMA_SIG_05 => net_gnd0,
      DMA_DONE_05 => open,
      DMA_ERR_05 => open,
      BUF_REQ_05 => net_gnd0,
      BUF_REQ_ACK_05 => open,
      BUF_REQ_ADDR_05 => open,
      BUF_REQ_SIZE_05 => open,
      BUF_REQ_RDY_05 => open,
      BUF_REQ_ERR_05 => open,
      BUF_REQD_05 => open,
      BUF_REQD_ADDR_05 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_05 => net_gnd5,
      BUF_REQD_RDY_05 => net_gnd0,
      BUF_REQD_ERR_05 => net_gnd0,
      INTERRUPT_06 => net_gnd0,
      INTERRUPT_ERR_06 => net_gnd0,
      INTERRUPT_ACK_06 => open,
      DOORBELL_06 => open,
      DOORBELL_ERR_06 => open,
      DOORBELL_LEN_06 => open,
      DOORBELL_ARG_06 => open,
      DMA_REQ_06 => net_gnd0,
      DMA_REQ_ACK_06 => open,
      DMA_SRC_06 => net_gnd32(0 to 31),
      DMA_DST_06 => net_gnd32(0 to 31),
      DMA_LEN_06 => net_gnd32(0 to 31),
      DMA_SIG_06 => net_gnd0,
      DMA_DONE_06 => open,
      DMA_ERR_06 => open,
      BUF_REQ_06 => net_gnd0,
      BUF_REQ_ACK_06 => open,
      BUF_REQ_ADDR_06 => open,
      BUF_REQ_SIZE_06 => open,
      BUF_REQ_RDY_06 => open,
      BUF_REQ_ERR_06 => open,
      BUF_REQD_06 => open,
      BUF_REQD_ADDR_06 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_06 => net_gnd5,
      BUF_REQD_RDY_06 => net_gnd0,
      BUF_REQD_ERR_06 => net_gnd0,
      INTERRUPT_07 => net_gnd0,
      INTERRUPT_ERR_07 => net_gnd0,
      INTERRUPT_ACK_07 => open,
      DOORBELL_07 => open,
      DOORBELL_ERR_07 => open,
      DOORBELL_LEN_07 => open,
      DOORBELL_ARG_07 => open,
      DMA_REQ_07 => net_gnd0,
      DMA_REQ_ACK_07 => open,
      DMA_SRC_07 => net_gnd32(0 to 31),
      DMA_DST_07 => net_gnd32(0 to 31),
      DMA_LEN_07 => net_gnd32(0 to 31),
      DMA_SIG_07 => net_gnd0,
      DMA_DONE_07 => open,
      DMA_ERR_07 => open,
      BUF_REQ_07 => net_gnd0,
      BUF_REQ_ACK_07 => open,
      BUF_REQ_ADDR_07 => open,
      BUF_REQ_SIZE_07 => open,
      BUF_REQ_RDY_07 => open,
      BUF_REQ_ERR_07 => open,
      BUF_REQD_07 => open,
      BUF_REQD_ADDR_07 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_07 => net_gnd5,
      BUF_REQD_RDY_07 => net_gnd0,
      BUF_REQD_ERR_07 => net_gnd0,
      INTERRUPT_08 => net_gnd0,
      INTERRUPT_ERR_08 => net_gnd0,
      INTERRUPT_ACK_08 => open,
      DOORBELL_08 => open,
      DOORBELL_ERR_08 => open,
      DOORBELL_LEN_08 => open,
      DOORBELL_ARG_08 => open,
      DMA_REQ_08 => net_gnd0,
      DMA_REQ_ACK_08 => open,
      DMA_SRC_08 => net_gnd32(0 to 31),
      DMA_DST_08 => net_gnd32(0 to 31),
      DMA_LEN_08 => net_gnd32(0 to 31),
      DMA_SIG_08 => net_gnd0,
      DMA_DONE_08 => open,
      DMA_ERR_08 => open,
      BUF_REQ_08 => net_gnd0,
      BUF_REQ_ACK_08 => open,
      BUF_REQ_ADDR_08 => open,
      BUF_REQ_SIZE_08 => open,
      BUF_REQ_RDY_08 => open,
      BUF_REQ_ERR_08 => open,
      BUF_REQD_08 => open,
      BUF_REQD_ADDR_08 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_08 => net_gnd5,
      BUF_REQD_RDY_08 => net_gnd0,
      BUF_REQD_ERR_08 => net_gnd0,
      INTERRUPT_09 => net_gnd0,
      INTERRUPT_ERR_09 => net_gnd0,
      INTERRUPT_ACK_09 => open,
      DOORBELL_09 => open,
      DOORBELL_ERR_09 => open,
      DOORBELL_LEN_09 => open,
      DOORBELL_ARG_09 => open,
      DMA_REQ_09 => net_gnd0,
      DMA_REQ_ACK_09 => open,
      DMA_SRC_09 => net_gnd32(0 to 31),
      DMA_DST_09 => net_gnd32(0 to 31),
      DMA_LEN_09 => net_gnd32(0 to 31),
      DMA_SIG_09 => net_gnd0,
      DMA_DONE_09 => open,
      DMA_ERR_09 => open,
      BUF_REQ_09 => net_gnd0,
      BUF_REQ_ACK_09 => open,
      BUF_REQ_ADDR_09 => open,
      BUF_REQ_SIZE_09 => open,
      BUF_REQ_RDY_09 => open,
      BUF_REQ_ERR_09 => open,
      BUF_REQD_09 => open,
      BUF_REQD_ADDR_09 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_09 => net_gnd5,
      BUF_REQD_RDY_09 => net_gnd0,
      BUF_REQD_ERR_09 => net_gnd0,
      INTERRUPT_10 => net_gnd0,
      INTERRUPT_ERR_10 => net_gnd0,
      INTERRUPT_ACK_10 => open,
      DOORBELL_10 => open,
      DOORBELL_ERR_10 => open,
      DOORBELL_LEN_10 => open,
      DOORBELL_ARG_10 => open,
      DMA_REQ_10 => net_gnd0,
      DMA_REQ_ACK_10 => open,
      DMA_SRC_10 => net_gnd32(0 to 31),
      DMA_DST_10 => net_gnd32(0 to 31),
      DMA_LEN_10 => net_gnd32(0 to 31),
      DMA_SIG_10 => net_gnd0,
      DMA_DONE_10 => open,
      DMA_ERR_10 => open,
      BUF_REQ_10 => net_gnd0,
      BUF_REQ_ACK_10 => open,
      BUF_REQ_ADDR_10 => open,
      BUF_REQ_SIZE_10 => open,
      BUF_REQ_RDY_10 => open,
      BUF_REQ_ERR_10 => open,
      BUF_REQD_10 => open,
      BUF_REQD_ADDR_10 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_10 => net_gnd5,
      BUF_REQD_RDY_10 => net_gnd0,
      BUF_REQD_ERR_10 => net_gnd0,
      INTERRUPT_11 => net_gnd0,
      INTERRUPT_ERR_11 => net_gnd0,
      INTERRUPT_ACK_11 => open,
      DOORBELL_11 => open,
      DOORBELL_ERR_11 => open,
      DOORBELL_LEN_11 => open,
      DOORBELL_ARG_11 => open,
      DMA_REQ_11 => net_gnd0,
      DMA_REQ_ACK_11 => open,
      DMA_SRC_11 => net_gnd32(0 to 31),
      DMA_DST_11 => net_gnd32(0 to 31),
      DMA_LEN_11 => net_gnd32(0 to 31),
      DMA_SIG_11 => net_gnd0,
      DMA_DONE_11 => open,
      DMA_ERR_11 => open,
      BUF_REQ_11 => net_gnd0,
      BUF_REQ_ACK_11 => open,
      BUF_REQ_ADDR_11 => open,
      BUF_REQ_SIZE_11 => open,
      BUF_REQ_RDY_11 => open,
      BUF_REQ_ERR_11 => open,
      BUF_REQD_11 => open,
      BUF_REQD_ADDR_11 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_11 => net_gnd5,
      BUF_REQD_RDY_11 => net_gnd0,
      BUF_REQD_ERR_11 => net_gnd0,
      INTERRUPT_12 => net_gnd0,
      INTERRUPT_ERR_12 => net_gnd0,
      INTERRUPT_ACK_12 => open,
      DOORBELL_12 => open,
      DOORBELL_ERR_12 => open,
      DOORBELL_LEN_12 => open,
      DOORBELL_ARG_12 => open,
      DMA_REQ_12 => net_gnd0,
      DMA_REQ_ACK_12 => open,
      DMA_SRC_12 => net_gnd32(0 to 31),
      DMA_DST_12 => net_gnd32(0 to 31),
      DMA_LEN_12 => net_gnd32(0 to 31),
      DMA_SIG_12 => net_gnd0,
      DMA_DONE_12 => open,
      DMA_ERR_12 => open,
      BUF_REQ_12 => net_gnd0,
      BUF_REQ_ACK_12 => open,
      BUF_REQ_ADDR_12 => open,
      BUF_REQ_SIZE_12 => open,
      BUF_REQ_RDY_12 => open,
      BUF_REQ_ERR_12 => open,
      BUF_REQD_12 => open,
      BUF_REQD_ADDR_12 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_12 => net_gnd5,
      BUF_REQD_RDY_12 => net_gnd0,
      BUF_REQD_ERR_12 => net_gnd0,
      INTERRUPT_13 => net_gnd0,
      INTERRUPT_ERR_13 => net_gnd0,
      INTERRUPT_ACK_13 => open,
      DOORBELL_13 => open,
      DOORBELL_ERR_13 => open,
      DOORBELL_LEN_13 => open,
      DOORBELL_ARG_13 => open,
      DMA_REQ_13 => net_gnd0,
      DMA_REQ_ACK_13 => open,
      DMA_SRC_13 => net_gnd32(0 to 31),
      DMA_DST_13 => net_gnd32(0 to 31),
      DMA_LEN_13 => net_gnd32(0 to 31),
      DMA_SIG_13 => net_gnd0,
      DMA_DONE_13 => open,
      DMA_ERR_13 => open,
      BUF_REQ_13 => net_gnd0,
      BUF_REQ_ACK_13 => open,
      BUF_REQ_ADDR_13 => open,
      BUF_REQ_SIZE_13 => open,
      BUF_REQ_RDY_13 => open,
      BUF_REQ_ERR_13 => open,
      BUF_REQD_13 => open,
      BUF_REQD_ADDR_13 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_13 => net_gnd5,
      BUF_REQD_RDY_13 => net_gnd0,
      BUF_REQD_ERR_13 => net_gnd0,
      INTERRUPT_14 => net_gnd0,
      INTERRUPT_ERR_14 => net_gnd0,
      INTERRUPT_ACK_14 => open,
      DOORBELL_14 => open,
      DOORBELL_ERR_14 => open,
      DOORBELL_LEN_14 => open,
      DOORBELL_ARG_14 => open,
      DMA_REQ_14 => net_gnd0,
      DMA_REQ_ACK_14 => open,
      DMA_SRC_14 => net_gnd32(0 to 31),
      DMA_DST_14 => net_gnd32(0 to 31),
      DMA_LEN_14 => net_gnd32(0 to 31),
      DMA_SIG_14 => net_gnd0,
      DMA_DONE_14 => open,
      DMA_ERR_14 => open,
      BUF_REQ_14 => net_gnd0,
      BUF_REQ_ACK_14 => open,
      BUF_REQ_ADDR_14 => open,
      BUF_REQ_SIZE_14 => open,
      BUF_REQ_RDY_14 => open,
      BUF_REQ_ERR_14 => open,
      BUF_REQD_14 => open,
      BUF_REQD_ADDR_14 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_14 => net_gnd5,
      BUF_REQD_RDY_14 => net_gnd0,
      BUF_REQD_ERR_14 => net_gnd0,
      INTERRUPT_15 => net_gnd0,
      INTERRUPT_ERR_15 => net_gnd0,
      INTERRUPT_ACK_15 => open,
      DOORBELL_15 => open,
      DOORBELL_ERR_15 => open,
      DOORBELL_LEN_15 => open,
      DOORBELL_ARG_15 => open,
      DMA_REQ_15 => net_gnd0,
      DMA_REQ_ACK_15 => open,
      DMA_SRC_15 => net_gnd32(0 to 31),
      DMA_DST_15 => net_gnd32(0 to 31),
      DMA_LEN_15 => net_gnd32(0 to 31),
      DMA_SIG_15 => net_gnd0,
      DMA_DONE_15 => open,
      DMA_ERR_15 => open,
      BUF_REQ_15 => net_gnd0,
      BUF_REQ_ACK_15 => open,
      BUF_REQ_ADDR_15 => open,
      BUF_REQ_SIZE_15 => open,
      BUF_REQ_RDY_15 => open,
      BUF_REQ_ERR_15 => open,
      BUF_REQD_15 => open,
      BUF_REQD_ADDR_15 => net_gnd32(0 to 31),
      BUF_REQD_SIZE_15 => net_gnd5,
      BUF_REQD_RDY_15 => net_gnd0,
      BUF_REQD_ERR_15 => net_gnd0
    );

  bram_block_0 : system_bram_block_0_wrapper
    port map (
      BRAM_Rst_A => xps_bram_if_cntlr_0_PORTA_BRAM_Rst,
      BRAM_Clk_A => xps_bram_if_cntlr_0_PORTA_BRAM_Clk,
      BRAM_EN_A => xps_bram_if_cntlr_0_PORTA_BRAM_EN,
      BRAM_WEN_A => xps_bram_if_cntlr_0_PORTA_BRAM_WEN,
      BRAM_Addr_A => xps_bram_if_cntlr_0_PORTA_BRAM_Addr,
      BRAM_Din_A => xps_bram_if_cntlr_0_PORTA_BRAM_Din,
      BRAM_Dout_A => xps_bram_if_cntlr_0_PORTA_BRAM_Dout,
      BRAM_Rst_B => riffa_0_BRAMPORT_0_BRAM_Rst,
      BRAM_Clk_B => riffa_0_BRAMPORT_0_BRAM_Clk,
      BRAM_EN_B => riffa_0_BRAMPORT_0_BRAM_EN,
      BRAM_WEN_B => riffa_0_BRAMPORT_0_BRAM_WEN,
      BRAM_Addr_B => riffa_0_BRAMPORT_0_BRAM_Addr,
      BRAM_Din_B => riffa_0_BRAMPORT_0_BRAM_Din,
      BRAM_Dout_B => riffa_0_BRAMPORT_0_BRAM_Dout
    );

  xps_bram_if_cntlr_0 : system_xps_bram_if_cntlr_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHz,
      SPLB_Rst => mb_plb_SPLB_Rst(2),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(2),
      PLB_wrPrim => mb_plb_PLB_wrPrim(2),
      PLB_masterID => mb_plb_PLB_masterID,
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(2),
      Sl_SSize => mb_plb_Sl_SSize(4 to 5),
      Sl_wait => mb_plb_Sl_wait(2),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(2),
      Sl_wrDAck => mb_plb_Sl_wrDAck(2),
      Sl_wrComp => mb_plb_Sl_wrComp(2),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(2),
      Sl_rdDBus => mb_plb_Sl_rdDBus(128 to 191),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(8 to 11),
      Sl_rdDAck => mb_plb_Sl_rdDAck(2),
      Sl_rdComp => mb_plb_Sl_rdComp(2),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(2),
      Sl_MBusy => mb_plb_Sl_MBusy(6 to 8),
      Sl_MWrErr => mb_plb_Sl_MWrErr(6 to 8),
      Sl_MRdErr => mb_plb_Sl_MRdErr(6 to 8),
      Sl_MIRQ => mb_plb_Sl_MIRQ(6 to 8),
      BRAM_Rst => xps_bram_if_cntlr_0_PORTA_BRAM_Rst,
      BRAM_Clk => xps_bram_if_cntlr_0_PORTA_BRAM_Clk,
      BRAM_EN => xps_bram_if_cntlr_0_PORTA_BRAM_EN,
      BRAM_WEN => xps_bram_if_cntlr_0_PORTA_BRAM_WEN,
      BRAM_Addr => xps_bram_if_cntlr_0_PORTA_BRAM_Addr,
      BRAM_Din => xps_bram_if_cntlr_0_PORTA_BRAM_Din,
      BRAM_Dout => xps_bram_if_cntlr_0_PORTA_BRAM_Dout
    );

  simpbus_slv_plbv46_adapter_0 : system_simpbus_slv_plbv46_adapter_0_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHz,
      SPLB_Rst => mb_plb_SPLB_Rst(3),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(3),
      PLB_wrPrim => mb_plb_PLB_wrPrim(3),
      PLB_masterID => mb_plb_PLB_masterID,
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(3),
      Sl_SSize => mb_plb_Sl_SSize(6 to 7),
      Sl_wait => mb_plb_Sl_wait(3),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(3),
      Sl_wrDAck => mb_plb_Sl_wrDAck(3),
      Sl_wrComp => mb_plb_Sl_wrComp(3),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(3),
      Sl_rdDBus => mb_plb_Sl_rdDBus(192 to 255),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(12 to 15),
      Sl_rdDAck => mb_plb_Sl_rdDAck(3),
      Sl_rdComp => mb_plb_Sl_rdComp(3),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(3),
      Sl_MBusy => mb_plb_Sl_MBusy(9 to 11),
      Sl_MWrErr => mb_plb_Sl_MWrErr(9 to 11),
      Sl_MRdErr => mb_plb_Sl_MRdErr(9 to 11),
      Sl_MIRQ => mb_plb_Sl_MIRQ(9 to 11),
      SIMPBUS_ADDR => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_ADDR(31 downto 0),
      SIMPBUS_WDATA => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_WDATA(31 downto 0),
      SIMPBUS_RDATA => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_RDATA,
      SIMPBUS_BE => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_BE(3 downto 0),
      SIMPBUS_RNW => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_RNW,
      SIMPBUS_START => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_START,
      SIMPBUS_DONE => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_DONE,
      SIMPBUS_ERR => simpbus_slv_plbv46_adapter_0_SIMPBUS_SIMPBUS_ERR
    );

  simpbus_mst_plbv46_adapter_0 : system_simpbus_mst_plbv46_adapter_0_wrapper
    port map (
      MPLB_Clk => clk_125_0000MHz,
      MPLB_Rst => mb_plb_MPLB_Rst(2),
      M_request => mb_plb_M_request(2),
      M_priority => mb_plb_M_priority(4 to 5),
      M_busLock => mb_plb_M_busLock(2),
      M_RNW => mb_plb_M_RNW(2),
      M_BE => mb_plb_M_BE(16 to 23),
      M_MSize => mb_plb_M_MSize(4 to 5),
      M_size => mb_plb_M_size(8 to 11),
      M_type => mb_plb_M_type(6 to 8),
      M_TAttribute => mb_plb_M_TAttribute(32 to 47),
      M_lockErr => mb_plb_M_lockErr(2),
      M_abort => mb_plb_M_abort(2),
      M_UABus => mb_plb_M_UABus(64 to 95),
      M_ABus => mb_plb_M_ABus(64 to 95),
      M_wrDBus => mb_plb_M_wrDBus(128 to 191),
      M_wrBurst => mb_plb_M_wrBurst(2),
      M_rdBurst => mb_plb_M_rdBurst(2),
      PLB_MAddrAck => mb_plb_PLB_MAddrAck(2),
      PLB_MSSize => mb_plb_PLB_MSSize(4 to 5),
      PLB_MRearbitrate => mb_plb_PLB_MRearbitrate(2),
      PLB_MTimeout => mb_plb_PLB_MTimeout(2),
      PLB_MBusy => mb_plb_PLB_MBusy(2),
      PLB_MRdErr => mb_plb_PLB_MRdErr(2),
      PLB_MWrErr => mb_plb_PLB_MWrErr(2),
      PLB_MIRQ => mb_plb_PLB_MIRQ(2),
      PLB_MRdDBus => mb_plb_PLB_MRdDBus(128 to 191),
      PLB_MRdWdAddr => mb_plb_PLB_MRdWdAddr(8 to 11),
      PLB_MRdDAck => mb_plb_PLB_MRdDAck(2),
      PLB_MRdBTerm => mb_plb_PLB_MRdBTerm(2),
      PLB_MWrDAck => mb_plb_PLB_MWrDAck(2),
      PLB_MWrBTerm => mb_plb_PLB_MWrBTerm(2),
      SIMPBUS_ADDR => central_notifier_0_SIMPBUS_MST_SIMPBUS_ADDR,
      SIMPBUS_WDATA => central_notifier_0_SIMPBUS_MST_SIMPBUS_WDATA,
      SIMPBUS_RDATA => central_notifier_0_SIMPBUS_MST_SIMPBUS_RDATA(31 downto 0),
      SIMPBUS_BE => central_notifier_0_SIMPBUS_MST_SIMPBUS_BE,
      SIMPBUS_RNW => central_notifier_0_SIMPBUS_MST_SIMPBUS_RNW,
      SIMPBUS_START => central_notifier_0_SIMPBUS_MST_SIMPBUS_START,
      SIMPBUS_DONE => central_notifier_0_SIMPBUS_MST_SIMPBUS_DONE,
      SIMPBUS_ERR => central_notifier_0_SIMPBUS_MST_SIMPBUS_ERR
    );

  riffa_0 : system_riffa_0_wrapper
    port map (
      SYS_CLK => clk_125_0000MHz,
      SYS_RST => sys_bus_reset(0),
      INTERRUPT => riffa_0_CHANNEL_INTERRUPT,
      INTERRUPT_ERR => riffa_0_CHANNEL_INTERRUPT_ERR,
      INTERRUPT_ACK => riffa_0_CHANNEL_INTERRUPT_ACK,
      DOORBELL => riffa_0_CHANNEL_DOORBELL,
      DOORBELL_ERR => riffa_0_CHANNEL_DOORBELL_ERR,
      DOORBELL_LEN => riffa_0_CHANNEL_DOORBELL_LEN,
      DOORBELL_ARG => riffa_0_CHANNEL_DOORBELL_ARG,
      DMA_REQ => riffa_0_CHANNEL_DMA_REQ,
      DMA_REQ_ACK => riffa_0_CHANNEL_DMA_REQ_ACK,
      DMA_SRC => riffa_0_CHANNEL_DMA_SRC,
      DMA_DST => riffa_0_CHANNEL_DMA_DST,
      DMA_LEN => riffa_0_CHANNEL_DMA_LEN,
      DMA_SIG => riffa_0_CHANNEL_DMA_SIG,
      DMA_DONE => riffa_0_CHANNEL_DMA_DONE,
      DMA_ERR => riffa_0_CHANNEL_DMA_ERR,
      BUF_REQ => riffa_0_CHANNEL_BUF_REQ,
      BUF_REQ_ACK => riffa_0_CHANNEL_BUF_REQ_ACK,
      BUF_REQ_ADDR => riffa_0_CHANNEL_BUF_REQ_ADDR,
      BUF_REQ_SIZE => riffa_0_CHANNEL_BUF_REQ_SIZE,
      BUF_REQ_RDY => riffa_0_CHANNEL_BUF_REQ_RDY,
      BUF_REQ_ERR => riffa_0_CHANNEL_BUF_REQ_ERR,
      BUF_REQD => riffa_0_CHANNEL_BUF_REQD,
      BUF_REQD_ADDR => riffa_0_CHANNEL_BUF_REQD_ADDR,
      BUF_REQD_SIZE => riffa_0_CHANNEL_BUF_REQD_SIZE,
      BUF_REQD_RDY => riffa_0_CHANNEL_BUF_REQD_RDY,
      BUF_REQD_ERR => riffa_0_CHANNEL_BUF_REQD_ERR,
      BRAM_Rst_0 => riffa_0_BRAMPORT_0_BRAM_Rst,
      BRAM_Clk_0 => riffa_0_BRAMPORT_0_BRAM_Clk,
      BRAM_EN_0 => riffa_0_BRAMPORT_0_BRAM_EN,
      BRAM_WEN_0 => riffa_0_BRAMPORT_0_BRAM_WEN,
      BRAM_Addr_0 => riffa_0_BRAMPORT_0_BRAM_Addr,
      BRAM_Din_0 => riffa_0_BRAMPORT_0_BRAM_Din,
      BRAM_Dout_0 => riffa_0_BRAMPORT_0_BRAM_Dout,
      BRAM_Rst_1 => riffa_0_BRAMPORT_1_BRAM_Rst,
      BRAM_Clk_1 => riffa_0_BRAMPORT_1_BRAM_Clk,
      BRAM_EN_1 => riffa_0_BRAMPORT_1_BRAM_EN,
      BRAM_WEN_1 => riffa_0_BRAMPORT_1_BRAM_WEN,
      BRAM_Addr_1 => riffa_0_BRAMPORT_1_BRAM_Addr,
      BRAM_Din_1 => riffa_0_BRAMPORT_1_BRAM_Din,
      BRAM_Dout_1 => riffa_0_BRAMPORT_1_BRAM_Dout
    );

  bram_block_1 : system_bram_block_1_wrapper
    port map (
      BRAM_Rst_A => xps_bram_if_cntlr_1_PORTA_BRAM_Rst,
      BRAM_Clk_A => xps_bram_if_cntlr_1_PORTA_BRAM_Clk,
      BRAM_EN_A => xps_bram_if_cntlr_1_PORTA_BRAM_EN,
      BRAM_WEN_A => xps_bram_if_cntlr_1_PORTA_BRAM_WEN,
      BRAM_Addr_A => xps_bram_if_cntlr_1_PORTA_BRAM_Addr,
      BRAM_Din_A => xps_bram_if_cntlr_1_PORTA_BRAM_Din,
      BRAM_Dout_A => xps_bram_if_cntlr_1_PORTA_BRAM_Dout,
      BRAM_Rst_B => riffa_0_BRAMPORT_1_BRAM_Rst,
      BRAM_Clk_B => riffa_0_BRAMPORT_1_BRAM_Clk,
      BRAM_EN_B => riffa_0_BRAMPORT_1_BRAM_EN,
      BRAM_WEN_B => riffa_0_BRAMPORT_1_BRAM_WEN,
      BRAM_Addr_B => riffa_0_BRAMPORT_1_BRAM_Addr,
      BRAM_Din_B => riffa_0_BRAMPORT_1_BRAM_Din,
      BRAM_Dout_B => riffa_0_BRAMPORT_1_BRAM_Dout
    );

  xps_bram_if_cntlr_1 : system_xps_bram_if_cntlr_1_wrapper
    port map (
      SPLB_Clk => clk_125_0000MHz,
      SPLB_Rst => mb_plb_SPLB_Rst(4),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(4),
      PLB_wrPrim => mb_plb_PLB_wrPrim(4),
      PLB_masterID => mb_plb_PLB_masterID,
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(4),
      Sl_SSize => mb_plb_Sl_SSize(8 to 9),
      Sl_wait => mb_plb_Sl_wait(4),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(4),
      Sl_wrDAck => mb_plb_Sl_wrDAck(4),
      Sl_wrComp => mb_plb_Sl_wrComp(4),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(4),
      Sl_rdDBus => mb_plb_Sl_rdDBus(256 to 319),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(16 to 19),
      Sl_rdDAck => mb_plb_Sl_rdDAck(4),
      Sl_rdComp => mb_plb_Sl_rdComp(4),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(4),
      Sl_MBusy => mb_plb_Sl_MBusy(12 to 14),
      Sl_MWrErr => mb_plb_Sl_MWrErr(12 to 14),
      Sl_MRdErr => mb_plb_Sl_MRdErr(12 to 14),
      Sl_MIRQ => mb_plb_Sl_MIRQ(12 to 14),
      BRAM_Rst => xps_bram_if_cntlr_1_PORTA_BRAM_Rst,
      BRAM_Clk => xps_bram_if_cntlr_1_PORTA_BRAM_Clk,
      BRAM_EN => xps_bram_if_cntlr_1_PORTA_BRAM_EN,
      BRAM_WEN => xps_bram_if_cntlr_1_PORTA_BRAM_WEN,
      BRAM_Addr => xps_bram_if_cntlr_1_PORTA_BRAM_Addr,
      BRAM_Din => xps_bram_if_cntlr_1_PORTA_BRAM_Din,
      BRAM_Dout => xps_bram_if_cntlr_1_PORTA_BRAM_Dout
    );

  ibufgds_0 : IBUFGDS
    port map (
      I => fpga_0_clk_1_sys_clk_p_pin,
      IB => fpga_0_clk_1_sys_clk_n_pin,
      O => CLK_S
    );

end architecture STRUCTURE;

