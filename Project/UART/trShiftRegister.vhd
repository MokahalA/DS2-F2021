--------------------------------------------------------------------------------
-- Title         : 8-bit Right Shift Register (Transmitter)
-------------------------------------------------------------------------------
-- File          : trShiftRegister.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 8-bit right shift register. 
-- 				Data input: i_A
--				Load the input: i_resetBar = 1, i_clock = clk, i_load = 1, i_clear = 0, i_shift = 0   (2 clock cycles)
--				Shift the input: i_resetBar = 1, i_clock = clk, i_load = 0, i_clear = 0, i_shift = 1  	  

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY trShiftRegister IS
	PORT(
		i_resetBar, i_clock	: IN	STD_LOGIC;
		i_load, i_clear, i_shift	: IN	STD_LOGIC;
		i_A			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Z			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END trShiftRegister;

ARCHITECTURE rtl OF trShiftRegister IS

	COMPONENT enASdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

	SIGNAL int_enable : STD_LOGIC;
	SIGNAL int_d, int_Y : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

int_enable <= i_shift XOR i_load XOR i_clear;
int_d <= ((i_load & i_load & i_load & i_load & i_load & i_load & i_load & i_load) AND i_A) OR
		((i_shift & i_shift & i_shift & i_shift & i_shift & i_shift & i_shift & i_shift) AND 
		('1' & int_Y(7) & int_Y(6) & int_Y(5) & int_Y(4) & int_Y(3) & int_Y(2) & int_Y(1))) OR
		((i_clear & i_clear & i_clear & i_clear & i_clear & i_clear & i_clear & i_clear) AND "00000000");

bit7: enASdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(7), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(7));

bit6: enASdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(6), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(6));


bit5: enASdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(5), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(5));


bit4: enASdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(4), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(4));


bit3: enASdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(3), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(3));

bit2: enASdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(2), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(2));

bit1: enASdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(1), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(1));


bit0: enASdFF_2
    PORT MAP (i_resetBar => i_resetBar,
            i_d => int_d(0), 
            i_enable => int_enable,
            i_clock => i_clock,
            o_q => int_Y(0));
              

	-- Output Driver
	o_Z	<= int_Y;

END rtl;