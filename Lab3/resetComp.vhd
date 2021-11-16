--------------------------------------------------------------------------------
--	File name: BCD 7 Segment Decoder
--	
--	Description: This file creates the resetComparator flag 
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity resetComp is

	port(	clk, TimerExpired: in std_logic;
			reset : out std_logic );

end resetComp;

architecture arch of resetComp is

begin
	process( TimerExpired, clk ) 
	begin 
		if ( clk'Event and clk='1' and TimerExpired='1' ) then
			reset <= '1';
		end if;
		if( TimerExpired='0' ) then 
			reset <= '0';
		end if;	
		
	end process;

end arch;