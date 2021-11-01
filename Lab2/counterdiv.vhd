--------------------------------------------------------------------------------
-- Title         : 4-bit counter
-- Project       : Fixed-Point Arithmetic Lab2
-------------------------------------------------------------------------------
-- File          : counterdiv.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 4-bit counter.
--               Each time it adds 0001 to the count until it reachs 0100 (4)
--               then it is done
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counterdiv IS
	PORT(
		i_rstBar, i_inc	: IN	STD_LOGIC;
		i_clk			: IN	STD_LOGIC;
		isdone			: Out	STD_LOGIC
	);
END counterdiv;

ARCHITECTURE rtl OF counterdiv IS

	COMPONENT enardFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT fourBitRegisterdiv
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0));
	END COMPONENT;

	COMPONENT fourBitAddSub
	port (
		addSub : IN STD_LOGIC;    -- add'Sub
		i_X, i_Y : IN STD_LOGIC_VECTOR(3 downto 0); -- 4-bits inputs
		o_Sum : OUT STD_LOGIC_VECTOR(3 downto 0) -- 4-bit sum output
	) ;
	
	END COMPONENT ;
  
	COMPONENT Mux2x1div
		port (
		i_sel : IN STD_LOGIC;
		i_D0, i_D1 : IN STD_LOGIC_VECTOR(3 downto 0);
		o_q :  out STD_LOGIC_VECTOR(3 downto 0)
	) ;
	END COMPONENT;

	SIGNAL regtoadd ,addtoreg , muxtoadd :std_LOGIC_VECTOR(3 downto 0);
	SIGNAL done :std_LOGIC ;
BEGIN

	done <=(NOT(regtoadd(3)) AND NOT(regtoadd(1)) AND NOT(regtoadd(0)) AND regtoadd(2) );

	addi : addSub4bitdiv port map ('0',muxtoadd,regtoadd,addtoreg);
	addimux: t2x1MUXdiv port map(i_inc ,"0000","0001",muxtoadd);
	reg: fourBitRegisterdiv port map(i_rstBar,i_inc and not(done),i_clk,addtoreg,regtoadd);

	isdone<= done;

END rtl;
