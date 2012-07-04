-------------------------------------------------------------------------------
-- bram_block_0_elaborate.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity bram_block_0_elaborate is
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
  attribute keep_hierarchy of bram_block_0_elaborate : entity is "yes";

end bram_block_0_elaborate;

architecture STRUCTURE of bram_block_0_elaborate is

  component RAMB36 is
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
      ADDRA : in std_logic_vector(15 downto 0);
      CASCADEINLATA : in std_logic;
      CASCADEINREGA : in std_logic;
      CASCADEOUTLATA : out std_logic;
      CASCADEOUTREGA : out std_logic;
      CLKA : in std_logic;
      DIA : in std_logic_vector(31 downto 0);
      DIPA : in std_logic_vector(3 downto 0);
      DOA : out std_logic_vector(31 downto 0);
      DOPA : out std_logic_vector(3 downto 0);
      ENA : in std_logic;
      REGCEA : in std_logic;
      SSRA : in std_logic;
      WEA : in std_logic_vector(3 downto 0);
      ADDRB : in std_logic_vector(15 downto 0);
      CASCADEINLATB : in std_logic;
      CASCADEINREGB : in std_logic;
      CASCADEOUTLATB : out std_logic;
      CASCADEOUTREGB : out std_logic;
      CLKB : in std_logic;
      DIB : in std_logic_vector(31 downto 0);
      DIPB : in std_logic_vector(3 downto 0);
      DOB : out std_logic_vector(31 downto 0);
      DOPB : out std_logic_vector(3 downto 0);
      ENB : in std_logic;
      REGCEB : in std_logic;
      SSRB : in std_logic;
      WEB : in std_logic_vector(3 downto 0)
    );
  end component;

  attribute BMM_INFO : STRING;

  attribute BMM_INFO of ramb36_0: label is " ";
  attribute BMM_INFO of ramb36_1: label is " ";
  attribute BMM_INFO of ramb36_2: label is " ";
  attribute BMM_INFO of ramb36_3: label is " ";
  attribute BMM_INFO of ramb36_4: label is " ";
  attribute BMM_INFO of ramb36_5: label is " ";
  attribute BMM_INFO of ramb36_6: label is " ";
  attribute BMM_INFO of ramb36_7: label is " ";
  attribute BMM_INFO of ramb36_8: label is " ";
  attribute BMM_INFO of ramb36_9: label is " ";
  attribute BMM_INFO of ramb36_10: label is " ";
  attribute BMM_INFO of ramb36_11: label is " ";
  attribute BMM_INFO of ramb36_12: label is " ";
  attribute BMM_INFO of ramb36_13: label is " ";
  attribute BMM_INFO of ramb36_14: label is " ";
  attribute BMM_INFO of ramb36_15: label is " ";
  attribute BMM_INFO of ramb36_16: label is " ";
  attribute BMM_INFO of ramb36_17: label is " ";
  attribute BMM_INFO of ramb36_18: label is " ";
  attribute BMM_INFO of ramb36_19: label is " ";
  attribute BMM_INFO of ramb36_20: label is " ";
  attribute BMM_INFO of ramb36_21: label is " ";
  attribute BMM_INFO of ramb36_22: label is " ";
  attribute BMM_INFO of ramb36_23: label is " ";
  attribute BMM_INFO of ramb36_24: label is " ";
  attribute BMM_INFO of ramb36_25: label is " ";
  attribute BMM_INFO of ramb36_26: label is " ";
  attribute BMM_INFO of ramb36_27: label is " ";
  attribute BMM_INFO of ramb36_28: label is " ";
  attribute BMM_INFO of ramb36_29: label is " ";
  attribute BMM_INFO of ramb36_30: label is " ";
  attribute BMM_INFO of ramb36_31: label is " ";
  attribute BMM_INFO of ramb36_32: label is " ";
  attribute BMM_INFO of ramb36_33: label is " ";
  attribute BMM_INFO of ramb36_34: label is " ";
  attribute BMM_INFO of ramb36_35: label is " ";
  attribute BMM_INFO of ramb36_36: label is " ";
  attribute BMM_INFO of ramb36_37: label is " ";
  attribute BMM_INFO of ramb36_38: label is " ";
  attribute BMM_INFO of ramb36_39: label is " ";
  attribute BMM_INFO of ramb36_40: label is " ";
  attribute BMM_INFO of ramb36_41: label is " ";
  attribute BMM_INFO of ramb36_42: label is " ";
  attribute BMM_INFO of ramb36_43: label is " ";
  attribute BMM_INFO of ramb36_44: label is " ";
  attribute BMM_INFO of ramb36_45: label is " ";
  attribute BMM_INFO of ramb36_46: label is " ";
  attribute BMM_INFO of ramb36_47: label is " ";
  attribute BMM_INFO of ramb36_48: label is " ";
  attribute BMM_INFO of ramb36_49: label is " ";
  attribute BMM_INFO of ramb36_50: label is " ";
  attribute BMM_INFO of ramb36_51: label is " ";
  attribute BMM_INFO of ramb36_52: label is " ";
  attribute BMM_INFO of ramb36_53: label is " ";
  attribute BMM_INFO of ramb36_54: label is " ";
  attribute BMM_INFO of ramb36_55: label is " ";
  attribute BMM_INFO of ramb36_56: label is " ";
  attribute BMM_INFO of ramb36_57: label is " ";
  attribute BMM_INFO of ramb36_58: label is " ";
  attribute BMM_INFO of ramb36_59: label is " ";
  attribute BMM_INFO of ramb36_60: label is " ";
  attribute BMM_INFO of ramb36_61: label is " ";
  attribute BMM_INFO of ramb36_62: label is " ";
  attribute BMM_INFO of ramb36_63: label is " ";
  -- Internal signals

  signal CASCADEA_0 : std_logic;
  signal CASCADEA_1 : std_logic;
  signal CASCADEA_2 : std_logic;
  signal CASCADEA_3 : std_logic;
  signal CASCADEA_4 : std_logic;
  signal CASCADEA_5 : std_logic;
  signal CASCADEA_6 : std_logic;
  signal CASCADEA_7 : std_logic;
  signal CASCADEA_8 : std_logic;
  signal CASCADEA_9 : std_logic;
  signal CASCADEA_10 : std_logic;
  signal CASCADEA_11 : std_logic;
  signal CASCADEA_12 : std_logic;
  signal CASCADEA_13 : std_logic;
  signal CASCADEA_14 : std_logic;
  signal CASCADEA_15 : std_logic;
  signal CASCADEA_16 : std_logic;
  signal CASCADEA_17 : std_logic;
  signal CASCADEA_18 : std_logic;
  signal CASCADEA_19 : std_logic;
  signal CASCADEA_20 : std_logic;
  signal CASCADEA_21 : std_logic;
  signal CASCADEA_22 : std_logic;
  signal CASCADEA_23 : std_logic;
  signal CASCADEA_24 : std_logic;
  signal CASCADEA_25 : std_logic;
  signal CASCADEA_26 : std_logic;
  signal CASCADEA_27 : std_logic;
  signal CASCADEA_28 : std_logic;
  signal CASCADEA_29 : std_logic;
  signal CASCADEA_30 : std_logic;
  signal CASCADEA_31 : std_logic;
  signal CASCADEB_0 : std_logic;
  signal CASCADEB_1 : std_logic;
  signal CASCADEB_2 : std_logic;
  signal CASCADEB_3 : std_logic;
  signal CASCADEB_4 : std_logic;
  signal CASCADEB_5 : std_logic;
  signal CASCADEB_6 : std_logic;
  signal CASCADEB_7 : std_logic;
  signal CASCADEB_8 : std_logic;
  signal CASCADEB_9 : std_logic;
  signal CASCADEB_10 : std_logic;
  signal CASCADEB_11 : std_logic;
  signal CASCADEB_12 : std_logic;
  signal CASCADEB_13 : std_logic;
  signal CASCADEB_14 : std_logic;
  signal CASCADEB_15 : std_logic;
  signal CASCADEB_16 : std_logic;
  signal CASCADEB_17 : std_logic;
  signal CASCADEB_18 : std_logic;
  signal CASCADEB_19 : std_logic;
  signal CASCADEB_20 : std_logic;
  signal CASCADEB_21 : std_logic;
  signal CASCADEB_22 : std_logic;
  signal CASCADEB_23 : std_logic;
  signal CASCADEB_24 : std_logic;
  signal CASCADEB_25 : std_logic;
  signal CASCADEB_26 : std_logic;
  signal CASCADEB_27 : std_logic;
  signal CASCADEB_28 : std_logic;
  signal CASCADEB_29 : std_logic;
  signal CASCADEB_30 : std_logic;
  signal CASCADEB_31 : std_logic;
  signal net_gnd0 : std_logic;
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal pgassign1 : std_logic_vector(0 to 30);
  signal pgassign2 : std_logic_vector(31 downto 0);
  signal pgassign3 : std_logic_vector(3 downto 0);
  signal pgassign4 : std_logic_vector(31 downto 0);
  signal pgassign5 : std_logic_vector(3 downto 0);
  signal pgassign6 : std_logic_vector(31 downto 0);
  signal pgassign7 : std_logic_vector(3 downto 0);
  signal pgassign8 : std_logic_vector(31 downto 0);
  signal pgassign9 : std_logic_vector(3 downto 0);
  signal pgassign10 : std_logic_vector(31 downto 0);
  signal pgassign11 : std_logic_vector(3 downto 0);
  signal pgassign12 : std_logic_vector(31 downto 0);
  signal pgassign13 : std_logic_vector(3 downto 0);
  signal pgassign14 : std_logic_vector(31 downto 0);
  signal pgassign15 : std_logic_vector(3 downto 0);
  signal pgassign16 : std_logic_vector(31 downto 0);
  signal pgassign17 : std_logic_vector(3 downto 0);
  signal pgassign18 : std_logic_vector(31 downto 0);
  signal pgassign19 : std_logic_vector(3 downto 0);
  signal pgassign20 : std_logic_vector(31 downto 0);
  signal pgassign21 : std_logic_vector(3 downto 0);
  signal pgassign22 : std_logic_vector(31 downto 0);
  signal pgassign23 : std_logic_vector(3 downto 0);
  signal pgassign24 : std_logic_vector(31 downto 0);
  signal pgassign25 : std_logic_vector(3 downto 0);
  signal pgassign26 : std_logic_vector(31 downto 0);
  signal pgassign27 : std_logic_vector(3 downto 0);
  signal pgassign28 : std_logic_vector(31 downto 0);
  signal pgassign29 : std_logic_vector(3 downto 0);
  signal pgassign30 : std_logic_vector(31 downto 0);
  signal pgassign31 : std_logic_vector(3 downto 0);
  signal pgassign32 : std_logic_vector(31 downto 0);
  signal pgassign33 : std_logic_vector(3 downto 0);
  signal pgassign34 : std_logic_vector(31 downto 0);
  signal pgassign35 : std_logic_vector(3 downto 0);
  signal pgassign36 : std_logic_vector(31 downto 0);
  signal pgassign37 : std_logic_vector(3 downto 0);
  signal pgassign38 : std_logic_vector(31 downto 0);
  signal pgassign39 : std_logic_vector(3 downto 0);
  signal pgassign40 : std_logic_vector(31 downto 0);
  signal pgassign41 : std_logic_vector(3 downto 0);
  signal pgassign42 : std_logic_vector(31 downto 0);
  signal pgassign43 : std_logic_vector(3 downto 0);
  signal pgassign44 : std_logic_vector(31 downto 0);
  signal pgassign45 : std_logic_vector(3 downto 0);
  signal pgassign46 : std_logic_vector(31 downto 0);
  signal pgassign47 : std_logic_vector(3 downto 0);
  signal pgassign48 : std_logic_vector(31 downto 0);
  signal pgassign49 : std_logic_vector(3 downto 0);
  signal pgassign50 : std_logic_vector(31 downto 0);
  signal pgassign51 : std_logic_vector(3 downto 0);
  signal pgassign52 : std_logic_vector(31 downto 0);
  signal pgassign53 : std_logic_vector(3 downto 0);
  signal pgassign54 : std_logic_vector(31 downto 0);
  signal pgassign55 : std_logic_vector(3 downto 0);
  signal pgassign56 : std_logic_vector(31 downto 0);
  signal pgassign57 : std_logic_vector(3 downto 0);
  signal pgassign58 : std_logic_vector(31 downto 0);
  signal pgassign59 : std_logic_vector(3 downto 0);
  signal pgassign60 : std_logic_vector(31 downto 0);
  signal pgassign61 : std_logic_vector(3 downto 0);
  signal pgassign62 : std_logic_vector(31 downto 0);
  signal pgassign63 : std_logic_vector(3 downto 0);
  signal pgassign64 : std_logic_vector(31 downto 0);
  signal pgassign65 : std_logic_vector(3 downto 0);
  signal pgassign66 : std_logic_vector(31 downto 0);
  signal pgassign67 : std_logic_vector(3 downto 0);
  signal pgassign68 : std_logic_vector(31 downto 0);
  signal pgassign69 : std_logic_vector(3 downto 0);
  signal pgassign70 : std_logic_vector(31 downto 0);
  signal pgassign71 : std_logic_vector(3 downto 0);
  signal pgassign72 : std_logic_vector(31 downto 0);
  signal pgassign73 : std_logic_vector(3 downto 0);
  signal pgassign74 : std_logic_vector(31 downto 0);
  signal pgassign75 : std_logic_vector(3 downto 0);
  signal pgassign76 : std_logic_vector(31 downto 0);
  signal pgassign77 : std_logic_vector(3 downto 0);
  signal pgassign78 : std_logic_vector(31 downto 0);
  signal pgassign79 : std_logic_vector(3 downto 0);
  signal pgassign80 : std_logic_vector(31 downto 0);
  signal pgassign81 : std_logic_vector(3 downto 0);
  signal pgassign82 : std_logic_vector(31 downto 0);
  signal pgassign83 : std_logic_vector(3 downto 0);
  signal pgassign84 : std_logic_vector(31 downto 0);
  signal pgassign85 : std_logic_vector(3 downto 0);
  signal pgassign86 : std_logic_vector(31 downto 0);
  signal pgassign87 : std_logic_vector(3 downto 0);
  signal pgassign88 : std_logic_vector(31 downto 0);
  signal pgassign89 : std_logic_vector(3 downto 0);
  signal pgassign90 : std_logic_vector(31 downto 0);
  signal pgassign91 : std_logic_vector(3 downto 0);
  signal pgassign92 : std_logic_vector(31 downto 0);
  signal pgassign93 : std_logic_vector(3 downto 0);
  signal pgassign94 : std_logic_vector(31 downto 0);
  signal pgassign95 : std_logic_vector(3 downto 0);
  signal pgassign96 : std_logic_vector(31 downto 0);
  signal pgassign97 : std_logic_vector(3 downto 0);
  signal pgassign98 : std_logic_vector(31 downto 0);
  signal pgassign99 : std_logic_vector(3 downto 0);
  signal pgassign100 : std_logic_vector(31 downto 0);
  signal pgassign101 : std_logic_vector(3 downto 0);
  signal pgassign102 : std_logic_vector(31 downto 0);
  signal pgassign103 : std_logic_vector(3 downto 0);
  signal pgassign104 : std_logic_vector(31 downto 0);
  signal pgassign105 : std_logic_vector(3 downto 0);
  signal pgassign106 : std_logic_vector(31 downto 0);
  signal pgassign107 : std_logic_vector(3 downto 0);
  signal pgassign108 : std_logic_vector(31 downto 0);
  signal pgassign109 : std_logic_vector(3 downto 0);
  signal pgassign110 : std_logic_vector(31 downto 0);
  signal pgassign111 : std_logic_vector(3 downto 0);
  signal pgassign112 : std_logic_vector(31 downto 0);
  signal pgassign113 : std_logic_vector(3 downto 0);
  signal pgassign114 : std_logic_vector(31 downto 0);
  signal pgassign115 : std_logic_vector(3 downto 0);
  signal pgassign116 : std_logic_vector(31 downto 0);
  signal pgassign117 : std_logic_vector(3 downto 0);
  signal pgassign118 : std_logic_vector(31 downto 0);
  signal pgassign119 : std_logic_vector(3 downto 0);
  signal pgassign120 : std_logic_vector(31 downto 0);
  signal pgassign121 : std_logic_vector(3 downto 0);
  signal pgassign122 : std_logic_vector(31 downto 0);
  signal pgassign123 : std_logic_vector(3 downto 0);
  signal pgassign124 : std_logic_vector(31 downto 0);
  signal pgassign125 : std_logic_vector(3 downto 0);
  signal pgassign126 : std_logic_vector(31 downto 0);
  signal pgassign127 : std_logic_vector(3 downto 0);
  signal pgassign128 : std_logic_vector(31 downto 0);
  signal pgassign129 : std_logic_vector(3 downto 0);
  signal pgassign130 : std_logic_vector(31 downto 0);
  signal pgassign131 : std_logic_vector(31 downto 0);
  signal pgassign132 : std_logic_vector(3 downto 0);
  signal pgassign133 : std_logic_vector(31 downto 0);
  signal pgassign134 : std_logic_vector(31 downto 0);
  signal pgassign135 : std_logic_vector(3 downto 0);
  signal pgassign136 : std_logic_vector(31 downto 0);
  signal pgassign137 : std_logic_vector(31 downto 0);
  signal pgassign138 : std_logic_vector(3 downto 0);
  signal pgassign139 : std_logic_vector(31 downto 0);
  signal pgassign140 : std_logic_vector(31 downto 0);
  signal pgassign141 : std_logic_vector(3 downto 0);
  signal pgassign142 : std_logic_vector(31 downto 0);
  signal pgassign143 : std_logic_vector(31 downto 0);
  signal pgassign144 : std_logic_vector(3 downto 0);
  signal pgassign145 : std_logic_vector(31 downto 0);
  signal pgassign146 : std_logic_vector(31 downto 0);
  signal pgassign147 : std_logic_vector(3 downto 0);
  signal pgassign148 : std_logic_vector(31 downto 0);
  signal pgassign149 : std_logic_vector(31 downto 0);
  signal pgassign150 : std_logic_vector(3 downto 0);
  signal pgassign151 : std_logic_vector(31 downto 0);
  signal pgassign152 : std_logic_vector(31 downto 0);
  signal pgassign153 : std_logic_vector(3 downto 0);
  signal pgassign154 : std_logic_vector(31 downto 0);
  signal pgassign155 : std_logic_vector(31 downto 0);
  signal pgassign156 : std_logic_vector(3 downto 0);
  signal pgassign157 : std_logic_vector(31 downto 0);
  signal pgassign158 : std_logic_vector(31 downto 0);
  signal pgassign159 : std_logic_vector(3 downto 0);
  signal pgassign160 : std_logic_vector(31 downto 0);
  signal pgassign161 : std_logic_vector(31 downto 0);
  signal pgassign162 : std_logic_vector(3 downto 0);
  signal pgassign163 : std_logic_vector(31 downto 0);
  signal pgassign164 : std_logic_vector(31 downto 0);
  signal pgassign165 : std_logic_vector(3 downto 0);
  signal pgassign166 : std_logic_vector(31 downto 0);
  signal pgassign167 : std_logic_vector(31 downto 0);
  signal pgassign168 : std_logic_vector(3 downto 0);
  signal pgassign169 : std_logic_vector(31 downto 0);
  signal pgassign170 : std_logic_vector(31 downto 0);
  signal pgassign171 : std_logic_vector(3 downto 0);
  signal pgassign172 : std_logic_vector(31 downto 0);
  signal pgassign173 : std_logic_vector(31 downto 0);
  signal pgassign174 : std_logic_vector(3 downto 0);
  signal pgassign175 : std_logic_vector(31 downto 0);
  signal pgassign176 : std_logic_vector(31 downto 0);
  signal pgassign177 : std_logic_vector(3 downto 0);
  signal pgassign178 : std_logic_vector(31 downto 0);
  signal pgassign179 : std_logic_vector(31 downto 0);
  signal pgassign180 : std_logic_vector(3 downto 0);
  signal pgassign181 : std_logic_vector(31 downto 0);
  signal pgassign182 : std_logic_vector(31 downto 0);
  signal pgassign183 : std_logic_vector(3 downto 0);
  signal pgassign184 : std_logic_vector(31 downto 0);
  signal pgassign185 : std_logic_vector(31 downto 0);
  signal pgassign186 : std_logic_vector(3 downto 0);
  signal pgassign187 : std_logic_vector(31 downto 0);
  signal pgassign188 : std_logic_vector(31 downto 0);
  signal pgassign189 : std_logic_vector(3 downto 0);
  signal pgassign190 : std_logic_vector(31 downto 0);
  signal pgassign191 : std_logic_vector(31 downto 0);
  signal pgassign192 : std_logic_vector(3 downto 0);
  signal pgassign193 : std_logic_vector(31 downto 0);
  signal pgassign194 : std_logic_vector(31 downto 0);
  signal pgassign195 : std_logic_vector(3 downto 0);
  signal pgassign196 : std_logic_vector(31 downto 0);
  signal pgassign197 : std_logic_vector(31 downto 0);
  signal pgassign198 : std_logic_vector(3 downto 0);
  signal pgassign199 : std_logic_vector(31 downto 0);
  signal pgassign200 : std_logic_vector(31 downto 0);
  signal pgassign201 : std_logic_vector(3 downto 0);
  signal pgassign202 : std_logic_vector(31 downto 0);
  signal pgassign203 : std_logic_vector(31 downto 0);
  signal pgassign204 : std_logic_vector(3 downto 0);
  signal pgassign205 : std_logic_vector(31 downto 0);
  signal pgassign206 : std_logic_vector(31 downto 0);
  signal pgassign207 : std_logic_vector(3 downto 0);
  signal pgassign208 : std_logic_vector(31 downto 0);
  signal pgassign209 : std_logic_vector(31 downto 0);
  signal pgassign210 : std_logic_vector(3 downto 0);
  signal pgassign211 : std_logic_vector(31 downto 0);
  signal pgassign212 : std_logic_vector(31 downto 0);
  signal pgassign213 : std_logic_vector(3 downto 0);
  signal pgassign214 : std_logic_vector(31 downto 0);
  signal pgassign215 : std_logic_vector(31 downto 0);
  signal pgassign216 : std_logic_vector(3 downto 0);
  signal pgassign217 : std_logic_vector(31 downto 0);
  signal pgassign218 : std_logic_vector(31 downto 0);
  signal pgassign219 : std_logic_vector(3 downto 0);
  signal pgassign220 : std_logic_vector(31 downto 0);
  signal pgassign221 : std_logic_vector(31 downto 0);
  signal pgassign222 : std_logic_vector(3 downto 0);
  signal pgassign223 : std_logic_vector(31 downto 0);
  signal pgassign224 : std_logic_vector(31 downto 0);
  signal pgassign225 : std_logic_vector(3 downto 0);
  signal pgassign226 : std_logic_vector(31 downto 0);
  signal pgassign227 : std_logic_vector(31 downto 0);
  signal pgassign228 : std_logic_vector(3 downto 0);
  signal pgassign229 : std_logic_vector(31 downto 0);
  signal pgassign230 : std_logic_vector(31 downto 0);
  signal pgassign231 : std_logic_vector(3 downto 0);
  signal pgassign232 : std_logic_vector(31 downto 0);
  signal pgassign233 : std_logic_vector(31 downto 0);
  signal pgassign234 : std_logic_vector(3 downto 0);
  signal pgassign235 : std_logic_vector(31 downto 0);
  signal pgassign236 : std_logic_vector(31 downto 0);
  signal pgassign237 : std_logic_vector(3 downto 0);
  signal pgassign238 : std_logic_vector(31 downto 0);
  signal pgassign239 : std_logic_vector(31 downto 0);
  signal pgassign240 : std_logic_vector(3 downto 0);
  signal pgassign241 : std_logic_vector(31 downto 0);
  signal pgassign242 : std_logic_vector(31 downto 0);
  signal pgassign243 : std_logic_vector(3 downto 0);
  signal pgassign244 : std_logic_vector(31 downto 0);
  signal pgassign245 : std_logic_vector(31 downto 0);
  signal pgassign246 : std_logic_vector(3 downto 0);
  signal pgassign247 : std_logic_vector(31 downto 0);
  signal pgassign248 : std_logic_vector(31 downto 0);
  signal pgassign249 : std_logic_vector(3 downto 0);
  signal pgassign250 : std_logic_vector(31 downto 0);
  signal pgassign251 : std_logic_vector(31 downto 0);
  signal pgassign252 : std_logic_vector(3 downto 0);
  signal pgassign253 : std_logic_vector(31 downto 0);
  signal pgassign254 : std_logic_vector(31 downto 0);
  signal pgassign255 : std_logic_vector(3 downto 0);
  signal pgassign256 : std_logic_vector(31 downto 0);
  signal pgassign257 : std_logic_vector(31 downto 0);
  signal pgassign258 : std_logic_vector(3 downto 0);
  signal pgassign259 : std_logic_vector(31 downto 0);
  signal pgassign260 : std_logic_vector(31 downto 0);
  signal pgassign261 : std_logic_vector(3 downto 0);
  signal pgassign262 : std_logic_vector(31 downto 0);
  signal pgassign263 : std_logic_vector(31 downto 0);
  signal pgassign264 : std_logic_vector(3 downto 0);
  signal pgassign265 : std_logic_vector(31 downto 0);
  signal pgassign266 : std_logic_vector(31 downto 0);
  signal pgassign267 : std_logic_vector(3 downto 0);
  signal pgassign268 : std_logic_vector(31 downto 0);
  signal pgassign269 : std_logic_vector(31 downto 0);
  signal pgassign270 : std_logic_vector(3 downto 0);
  signal pgassign271 : std_logic_vector(31 downto 0);
  signal pgassign272 : std_logic_vector(31 downto 0);
  signal pgassign273 : std_logic_vector(3 downto 0);
  signal pgassign274 : std_logic_vector(31 downto 0);
  signal pgassign275 : std_logic_vector(31 downto 0);
  signal pgassign276 : std_logic_vector(3 downto 0);
  signal pgassign277 : std_logic_vector(31 downto 0);
  signal pgassign278 : std_logic_vector(31 downto 0);
  signal pgassign279 : std_logic_vector(3 downto 0);
  signal pgassign280 : std_logic_vector(31 downto 0);
  signal pgassign281 : std_logic_vector(31 downto 0);
  signal pgassign282 : std_logic_vector(3 downto 0);
  signal pgassign283 : std_logic_vector(31 downto 0);
  signal pgassign284 : std_logic_vector(31 downto 0);
  signal pgassign285 : std_logic_vector(3 downto 0);
  signal pgassign286 : std_logic_vector(31 downto 0);
  signal pgassign287 : std_logic_vector(31 downto 0);
  signal pgassign288 : std_logic_vector(3 downto 0);
  signal pgassign289 : std_logic_vector(31 downto 0);
  signal pgassign290 : std_logic_vector(31 downto 0);
  signal pgassign291 : std_logic_vector(3 downto 0);
  signal pgassign292 : std_logic_vector(31 downto 0);
  signal pgassign293 : std_logic_vector(31 downto 0);
  signal pgassign294 : std_logic_vector(3 downto 0);
  signal pgassign295 : std_logic_vector(31 downto 0);
  signal pgassign296 : std_logic_vector(31 downto 0);
  signal pgassign297 : std_logic_vector(3 downto 0);
  signal pgassign298 : std_logic_vector(31 downto 0);
  signal pgassign299 : std_logic_vector(31 downto 0);
  signal pgassign300 : std_logic_vector(3 downto 0);
  signal pgassign301 : std_logic_vector(31 downto 0);
  signal pgassign302 : std_logic_vector(31 downto 0);
  signal pgassign303 : std_logic_vector(3 downto 0);
  signal pgassign304 : std_logic_vector(31 downto 0);
  signal pgassign305 : std_logic_vector(31 downto 0);
  signal pgassign306 : std_logic_vector(3 downto 0);
  signal pgassign307 : std_logic_vector(31 downto 0);
  signal pgassign308 : std_logic_vector(31 downto 0);
  signal pgassign309 : std_logic_vector(3 downto 0);
  signal pgassign310 : std_logic_vector(31 downto 0);
  signal pgassign311 : std_logic_vector(31 downto 0);
  signal pgassign312 : std_logic_vector(3 downto 0);
  signal pgassign313 : std_logic_vector(31 downto 0);
  signal pgassign314 : std_logic_vector(31 downto 0);
  signal pgassign315 : std_logic_vector(3 downto 0);
  signal pgassign316 : std_logic_vector(31 downto 0);
  signal pgassign317 : std_logic_vector(31 downto 0);
  signal pgassign318 : std_logic_vector(3 downto 0);
  signal pgassign319 : std_logic_vector(31 downto 0);
  signal pgassign320 : std_logic_vector(31 downto 0);
  signal pgassign321 : std_logic_vector(3 downto 0);

