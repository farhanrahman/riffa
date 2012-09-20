-------------------------------------------------------------------------------
-- system_central_notifier_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library central_notifier_v2_00_a;
use central_notifier_v2_00_a.all;

entity system_central_notifier_0_wrapper is
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
end system_central_notifier_0_wrapper;

architecture STRUCTURE of system_central_notifier_0_wrapper is

  component central_notifier is
    generic (
      C_ARCH : string;
      C_SIMPBUS_AWIDTH : INTEGER;
      C_SIMPBUS_DWIDTH : INTEGER;
      C_NUM_CHANNELS : INTEGER;
      C_INIT_BUS : INTEGER;
      C_DMA_BASE_ADDR : std_logic_vector;
      C_PCIE_BASE_ADDR : std_logic_vector;
      C_PCIE_IPIF2PCI_LEN : INTEGER
    );
    port (
      SYS_CLK : in std_logic;
      SYS_RST : in std_logic;
      INTR_PCI : out std_logic;
      INTR_DMA : in std_logic;
      INIT_START : out std_logic;
      INIT_DONE : in std_logic;
      SIMPBUS_INIT_ADDR : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      SIMPBUS_INIT_WDATA : in std_logic_vector((C_SIMPBUS_DWIDTH-1) downto 0);
      SIMPBUS_INIT_RDATA : out std_logic_vector((C_SIMPBUS_DWIDTH-1) downto 0);
      SIMPBUS_INIT_BE : in std_logic_vector((C_SIMPBUS_DWIDTH/8-1) downto 0);
      SIMPBUS_INIT_RNW : in std_logic;
      SIMPBUS_INIT_START : in std_logic;
      SIMPBUS_INIT_DONE : out std_logic;
      SIMPBUS_INIT_ERR : out std_logic;
      SIMPBUS_MST_ADDR : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      SIMPBUS_MST_WDATA : out std_logic_vector((C_SIMPBUS_DWIDTH-1) downto 0);
      SIMPBUS_MST_RDATA : in std_logic_vector((C_SIMPBUS_DWIDTH-1) downto 0);
      SIMPBUS_MST_BE : out std_logic_vector((C_SIMPBUS_DWIDTH/8-1) downto 0);
      SIMPBUS_MST_RNW : out std_logic;
      SIMPBUS_MST_START : out std_logic;
      SIMPBUS_MST_DONE : in std_logic;
      SIMPBUS_MST_ERR : in std_logic;
      SIMPBUS_SLV_ADDR : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      SIMPBUS_SLV_WDATA : in std_logic_vector((C_SIMPBUS_DWIDTH-1) downto 0);
      SIMPBUS_SLV_RDATA : out std_logic_vector((C_SIMPBUS_DWIDTH-1) downto 0);
      SIMPBUS_SLV_BE : in std_logic_vector((C_SIMPBUS_DWIDTH/8-1) downto 0);
      SIMPBUS_SLV_RNW : in std_logic;
      SIMPBUS_SLV_START : in std_logic;
      SIMPBUS_SLV_DONE : out std_logic;
      SIMPBUS_SLV_ERR : out std_logic;
      INTERRUPT_00 : in std_logic;
      INTERRUPT_ERR_00 : in std_logic;
      INTERRUPT_ACK_00 : out std_logic;
      DOORBELL_00 : out std_logic;
      DOORBELL_ERR_00 : out std_logic;
      DOORBELL_LEN_00 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_00 : out std_logic_vector(31 downto 0);
      DMA_REQ_00 : in std_logic;
      DMA_REQ_ACK_00 : out std_logic;
      DMA_SRC_00 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_00 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_00 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_00 : in std_logic;
      DMA_DONE_00 : out std_logic;
      DMA_ERR_00 : out std_logic;
      BUF_REQ_00 : in std_logic;
      BUF_REQ_ACK_00 : out std_logic;
      BUF_REQ_ADDR_00 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_00 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_00 : out std_logic;
      BUF_REQ_ERR_00 : out std_logic;
      BUF_REQD_00 : out std_logic;
      BUF_REQD_ADDR_00 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_00 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_00 : in std_logic;
      BUF_REQD_ERR_00 : in std_logic;
      INTERRUPT_01 : in std_logic;
      INTERRUPT_ERR_01 : in std_logic;
      INTERRUPT_ACK_01 : out std_logic;
      DOORBELL_01 : out std_logic;
      DOORBELL_ERR_01 : out std_logic;
      DOORBELL_LEN_01 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_01 : out std_logic_vector(31 downto 0);
      DMA_REQ_01 : in std_logic;
      DMA_REQ_ACK_01 : out std_logic;
      DMA_SRC_01 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_01 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_01 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_01 : in std_logic;
      DMA_DONE_01 : out std_logic;
      DMA_ERR_01 : out std_logic;
      BUF_REQ_01 : in std_logic;
      BUF_REQ_ACK_01 : out std_logic;
      BUF_REQ_ADDR_01 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_01 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_01 : out std_logic;
      BUF_REQ_ERR_01 : out std_logic;
      BUF_REQD_01 : out std_logic;
      BUF_REQD_ADDR_01 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_01 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_01 : in std_logic;
      BUF_REQD_ERR_01 : in std_logic;
      INTERRUPT_02 : in std_logic;
      INTERRUPT_ERR_02 : in std_logic;
      INTERRUPT_ACK_02 : out std_logic;
      DOORBELL_02 : out std_logic;
      DOORBELL_ERR_02 : out std_logic;
      DOORBELL_LEN_02 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_02 : out std_logic_vector(31 downto 0);
      DMA_REQ_02 : in std_logic;
      DMA_REQ_ACK_02 : out std_logic;
      DMA_SRC_02 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_02 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_02 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_02 : in std_logic;
      DMA_DONE_02 : out std_logic;
      DMA_ERR_02 : out std_logic;
      BUF_REQ_02 : in std_logic;
      BUF_REQ_ACK_02 : out std_logic;
      BUF_REQ_ADDR_02 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_02 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_02 : out std_logic;
      BUF_REQ_ERR_02 : out std_logic;
      BUF_REQD_02 : out std_logic;
      BUF_REQD_ADDR_02 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_02 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_02 : in std_logic;
      BUF_REQD_ERR_02 : in std_logic;
      INTERRUPT_03 : in std_logic;
      INTERRUPT_ERR_03 : in std_logic;
      INTERRUPT_ACK_03 : out std_logic;
      DOORBELL_03 : out std_logic;
      DOORBELL_ERR_03 : out std_logic;
      DOORBELL_LEN_03 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_03 : out std_logic_vector(31 downto 0);
      DMA_REQ_03 : in std_logic;
      DMA_REQ_ACK_03 : out std_logic;
      DMA_SRC_03 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_03 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_03 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_03 : in std_logic;
      DMA_DONE_03 : out std_logic;
      DMA_ERR_03 : out std_logic;
      BUF_REQ_03 : in std_logic;
      BUF_REQ_ACK_03 : out std_logic;
      BUF_REQ_ADDR_03 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_03 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_03 : out std_logic;
      BUF_REQ_ERR_03 : out std_logic;
      BUF_REQD_03 : out std_logic;
      BUF_REQD_ADDR_03 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_03 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_03 : in std_logic;
      BUF_REQD_ERR_03 : in std_logic;
      INTERRUPT_04 : in std_logic;
      INTERRUPT_ERR_04 : in std_logic;
      INTERRUPT_ACK_04 : out std_logic;
      DOORBELL_04 : out std_logic;
      DOORBELL_ERR_04 : out std_logic;
      DOORBELL_LEN_04 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_04 : out std_logic_vector(31 downto 0);
      DMA_REQ_04 : in std_logic;
      DMA_REQ_ACK_04 : out std_logic;
      DMA_SRC_04 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_04 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_04 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_04 : in std_logic;
      DMA_DONE_04 : out std_logic;
      DMA_ERR_04 : out std_logic;
      BUF_REQ_04 : in std_logic;
      BUF_REQ_ACK_04 : out std_logic;
      BUF_REQ_ADDR_04 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_04 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_04 : out std_logic;
      BUF_REQ_ERR_04 : out std_logic;
      BUF_REQD_04 : out std_logic;
      BUF_REQD_ADDR_04 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_04 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_04 : in std_logic;
      BUF_REQD_ERR_04 : in std_logic;
      INTERRUPT_05 : in std_logic;
      INTERRUPT_ERR_05 : in std_logic;
      INTERRUPT_ACK_05 : out std_logic;
      DOORBELL_05 : out std_logic;
      DOORBELL_ERR_05 : out std_logic;
      DOORBELL_LEN_05 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_05 : out std_logic_vector(31 downto 0);
      DMA_REQ_05 : in std_logic;
      DMA_REQ_ACK_05 : out std_logic;
      DMA_SRC_05 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_05 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_05 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_05 : in std_logic;
      DMA_DONE_05 : out std_logic;
      DMA_ERR_05 : out std_logic;
      BUF_REQ_05 : in std_logic;
      BUF_REQ_ACK_05 : out std_logic;
      BUF_REQ_ADDR_05 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_05 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_05 : out std_logic;
      BUF_REQ_ERR_05 : out std_logic;
      BUF_REQD_05 : out std_logic;
      BUF_REQD_ADDR_05 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_05 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_05 : in std_logic;
      BUF_REQD_ERR_05 : in std_logic;
      INTERRUPT_06 : in std_logic;
      INTERRUPT_ERR_06 : in std_logic;
      INTERRUPT_ACK_06 : out std_logic;
      DOORBELL_06 : out std_logic;
      DOORBELL_ERR_06 : out std_logic;
      DOORBELL_LEN_06 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_06 : out std_logic_vector(31 downto 0);
      DMA_REQ_06 : in std_logic;
      DMA_REQ_ACK_06 : out std_logic;
      DMA_SRC_06 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_06 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_06 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_06 : in std_logic;
      DMA_DONE_06 : out std_logic;
      DMA_ERR_06 : out std_logic;
      BUF_REQ_06 : in std_logic;
      BUF_REQ_ACK_06 : out std_logic;
      BUF_REQ_ADDR_06 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_06 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_06 : out std_logic;
      BUF_REQ_ERR_06 : out std_logic;
      BUF_REQD_06 : out std_logic;
      BUF_REQD_ADDR_06 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_06 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_06 : in std_logic;
      BUF_REQD_ERR_06 : in std_logic;
      INTERRUPT_07 : in std_logic;
      INTERRUPT_ERR_07 : in std_logic;
      INTERRUPT_ACK_07 : out std_logic;
      DOORBELL_07 : out std_logic;
      DOORBELL_ERR_07 : out std_logic;
      DOORBELL_LEN_07 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_07 : out std_logic_vector(31 downto 0);
      DMA_REQ_07 : in std_logic;
      DMA_REQ_ACK_07 : out std_logic;
      DMA_SRC_07 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_07 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_07 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_07 : in std_logic;
      DMA_DONE_07 : out std_logic;
      DMA_ERR_07 : out std_logic;
      BUF_REQ_07 : in std_logic;
      BUF_REQ_ACK_07 : out std_logic;
      BUF_REQ_ADDR_07 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_07 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_07 : out std_logic;
      BUF_REQ_ERR_07 : out std_logic;
      BUF_REQD_07 : out std_logic;
      BUF_REQD_ADDR_07 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_07 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_07 : in std_logic;
      BUF_REQD_ERR_07 : in std_logic;
      INTERRUPT_08 : in std_logic;
      INTERRUPT_ERR_08 : in std_logic;
      INTERRUPT_ACK_08 : out std_logic;
      DOORBELL_08 : out std_logic;
      DOORBELL_ERR_08 : out std_logic;
      DOORBELL_LEN_08 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_08 : out std_logic_vector(31 downto 0);
      DMA_REQ_08 : in std_logic;
      DMA_REQ_ACK_08 : out std_logic;
      DMA_SRC_08 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_08 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_08 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_08 : in std_logic;
      DMA_DONE_08 : out std_logic;
      DMA_ERR_08 : out std_logic;
      BUF_REQ_08 : in std_logic;
      BUF_REQ_ACK_08 : out std_logic;
      BUF_REQ_ADDR_08 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_08 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_08 : out std_logic;
      BUF_REQ_ERR_08 : out std_logic;
      BUF_REQD_08 : out std_logic;
      BUF_REQD_ADDR_08 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_08 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_08 : in std_logic;
      BUF_REQD_ERR_08 : in std_logic;
      INTERRUPT_09 : in std_logic;
      INTERRUPT_ERR_09 : in std_logic;
      INTERRUPT_ACK_09 : out std_logic;
      DOORBELL_09 : out std_logic;
      DOORBELL_ERR_09 : out std_logic;
      DOORBELL_LEN_09 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_09 : out std_logic_vector(31 downto 0);
      DMA_REQ_09 : in std_logic;
      DMA_REQ_ACK_09 : out std_logic;
      DMA_SRC_09 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_09 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_09 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_09 : in std_logic;
      DMA_DONE_09 : out std_logic;
      DMA_ERR_09 : out std_logic;
      BUF_REQ_09 : in std_logic;
      BUF_REQ_ACK_09 : out std_logic;
      BUF_REQ_ADDR_09 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_09 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_09 : out std_logic;
      BUF_REQ_ERR_09 : out std_logic;
      BUF_REQD_09 : out std_logic;
      BUF_REQD_ADDR_09 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_09 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_09 : in std_logic;
      BUF_REQD_ERR_09 : in std_logic;
      INTERRUPT_10 : in std_logic;
      INTERRUPT_ERR_10 : in std_logic;
      INTERRUPT_ACK_10 : out std_logic;
      DOORBELL_10 : out std_logic;
      DOORBELL_ERR_10 : out std_logic;
      DOORBELL_LEN_10 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_10 : out std_logic_vector(31 downto 0);
      DMA_REQ_10 : in std_logic;
      DMA_REQ_ACK_10 : out std_logic;
      DMA_SRC_10 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_10 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_10 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_10 : in std_logic;
      DMA_DONE_10 : out std_logic;
      DMA_ERR_10 : out std_logic;
      BUF_REQ_10 : in std_logic;
      BUF_REQ_ACK_10 : out std_logic;
      BUF_REQ_ADDR_10 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_10 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_10 : out std_logic;
      BUF_REQ_ERR_10 : out std_logic;
      BUF_REQD_10 : out std_logic;
      BUF_REQD_ADDR_10 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_10 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_10 : in std_logic;
      BUF_REQD_ERR_10 : in std_logic;
      INTERRUPT_11 : in std_logic;
      INTERRUPT_ERR_11 : in std_logic;
      INTERRUPT_ACK_11 : out std_logic;
      DOORBELL_11 : out std_logic;
      DOORBELL_ERR_11 : out std_logic;
      DOORBELL_LEN_11 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_11 : out std_logic_vector(31 downto 0);
      DMA_REQ_11 : in std_logic;
      DMA_REQ_ACK_11 : out std_logic;
      DMA_SRC_11 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_11 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_11 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_11 : in std_logic;
      DMA_DONE_11 : out std_logic;
      DMA_ERR_11 : out std_logic;
      BUF_REQ_11 : in std_logic;
      BUF_REQ_ACK_11 : out std_logic;
      BUF_REQ_ADDR_11 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_11 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_11 : out std_logic;
      BUF_REQ_ERR_11 : out std_logic;
      BUF_REQD_11 : out std_logic;
      BUF_REQD_ADDR_11 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_11 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_11 : in std_logic;
      BUF_REQD_ERR_11 : in std_logic;
      INTERRUPT_12 : in std_logic;
      INTERRUPT_ERR_12 : in std_logic;
      INTERRUPT_ACK_12 : out std_logic;
      DOORBELL_12 : out std_logic;
      DOORBELL_ERR_12 : out std_logic;
      DOORBELL_LEN_12 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_12 : out std_logic_vector(31 downto 0);
      DMA_REQ_12 : in std_logic;
      DMA_REQ_ACK_12 : out std_logic;
      DMA_SRC_12 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_12 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_12 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_12 : in std_logic;
      DMA_DONE_12 : out std_logic;
      DMA_ERR_12 : out std_logic;
      BUF_REQ_12 : in std_logic;
      BUF_REQ_ACK_12 : out std_logic;
      BUF_REQ_ADDR_12 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_12 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_12 : out std_logic;
      BUF_REQ_ERR_12 : out std_logic;
      BUF_REQD_12 : out std_logic;
      BUF_REQD_ADDR_12 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_12 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_12 : in std_logic;
      BUF_REQD_ERR_12 : in std_logic;
      INTERRUPT_13 : in std_logic;
      INTERRUPT_ERR_13 : in std_logic;
      INTERRUPT_ACK_13 : out std_logic;
      DOORBELL_13 : out std_logic;
      DOORBELL_ERR_13 : out std_logic;
      DOORBELL_LEN_13 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_13 : out std_logic_vector(31 downto 0);
      DMA_REQ_13 : in std_logic;
      DMA_REQ_ACK_13 : out std_logic;
      DMA_SRC_13 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_13 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_13 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_13 : in std_logic;
      DMA_DONE_13 : out std_logic;
      DMA_ERR_13 : out std_logic;
      BUF_REQ_13 : in std_logic;
      BUF_REQ_ACK_13 : out std_logic;
      BUF_REQ_ADDR_13 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_13 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_13 : out std_logic;
      BUF_REQ_ERR_13 : out std_logic;
      BUF_REQD_13 : out std_logic;
      BUF_REQD_ADDR_13 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_13 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_13 : in std_logic;
      BUF_REQD_ERR_13 : in std_logic;
      INTERRUPT_14 : in std_logic;
      INTERRUPT_ERR_14 : in std_logic;
      INTERRUPT_ACK_14 : out std_logic;
      DOORBELL_14 : out std_logic;
      DOORBELL_ERR_14 : out std_logic;
      DOORBELL_LEN_14 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_14 : out std_logic_vector(31 downto 0);
      DMA_REQ_14 : in std_logic;
      DMA_REQ_ACK_14 : out std_logic;
      DMA_SRC_14 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_14 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_14 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_14 : in std_logic;
      DMA_DONE_14 : out std_logic;
      DMA_ERR_14 : out std_logic;
      BUF_REQ_14 : in std_logic;
      BUF_REQ_ACK_14 : out std_logic;
      BUF_REQ_ADDR_14 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_14 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_14 : out std_logic;
      BUF_REQ_ERR_14 : out std_logic;
      BUF_REQD_14 : out std_logic;
      BUF_REQD_ADDR_14 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_14 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_14 : in std_logic;
      BUF_REQD_ERR_14 : in std_logic;
      INTERRUPT_15 : in std_logic;
      INTERRUPT_ERR_15 : in std_logic;
      INTERRUPT_ACK_15 : out std_logic;
      DOORBELL_15 : out std_logic;
      DOORBELL_ERR_15 : out std_logic;
      DOORBELL_LEN_15 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG_15 : out std_logic_vector(31 downto 0);
      DMA_REQ_15 : in std_logic;
      DMA_REQ_ACK_15 : out std_logic;
      DMA_SRC_15 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST_15 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN_15 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG_15 : in std_logic;
      DMA_DONE_15 : out std_logic;
      DMA_ERR_15 : out std_logic;
      BUF_REQ_15 : in std_logic;
      BUF_REQ_ACK_15 : out std_logic;
      BUF_REQ_ADDR_15 : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE_15 : out std_logic_vector(4 downto 0);
      BUF_REQ_RDY_15 : out std_logic;
      BUF_REQ_ERR_15 : out std_logic;
      BUF_REQD_15 : out std_logic;
      BUF_REQD_ADDR_15 : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQD_SIZE_15 : in std_logic_vector(4 downto 0);
      BUF_REQD_RDY_15 : in std_logic;
      BUF_REQD_ERR_15 : in std_logic
    );
  end component;

