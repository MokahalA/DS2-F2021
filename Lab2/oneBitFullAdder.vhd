--------------------------------------------------------------------------------
-- Title         : 1-bit Full Adder
-------------------------------------------------------------------------------
-- File          : oneBitFullAdder.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 1-bit full adder circuit

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity oneBitFullAdder is
  port (
    i_A, i_B : IN STD_LOGIC;   -- 1-bit inputs
    i_carryIn : IN STD_LOGIC;  -- carry input
    o_S : OUT STD_LOGIC;        -- sum output
    o_carryOut: OUT STD_LOGIC   -- carry output
  ) ;
end oneBitFullAdder ;

architecture arch of oneBitFullAdder is

  SIGNAL int_w1 : STD_LOGIC; -- A xor B
  SIGNAL int_w2 : STD_LOGIC; -- (A xor B) and Carry In
  SIGNAL int_w3 : STD_LOGIC; -- A and B

  begin
    int_w1 <= i_A xor i_B;
    int_w2 <= int_w1 and i_carryIn;
    int_w3 <= i_A and i_B;

  -- Output driver
  o_S <= int_w1 xor i_carryIn;
  o_carryOut <= int_w2 and int_w3;


end architecture ; -- arch