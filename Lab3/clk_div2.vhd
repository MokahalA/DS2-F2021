--------------------------------------------------------------------------------
--	File name: clk_div2
--	
--	Description: This clock divider file uses 2 clk_div components 
-- 				  to create a 1Hz output clock, from an input 50MHz clock
--------------------------------------------------------------------------------

library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY clk_div2 IS

	PORT
(		clock			: IN	STD_LOGIC;
		
		clock_1s				: OUT	STD_LOGIC);
	
END clk_div2;






ARCHITECTURE a OF clk_div2 IS



	SIGNAL  divtodiv :	 STD_LOGIC; 
	
	
	COMPONENT clk_div 

	PORT
	(	workclock 				: IN STD_LOGIC ; 
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1MHz				: OUT	STD_LOGIC);
	
END COMPONENT;
	
BEGIN
	
	div1 : clk_div port map ('1',clock,divtodiv); 
	div2 : clk_div port map (divtodiv,clock,clock_1s); -- Outputs a 1Hz clock (period = ~1s)

END a;

