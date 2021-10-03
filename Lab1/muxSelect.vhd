LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity muxSelect is
  port (
    i_A, i_B : IN STD_LOGIC;
    o_Z : OUT STD_LOGIC_VECTOR(1 downto 0)
  ) ;
end muxSelect ;

architecture arch of muxSelect is
    SIGNAL int_Z : STD_LOGIC_VECTOR(1 downto 0);

begin
    int_Z(0) <= i_A;
    int_Z(1) <= i_B;

    o_Z <= int_Z;

end architecture ; -- arch