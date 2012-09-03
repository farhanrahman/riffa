-------------------------------------------------------------------------------
-- system_riffa_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library riffa_v1_00_a;
use riffa_v1_00_a.all;

entity system_riffa_0_wrapper is
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
end system_riffa_0_wrapper;

architecture STRUCTURE of system_riffa_0_wrapper is

  component riffa is
    generic (
      C_SIMPBUS_AWIDTH : INTEGER;
      C_BRAM_ADDR_0 : std_logic_vector;
      C_BRAM_ADDR_1 : std_logic_vector;
      C_BRAM_SIZE : INTEGER;
      C_NUM_OF_INPUTS_TO_CORE : INTEGER;
      C_NUM_OF_OUTPUTS_FROM_CORE : INTEGER;
      DOORBELL_ARGUMENT_ZERO_VAL : std_logic_vector;
      DOORBELL_ARGUMENT_ONE_VAL : std_logic_vector
    );
    port (
      SYS_CLK : in std_logic;
      SYS_RST : in std_logic;
      INTERRUPT : out std_logic;
      INTERRUPT_ERR : out std_logic;
      INTERRUPT_ACK : in std_logic;
      DOORBELL : in std_logic;
      DOORBELL_ERR : in std_logic;
      DOORBELL_LEN : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DOORBELL_ARG : in std_logic_vector(31 downto 0);
      DMA_REQ : out std_logic;
      DMA_REQ_ACK : in std_logic;
      DMA_SRC : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_DST : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_LEN : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      DMA_SIG : out std_logic;
      DMA_DONE : in std_logic;
      DMA_ERR : in std_logic;
      BUF_REQ : out std_logic;
      BUF_REQ_ACK : in std_logic;
      BUF_REQ_ADDR : in std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
      BUF_REQ_SIZE : in std_logic_vector(4 downto 0);
      BUF_REQ_RDY : in std_logic;
      BUF_REQ_ERR : in std_logic;
      BUF_REQD : in std_logic;
      BUF_REQD_ADDR : out std_logic_vector((C_SIMPBUS_AWIDTH-1) downto 0);
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

begin

  riffa_0 : riffa
    generic map (
      C_SIMPBUS_AWIDTH => 32,
      C_BRAM_ADDR_0 => X"90000000",
      C_BRAM_ADDR_1 => X"90010000",
      C_BRAM_SIZE => 65536,
      C_NUM_OF_INPUTS_TO_CORE => 2,
      C_NUM_OF_OUTPUTS_FROM_CORE => 1,
      DOORBELL_ARGUMENT_ZERO_VAL => X"ffffffff",
      DOORBELL_ARGUMENT_ONE_VAL => X"ffffffff"
    )
    port map (
      SYS_CLK => SYS_CLK,
      SYS_RST => SYS_RST,
      INTERRUPT => INTERRUPT,
      INTERRUPT_ERR => INTERRUPT_ERR,
      INTERRUPT_ACK => INTERRUPT_ACK,
      DOORBELL => DOORBELL,
      DOORBELL_ERR => DOORBELL_ERR,
      DOORBELL_LEN => DOORBELL_LEN,
      DOORBELL_ARG => DOORBELL_ARG,
      DMA_REQ => DMA_REQ,
      DMA_REQ_ACK => DMA_REQ_ACK,
      DMA_SRC => DMA_SRC,
      DMA_DST => DMA_DST,
      DMA_LEN => DMA_LEN,
      DMA_SIG => DMA_SIG,
      DMA_DONE => DMA_DONE,
      DMA_ERR => DMA_ERR,
      BUF_REQ => BUF_REQ,
      BUF_REQ_ACK => BUF_REQ_ACK,
      BUF_REQ_ADDR => BUF_REQ_ADDR,
      BUF_REQ_SIZE => BUF_REQ_SIZE,
      BUF_REQ_RDY => BUF_REQ_RDY,
      BUF_REQ_ERR => BUF_REQ_ERR,
      BUF_REQD => BUF_REQD,
      BUF_REQD_ADDR => BUF_REQD_ADDR,
      BUF_REQD_SIZE => BUF_REQD_SIZE,
      BUF_REQD_RDY => BUF_REQD_RDY,
      BUF_REQD_ERR => BUF_REQD_ERR,
      BRAM_Rst_0 => BRAM_Rst_0,
      BRAM_Clk_0 => BRAM_Clk_0,
      BRAM_EN_0 => BRAM_EN_0,
      BRAM_WEN_0 => BRAM_WEN_0,
      BRAM_Addr_0 => BRAM_Addr_0,
      BRAM_Din_0 => BRAM_Din_0,
      BRAM_Dout_0 => BRAM_Dout_0,
      BRAM_Rst_1 => BRAM_Rst_1,
      BRAM_Clk_1 => BRAM_Clk_1,
      BRAM_EN_1 => BRAM_EN_1,
      BRAM_WEN_1 => BRAM_WEN_1,
      BRAM_Addr_1 => BRAM_Addr_1,
      BRAM_Din_1 => BRAM_Din_1,
      BRAM_Dout_1 => BRAM_Dout_1
    );

end architecture STRUCTURE;

