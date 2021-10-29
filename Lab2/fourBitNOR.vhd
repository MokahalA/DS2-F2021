--------------------------------------------------------------------------------
-- Title         : 4-bit NOR Gate
-------------------------------------------------------------------------------
-- File          : fourBitNOR.vhd
-------------------------------------------------------------------------------
-- Description : This file creates an 4-bit NOR gate used to check BeqZero
--           Input 4 bits, output 1-bit
--           If o_q = 1, Input is zero.
--           If o_q = 0, Input is non-zero.


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fourBitNOR is
  port (
    i_A, i_B : IN STD_LOGIC_VECTOR(3 downto 0);
    o_q : OUT STD_LOGIC
  ) ;
end fourBitNOR ;

architecture arch of fourBitNOR is
    SIGNAL int_q : STD_LOGIC_VECTOR(3 downto 0);

begin
    int_q(0) <= not(i_A(0) or i_B(0));
    int_q(1) <= not(i_A(1) or i_B(1));
    int_q(2) <= not(i_A(2) or i_B(2));
    int_q(3) <= not(i_A(3) or i_B(3));

    o_q <= '1' when int_q = "1111"
      else '0';

end architecture ; -- arch