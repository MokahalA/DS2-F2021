--------------------------------------------------------------------------------
--	File name: oneBitComparator
--	
--	Description: This file creates a 1-bit comparator,
--				 used as a building block for the 4-bit comparator.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity oneBitComparator is 
	port(	A, B : in std_logic;
			S : out std_logic);
end oneBitComparator;

architecture arch of oneBitComparator is
begin
	S <= not(A xor B);
end arch;
