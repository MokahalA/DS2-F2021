--------------------------------------------------------------------------------
-- Title         : 1-bit Full Adder Subtractor
-------------------------------------------------------------------------------
-- File          : oneBitFullAddSub.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 1-bit full adder/Subtractor circuit
--                  addSub = 0 for addition      addSub = 1 for subtraction

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity oneBitFullAddSub is
  port (
    addSub : IN STD_LOGIC; -- add'Sub
    i_A, i_B : IN STD_LOGIC;   -- 1-bit inputs
    i_carryIn : IN STD_LOGIC;  -- carry input
    o_S : OUT STD_LOGIC;        -- sum output
    o_carryOut: OUT STD_LOGIC   -- carry output
  ) ;
end oneBitFullAddSub ;

architecture arch of oneBitFullAddSub is

  SIGNAL i_newB : STD_LOGIC; -- B xor addSub
  SIGNAL int_w1 : STD_LOGIC; -- A xor newB
  SIGNAL int_w2 : STD_LOGIC; -- (A xor newB) and Carry In
  SIGNAL int_w3 : STD_LOGIC; -- A and newB

  begin
    i_newB <= i_B xor addSub;
    int_w1 <= i_A xor i_newB;
    int_w2 <= int_w1 and i_carryIn;
    int_w3 <= i_A and i_newB;

  -- Output driver
  o_S <= int_w1 xor i_carryIn;
  o_carryOut <= int_w2 and int_w3;


end architecture ; -- arch