begin

  central_notifier_0 : central_notifier
    generic map (
      C_ARCH => "V6",
      C_SIMPBUS_AWIDTH => 32,
      C_SIMPBUS_DWIDTH => 32,
      C_NUM_CHANNELS => 1,
      C_INIT_BUS => 0,
      C_DMA_BASE_ADDR => X"80200000",
      C_PCIE_BASE_ADDR => X"85C00000",
      C_PCIE_IPIF2PCI_LEN => 4194304
    )
    port map (
      SYS_CLK => SYS_CLK,
      SYS_RST => SYS_RST,
      INTR_PCI => INTR_PCI,
      INTR_DMA => INTR_DMA,
      INIT_START => INIT_START,
      INIT_DONE => INIT_DONE,
      SIMPBUS_INIT_ADDR => SIMPBUS_INIT_ADDR,
      SIMPBUS_INIT_WDATA => SIMPBUS_INIT_WDATA,
      SIMPBUS_INIT_RDATA => SIMPBUS_INIT_RDATA,
      SIMPBUS_INIT_BE => SIMPBUS_INIT_BE,
      SIMPBUS_INIT_RNW => SIMPBUS_INIT_RNW,
      SIMPBUS_INIT_START => SIMPBUS_INIT_START,
      SIMPBUS_INIT_DONE => SIMPBUS_INIT_DONE,
      SIMPBUS_INIT_ERR => SIMPBUS_INIT_ERR,
      SIMPBUS_MST_ADDR => SIMPBUS_MST_ADDR,
      SIMPBUS_MST_WDATA => SIMPBUS_MST_WDATA,
      SIMPBUS_MST_RDATA => SIMPBUS_MST_RDATA,
      SIMPBUS_MST_BE => SIMPBUS_MST_BE,
      SIMPBUS_MST_RNW => SIMPBUS_MST_RNW,
      SIMPBUS_MST_START => SIMPBUS_MST_START,
      SIMPBUS_MST_DONE => SIMPBUS_MST_DONE,
      SIMPBUS_MST_ERR => SIMPBUS_MST_ERR,
      SIMPBUS_SLV_ADDR => SIMPBUS_SLV_ADDR,
      SIMPBUS_SLV_WDATA => SIMPBUS_SLV_WDATA,
      SIMPBUS_SLV_RDATA => SIMPBUS_SLV_RDATA,
      SIMPBUS_SLV_BE => SIMPBUS_SLV_BE,
      SIMPBUS_SLV_RNW => SIMPBUS_SLV_RNW,
      SIMPBUS_SLV_START => SIMPBUS_SLV_START,
      SIMPBUS_SLV_DONE => SIMPBUS_SLV_DONE,
      SIMPBUS_SLV_ERR => SIMPBUS_SLV_ERR,
      INTERRUPT_00 => INTERRUPT_00,
      INTERRUPT_ERR_00 => INTERRUPT_ERR_00,
      INTERRUPT_ACK_00 => INTERRUPT_ACK_00,
      DOORBELL_00 => DOORBELL_00,
      DOORBELL_ERR_00 => DOORBELL_ERR_00,
      DOORBELL_LEN_00 => DOORBELL_LEN_00,
      DOORBELL_ARG_00 => DOORBELL_ARG_00,
      DMA_REQ_00 => DMA_REQ_00,
      DMA_REQ_ACK_00 => DMA_REQ_ACK_00,
      DMA_SRC_00 => DMA_SRC_00,
      DMA_DST_00 => DMA_DST_00,
      DMA_LEN_00 => DMA_LEN_00,
      DMA_SIG_00 => DMA_SIG_00,
      DMA_DONE_00 => DMA_DONE_00,
      DMA_ERR_00 => DMA_ERR_00,
      BUF_REQ_00 => BUF_REQ_00,
      BUF_REQ_ACK_00 => BUF_REQ_ACK_00,
      BUF_REQ_ADDR_00 => BUF_REQ_ADDR_00,
      BUF_REQ_SIZE_00 => BUF_REQ_SIZE_00,
      BUF_REQ_RDY_00 => BUF_REQ_RDY_00,
      BUF_REQ_ERR_00 => BUF_REQ_ERR_00,
      BUF_REQD_00 => BUF_REQD_00,
      BUF_REQD_ADDR_00 => BUF_REQD_ADDR_00,
      BUF_REQD_SIZE_00 => BUF_REQD_SIZE_00,
      BUF_REQD_RDY_00 => BUF_REQD_RDY_00,
      BUF_REQD_ERR_00 => BUF_REQD_ERR_00,
      INTERRUPT_01 => INTERRUPT_01,
      INTERRUPT_ERR_01 => INTERRUPT_ERR_01,
      INTERRUPT_ACK_01 => INTERRUPT_ACK_01,
      DOORBELL_01 => DOORBELL_01,
      DOORBELL_ERR_01 => DOORBELL_ERR_01,
      DOORBELL_LEN_01 => DOORBELL_LEN_01,
      DOORBELL_ARG_01 => DOORBELL_ARG_01,
      DMA_REQ_01 => DMA_REQ_01,
      DMA_REQ_ACK_01 => DMA_REQ_ACK_01,
      DMA_SRC_01 => DMA_SRC_01,
      DMA_DST_01 => DMA_DST_01,
      DMA_LEN_01 => DMA_LEN_01,
      DMA_SIG_01 => DMA_SIG_01,
      DMA_DONE_01 => DMA_DONE_01,
      DMA_ERR_01 => DMA_ERR_01,
      BUF_REQ_01 => BUF_REQ_01,
      BUF_REQ_ACK_01 => BUF_REQ_ACK_01,
      BUF_REQ_ADDR_01 => BUF_REQ_ADDR_01,
      BUF_REQ_SIZE_01 => BUF_REQ_SIZE_01,
      BUF_REQ_RDY_01 => BUF_REQ_RDY_01,
      BUF_REQ_ERR_01 => BUF_REQ_ERR_01,
      BUF_REQD_01 => BUF_REQD_01,
      BUF_REQD_ADDR_01 => BUF_REQD_ADDR_01,
      BUF_REQD_SIZE_01 => BUF_REQD_SIZE_01,
      BUF_REQD_RDY_01 => BUF_REQD_RDY_01,
      BUF_REQD_ERR_01 => BUF_REQD_ERR_01,
      INTERRUPT_02 => INTERRUPT_02,
      INTERRUPT_ERR_02 => INTERRUPT_ERR_02,
      INTERRUPT_ACK_02 => INTERRUPT_ACK_02,
      DOORBELL_02 => DOORBELL_02,
      DOORBELL_ERR_02 => DOORBELL_ERR_02,
      DOORBELL_LEN_02 => DOORBELL_LEN_02,
      DOORBELL_ARG_02 => DOORBELL_ARG_02,
      DMA_REQ_02 => DMA_REQ_02,
      DMA_REQ_ACK_02 => DMA_REQ_ACK_02,
      DMA_SRC_02 => DMA_SRC_02,
      DMA_DST_02 => DMA_DST_02,
      DMA_LEN_02 => DMA_LEN_02,
      DMA_SIG_02 => DMA_SIG_02,
      DMA_DONE_02 => DMA_DONE_02,
      DMA_ERR_02 => DMA_ERR_02,
      BUF_REQ_02 => BUF_REQ_02,
      BUF_REQ_ACK_02 => BUF_REQ_ACK_02,
      BUF_REQ_ADDR_02 => BUF_REQ_ADDR_02,
      BUF_REQ_SIZE_02 => BUF_REQ_SIZE_02,
      BUF_REQ_RDY_02 => BUF_REQ_RDY_02,
      BUF_REQ_ERR_02 => BUF_REQ_ERR_02,
      BUF_REQD_02 => BUF_REQD_02,
      BUF_REQD_ADDR_02 => BUF_REQD_ADDR_02,
      BUF_REQD_SIZE_02 => BUF_REQD_SIZE_02,
      BUF_REQD_RDY_02 => BUF_REQD_RDY_02,
      BUF_REQD_ERR_02 => BUF_REQD_ERR_02,
      INTERRUPT_03 => INTERRUPT_03,
      INTERRUPT_ERR_03 => INTERRUPT_ERR_03,
      INTERRUPT_ACK_03 => INTERRUPT_ACK_03,
      DOORBELL_03 => DOORBELL_03,
      DOORBELL_ERR_03 => DOORBELL_ERR_03,
      DOORBELL_LEN_03 => DOORBELL_LEN_03,
      DOORBELL_ARG_03 => DOORBELL_ARG_03,
      DMA_REQ_03 => DMA_REQ_03,
      DMA_REQ_ACK_03 => DMA_REQ_ACK_03,
      DMA_SRC_03 => DMA_SRC_03,
      DMA_DST_03 => DMA_DST_03,
      DMA_LEN_03 => DMA_LEN_03,
      DMA_SIG_03 => DMA_SIG_03,
      DMA_DONE_03 => DMA_DONE_03,
      DMA_ERR_03 => DMA_ERR_03,
      BUF_REQ_03 => BUF_REQ_03,
      BUF_REQ_ACK_03 => BUF_REQ_ACK_03,
      BUF_REQ_ADDR_03 => BUF_REQ_ADDR_03,
      BUF_REQ_SIZE_03 => BUF_REQ_SIZE_03,
      BUF_REQ_RDY_03 => BUF_REQ_RDY_03,
      BUF_REQ_ERR_03 => BUF_REQ_ERR_03,
      BUF_REQD_03 => BUF_REQD_03,
      BUF_REQD_ADDR_03 => BUF_REQD_ADDR_03,
      BUF_REQD_SIZE_03 => BUF_REQD_SIZE_03,
      BUF_REQD_RDY_03 => BUF_REQD_RDY_03,
      BUF_REQD_ERR_03 => BUF_REQD_ERR_03,
      INTERRUPT_04 => INTERRUPT_04,
      INTERRUPT_ERR_04 => INTERRUPT_ERR_04,
      INTERRUPT_ACK_04 => INTERRUPT_ACK_04,
      DOORBELL_04 => DOORBELL_04,
      DOORBELL_ERR_04 => DOORBELL_ERR_04,
      DOORBELL_LEN_04 => DOORBELL_LEN_04,
      DOORBELL_ARG_04 => DOORBELL_ARG_04,
      DMA_REQ_04 => DMA_REQ_04,
      DMA_REQ_ACK_04 => DMA_REQ_ACK_04,
      DMA_SRC_04 => DMA_SRC_04,
      DMA_DST_04 => DMA_DST_04,
      DMA_LEN_04 => DMA_LEN_04,
      DMA_SIG_04 => DMA_SIG_04,
      DMA_DONE_04 => DMA_DONE_04,
      DMA_ERR_04 => DMA_ERR_04,
      BUF_REQ_04 => BUF_REQ_04,
      BUF_REQ_ACK_04 => BUF_REQ_ACK_04,
      BUF_REQ_ADDR_04 => BUF_REQ_ADDR_04,
      BUF_REQ_SIZE_04 => BUF_REQ_SIZE_04,
      BUF_REQ_RDY_04 => BUF_REQ_RDY_04,
      BUF_REQ_ERR_04 => BUF_REQ_ERR_04,
      BUF_REQD_04 => BUF_REQD_04,
      BUF_REQD_ADDR_04 => BUF_REQD_ADDR_04,
      BUF_REQD_SIZE_04 => BUF_REQD_SIZE_04,
      BUF_REQD_RDY_04 => BUF_REQD_RDY_04,
      BUF_REQD_ERR_04 => BUF_REQD_ERR_04,
      INTERRUPT_05 => INTERRUPT_05,
      INTERRUPT_ERR_05 => INTERRUPT_ERR_05,
      INTERRUPT_ACK_05 => INTERRUPT_ACK_05,
      DOORBELL_05 => DOORBELL_05,
      DOORBELL_ERR_05 => DOORBELL_ERR_05,
      DOORBELL_LEN_05 => DOORBELL_LEN_05,
      DOORBELL_ARG_05 => DOORBELL_ARG_05,
      DMA_REQ_05 => DMA_REQ_05,
      DMA_REQ_ACK_05 => DMA_REQ_ACK_05,
      DMA_SRC_05 => DMA_SRC_05,
      DMA_DST_05 => DMA_DST_05,
      DMA_LEN_05 => DMA_LEN_05,
      DMA_SIG_05 => DMA_SIG_05,
      DMA_DONE_05 => DMA_DONE_05,
      DMA_ERR_05 => DMA_ERR_05,
      BUF_REQ_05 => BUF_REQ_05,
      BUF_REQ_ACK_05 => BUF_REQ_ACK_05,
      BUF_REQ_ADDR_05 => BUF_REQ_ADDR_05,
      BUF_REQ_SIZE_05 => BUF_REQ_SIZE_05,
      BUF_REQ_RDY_05 => BUF_REQ_RDY_05,
      BUF_REQ_ERR_05 => BUF_REQ_ERR_05,
      BUF_REQD_05 => BUF_REQD_05,
      BUF_REQD_ADDR_05 => BUF_REQD_ADDR_05,
      BUF_REQD_SIZE_05 => BUF_REQD_SIZE_05,
      BUF_REQD_RDY_05 => BUF_REQD_RDY_05,
      BUF_REQD_ERR_05 => BUF_REQD_ERR_05,
      INTERRUPT_06 => INTERRUPT_06,
      INTERRUPT_ERR_06 => INTERRUPT_ERR_06,
      INTERRUPT_ACK_06 => INTERRUPT_ACK_06,
      DOORBELL_06 => DOORBELL_06,
      DOORBELL_ERR_06 => DOORBELL_ERR_06,
      DOORBELL_LEN_06 => DOORBELL_LEN_06,
      DOORBELL_ARG_06 => DOORBELL_ARG_06,
      DMA_REQ_06 => DMA_REQ_06,
      DMA_REQ_ACK_06 => DMA_REQ_ACK_06,
      DMA_SRC_06 => DMA_SRC_06,
      DMA_DST_06 => DMA_DST_06,
      DMA_LEN_06 => DMA_LEN_06,
      DMA_SIG_06 => DMA_SIG_06,
      DMA_DONE_06 => DMA_DONE_06,
      DMA_ERR_06 => DMA_ERR_06,
      BUF_REQ_06 => BUF_REQ_06,
      BUF_REQ_ACK_06 => BUF_REQ_ACK_06,
      BUF_REQ_ADDR_06 => BUF_REQ_ADDR_06,
      BUF_REQ_SIZE_06 => BUF_REQ_SIZE_06,
      BUF_REQ_RDY_06 => BUF_REQ_RDY_06,
      BUF_REQ_ERR_06 => BUF_REQ_ERR_06,
      BUF_REQD_06 => BUF_REQD_06,
      BUF_REQD_ADDR_06 => BUF_REQD_ADDR_06,
      BUF_REQD_SIZE_06 => BUF_REQD_SIZE_06,
      BUF_REQD_RDY_06 => BUF_REQD_RDY_06,
      BUF_REQD_ERR_06 => BUF_REQD_ERR_06,
      INTERRUPT_07 => INTERRUPT_07,
      INTERRUPT_ERR_07 => INTERRUPT_ERR_07,
      INTERRUPT_ACK_07 => INTERRUPT_ACK_07,
      DOORBELL_07 => DOORBELL_07,
      DOORBELL_ERR_07 => DOORBELL_ERR_07,
      DOORBELL_LEN_07 => DOORBELL_LEN_07,
      DOORBELL_ARG_07 => DOORBELL_ARG_07,
      DMA_REQ_07 => DMA_REQ_07,
      DMA_REQ_ACK_07 => DMA_REQ_ACK_07,
      DMA_SRC_07 => DMA_SRC_07,
      DMA_DST_07 => DMA_DST_07,
      DMA_LEN_07 => DMA_LEN_07,
      DMA_SIG_07 => DMA_SIG_07,
      DMA_DONE_07 => DMA_DONE_07,
      DMA_ERR_07 => DMA_ERR_07,
      BUF_REQ_07 => BUF_REQ_07,
      BUF_REQ_ACK_07 => BUF_REQ_ACK_07,
      BUF_REQ_ADDR_07 => BUF_REQ_ADDR_07,
      BUF_REQ_SIZE_07 => BUF_REQ_SIZE_07,
      BUF_REQ_RDY_07 => BUF_REQ_RDY_07,
      BUF_REQ_ERR_07 => BUF_REQ_ERR_07,
      BUF_REQD_07 => BUF_REQD_07,
      BUF_REQD_ADDR_07 => BUF_REQD_ADDR_07,
      BUF_REQD_SIZE_07 => BUF_REQD_SIZE_07,
      BUF_REQD_RDY_07 => BUF_REQD_RDY_07,
      BUF_REQD_ERR_07 => BUF_REQD_ERR_07,
      INTERRUPT_08 => INTERRUPT_08,
      INTERRUPT_ERR_08 => INTERRUPT_ERR_08,
      INTERRUPT_ACK_08 => INTERRUPT_ACK_08,
      DOORBELL_08 => DOORBELL_08,
      DOORBELL_ERR_08 => DOORBELL_ERR_08,
      DOORBELL_LEN_08 => DOORBELL_LEN_08,
      DOORBELL_ARG_08 => DOORBELL_ARG_08,
      DMA_REQ_08 => DMA_REQ_08,
      DMA_REQ_ACK_08 => DMA_REQ_ACK_08,
      DMA_SRC_08 => DMA_SRC_08,
      DMA_DST_08 => DMA_DST_08,
      DMA_LEN_08 => DMA_LEN_08,
      DMA_SIG_08 => DMA_SIG_08,
      DMA_DONE_08 => DMA_DONE_08,
      DMA_ERR_08 => DMA_ERR_08,
      BUF_REQ_08 => BUF_REQ_08,
      BUF_REQ_ACK_08 => BUF_REQ_ACK_08,
      BUF_REQ_ADDR_08 => BUF_REQ_ADDR_08,
      BUF_REQ_SIZE_08 => BUF_REQ_SIZE_08,
      BUF_REQ_RDY_08 => BUF_REQ_RDY_08,
      BUF_REQ_ERR_08 => BUF_REQ_ERR_08,
      BUF_REQD_08 => BUF_REQD_08,
      BUF_REQD_ADDR_08 => BUF_REQD_ADDR_08,
      BUF_REQD_SIZE_08 => BUF_REQD_SIZE_08,
      BUF_REQD_RDY_08 => BUF_REQD_RDY_08,
      BUF_REQD_ERR_08 => BUF_REQD_ERR_08,
      INTERRUPT_09 => INTERRUPT_09,
      INTERRUPT_ERR_09 => INTERRUPT_ERR_09,
      INTERRUPT_ACK_09 => INTERRUPT_ACK_09,
      DOORBELL_09 => DOORBELL_09,
      DOORBELL_ERR_09 => DOORBELL_ERR_09,
      DOORBELL_LEN_09 => DOORBELL_LEN_09,
      DOORBELL_ARG_09 => DOORBELL_ARG_09,
      DMA_REQ_09 => DMA_REQ_09,
      DMA_REQ_ACK_09 => DMA_REQ_ACK_09,
      DMA_SRC_09 => DMA_SRC_09,
      DMA_DST_09 => DMA_DST_09,
      DMA_LEN_09 => DMA_LEN_09,
      DMA_SIG_09 => DMA_SIG_09,
      DMA_DONE_09 => DMA_DONE_09,
      DMA_ERR_09 => DMA_ERR_09,
      BUF_REQ_09 => BUF_REQ_09,
      BUF_REQ_ACK_09 => BUF_REQ_ACK_09,
      BUF_REQ_ADDR_09 => BUF_REQ_ADDR_09,
      BUF_REQ_SIZE_09 => BUF_REQ_SIZE_09,
      BUF_REQ_RDY_09 => BUF_REQ_RDY_09,
      BUF_REQ_ERR_09 => BUF_REQ_ERR_09,
      BUF_REQD_09 => BUF_REQD_09,
      BUF_REQD_ADDR_09 => BUF_REQD_ADDR_09,
      BUF_REQD_SIZE_09 => BUF_REQD_SIZE_09,
      BUF_REQD_RDY_09 => BUF_REQD_RDY_09,
      BUF_REQD_ERR_09 => BUF_REQD_ERR_09,
      INTERRUPT_10 => INTERRUPT_10,
      INTERRUPT_ERR_10 => INTERRUPT_ERR_10,
      INTERRUPT_ACK_10 => INTERRUPT_ACK_10,
      DOORBELL_10 => DOORBELL_10,
      DOORBELL_ERR_10 => DOORBELL_ERR_10,
      DOORBELL_LEN_10 => DOORBELL_LEN_10,
      DOORBELL_ARG_10 => DOORBELL_ARG_10,
      DMA_REQ_10 => DMA_REQ_10,
      DMA_REQ_ACK_10 => DMA_REQ_ACK_10,
      DMA_SRC_10 => DMA_SRC_10,
      DMA_DST_10 => DMA_DST_10,
      DMA_LEN_10 => DMA_LEN_10,
      DMA_SIG_10 => DMA_SIG_10,
      DMA_DONE_10 => DMA_DONE_10,
      DMA_ERR_10 => DMA_ERR_10,
      BUF_REQ_10 => BUF_REQ_10,
      BUF_REQ_ACK_10 => BUF_REQ_ACK_10,
      BUF_REQ_ADDR_10 => BUF_REQ_ADDR_10,
      BUF_REQ_SIZE_10 => BUF_REQ_SIZE_10,
      BUF_REQ_RDY_10 => BUF_REQ_RDY_10,
      BUF_REQ_ERR_10 => BUF_REQ_ERR_10,
      BUF_REQD_10 => BUF_REQD_10,
      BUF_REQD_ADDR_10 => BUF_REQD_ADDR_10,
      BUF_REQD_SIZE_10 => BUF_REQD_SIZE_10,
      BUF_REQD_RDY_10 => BUF_REQD_RDY_10,
      BUF_REQD_ERR_10 => BUF_REQD_ERR_10,
      INTERRUPT_11 => INTERRUPT_11,
      INTERRUPT_ERR_11 => INTERRUPT_ERR_11,
      INTERRUPT_ACK_11 => INTERRUPT_ACK_11,
      DOORBELL_11 => DOORBELL_11,
      DOORBELL_ERR_11 => DOORBELL_ERR_11,
      DOORBELL_LEN_11 => DOORBELL_LEN_11,
      DOORBELL_ARG_11 => DOORBELL_ARG_11,
      DMA_REQ_11 => DMA_REQ_11,
      DMA_REQ_ACK_11 => DMA_REQ_ACK_11,
      DMA_SRC_11 => DMA_SRC_11,
      DMA_DST_11 => DMA_DST_11,
      DMA_LEN_11 => DMA_LEN_11,
      DMA_SIG_11 => DMA_SIG_11,
      DMA_DONE_11 => DMA_DONE_11,
      DMA_ERR_11 => DMA_ERR_11,
      BUF_REQ_11 => BUF_REQ_11,
      BUF_REQ_ACK_11 => BUF_REQ_ACK_11,
      BUF_REQ_ADDR_11 => BUF_REQ_ADDR_11,
      BUF_REQ_SIZE_11 => BUF_REQ_SIZE_11,
      BUF_REQ_RDY_11 => BUF_REQ_RDY_11,
      BUF_REQ_ERR_11 => BUF_REQ_ERR_11,
      BUF_REQD_11 => BUF_REQD_11,
      BUF_REQD_ADDR_11 => BUF_REQD_ADDR_11,
      BUF_REQD_SIZE_11 => BUF_REQD_SIZE_11,
      BUF_REQD_RDY_11 => BUF_REQD_RDY_11,
      BUF_REQD_ERR_11 => BUF_REQD_ERR_11,
      INTERRUPT_12 => INTERRUPT_12,
      INTERRUPT_ERR_12 => INTERRUPT_ERR_12,
      INTERRUPT_ACK_12 => INTERRUPT_ACK_12,
      DOORBELL_12 => DOORBELL_12,
      DOORBELL_ERR_12 => DOORBELL_ERR_12,
      DOORBELL_LEN_12 => DOORBELL_LEN_12,
      DOORBELL_ARG_12 => DOORBELL_ARG_12,
      DMA_REQ_12 => DMA_REQ_12,
      DMA_REQ_ACK_12 => DMA_REQ_ACK_12,
      DMA_SRC_12 => DMA_SRC_12,
      DMA_DST_12 => DMA_DST_12,
      DMA_LEN_12 => DMA_LEN_12,
      DMA_SIG_12 => DMA_SIG_12,
      DMA_DONE_12 => DMA_DONE_12,
      DMA_ERR_12 => DMA_ERR_12,
      BUF_REQ_12 => BUF_REQ_12,
      BUF_REQ_ACK_12 => BUF_REQ_ACK_12,
      BUF_REQ_ADDR_12 => BUF_REQ_ADDR_12,
      BUF_REQ_SIZE_12 => BUF_REQ_SIZE_12,
      BUF_REQ_RDY_12 => BUF_REQ_RDY_12,
      BUF_REQ_ERR_12 => BUF_REQ_ERR_12,
      BUF_REQD_12 => BUF_REQD_12,
      BUF_REQD_ADDR_12 => BUF_REQD_ADDR_12,
      BUF_REQD_SIZE_12 => BUF_REQD_SIZE_12,
      BUF_REQD_RDY_12 => BUF_REQD_RDY_12,
      BUF_REQD_ERR_12 => BUF_REQD_ERR_12,
      INTERRUPT_13 => INTERRUPT_13,
      INTERRUPT_ERR_13 => INTERRUPT_ERR_13,
      INTERRUPT_ACK_13 => INTERRUPT_ACK_13,
      DOORBELL_13 => DOORBELL_13,
      DOORBELL_ERR_13 => DOORBELL_ERR_13,
      DOORBELL_LEN_13 => DOORBELL_LEN_13,
      DOORBELL_ARG_13 => DOORBELL_ARG_13,
      DMA_REQ_13 => DMA_REQ_13,
      DMA_REQ_ACK_13 => DMA_REQ_ACK_13,
      DMA_SRC_13 => DMA_SRC_13,
      DMA_DST_13 => DMA_DST_13,
      DMA_LEN_13 => DMA_LEN_13,
      DMA_SIG_13 => DMA_SIG_13,
      DMA_DONE_13 => DMA_DONE_13,
      DMA_ERR_13 => DMA_ERR_13,
      BUF_REQ_13 => BUF_REQ_13,
      BUF_REQ_ACK_13 => BUF_REQ_ACK_13,
      BUF_REQ_ADDR_13 => BUF_REQ_ADDR_13,
      BUF_REQ_SIZE_13 => BUF_REQ_SIZE_13,
      BUF_REQ_RDY_13 => BUF_REQ_RDY_13,
      BUF_REQ_ERR_13 => BUF_REQ_ERR_13,
      BUF_REQD_13 => BUF_REQD_13,
      BUF_REQD_ADDR_13 => BUF_REQD_ADDR_13,
      BUF_REQD_SIZE_13 => BUF_REQD_SIZE_13,
      BUF_REQD_RDY_13 => BUF_REQD_RDY_13,
      BUF_REQD_ERR_13 => BUF_REQD_ERR_13,
      INTERRUPT_14 => INTERRUPT_14,
      INTERRUPT_ERR_14 => INTERRUPT_ERR_14,
      INTERRUPT_ACK_14 => INTERRUPT_ACK_14,
      DOORBELL_14 => DOORBELL_14,
      DOORBELL_ERR_14 => DOORBELL_ERR_14,
      DOORBELL_LEN_14 => DOORBELL_LEN_14,
      DOORBELL_ARG_14 => DOORBELL_ARG_14,
      DMA_REQ_14 => DMA_REQ_14,
      DMA_REQ_ACK_14 => DMA_REQ_ACK_14,
      DMA_SRC_14 => DMA_SRC_14,
      DMA_DST_14 => DMA_DST_14,
      DMA_LEN_14 => DMA_LEN_14,
      DMA_SIG_14 => DMA_SIG_14,
      DMA_DONE_14 => DMA_DONE_14,
      DMA_ERR_14 => DMA_ERR_14,
      BUF_REQ_14 => BUF_REQ_14,
      BUF_REQ_ACK_14 => BUF_REQ_ACK_14,
      BUF_REQ_ADDR_14 => BUF_REQ_ADDR_14,
      BUF_REQ_SIZE_14 => BUF_REQ_SIZE_14,
      BUF_REQ_RDY_14 => BUF_REQ_RDY_14,
      BUF_REQ_ERR_14 => BUF_REQ_ERR_14,
      BUF_REQD_14 => BUF_REQD_14,
      BUF_REQD_ADDR_14 => BUF_REQD_ADDR_14,
      BUF_REQD_SIZE_14 => BUF_REQD_SIZE_14,
      BUF_REQD_RDY_14 => BUF_REQD_RDY_14,
      BUF_REQD_ERR_14 => BUF_REQD_ERR_14,
      INTERRUPT_15 => INTERRUPT_15,
      INTERRUPT_ERR_15 => INTERRUPT_ERR_15,
      INTERRUPT_ACK_15 => INTERRUPT_ACK_15,
      DOORBELL_15 => DOORBELL_15,
      DOORBELL_ERR_15 => DOORBELL_ERR_15,
      DOORBELL_LEN_15 => DOORBELL_LEN_15,
      DOORBELL_ARG_15 => DOORBELL_ARG_15,
      DMA_REQ_15 => DMA_REQ_15,
      DMA_REQ_ACK_15 => DMA_REQ_ACK_15,
      DMA_SRC_15 => DMA_SRC_15,
      DMA_DST_15 => DMA_DST_15,
      DMA_LEN_15 => DMA_LEN_15,
      DMA_SIG_15 => DMA_SIG_15,
      DMA_DONE_15 => DMA_DONE_15,
      DMA_ERR_15 => DMA_ERR_15,
      BUF_REQ_15 => BUF_REQ_15,
      BUF_REQ_ACK_15 => BUF_REQ_ACK_15,
      BUF_REQ_ADDR_15 => BUF_REQ_ADDR_15,
      BUF_REQ_SIZE_15 => BUF_REQ_SIZE_15,
      BUF_REQ_RDY_15 => BUF_REQ_RDY_15,
      BUF_REQ_ERR_15 => BUF_REQ_ERR_15,
      BUF_REQD_15 => BUF_REQD_15,
      BUF_REQD_ADDR_15 => BUF_REQD_ADDR_15,
      BUF_REQD_SIZE_15 => BUF_REQD_SIZE_15,
      BUF_REQD_RDY_15 => BUF_REQD_RDY_15,
      BUF_REQD_ERR_15 => BUF_REQD_ERR_15
    );

end architecture STRUCTURE;

