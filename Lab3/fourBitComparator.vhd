--------------------------------------------------------------------------------
--	File name: fourBitComparator
--	
--	Description: This file creates a 4-bit comparator
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fourBitComparator is
	port(	A, B : in std_logic_vector(3 downto 0);
			S : out std_logic);
end fourBitComparator;

architecture arch of fourBitComparator is
	component oneBitComparator 
		port(	A, B :in std_logic;
				S : out std_logic);
	end component;
    
	signal int_s : std_logic_vector(3 downto 0);

begin
	comp0: oneBitComparator port map(A=>A(0), B=>B(0), S=>int_s(0));
	comp1: oneBitComparator port map(A=>A(1), B=>B(1), S=>int_s(1));
	comp2: oneBitComparator port map(A=>A(2), B=>B(2), S=>int_s(2));
	comp3: oneBitComparator port map(A=>A(3), B=>B(3), S=>int_s(3));

	S<=int_s(0) and int_s(1) and int_s(2) and int_s(3); 	

end arch;