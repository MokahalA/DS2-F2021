--------------------------------------------------------------------------------
--	File name: bcdseg
--	
--	Description: This file decodes the input states into a 7 seg decoder
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity bcdseg is
	port(	
			temps : in std_logic_vector(3 downto 0);
			decout: out  std_logic_vector(6 downto 0 );
			bcdout : out std_logic_vector(6 downto 0 ));
			
end bcdseg;

architecture s of bcdseg is 

begin

	PROCESS (temps)
		BEGIN

		CASE temps IS
		WHEN "0000" => bcdout<="1000000";--0
							decout<="1000000";
		WHEN "0001" => bcdout<="1111001";--1
							decout<="1000000";
		WHEN "0010" => bcdout<="0100100";--2
							decout<="1000000";
		WHEN "0011" => bcdout<="0110000";--3
							decout<="1000000";
		WHEN "0100" => bcdout<="0011001";--4
							decout<="1000000";
		WHEN "0101" => bcdout<="0010010";--5
							decout<="1000000";
		WHEN "0110" => bcdout<="0000010";--6
							decout<="1000000";
		WHEN "0111" => bcdout<="1111000";--7
							decout<="1000000";
		WHEN "1000" => bcdout<="0000000";--8
							decout<="1000000";
		WHEN "1001" => bcdout<="0010000";--9
							decout<="1000000";
		WHEN "1010" => bcdout<="1000000";--10
							decout<="1111001";
		WHEN "1011" => bcdout<="1111001";--11
							decout<="1111001";
		WHEN "1100" => bcdout<="0100100";--12
							decout<="1111001";
		WHEN "1101" => bcdout<="0110000";--13
							decout<="1111001";
		WHEN "1110" => bcdout<="0011001";--14
							decout<="1111001";
		WHEN "1111" => bcdout<="0010010";--14
							decout<="1111001";
		WHEN OTHERS => bcdout<="1000000";

		END CASE;
	END PROCESS;

end s;
