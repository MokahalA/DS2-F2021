--------------------------------------------------------------------------------
-- Title         : Three bit Comparator
-- Project       : Fixed-Point Arithmetic Lab2
-------------------------------------------------------------------------------
-- File          : threeBitComparatordiv.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 3-bit comparator.
--               Take two inputs (A and B) and compare them.
--               O_GT = signal for A greater than B
--               O_LT = signal for A lower than B
--               O_EQ = singal for A equal to B
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY threeBitComparatordiv IS
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
END threeBitComparatordiv;

ARCHITECTURE rtl OF threeBitComparatordiv IS
	SIGNAL int_GT, int_LT : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL grnd : STD_LOGIC;

	COMPONENT oneBitComparatordiv
	PORT(
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		i_Ai, i_Bi			: IN	STD_LOGIC;
		o_GT, o_LT			: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Concurrent Signal Assignment
	grnd <= '0';

comp3: oneBitComparatordiv
	PORT MAP (i_GTPrevious => grnd, 
	          i_LTPrevious => grnd,
			  i_Ai => i_Ai(3),
			  i_Bi => i_Bi(3),
			  o_GT => int_GT(3),
			  o_LT => int_LT(3));
	
comp2: oneBitComparatordiv
	PORT MAP (i_GTPrevious => grnd, 
	          i_LTPrevious => grnd,
			  i_Ai => i_Ai(2),
			  i_Bi => i_Bi(2),
			  o_GT => int_GT(2),
			  o_LT => int_LT(2));

comp1: oneBitComparatordiv
	PORT MAP (i_GTPrevious => int_GT(2), 
	          i_LTPrevious => int_LT(2),
			  i_Ai => i_Ai(1),
			  i_Bi => i_Bi(1),
			  o_GT => int_GT(1),
			  o_LT => int_LT(1));

comp0: oneBitComparatordiv
	PORT MAP (i_GTPrevious => int_GT(1), 
	          i_LTPrevious => int_LT(1),
			  i_Ai => i_Ai(0),
			  i_Bi => i_Bi(0),
			  o_GT => int_GT(0),
			  o_LT => int_LT(0));

	-- Output Driver
	o_GT <= int_GT(0);
	o_LT <= int_LT(0);
	o_EQ <= int_GT(0) nor int_LT(0);

END rtl;
