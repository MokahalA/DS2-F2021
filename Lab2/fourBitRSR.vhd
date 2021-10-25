--------------------------------------------------------------------------------
-- Title         : 4-bit Right Shift Register
-------------------------------------------------------------------------------
-- File          : fourBitRSR.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 4-bit right shift register. 
-- 				Data input: i_A
--				Load the input: i_resetBar = 1, i_clock = clk, i_load = 1, i_clear = 0, i_shift = 0   (2 clock cycles)
--				Shift the input: i_resetBar = 1, i_clock = clk, i_load = 0, i_clear = 0, i_shift = 1  	  

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fourBitRSR IS
	PORT(
		i_resetBar, i_clock	: IN	STD_LOGIC;
		i_load, i_clear, i_shift	: IN	STD_LOGIC;
		i_A			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_Z			: OUT	STD_LOGIC_VECTOR(3 downto 0));
END fourBitRSR;

ARCHITECTURE rtl OF fourBitRSR IS

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

	SIGNAL int_enable : STD_LOGIC;
	SIGNAL int_d, int_Y : STD_LOGIC_VECTOR(3 downto 0);

BEGIN

int_enable <= i_shift XOR i_load XOR i_clear;
int_d <= ((i_load & i_load & i_load & i_load) AND i_A) OR
		((i_shift & i_shift & i_shift & i_shift) AND 
		('0' & int_Y(3) & int_Y(2) & int_Y(1))) OR
		((i_clear & i_clear & i_clear & i_clear) AND "0000");

bit3: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(3), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(3));

bit2: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(2), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(2));

bit1: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(1), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(1));


bit0: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar,
            i_d => int_d(0), 
            i_enable => int_enable,
            i_clock => i_clock,
            o_q => int_Y(0));
              

	-- Output Driver
	o_Z	<= int_Y;

END rtl;
