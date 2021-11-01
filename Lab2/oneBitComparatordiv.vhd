--------------------------------------------------------------------------------
-- Title         : One bit Comparator
-- Project       : Fixed-Point Arithmetic Lab2
-------------------------------------------------------------------------------
-- File          : oneBitComparatordiv.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 1-bit comparator.
--               Take two inputs (A and B) and compare them.
--               O_GT = signal for A greater than B
--               O_LT = signal for A lower than B
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitComparatordiv IS
	PORT(
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		i_Ai, i_Bi			: IN	STD_LOGIC;
		o_GT, o_LT			: OUT	STD_LOGIC);
END oneBitComparatordiv;

ARCHITECTURE rtl OF oneBitComparatordiv IS
	SIGNAL int_GT1, int_GT2, int_LT1, int_LT2 : STD_LOGIC;
	SIGNAL int_GT, int_LT : STD_LOGIC;

BEGIN

	-- Concurrent Signal Assignment
	int_GT1 <= not(i_GTPrevious) and not(i_LTPrevious) and i_Ai and not(i_Bi);
	int_GT2 <= i_GTPrevious and not(i_LTPrevious);
	int_GT <= int_GT1 or int_GT2;
	int_LT1 <= not(i_GTPrevious) and not(i_LTPrevious) and not(i_Ai) and i_Bi;
	int_LT2 <= not(i_GTPrevious) and i_LTPrevious;
	int_LT <= int_LT1 or int_LT2;

	-- Output Driver
	o_GT <= int_GT;
	o_LT <= int_LT;

END rtl;