begin

  -- Internal assignments

  pgassign1(0 to 30) <= B"0000000000000000000000000000000";
  pgassign2(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign2(0 downto 0) <= BRAM_Dout_A(0 to 0);
  pgassign3(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign3(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign3(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign3(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign4(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign4(0 downto 0) <= BRAM_Dout_B(0 to 0);
  pgassign5(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign5(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign5(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign5(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign6(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign6(0 downto 0) <= BRAM_Dout_A(1 to 1);
  pgassign7(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign7(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign7(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign7(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign8(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign8(0 downto 0) <= BRAM_Dout_B(1 to 1);
  pgassign9(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign9(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign9(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign9(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign10(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign10(0 downto 0) <= BRAM_Dout_A(2 to 2);
  pgassign11(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign11(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign11(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign11(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign12(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign12(0 downto 0) <= BRAM_Dout_B(2 to 2);
  pgassign13(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign13(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign13(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign13(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign14(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign14(0 downto 0) <= BRAM_Dout_A(3 to 3);
  pgassign15(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign15(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign15(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign15(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign16(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign16(0 downto 0) <= BRAM_Dout_B(3 to 3);
  pgassign17(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign17(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign17(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign17(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign18(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign18(0 downto 0) <= BRAM_Dout_A(4 to 4);
  pgassign19(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign19(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign19(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign19(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign20(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign20(0 downto 0) <= BRAM_Dout_B(4 to 4);
  pgassign21(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign21(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign21(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign21(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign22(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign22(0 downto 0) <= BRAM_Dout_A(5 to 5);
  pgassign23(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign23(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign23(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign23(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign24(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign24(0 downto 0) <= BRAM_Dout_B(5 to 5);
  pgassign25(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign25(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign25(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign25(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign26(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign26(0 downto 0) <= BRAM_Dout_A(6 to 6);
  pgassign27(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign27(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign27(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign27(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign28(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign28(0 downto 0) <= BRAM_Dout_B(6 to 6);
  pgassign29(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign29(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign29(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign29(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign30(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign30(0 downto 0) <= BRAM_Dout_A(7 to 7);
  pgassign31(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign31(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign31(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign31(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign32(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign32(0 downto 0) <= BRAM_Dout_B(7 to 7);
  pgassign33(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign33(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign33(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign33(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign34(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign34(0 downto 0) <= BRAM_Dout_A(8 to 8);
  pgassign35(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign35(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign35(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign35(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign36(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign36(0 downto 0) <= BRAM_Dout_B(8 to 8);
  pgassign37(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign37(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign37(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign37(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign38(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign38(0 downto 0) <= BRAM_Dout_A(9 to 9);
  pgassign39(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign39(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign39(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign39(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign40(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign40(0 downto 0) <= BRAM_Dout_B(9 to 9);
  pgassign41(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign41(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign41(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign41(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign42(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign42(0 downto 0) <= BRAM_Dout_A(10 to 10);
  pgassign43(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign43(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign43(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign43(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign44(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign44(0 downto 0) <= BRAM_Dout_B(10 to 10);
  pgassign45(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign45(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign45(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign45(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign46(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign46(0 downto 0) <= BRAM_Dout_A(11 to 11);
  pgassign47(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign47(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign47(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign47(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign48(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign48(0 downto 0) <= BRAM_Dout_B(11 to 11);
  pgassign49(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign49(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign49(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign49(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign50(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign50(0 downto 0) <= BRAM_Dout_A(12 to 12);
  pgassign51(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign51(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign51(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign51(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign52(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign52(0 downto 0) <= BRAM_Dout_B(12 to 12);
  pgassign53(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign53(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign53(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign53(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign54(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign54(0 downto 0) <= BRAM_Dout_A(13 to 13);
  pgassign55(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign55(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign55(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign55(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign56(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign56(0 downto 0) <= BRAM_Dout_B(13 to 13);
  pgassign57(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign57(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign57(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign57(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign58(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign58(0 downto 0) <= BRAM_Dout_A(14 to 14);
  pgassign59(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign59(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign59(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign59(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign60(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign60(0 downto 0) <= BRAM_Dout_B(14 to 14);
  pgassign61(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign61(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign61(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign61(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign62(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign62(0 downto 0) <= BRAM_Dout_A(15 to 15);
  pgassign63(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign63(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign63(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign63(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign64(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign64(0 downto 0) <= BRAM_Dout_B(15 to 15);
  pgassign65(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign65(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign65(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign65(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign66(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign66(0 downto 0) <= BRAM_Dout_A(16 to 16);
  pgassign67(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign67(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign67(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign67(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign68(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign68(0 downto 0) <= BRAM_Dout_B(16 to 16);
  pgassign69(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign69(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign69(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign69(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign70(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign70(0 downto 0) <= BRAM_Dout_A(17 to 17);
  pgassign71(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign71(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign71(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign71(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign72(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign72(0 downto 0) <= BRAM_Dout_B(17 to 17);
  pgassign73(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign73(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign73(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign73(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign74(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign74(0 downto 0) <= BRAM_Dout_A(18 to 18);
  pgassign75(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign75(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign75(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign75(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign76(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign76(0 downto 0) <= BRAM_Dout_B(18 to 18);
  pgassign77(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign77(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign77(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign77(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign78(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign78(0 downto 0) <= BRAM_Dout_A(19 to 19);
  pgassign79(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign79(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign79(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign79(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign80(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign80(0 downto 0) <= BRAM_Dout_B(19 to 19);
  pgassign81(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign81(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign81(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign81(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign82(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign82(0 downto 0) <= BRAM_Dout_A(20 to 20);
  pgassign83(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign83(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign83(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign83(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign84(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign84(0 downto 0) <= BRAM_Dout_B(20 to 20);
  pgassign85(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign85(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign85(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign85(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign86(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign86(0 downto 0) <= BRAM_Dout_A(21 to 21);
  pgassign87(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign87(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign87(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign87(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign88(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign88(0 downto 0) <= BRAM_Dout_B(21 to 21);
  pgassign89(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign89(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign89(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign89(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign90(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign90(0 downto 0) <= BRAM_Dout_A(22 to 22);
  pgassign91(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign91(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign91(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign91(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign92(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign92(0 downto 0) <= BRAM_Dout_B(22 to 22);
  pgassign93(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign93(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign93(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign93(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign94(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign94(0 downto 0) <= BRAM_Dout_A(23 to 23);
  pgassign95(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign95(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign95(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign95(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign96(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign96(0 downto 0) <= BRAM_Dout_B(23 to 23);
  pgassign97(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign97(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign97(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign97(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign98(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign98(0 downto 0) <= BRAM_Dout_A(24 to 24);
  pgassign99(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign99(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign99(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign99(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign100(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign100(0 downto 0) <= BRAM_Dout_B(24 to 24);
  pgassign101(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign101(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign101(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign101(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign102(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign102(0 downto 0) <= BRAM_Dout_A(25 to 25);
  pgassign103(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign103(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign103(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign103(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign104(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign104(0 downto 0) <= BRAM_Dout_B(25 to 25);
  pgassign105(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign105(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign105(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign105(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign106(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign106(0 downto 0) <= BRAM_Dout_A(26 to 26);
  pgassign107(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign107(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign107(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign107(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign108(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign108(0 downto 0) <= BRAM_Dout_B(26 to 26);
  pgassign109(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign109(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign109(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign109(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign110(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign110(0 downto 0) <= BRAM_Dout_A(27 to 27);
  pgassign111(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign111(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign111(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign111(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign112(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign112(0 downto 0) <= BRAM_Dout_B(27 to 27);
  pgassign113(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign113(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign113(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign113(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign114(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign114(0 downto 0) <= BRAM_Dout_A(28 to 28);
  pgassign115(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign115(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign115(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign115(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign116(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign116(0 downto 0) <= BRAM_Dout_B(28 to 28);
  pgassign117(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign117(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign117(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign117(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign118(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign118(0 downto 0) <= BRAM_Dout_A(29 to 29);
  pgassign119(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign119(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign119(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign119(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign120(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign120(0 downto 0) <= BRAM_Dout_B(29 to 29);
  pgassign121(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign121(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign121(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign121(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign122(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign122(0 downto 0) <= BRAM_Dout_A(30 to 30);
  pgassign123(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign123(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign123(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign123(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign124(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign124(0 downto 0) <= BRAM_Dout_B(30 to 30);
  pgassign125(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign125(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign125(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign125(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign126(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign126(0 downto 0) <= BRAM_Dout_A(31 to 31);
  pgassign127(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign127(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign127(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign127(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign128(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign128(0 downto 0) <= BRAM_Dout_B(31 to 31);
  pgassign129(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign129(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign129(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign129(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign130(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign130(0 downto 0) <= BRAM_Dout_A(0 to 0);
  BRAM_Din_A(0 to 0) <= pgassign131(0 downto 0);
  pgassign132(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign132(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign132(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign132(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign133(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign133(0 downto 0) <= BRAM_Dout_B(0 to 0);
  BRAM_Din_B(0 to 0) <= pgassign134(0 downto 0);
  pgassign135(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign135(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign135(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign135(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign136(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign136(0 downto 0) <= BRAM_Dout_A(1 to 1);
  BRAM_Din_A(1 to 1) <= pgassign137(0 downto 0);
  pgassign138(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign138(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign138(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign138(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign139(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign139(0 downto 0) <= BRAM_Dout_B(1 to 1);
  BRAM_Din_B(1 to 1) <= pgassign140(0 downto 0);
  pgassign141(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign141(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign141(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign141(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign142(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign142(0 downto 0) <= BRAM_Dout_A(2 to 2);
  BRAM_Din_A(2 to 2) <= pgassign143(0 downto 0);
  pgassign144(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign144(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign144(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign144(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign145(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign145(0 downto 0) <= BRAM_Dout_B(2 to 2);
  BRAM_Din_B(2 to 2) <= pgassign146(0 downto 0);
  pgassign147(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign147(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign147(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign147(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign148(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign148(0 downto 0) <= BRAM_Dout_A(3 to 3);
  BRAM_Din_A(3 to 3) <= pgassign149(0 downto 0);
  pgassign150(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign150(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign150(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign150(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign151(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign151(0 downto 0) <= BRAM_Dout_B(3 to 3);
  BRAM_Din_B(3 to 3) <= pgassign152(0 downto 0);
  pgassign153(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign153(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign153(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign153(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign154(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign154(0 downto 0) <= BRAM_Dout_A(4 to 4);
  BRAM_Din_A(4 to 4) <= pgassign155(0 downto 0);
  pgassign156(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign156(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign156(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign156(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign157(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign157(0 downto 0) <= BRAM_Dout_B(4 to 4);
  BRAM_Din_B(4 to 4) <= pgassign158(0 downto 0);
  pgassign159(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign159(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign159(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign159(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign160(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign160(0 downto 0) <= BRAM_Dout_A(5 to 5);
  BRAM_Din_A(5 to 5) <= pgassign161(0 downto 0);
  pgassign162(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign162(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign162(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign162(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign163(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign163(0 downto 0) <= BRAM_Dout_B(5 to 5);
  BRAM_Din_B(5 to 5) <= pgassign164(0 downto 0);
  pgassign165(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign165(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign165(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign165(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign166(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign166(0 downto 0) <= BRAM_Dout_A(6 to 6);
  BRAM_Din_A(6 to 6) <= pgassign167(0 downto 0);
  pgassign168(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign168(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign168(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign168(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign169(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign169(0 downto 0) <= BRAM_Dout_B(6 to 6);
  BRAM_Din_B(6 to 6) <= pgassign170(0 downto 0);
  pgassign171(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign171(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign171(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign171(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign172(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign172(0 downto 0) <= BRAM_Dout_A(7 to 7);
  BRAM_Din_A(7 to 7) <= pgassign173(0 downto 0);
  pgassign174(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign174(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign174(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign174(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign175(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign175(0 downto 0) <= BRAM_Dout_B(7 to 7);
  BRAM_Din_B(7 to 7) <= pgassign176(0 downto 0);
  pgassign177(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign177(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign177(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign177(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign178(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign178(0 downto 0) <= BRAM_Dout_A(8 to 8);
  BRAM_Din_A(8 to 8) <= pgassign179(0 downto 0);
  pgassign180(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign180(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign180(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign180(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign181(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign181(0 downto 0) <= BRAM_Dout_B(8 to 8);
  BRAM_Din_B(8 to 8) <= pgassign182(0 downto 0);
  pgassign183(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign183(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign183(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign183(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign184(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign184(0 downto 0) <= BRAM_Dout_A(9 to 9);
  BRAM_Din_A(9 to 9) <= pgassign185(0 downto 0);
  pgassign186(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign186(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign186(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign186(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign187(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign187(0 downto 0) <= BRAM_Dout_B(9 to 9);
  BRAM_Din_B(9 to 9) <= pgassign188(0 downto 0);
  pgassign189(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign189(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign189(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign189(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign190(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign190(0 downto 0) <= BRAM_Dout_A(10 to 10);
  BRAM_Din_A(10 to 10) <= pgassign191(0 downto 0);
  pgassign192(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign192(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign192(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign192(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign193(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign193(0 downto 0) <= BRAM_Dout_B(10 to 10);
  BRAM_Din_B(10 to 10) <= pgassign194(0 downto 0);
  pgassign195(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign195(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign195(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign195(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign196(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign196(0 downto 0) <= BRAM_Dout_A(11 to 11);
  BRAM_Din_A(11 to 11) <= pgassign197(0 downto 0);
  pgassign198(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign198(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign198(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign198(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign199(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign199(0 downto 0) <= BRAM_Dout_B(11 to 11);
  BRAM_Din_B(11 to 11) <= pgassign200(0 downto 0);
  pgassign201(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign201(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign201(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign201(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign202(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign202(0 downto 0) <= BRAM_Dout_A(12 to 12);
  BRAM_Din_A(12 to 12) <= pgassign203(0 downto 0);
  pgassign204(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign204(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign204(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign204(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign205(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign205(0 downto 0) <= BRAM_Dout_B(12 to 12);
  BRAM_Din_B(12 to 12) <= pgassign206(0 downto 0);
  pgassign207(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign207(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign207(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign207(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign208(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign208(0 downto 0) <= BRAM_Dout_A(13 to 13);
  BRAM_Din_A(13 to 13) <= pgassign209(0 downto 0);
  pgassign210(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign210(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign210(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign210(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign211(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign211(0 downto 0) <= BRAM_Dout_B(13 to 13);
  BRAM_Din_B(13 to 13) <= pgassign212(0 downto 0);
  pgassign213(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign213(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign213(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign213(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign214(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign214(0 downto 0) <= BRAM_Dout_A(14 to 14);
  BRAM_Din_A(14 to 14) <= pgassign215(0 downto 0);
  pgassign216(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign216(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign216(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign216(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign217(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign217(0 downto 0) <= BRAM_Dout_B(14 to 14);
  BRAM_Din_B(14 to 14) <= pgassign218(0 downto 0);
  pgassign219(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign219(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign219(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign219(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign220(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign220(0 downto 0) <= BRAM_Dout_A(15 to 15);
  BRAM_Din_A(15 to 15) <= pgassign221(0 downto 0);
  pgassign222(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign222(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign222(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign222(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign223(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign223(0 downto 0) <= BRAM_Dout_B(15 to 15);
  BRAM_Din_B(15 to 15) <= pgassign224(0 downto 0);
  pgassign225(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign225(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign225(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign225(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign226(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign226(0 downto 0) <= BRAM_Dout_A(16 to 16);
  BRAM_Din_A(16 to 16) <= pgassign227(0 downto 0);
  pgassign228(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign228(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign228(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign228(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign229(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign229(0 downto 0) <= BRAM_Dout_B(16 to 16);
  BRAM_Din_B(16 to 16) <= pgassign230(0 downto 0);
  pgassign231(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign231(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign231(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign231(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign232(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign232(0 downto 0) <= BRAM_Dout_A(17 to 17);
  BRAM_Din_A(17 to 17) <= pgassign233(0 downto 0);
  pgassign234(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign234(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign234(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign234(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign235(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign235(0 downto 0) <= BRAM_Dout_B(17 to 17);
  BRAM_Din_B(17 to 17) <= pgassign236(0 downto 0);
  pgassign237(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign237(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign237(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign237(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign238(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign238(0 downto 0) <= BRAM_Dout_A(18 to 18);
  BRAM_Din_A(18 to 18) <= pgassign239(0 downto 0);
  pgassign240(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign240(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign240(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign240(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign241(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign241(0 downto 0) <= BRAM_Dout_B(18 to 18);
  BRAM_Din_B(18 to 18) <= pgassign242(0 downto 0);
  pgassign243(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign243(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign243(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign243(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign244(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign244(0 downto 0) <= BRAM_Dout_A(19 to 19);
  BRAM_Din_A(19 to 19) <= pgassign245(0 downto 0);
  pgassign246(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign246(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign246(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign246(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign247(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign247(0 downto 0) <= BRAM_Dout_B(19 to 19);
  BRAM_Din_B(19 to 19) <= pgassign248(0 downto 0);
  pgassign249(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign249(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign249(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign249(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign250(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign250(0 downto 0) <= BRAM_Dout_A(20 to 20);
  BRAM_Din_A(20 to 20) <= pgassign251(0 downto 0);
  pgassign252(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign252(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign252(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign252(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign253(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign253(0 downto 0) <= BRAM_Dout_B(20 to 20);
  BRAM_Din_B(20 to 20) <= pgassign254(0 downto 0);
  pgassign255(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign255(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign255(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign255(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign256(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign256(0 downto 0) <= BRAM_Dout_A(21 to 21);
  BRAM_Din_A(21 to 21) <= pgassign257(0 downto 0);
  pgassign258(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign258(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign258(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign258(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign259(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign259(0 downto 0) <= BRAM_Dout_B(21 to 21);
  BRAM_Din_B(21 to 21) <= pgassign260(0 downto 0);
  pgassign261(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign261(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign261(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign261(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign262(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign262(0 downto 0) <= BRAM_Dout_A(22 to 22);
  BRAM_Din_A(22 to 22) <= pgassign263(0 downto 0);
  pgassign264(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign264(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign264(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign264(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign265(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign265(0 downto 0) <= BRAM_Dout_B(22 to 22);
  BRAM_Din_B(22 to 22) <= pgassign266(0 downto 0);
  pgassign267(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign267(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign267(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign267(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign268(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign268(0 downto 0) <= BRAM_Dout_A(23 to 23);
  BRAM_Din_A(23 to 23) <= pgassign269(0 downto 0);
  pgassign270(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign270(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign270(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign270(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign271(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign271(0 downto 0) <= BRAM_Dout_B(23 to 23);
  BRAM_Din_B(23 to 23) <= pgassign272(0 downto 0);
  pgassign273(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign273(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign273(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign273(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign274(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign274(0 downto 0) <= BRAM_Dout_A(24 to 24);
  BRAM_Din_A(24 to 24) <= pgassign275(0 downto 0);
  pgassign276(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign276(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign276(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign276(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign277(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign277(0 downto 0) <= BRAM_Dout_B(24 to 24);
  BRAM_Din_B(24 to 24) <= pgassign278(0 downto 0);
  pgassign279(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign279(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign279(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign279(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign280(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign280(0 downto 0) <= BRAM_Dout_A(25 to 25);
  BRAM_Din_A(25 to 25) <= pgassign281(0 downto 0);
  pgassign282(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign282(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign282(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign282(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign283(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign283(0 downto 0) <= BRAM_Dout_B(25 to 25);
  BRAM_Din_B(25 to 25) <= pgassign284(0 downto 0);
  pgassign285(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign285(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign285(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign285(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign286(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign286(0 downto 0) <= BRAM_Dout_A(26 to 26);
  BRAM_Din_A(26 to 26) <= pgassign287(0 downto 0);
  pgassign288(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign288(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign288(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign288(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign289(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign289(0 downto 0) <= BRAM_Dout_B(26 to 26);
  BRAM_Din_B(26 to 26) <= pgassign290(0 downto 0);
  pgassign291(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign291(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign291(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign291(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign292(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign292(0 downto 0) <= BRAM_Dout_A(27 to 27);
  BRAM_Din_A(27 to 27) <= pgassign293(0 downto 0);
  pgassign294(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign294(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign294(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign294(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign295(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign295(0 downto 0) <= BRAM_Dout_B(27 to 27);
  BRAM_Din_B(27 to 27) <= pgassign296(0 downto 0);
  pgassign297(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign297(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign297(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign297(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign298(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign298(0 downto 0) <= BRAM_Dout_A(28 to 28);
  BRAM_Din_A(28 to 28) <= pgassign299(0 downto 0);
  pgassign300(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign300(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign300(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign300(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign301(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign301(0 downto 0) <= BRAM_Dout_B(28 to 28);
  BRAM_Din_B(28 to 28) <= pgassign302(0 downto 0);
  pgassign303(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign303(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign303(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign303(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign304(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign304(0 downto 0) <= BRAM_Dout_A(29 to 29);
  BRAM_Din_A(29 to 29) <= pgassign305(0 downto 0);
  pgassign306(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign306(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign306(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign306(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign307(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign307(0 downto 0) <= BRAM_Dout_B(29 to 29);
  BRAM_Din_B(29 to 29) <= pgassign308(0 downto 0);
  pgassign309(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign309(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign309(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign309(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign310(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign310(0 downto 0) <= BRAM_Dout_A(30 to 30);
  BRAM_Din_A(30 to 30) <= pgassign311(0 downto 0);
  pgassign312(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign312(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign312(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign312(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign313(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign313(0 downto 0) <= BRAM_Dout_B(30 to 30);
  BRAM_Din_B(30 to 30) <= pgassign314(0 downto 0);
  pgassign315(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign315(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign315(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign315(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign316(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign316(0 downto 0) <= BRAM_Dout_A(31 to 31);
  BRAM_Din_A(31 to 31) <= pgassign317(0 downto 0);
  pgassign318(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign318(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign318(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign318(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign319(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign319(0 downto 0) <= BRAM_Dout_B(31 to 31);
  BRAM_Din_B(31 to 31) <= pgassign320(0 downto 0);
  pgassign321(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign321(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign321(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign321(0 downto 0) <= BRAM_WEN_B(3 to 3);
  net_gnd0 <= '0';
  net_gnd4(3 downto 0) <= B"0000";

  ramb36_0 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_0.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_0,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign2,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign3,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_0,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign4,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign5
    );

  ramb36_1 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_1.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_1,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign6,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign7,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_1,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign8,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign9
    );

  ramb36_2 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_2.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_2,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign10,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign11,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_2,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign12,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign13
    );

  ramb36_3 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_3.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_3,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign14,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign15,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_3,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign16,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign17
    );

  ramb36_4 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_4.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_4,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign18,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign19,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_4,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign20,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign21
    );

  ramb36_5 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_5.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_5,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign22,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign23,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_5,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign24,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign25
    );

  ramb36_6 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_6.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_6,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign26,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign27,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_6,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign28,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign29
    );

  ramb36_7 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_7.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_7,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign30,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign31,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_7,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign32,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign33
    );

  ramb36_8 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_8.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_8,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign34,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign35,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_8,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign36,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign37
    );

  ramb36_9 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_9.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_9,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign38,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign39,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_9,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign40,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign41
    );

  ramb36_10 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_10.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_10,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign42,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign43,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_10,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign44,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign45
    );

  ramb36_11 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_11.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_11,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign46,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign47,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_11,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign48,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign49
    );

  ramb36_12 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_12.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_12,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign50,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign51,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_12,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign52,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign53
    );

  ramb36_13 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_13.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_13,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign54,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign55,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_13,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign56,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign57
    );

  ramb36_14 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_14.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_14,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign58,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign59,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_14,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign60,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign61
    );

  ramb36_15 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_15.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_15,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign62,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign63,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_15,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign64,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign65
    );

  ramb36_16 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_16.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_16,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign66,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign67,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_16,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign68,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign69
    );

  ramb36_17 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_17.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_17,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign70,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign71,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_17,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign72,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign73
    );

  ramb36_18 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_18.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_18,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign74,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign75,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_18,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign76,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign77
    );

  ramb36_19 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_19.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_19,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign78,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign79,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_19,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign80,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign81
    );

  ramb36_20 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_20.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_20,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign82,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign83,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_20,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign84,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign85
    );

  ramb36_21 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_21.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_21,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign86,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign87,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_21,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign88,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign89
    );

  ramb36_22 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_22.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_22,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign90,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign91,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_22,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign92,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign93
    );

  ramb36_23 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_23.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_23,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign94,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign95,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_23,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign96,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign97
    );

  ramb36_24 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_24.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_24,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign98,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign99,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_24,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign100,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign101
    );

  ramb36_25 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_25.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_25,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign102,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign103,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_25,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign104,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign105
    );

  ramb36_26 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_26.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_26,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign106,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign107,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_26,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign108,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign109
    );

  ramb36_27 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_27.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_27,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign110,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign111,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_27,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign112,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign113
    );

  ramb36_28 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_28.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_28,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign114,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign115,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_28,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign116,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign117
    );

  ramb36_29 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_29.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_29,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign118,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign119,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_29,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign120,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign121
    );

  ramb36_30 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_30.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_30,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign122,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign123,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_30,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign124,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign125
    );

  ramb36_31 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_31.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "LOWER",
      RAM_EXTENSION_B => "LOWER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => net_gnd0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => CASCADEA_31,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign126,
      DIPA => net_gnd4,
      DOA => open,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign127,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => net_gnd0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => CASCADEB_31,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign128,
      DIPB => net_gnd4,
      DOB => open,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign129
    );

  ramb36_32 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_32.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_0,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign130,
      DIPA => net_gnd4,
      DOA => pgassign131,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign132,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_0,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign133,
      DIPB => net_gnd4,
      DOB => pgassign134,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign135
    );

  ramb36_33 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_33.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_1,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign136,
      DIPA => net_gnd4,
      DOA => pgassign137,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign138,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_1,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign139,
      DIPB => net_gnd4,
      DOB => pgassign140,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign141
    );

  ramb36_34 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_34.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_2,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign142,
      DIPA => net_gnd4,
      DOA => pgassign143,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign144,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_2,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign145,
      DIPB => net_gnd4,
      DOB => pgassign146,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign147
    );

  ramb36_35 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_35.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_3,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign148,
      DIPA => net_gnd4,
      DOA => pgassign149,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign150,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_3,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign151,
      DIPB => net_gnd4,
      DOB => pgassign152,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign153
    );

  ramb36_36 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_36.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_4,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign154,
      DIPA => net_gnd4,
      DOA => pgassign155,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign156,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_4,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign157,
      DIPB => net_gnd4,
      DOB => pgassign158,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign159
    );

  ramb36_37 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_37.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_5,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign160,
      DIPA => net_gnd4,
      DOA => pgassign161,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign162,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_5,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign163,
      DIPB => net_gnd4,
      DOB => pgassign164,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign165
    );

  ramb36_38 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_38.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_6,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign166,
      DIPA => net_gnd4,
      DOA => pgassign167,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign168,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_6,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign169,
      DIPB => net_gnd4,
      DOB => pgassign170,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign171
    );

  ramb36_39 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_39.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_7,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign172,
      DIPA => net_gnd4,
      DOA => pgassign173,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign174,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_7,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign175,
      DIPB => net_gnd4,
      DOB => pgassign176,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign177
    );

  ramb36_40 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_40.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_8,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign178,
      DIPA => net_gnd4,
      DOA => pgassign179,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign180,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_8,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign181,
      DIPB => net_gnd4,
      DOB => pgassign182,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign183
    );

  ramb36_41 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_41.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_9,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign184,
      DIPA => net_gnd4,
      DOA => pgassign185,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign186,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_9,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign187,
      DIPB => net_gnd4,
      DOB => pgassign188,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign189
    );

  ramb36_42 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_42.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_10,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign190,
      DIPA => net_gnd4,
      DOA => pgassign191,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign192,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_10,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign193,
      DIPB => net_gnd4,
      DOB => pgassign194,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign195
    );

  ramb36_43 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_43.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_11,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign196,
      DIPA => net_gnd4,
      DOA => pgassign197,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign198,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_11,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign199,
      DIPB => net_gnd4,
      DOB => pgassign200,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign201
    );

  ramb36_44 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_44.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_12,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign202,
      DIPA => net_gnd4,
      DOA => pgassign203,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign204,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_12,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign205,
      DIPB => net_gnd4,
      DOB => pgassign206,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign207
    );

  ramb36_45 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_45.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_13,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign208,
      DIPA => net_gnd4,
      DOA => pgassign209,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign210,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_13,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign211,
      DIPB => net_gnd4,
      DOB => pgassign212,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign213
    );

  ramb36_46 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_46.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_14,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign214,
      DIPA => net_gnd4,
      DOA => pgassign215,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign216,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_14,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign217,
      DIPB => net_gnd4,
      DOB => pgassign218,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign219
    );

  ramb36_47 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_47.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_15,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign220,
      DIPA => net_gnd4,
      DOA => pgassign221,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign222,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_15,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign223,
      DIPB => net_gnd4,
      DOB => pgassign224,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign225
    );

  ramb36_48 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_48.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_16,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign226,
      DIPA => net_gnd4,
      DOA => pgassign227,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign228,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_16,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign229,
      DIPB => net_gnd4,
      DOB => pgassign230,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign231
    );

  ramb36_49 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_49.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_17,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign232,
      DIPA => net_gnd4,
      DOA => pgassign233,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign234,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_17,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign235,
      DIPB => net_gnd4,
      DOB => pgassign236,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign237
    );

  ramb36_50 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_50.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_18,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign238,
      DIPA => net_gnd4,
      DOA => pgassign239,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign240,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_18,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign241,
      DIPB => net_gnd4,
      DOB => pgassign242,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign243
    );

  ramb36_51 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_51.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_19,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign244,
      DIPA => net_gnd4,
      DOA => pgassign245,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign246,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_19,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign247,
      DIPB => net_gnd4,
      DOB => pgassign248,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign249
    );

  ramb36_52 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_52.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_20,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign250,
      DIPA => net_gnd4,
      DOA => pgassign251,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign252,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_20,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign253,
      DIPB => net_gnd4,
      DOB => pgassign254,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign255
    );

  ramb36_53 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_53.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_21,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign256,
      DIPA => net_gnd4,
      DOA => pgassign257,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign258,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_21,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign259,
      DIPB => net_gnd4,
      DOB => pgassign260,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign261
    );

  ramb36_54 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_54.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_22,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign262,
      DIPA => net_gnd4,
      DOA => pgassign263,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign264,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_22,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign265,
      DIPB => net_gnd4,
      DOB => pgassign266,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign267
    );

  ramb36_55 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_55.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_23,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign268,
      DIPA => net_gnd4,
      DOA => pgassign269,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign270,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_23,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign271,
      DIPB => net_gnd4,
      DOB => pgassign272,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign273
    );

  ramb36_56 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_56.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_24,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign274,
      DIPA => net_gnd4,
      DOA => pgassign275,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign276,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_24,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign277,
      DIPB => net_gnd4,
      DOB => pgassign278,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign279
    );

  ramb36_57 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_57.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_25,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign280,
      DIPA => net_gnd4,
      DOA => pgassign281,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign282,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_25,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign283,
      DIPB => net_gnd4,
      DOB => pgassign284,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign285
    );

  ramb36_58 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_58.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_26,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign286,
      DIPA => net_gnd4,
      DOA => pgassign287,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign288,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_26,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign289,
      DIPB => net_gnd4,
      DOB => pgassign290,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign291
    );

  ramb36_59 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_59.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_27,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign292,
      DIPA => net_gnd4,
      DOA => pgassign293,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign294,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_27,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign295,
      DIPB => net_gnd4,
      DOB => pgassign296,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign297
    );

  ramb36_60 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_60.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_28,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign298,
      DIPA => net_gnd4,
      DOA => pgassign299,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign300,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_28,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign301,
      DIPB => net_gnd4,
      DOB => pgassign302,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign303
    );

  ramb36_61 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_61.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_29,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign304,
      DIPA => net_gnd4,
      DOA => pgassign305,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign306,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_29,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign307,
      DIPB => net_gnd4,
      DOB => pgassign308,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign309
    );

  ramb36_62 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_62.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_30,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign310,
      DIPA => net_gnd4,
      DOA => pgassign311,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign312,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_30,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign313,
      DIPB => net_gnd4,
      DOB => pgassign314,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign315
    );

  ramb36_63 : RAMB36
    generic map (
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INIT_FILE => "bram_block_0_combined_63.mem",
      READ_WIDTH_A => 1,
      READ_WIDTH_B => 1,
      WRITE_WIDTH_A => 1,
      WRITE_WIDTH_B => 1,
      RAM_EXTENSION_A => "UPPER",
      RAM_EXTENSION_B => "UPPER"
    )
    port map (
      ADDRA => BRAM_Addr_A(14 to 29),
      CASCADEINLATA => CASCADEA_31,
      CASCADEINREGA => net_gnd0,
      CASCADEOUTLATA => open,
      CASCADEOUTREGA => open,
      CLKA => BRAM_Clk_A,
      DIA => pgassign316,
      DIPA => net_gnd4,
      DOA => pgassign317,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      SSRA => BRAM_Rst_A,
      WEA => pgassign318,
      ADDRB => BRAM_Addr_B(14 to 29),
      CASCADEINLATB => CASCADEB_31,
      CASCADEINREGB => net_gnd0,
      CASCADEOUTLATB => open,
      CASCADEOUTREGB => open,
      CLKB => BRAM_Clk_B,
      DIB => pgassign319,
      DIPB => net_gnd4,
      DOB => pgassign320,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      SSRB => BRAM_Rst_B,
      WEB => pgassign321
    );

end architecture STRUCTURE;

