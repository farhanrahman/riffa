-------------------------------------------------------------------------------
-- bram_block_1_elaborate.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity bram_block_1_elaborate is
  generic (
    C_MEMSIZE : integer;
    C_PORT_DWIDTH : integer;
    C_PORT_AWIDTH : integer;
    C_NUM_WE : integer;
    C_FAMILY : string
    );
  port (
    BRAM_Rst_A : in std_logic;
    BRAM_Clk_A : in std_logic;
    BRAM_EN_A : in std_logic;
    BRAM_WEN_A : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_A : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_A : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_A : in std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Rst_B : in std_logic;
    BRAM_Clk_B : in std_logic;
    BRAM_EN_B : in std_logic;
    BRAM_WEN_B : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_B : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_B : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_B : in std_logic_vector(0 to C_PORT_DWIDTH-1)
  );

  attribute keep_hierarchy : STRING;
  attribute keep_hierarchy of bram_block_1_elaborate : entity is "yes";

end bram_block_1_elaborate;

architecture STRUCTURE of bram_block_1_elaborate is

  component RAMB36E1 is
    generic (
      WRITE_MODE_A : string;
      WRITE_MODE_B : string;
      INIT_FILE : string;
      READ_WIDTH_A : integer;
      READ_WIDTH_B : integer;
      WRITE_WIDTH_A : integer;
      WRITE_WIDTH_B : integer;
      RAM_EXTENSION_A : string;
      RAM_EXTENSION_B : string
    );
    port (
      DBITERR : out std_logic;
      ECCPARITY : out std_logic_vector(7 downto 0);
      INJECTDBITERR : in std_logic;
      INJECTSBITERR : in std_logic;
      RDADDRECC : out std_logic_vector(8 downto 0);
      SBITERR : out std_logic;
      ADDRARDADDR : in std_logic_vector(15 downto 0);
      CASCADEINA : in std_logic;
      CASCADEOUTA : out std_logic;
      CLKARDCLK : in std_logic;
      DIADI : in std_logic_vector(31 downto 0);
      DIPADIP : in std_logic_vector(3 downto 0);
      DOADO : out std_logic_vector(31 downto 0);
      DOPADOP : out std_logic_vector(3 downto 0);
      ENARDEN : in std_logic;
      REGCEAREGCE : in std_logic;
      RSTRAMARSTRAM : in std_logic;
      RSTREGARSTREG : in std_logic;
      WEA : in std_logic_vector(3 downto 0);
      ADDRBWRADDR : in std_logic_vector(15 downto 0);
      CASCADEINB : in std_logic;
      CASCADEOUTB : out std_logic;
      CLKBWRCLK : in std_logic;
      DIBDI : in std_logic_vector(31 downto 0);
      DIPBDIP : in std_logic_vector(3 downto 0);
      DOBDO : out std_logic_vector(31 downto 0);
      DOPBDOP : out std_logic_vector(3 downto 0);
      ENBWREN : in std_logic;
      REGCEB : in std_logic;
      RSTRAMB : in std_logic;
      RSTREGB : in std_logic;
      WEBWE : in std_logic_vector(7 downto 0)
    );
  end component;

  attribute BMM_INFO : STRING;

  attribute BMM_INFO of ramb36e1_0: label is " ";
  attribute BMM_INFO of ramb36e1_1: label is " ";
  attribute BMM_INFO of ramb36e1_2: label is " ";
  attribute BMM_INFO of ramb36e1_3: label is " ";
  attribute BMM_INFO of ramb36e1_4: label is " ";
  attribute BMM_INFO of ramb36e1_5: label is " ";
  attribute BMM_INFO of ramb36e1_6: label is " ";
  attribute BMM_INFO of ramb36e1_7: label is " ";
  attribute BMM_INFO of ramb36e1_8: label is " ";
  attribute BMM_INFO of ramb36e1_9: label is " ";
  attribute BMM_INFO of ramb36e1_10: label is " ";
  attribute BMM_INFO of ramb36e1_11: label is " ";
  attribute BMM_INFO of ramb36e1_12: label is " ";
  attribute BMM_INFO of ramb36e1_13: label is " ";
  attribute BMM_INFO of ramb36e1_14: label is " ";
  attribute BMM_INFO of ramb36e1_15: label is " ";
  -- Internal signals

  signal net_gnd0 : std_logic;
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal pgassign1 : std_logic_vector(0 to 0);
  signal pgassign2 : std_logic_vector(0 to 0);
  signal pgassign3 : std_logic_vector(0 to 29);
  signal pgassign4 : std_logic_vector(0 to 3);
  signal pgassign5 : std_logic_vector(15 downto 0);
  signal pgassign6 : std_logic_vector(31 downto 0);
  signal pgassign7 : std_logic_vector(31 downto 0);
  signal pgassign8 : std_logic_vector(3 downto 0);
  signal pgassign9 : std_logic_vector(15 downto 0);
  signal pgassign10 : std_logic_vector(31 downto 0);
  signal pgassign11 : std_logic_vector(31 downto 0);
  signal pgassign12 : std_logic_vector(7 downto 0);
  signal pgassign13 : std_logic_vector(15 downto 0);
  signal pgassign14 : std_logic_vector(31 downto 0);
  signal pgassign15 : std_logic_vector(31 downto 0);
  signal pgassign16 : std_logic_vector(3 downto 0);
  signal pgassign17 : std_logic_vector(15 downto 0);
  signal pgassign18 : std_logic_vector(31 downto 0);
  signal pgassign19 : std_logic_vector(31 downto 0);
  signal pgassign20 : std_logic_vector(7 downto 0);
  signal pgassign21 : std_logic_vector(15 downto 0);
  signal pgassign22 : std_logic_vector(31 downto 0);
  signal pgassign23 : std_logic_vector(31 downto 0);
  signal pgassign24 : std_logic_vector(3 downto 0);
  signal pgassign25 : std_logic_vector(15 downto 0);
  signal pgassign26 : std_logic_vector(31 downto 0);
  signal pgassign27 : std_logic_vector(31 downto 0);
  signal pgassign28 : std_logic_vector(7 downto 0);
  signal pgassign29 : std_logic_vector(15 downto 0);
  signal pgassign30 : std_logic_vector(31 downto 0);
  signal pgassign31 : std_logic_vector(31 downto 0);
  signal pgassign32 : std_logic_vector(3 downto 0);
  signal pgassign33 : std_logic_vector(15 downto 0);
  signal pgassign34 : std_logic_vector(31 downto 0);
  signal pgassign35 : std_logic_vector(31 downto 0);
  signal pgassign36 : std_logic_vector(7 downto 0);
  signal pgassign37 : std_logic_vector(15 downto 0);
  signal pgassign38 : std_logic_vector(31 downto 0);
  signal pgassign39 : std_logic_vector(31 downto 0);
  signal pgassign40 : std_logic_vector(3 downto 0);
  signal pgassign41 : std_logic_vector(15 downto 0);
  signal pgassign42 : std_logic_vector(31 downto 0);
  signal pgassign43 : std_logic_vector(31 downto 0);
  signal pgassign44 : std_logic_vector(7 downto 0);
  signal pgassign45 : std_logic_vector(15 downto 0);
  signal pgassign46 : std_logic_vector(31 downto 0);
  signal pgassign47 : std_logic_vector(31 downto 0);
  signal pgassign48 : std_logic_vector(3 downto 0);
  signal pgassign49 : std_logic_vector(15 downto 0);
  signal pgassign50 : std_logic_vector(31 downto 0);
  signal pgassign51 : std_logic_vector(31 downto 0);
  signal pgassign52 : std_logic_vector(7 downto 0);
  signal pgassign53 : std_logic_vector(15 downto 0);
  signal pgassign54 : std_logic_vector(31 downto 0);
  signal pgassign55 : std_logic_vector(31 downto 0);
  signal pgassign56 : std_logic_vector(3 downto 0);
  signal pgassign57 : std_logic_vector(15 downto 0);
  signal pgassign58 : std_logic_vector(31 downto 0);
  signal pgassign59 : std_logic_vector(31 downto 0);
  signal pgassign60 : std_logic_vector(7 downto 0);
  signal pgassign61 : std_logic_vector(15 downto 0);
  signal pgassign62 : std_logic_vector(31 downto 0);
  signal pgassign63 : std_logic_vector(31 downto 0);
  signal pgassign64 : std_logic_vector(3 downto 0);
  signal pgassign65 : std_logic_vector(15 downto 0);
  signal pgassign66 : std_logic_vector(31 downto 0);
  signal pgassign67 : std_logic_vector(31 downto 0);
  signal pgassign68 : std_logic_vector(7 downto 0);
  signal pgassign69 : std_logic_vector(15 downto 0);
  signal pgassign70 : std_logic_vector(31 downto 0);
  signal pgassign71 : std_logic_vector(31 downto 0);
  signal pgassign72 : std_logic_vector(3 downto 0);
  signal pgassign73 : std_logic_vector(15 downto 0);
  signal pgassign74 : std_logic_vector(31 downto 0);
  signal pgassign75 : std_logic_vector(31 downto 0);
  signal pgassign76 : std_logic_vector(7 downto 0);
  signal pgassign77 : std_logic_vector(15 downto 0);
  signal pgassign78 : std_logic_vector(31 downto 0);
  signal pgassign79 : std_logic_vector(31 downto 0);
  signal pgassign80 : std_logic_vector(3 downto 0);
  signal pgassign81 : std_logic_vector(15 downto 0);
  signal pgassign82 : std_logic_vector(31 downto 0);
  signal pgassign83 : std_logic_vector(31 downto 0);
  signal pgassign84 : std_logic_vector(7 downto 0);
  signal pgassign85 : std_logic_vector(15 downto 0);
  signal pgassign86 : std_logic_vector(31 downto 0);
  signal pgassign87 : std_logic_vector(31 downto 0);
  signal pgassign88 : std_logic_vector(3 downto 0);
  signal pgassign89 : std_logic_vector(15 downto 0);
  signal pgassign90 : std_logic_vector(31 downto 0);
  signal pgassign91 : std_logic_vector(31 downto 0);
  signal pgassign92 : std_logic_vector(7 downto 0);
  signal pgassign93 : std_logic_vector(15 downto 0);
  signal pgassign94 : std_logic_vector(31 downto 0);
  signal pgassign95 : std_logic_vector(31 downto 0);
  signal pgassign96 : std_logic_vector(3 downto 0);
  signal pgassign97 : std_logic_vector(15 downto 0);
  signal pgassign98 : std_logic_vector(31 downto 0);
  signal pgassign99 : std_logic_vector(31 downto 0);
  signal pgassign100 : std_logic_vector(7 downto 0);
  signal pgassign101 : std_logic_vector(15 downto 0);
  signal pgassign102 : std_logic_vector(31 downto 0);
  signal pgassign103 : std_logic_vector(31 downto 0);
  signal pgassign104 : std_logic_vector(3 downto 0);
  signal pgassign105 : std_logic_vector(15 downto 0);
  signal pgassign106 : std_logic_vector(31 downto 0);
  signal pgassign107 : std_logic_vector(31 downto 0);
  signal pgassign108 : std_logic_vector(7 downto 0);
  signal pgassign109 : std_logic_vector(15 downto 0);
  signal pgassign110 : std_logic_vector(31 downto 0);
  signal pgassign111 : std_logic_vector(31 downto 0);
  signal pgassign112 : std_logic_vector(3 downto 0);
  signal pgassign113 : std_logic_vector(15 downto 0);
  signal pgassign114 : std_logic_vector(31 downto 0);
  signal pgassign115 : std_logic_vector(31 downto 0);
  signal pgassign116 : std_logic_vector(7 downto 0);
  signal pgassign117 : std_logic_vector(15 downto 0);
  signal pgassign118 : std_logic_vector(31 downto 0);
  signal pgassign119 : std_logic_vector(31 downto 0);
  signal pgassign120 : std_logic_vector(3 downto 0);
  signal pgassign121 : std_logic_vector(15 downto 0);
  signal pgassign122 : std_logic_vector(31 downto 0);
  signal pgassign123 : std_logic_vector(31 downto 0);
  signal pgassign124 : std_logic_vector(7 downto 0);
  signal pgassign125 : std_logic_vector(15 downto 0);
  signal pgassign126 : std_logic_vector(31 downto 0);
  signal pgassign127 : std_logic_vector(31 downto 0);
  signal pgassign128 : std_logic_vector(3 downto 0);
  signal pgassign129 : std_logic_vector(15 downto 0);
  signal pgassign130 : std_logic_vector(31 downto 0);
  signal pgassign131 : std_logic_vector(31 downto 0);
  signal pgassign132 : std_logic_vector(7 downto 0);

