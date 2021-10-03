--------------------------------------------------------------------------------
-- Title         : 8-bit OR gate
-------------------------------------------------------------------------------
-- File          : eightBitOR.vhd
-------------------------------------------------------------------------------
-- Description : This file creates an 8-bit OR gate.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity eightBitOR is
  port (
    i_A, i_B : IN STD_LOGIC_VECTOR(7 downto 0);
    o_Z : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end eightBitOR ;

architecture arch of eightBitOR is

begin

    o_Z <= i_A OR i_B;

end architecture ; -- arch