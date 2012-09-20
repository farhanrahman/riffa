-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
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
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
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
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system : component is "user_black_box";

begin

  system_i : system
    port map (
      fpga_0_clk_1_sys_clk_p_pin => fpga_0_clk_1_sys_clk_p_pin,
      fpga_0_clk_1_sys_clk_n_pin => fpga_0_clk_1_sys_clk_n_pin,
      fpga_0_rst_1_sys_rst_pin => fpga_0_rst_1_sys_rst_pin,
      fpga_0_PCIe_Bridge_RXN_pin => fpga_0_PCIe_Bridge_RXN_pin,
      fpga_0_PCIe_Bridge_RXP_pin => fpga_0_PCIe_Bridge_RXP_pin,
      fpga_0_PCIe_Bridge_TXN_pin => fpga_0_PCIe_Bridge_TXN_pin,
      fpga_0_PCIe_Bridge_TXP_pin => fpga_0_PCIe_Bridge_TXP_pin,
      fpga_0_PCIe_Diff_Clk_P_pin => fpga_0_PCIe_Diff_Clk_P_pin,
      fpga_0_PCIe_Diff_Clk_N_pin => fpga_0_PCIe_Diff_Clk_N_pin,
      fpga_0_PCIe_perstn => fpga_0_PCIe_perstn
    );

end architecture STRUCTURE;