begin

  -- Internal assignments

  pgassign1(0 to 0) <= B"1";
  pgassign2(0 to 0) <= B"0";
  pgassign3(0 to 29) <= B"000000000000000000000000000000";
  pgassign4(0 to 3) <= B"0000";
  pgassign5(15 downto 15) <= B"1";
  pgassign5(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign5(0 downto 0) <= B"0";
  pgassign6(31 downto 2) <= B"000000000000000000000000000000";
  pgassign6(1 downto 0) <= BRAM_Dout_A(0 to 1);
  BRAM_Din_A(0 to 1) <= pgassign7(1 downto 0);
  pgassign8(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign8(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign8(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign8(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign9(15 downto 15) <= B"1";
  pgassign9(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign9(0 downto 0) <= B"0";
  pgassign10(31 downto 2) <= B"000000000000000000000000000000";
  pgassign10(1 downto 0) <= BRAM_Dout_B(0 to 1);
  BRAM_Din_B(0 to 1) <= pgassign11(1 downto 0);
  pgassign12(7 downto 4) <= B"0000";
  pgassign12(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign12(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign12(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign12(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign13(15 downto 15) <= B"1";
  pgassign13(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign13(0 downto 0) <= B"0";
  pgassign14(31 downto 2) <= B"000000000000000000000000000000";
  pgassign14(1 downto 0) <= BRAM_Dout_A(2 to 3);
  BRAM_Din_A(2 to 3) <= pgassign15(1 downto 0);
  pgassign16(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign16(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign16(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign16(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign17(15 downto 15) <= B"1";
  pgassign17(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign17(0 downto 0) <= B"0";
  pgassign18(31 downto 2) <= B"000000000000000000000000000000";
  pgassign18(1 downto 0) <= BRAM_Dout_B(2 to 3);
  BRAM_Din_B(2 to 3) <= pgassign19(1 downto 0);
  pgassign20(7 downto 4) <= B"0000";
  pgassign20(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign20(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign20(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign20(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign21(15 downto 15) <= B"1";
  pgassign21(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign21(0 downto 0) <= B"0";
  pgassign22(31 downto 2) <= B"000000000000000000000000000000";
  pgassign22(1 downto 0) <= BRAM_Dout_A(4 to 5);
  BRAM_Din_A(4 to 5) <= pgassign23(1 downto 0);
  pgassign24(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign24(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign24(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign24(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign25(15 downto 15) <= B"1";
  pgassign25(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign25(0 downto 0) <= B"0";
  pgassign26(31 downto 2) <= B"000000000000000000000000000000";
  pgassign26(1 downto 0) <= BRAM_Dout_B(4 to 5);
  BRAM_Din_B(4 to 5) <= pgassign27(1 downto 0);
  pgassign28(7 downto 4) <= B"0000";
  pgassign28(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign28(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign28(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign28(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign29(15 downto 15) <= B"1";
  pgassign29(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign29(0 downto 0) <= B"0";
  pgassign30(31 downto 2) <= B"000000000000000000000000000000";
  pgassign30(1 downto 0) <= BRAM_Dout_A(6 to 7);
  BRAM_Din_A(6 to 7) <= pgassign31(1 downto 0);
  pgassign32(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign32(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign32(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign32(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign33(15 downto 15) <= B"1";
  pgassign33(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign33(0 downto 0) <= B"0";
  pgassign34(31 downto 2) <= B"000000000000000000000000000000";
  pgassign34(1 downto 0) <= BRAM_Dout_B(6 to 7);
  BRAM_Din_B(6 to 7) <= pgassign35(1 downto 0);
  pgassign36(7 downto 4) <= B"0000";
  pgassign36(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign36(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign36(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign36(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign37(15 downto 15) <= B"1";
  pgassign37(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign37(0 downto 0) <= B"0";
  pgassign38(31 downto 2) <= B"000000000000000000000000000000";
  pgassign38(1 downto 0) <= BRAM_Dout_A(8 to 9);
  BRAM_Din_A(8 to 9) <= pgassign39(1 downto 0);
  pgassign40(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign40(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign40(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign40(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign41(15 downto 15) <= B"1";
  pgassign41(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign41(0 downto 0) <= B"0";
  pgassign42(31 downto 2) <= B"000000000000000000000000000000";
  pgassign42(1 downto 0) <= BRAM_Dout_B(8 to 9);
  BRAM_Din_B(8 to 9) <= pgassign43(1 downto 0);
  pgassign44(7 downto 4) <= B"0000";
  pgassign44(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign44(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign44(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign44(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign45(15 downto 15) <= B"1";
  pgassign45(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign45(0 downto 0) <= B"0";
  pgassign46(31 downto 2) <= B"000000000000000000000000000000";
  pgassign46(1 downto 0) <= BRAM_Dout_A(10 to 11);
  BRAM_Din_A(10 to 11) <= pgassign47(1 downto 0);
  pgassign48(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign48(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign48(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign48(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign49(15 downto 15) <= B"1";
  pgassign49(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign49(0 downto 0) <= B"0";
  pgassign50(31 downto 2) <= B"000000000000000000000000000000";
  pgassign50(1 downto 0) <= BRAM_Dout_B(10 to 11);
  BRAM_Din_B(10 to 11) <= pgassign51(1 downto 0);
  pgassign52(7 downto 4) <= B"0000";
  pgassign52(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign52(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign52(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign52(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign53(15 downto 15) <= B"1";
  pgassign53(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign53(0 downto 0) <= B"0";
  pgassign54(31 downto 2) <= B"000000000000000000000000000000";
  pgassign54(1 downto 0) <= BRAM_Dout_A(12 to 13);
  BRAM_Din_A(12 to 13) <= pgassign55(1 downto 0);
  pgassign56(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign56(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign56(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign56(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign57(15 downto 15) <= B"1";
  pgassign57(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign57(0 downto 0) <= B"0";
  pgassign58(31 downto 2) <= B"000000000000000000000000000000";
  pgassign58(1 downto 0) <= BRAM_Dout_B(12 to 13);
  BRAM_Din_B(12 to 13) <= pgassign59(1 downto 0);
  pgassign60(7 downto 4) <= B"0000";
  pgassign60(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign60(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign60(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign60(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign61(15 downto 15) <= B"1";
  pgassign61(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign61(0 downto 0) <= B"0";
  pgassign62(31 downto 2) <= B"000000000000000000000000000000";
  pgassign62(1 downto 0) <= BRAM_Dout_A(14 to 15);
  BRAM_Din_A(14 to 15) <= pgassign63(1 downto 0);
  pgassign64(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign64(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign64(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign64(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign65(15 downto 15) <= B"1";
  pgassign65(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign65(0 downto 0) <= B"0";
  pgassign66(31 downto 2) <= B"000000000000000000000000000000";
  pgassign66(1 downto 0) <= BRAM_Dout_B(14 to 15);
  BRAM_Din_B(14 to 15) <= pgassign67(1 downto 0);
  pgassign68(7 downto 4) <= B"0000";
  pgassign68(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign68(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign68(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign68(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign69(15 downto 15) <= B"1";
  pgassign69(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign69(0 downto 0) <= B"0";
  pgassign70(31 downto 2) <= B"000000000000000000000000000000";
  pgassign70(1 downto 0) <= BRAM_Dout_A(16 to 17);
  BRAM_Din_A(16 to 17) <= pgassign71(1 downto 0);
  pgassign72(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign72(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign72(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign72(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign73(15 downto 15) <= B"1";
  pgassign73(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign73(0 downto 0) <= B"0";
  pgassign74(31 downto 2) <= B"000000000000000000000000000000";
  pgassign74(1 downto 0) <= BRAM_Dout_B(16 to 17);
  BRAM_Din_B(16 to 17) <= pgassign75(1 downto 0);
  pgassign76(7 downto 4) <= B"0000";
  pgassign76(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign76(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign76(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign76(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign77(15 downto 15) <= B"1";
  pgassign77(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign77(0 downto 0) <= B"0";
  pgassign78(31 downto 2) <= B"000000000000000000000000000000";
  pgassign78(1 downto 0) <= BRAM_Dout_A(18 to 19);
  BRAM_Din_A(18 to 19) <= pgassign79(1 downto 0);
  pgassign80(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign80(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign80(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign80(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign81(15 downto 15) <= B"1";
  pgassign81(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign81(0 downto 0) <= B"0";
  pgassign82(31 downto 2) <= B"000000000000000000000000000000";
  pgassign82(1 downto 0) <= BRAM_Dout_B(18 to 19);
  BRAM_Din_B(18 to 19) <= pgassign83(1 downto 0);
  pgassign84(7 downto 4) <= B"0000";
  pgassign84(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign84(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign84(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign84(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign85(15 downto 15) <= B"1";
  pgassign85(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign85(0 downto 0) <= B"0";
  pgassign86(31 downto 2) <= B"000000000000000000000000000000";
  pgassign86(1 downto 0) <= BRAM_Dout_A(20 to 21);
  BRAM_Din_A(20 to 21) <= pgassign87(1 downto 0);
  pgassign88(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign88(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign88(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign88(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign89(15 downto 15) <= B"1";
  pgassign89(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign89(0 downto 0) <= B"0";
  pgassign90(31 downto 2) <= B"000000000000000000000000000000";
  pgassign90(1 downto 0) <= BRAM_Dout_B(20 to 21);
  BRAM_Din_B(20 to 21) <= pgassign91(1 downto 0);
  pgassign92(7 downto 4) <= B"0000";
  pgassign92(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign92(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign92(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign92(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign93(15 downto 15) <= B"1";
  pgassign93(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign93(0 downto 0) <= B"0";
  pgassign94(31 downto 2) <= B"000000000000000000000000000000";
  pgassign94(1 downto 0) <= BRAM_Dout_A(22 to 23);
  BRAM_Din_A(22 to 23) <= pgassign95(1 downto 0);
  pgassign96(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign96(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign96(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign96(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign97(15 downto 15) <= B"1";
  pgassign97(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign97(0 downto 0) <= B"0";
  pgassign98(31 downto 2) <= B"000000000000000000000000000000";
  pgassign98(1 downto 0) <= BRAM_Dout_B(22 to 23);
  BRAM_Din_B(22 to 23) <= pgassign99(1 downto 0);
  pgassign100(7 downto 4) <= B"0000";
  pgassign100(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign100(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign100(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign100(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign101(15 downto 15) <= B"1";
  pgassign101(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign101(0 downto 0) <= B"0";
  pgassign102(31 downto 2) <= B"000000000000000000000000000000";
  pgassign102(1 downto 0) <= BRAM_Dout_A(24 to 25);
  BRAM_Din_A(24 to 25) <= pgassign103(1 downto 0);
  pgassign104(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign104(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign104(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign104(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign105(15 downto 15) <= B"1";
  pgassign105(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign105(0 downto 0) <= B"0";
  pgassign106(31 downto 2) <= B"000000000000000000000000000000";
  pgassign106(1 downto 0) <= BRAM_Dout_B(24 to 25);
  BRAM_Din_B(24 to 25) <= pgassign107(1 downto 0);
  pgassign108(7 downto 4) <= B"0000";
  pgassign108(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign108(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign108(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign108(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign109(15 downto 15) <= B"1";
  pgassign109(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign109(0 downto 0) <= B"0";
  pgassign110(31 downto 2) <= B"000000000000000000000000000000";
  pgassign110(1 downto 0) <= BRAM_Dout_A(26 to 27);
  BRAM_Din_A(26 to 27) <= pgassign111(1 downto 0);
  pgassign112(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign112(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign112(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign112(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign113(15 downto 15) <= B"1";
  pgassign113(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign113(0 downto 0) <= B"0";
  pgassign114(31 downto 2) <= B"000000000000000000000000000000";
  pgassign114(1 downto 0) <= BRAM_Dout_B(26 to 27);
  BRAM_Din_B(26 to 27) <= pgassign115(1 downto 0);
  pgassign116(7 downto 4) <= B"0000";
  pgassign116(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign116(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign116(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign116(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign117(15 downto 15) <= B"1";
  pgassign117(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign117(0 downto 0) <= B"0";
  pgassign118(31 downto 2) <= B"000000000000000000000000000000";
  pgassign118(1 downto 0) <= BRAM_Dout_A(28 to 29);
  BRAM_Din_A(28 to 29) <= pgassign119(1 downto 0);
  pgassign120(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign120(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign120(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign120(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign121(15 downto 15) <= B"1";
  pgassign121(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign121(0 downto 0) <= B"0";
  pgassign122(31 downto 2) <= B"000000000000000000000000000000";
  pgassign122(1 downto 0) <= BRAM_Dout_B(28 to 29);
  BRAM_Din_B(28 to 29) <= pgassign123(1 downto 0);
  pgassign124(7 downto 4) <= B"0000";
  pgassign124(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign124(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign124(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign124(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign125(15 downto 15) <= B"1";
  pgassign125(14 downto 1) <= BRAM_Addr_A(16 to 29);
  pgassign125(0 downto 0) <= B"0";
  pgassign126(31 downto 2) <= B"000000000000000000000000000000";
  pgassign126(1 downto 0) <= BRAM_Dout_A(30 to 31);
  BRAM_Din_A(30 to 31) <= pgassign127(1 downto 0);
  pgassign128(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign128(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign128(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign128(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign129(15 downto 15) <= B"1";
  pgassign129(14 downto 1) <= BRAM_Addr_B(16 to 29);
  pgassign129(0 downto 0) <= B"0";
  pgassign130(31 downto 2) <= B"000000000000000000000000000000";
  pgassign130(1 downto 0) <= BRAM_Dout_B(30 to 31);
  BRAM_Din_B(30 to 31) <= pgassign131(1 downto 0);
  pgassign132(7 downto 4) <= B"0000";
  pgassign132(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign132(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign132(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign132(0 downto 0) <= BRAM_WEN_B(3 to 3);
  net_gnd0 <= '0';
  net_gnd4(3 downto 0) <= B"0000";

  ramb36e1_0 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_0.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign5,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign6,
      DIPADIP => net_gnd4,
      DOADO => pgassign7,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign8,
      ADDRBWRADDR => pgassign9,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign10,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign11,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign12
    );

  ramb36e1_1 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_1.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign13,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign14,
      DIPADIP => net_gnd4,
      DOADO => pgassign15,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign16,
      ADDRBWRADDR => pgassign17,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign18,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign19,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign20
    );

  ramb36e1_2 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_2.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign21,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign22,
      DIPADIP => net_gnd4,
      DOADO => pgassign23,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign24,
      ADDRBWRADDR => pgassign25,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign26,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign27,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign28
    );

  ramb36e1_3 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_3.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign29,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign30,
      DIPADIP => net_gnd4,
      DOADO => pgassign31,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign32,
      ADDRBWRADDR => pgassign33,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign34,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign35,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign36
    );

  ramb36e1_4 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_4.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign37,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign38,
      DIPADIP => net_gnd4,
      DOADO => pgassign39,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign40,
      ADDRBWRADDR => pgassign41,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign42,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign43,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign44
    );

  ramb36e1_5 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_5.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign45,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign46,
      DIPADIP => net_gnd4,
      DOADO => pgassign47,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign48,
      ADDRBWRADDR => pgassign49,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign50,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign51,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign52
    );

  ramb36e1_6 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_6.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign53,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign54,
      DIPADIP => net_gnd4,
      DOADO => pgassign55,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign56,
      ADDRBWRADDR => pgassign57,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign58,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign59,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign60
    );

  ramb36e1_7 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_7.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign61,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign62,
      DIPADIP => net_gnd4,
      DOADO => pgassign63,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign64,
      ADDRBWRADDR => pgassign65,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign66,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign67,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign68
    );

  ramb36e1_8 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_8.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign69,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign70,
      DIPADIP => net_gnd4,
      DOADO => pgassign71,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign72,
      ADDRBWRADDR => pgassign73,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign74,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign75,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign76
    );

  ramb36e1_9 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_9.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign77,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign78,
      DIPADIP => net_gnd4,
      DOADO => pgassign79,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign80,
      ADDRBWRADDR => pgassign81,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign82,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign83,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign84
    );

  ramb36e1_10 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_10.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign85,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign86,
      DIPADIP => net_gnd4,
      DOADO => pgassign87,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign88,
      ADDRBWRADDR => pgassign89,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign90,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign91,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign92
    );

  ramb36e1_11 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_11.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign93,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign94,
      DIPADIP => net_gnd4,
      DOADO => pgassign95,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign96,
      ADDRBWRADDR => pgassign97,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign98,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign99,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign100
    );

  ramb36e1_12 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_12.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign101,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign102,
      DIPADIP => net_gnd4,
      DOADO => pgassign103,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign104,
      ADDRBWRADDR => pgassign105,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign106,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign107,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign108
    );

  ramb36e1_13 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_13.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign109,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign110,
      DIPADIP => net_gnd4,
      DOADO => pgassign111,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign112,
      ADDRBWRADDR => pgassign113,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign114,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign115,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign116
    );

  ramb36e1_14 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_14.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign117,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign118,
      DIPADIP => net_gnd4,
      DOADO => pgassign119,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign120,
      ADDRBWRADDR => pgassign121,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign122,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign123,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign124
    );

  ramb36e1_15 : RAMB36E1
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_1_combined_15.mem",
      READ_WIDTH_A => 2,
      READ_WIDTH_B => 2,
      WRITE_WIDTH_A => 2,
      WRITE_WIDTH_B => 2,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE"
    )
    port map (
      DBITERR => open,
      ECCPARITY => open,
      INJECTDBITERR => net_gnd0,
      INJECTSBITERR => net_gnd0,
      RDADDRECC => open,
      SBITERR => open,
      ADDRARDADDR => pgassign125,
      CASCADEINA => net_gnd0,
      CASCADEOUTA => open,
      CLKARDCLK => BRAM_Clk_A,
      DIADI => pgassign126,
      DIPADIP => net_gnd4,
      DOADO => pgassign127,
      DOPADOP => open,
      ENARDEN => BRAM_EN_A,
      REGCEAREGCE => net_gnd0,
      RSTRAMARSTRAM => BRAM_Rst_A,
      RSTREGARSTREG => net_gnd0,
      WEA => pgassign128,
      ADDRBWRADDR => pgassign129,
      CASCADEINB => net_gnd0,
      CASCADEOUTB => open,
      CLKBWRCLK => BRAM_Clk_B,
      DIBDI => pgassign130,
      DIPBDIP => net_gnd4,
      DOBDO => pgassign131,
      DOPBDOP => open,
      ENBWREN => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTRAMB => BRAM_Rst_B,
      RSTREGB => net_gnd0,
      WEBWE => pgassign132
    );

end architecture STRUCTURE;

