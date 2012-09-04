------------------------------------------------------------------------------
--	Copyright (c) 2012, Imperial College London
--	All rights reserved.
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE project_pak IS

CONSTANT clk_per : time := 8 ns;

CONSTANT C_SIMPBUS_AWIDTH : integer := 32;

CONSTANT ARG_0 : std_logic_vector(31 DOWNTO 0) := (OTHERS => '1');
CONSTANT ARG_1 : std_logic_vector(31 DOWNTO 0) := (OTHERS => '1');

END PACKAGE project_pak;