--------------------------------------------------------------------------------
-- Title         : 8-bit Left Shift Register
-------------------------------------------------------------------------------
-- File          : eightBitLSR.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 4-bit input & 8-bit output left shift register. 
-- 				Data input: i_A
--				Load the input: i_resetBar = 1, i_clock = clk, i_load = 1, i_clear = 0, i_shift = 0   (2 clock cycles)
--				Shift the input: i_resetBar = 1, i_clock = clk, i_load = 0, i_clear = 0, i_shift = 1  	

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitLSR IS
	PORT(
		i_resetBar, i_clock	: IN	STD_LOGIC;
		i_load, i_clear, i_shift	: IN	STD_LOGIC;
		i_A			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_Z			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitLSR;

ARCHITECTURE rtl OF eightBitLSR IS

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

	SIGNAL int_enable : STD_LOGIC;
	SIGNAL int_A, int_d, int_Y : STD_LOGIC_VECTOR(7 downto 0); 

BEGIN

-- int_A <= '0000' + i_A  for the 4 left most significant bits.
int_A(7) <= '0';
int_A(6) <= '0';
int_A(5) <= '0';
int_A(4) <= '0';
int_A(3) <= i_A(3);
int_A(2) <= i_A(2);
int_A(1) <= i_A(1);
int_A(0) <= i_A(0);

int_enable <= i_shift XOR i_load XOR i_clear;
int_d <= ((i_load & i_load & i_load & i_load & i_load & i_load & i_load & i_load) AND int_A) OR
		((i_shift & i_shift & i_shift & i_shift & i_shift & i_shift & i_shift & i_shift ) AND 
		(int_Y(6) & int_Y(5) & int_Y(4) & int_Y(3) & int_Y(2) & int_Y(1) & int_Y(0) & '0')) OR
		((i_clear & i_clear & i_clear & i_clear & i_clear & i_clear & i_clear & i_clear) AND "00000000");

bit0: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar,
            i_d => int_d(0), 
            i_enable => int_enable,
            i_clock => i_clock,
            o_q => int_Y(0));

bit1: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(1), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(1));

bit2: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(2), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(2));

bit3: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(3), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(3));     

bit4: enARdFF_2
    PORT MAP (i_resetBar => i_resetBar,
            i_d => int_d(4), 
            i_enable => int_enable,
            i_clock => i_clock,
            o_q => int_Y(4));

bit5: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(5), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(5));

bit6: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(6), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(6));

bit7: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_d(7), 
			  i_enable => int_enable,
			  i_clock => i_clock,
			  o_q => int_Y(7));    


	-- Output Driver
	o_Z	<= int_Y;

END rtl;
