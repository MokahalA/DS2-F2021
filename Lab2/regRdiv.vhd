--------------------------------------------------------------------------------
-- Title         : 4-bit Register R
-- Project       : Fixed-Point Arithmetic Lab2
-------------------------------------------------------------------------------
-- File          : regRdiv.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 4-bit register.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regRdiv IS
	PORT(
		i_resetBar, i_load, i_shift	: IN	STD_LOGIC;
		i_clock,w			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0)
			);
END regRdiv;

ARCHITECTURE rtl OF regRdiv IS
	SIGNAL int_Value, int_notValue ,outmux: STD_LOGIC_VECTOR(3 downto 0);

	COMPONENT enardFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT Mux2x1div
        port (
    		i_sel : IN STD_LOGIC;
    		i_D0, i_D1 : IN STD_LOGIC;
			o_q : OUT STD_LOGIC
  		) ;
    END COMPONENT;

BEGIN


			
mux3 :Mux2x1div port map(i_shift,i_value(3),int_Value(2),outmux(3));

bit3: enardFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(3), 
			  i_enable => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(3),
	          o_qBar => int_notValue(3));


mux2 :Mux2x1div port map(i_shift,i_value(2),int_Value(1),outmux(2));

bit2: enardFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(2), 
			  i_enable  => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(2),
	          o_qBar => int_notValue(2));
				 
mux1 :Mux2x1div port map(i_shift,i_value(1),int_Value(0),outmux(1));

bit1: enardFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(1), 
			  i_enable  => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(1),
	          o_qBar => int_notValue(1));

				 
mux0 :Mux2x1div port map(i_shift,i_value(0),w,outmux(0));

bit0: enardFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(0),
			  i_enable  => i_load or i_shift, 
			  i_clock => i_clock,
			  o_q => int_Value(0),
	          o_qBar => int_notValue(0));

	-- Output Driver
	o_Value		<= int_Value;

END rtl;