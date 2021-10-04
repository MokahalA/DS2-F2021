--------------------------------------------------------------------------------
-- Title         : 4-bit Adder Subtractor
-------------------------------------------------------------------------------
-- File          : fouritFullAdder.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 4-bit adder subtractor circuit.
--                addSub = 0 for addition      addSub = 1 for subtraction

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fourBitAdderSubtractor is
  port (
    addSub : IN STD_LOGIC;    -- add'Sub
    i_X, i_Y : IN STD_LOGIC_VECTOR(4 downto 0);
    o_Sum : OUT STD_LOGIC_VECTOR(4 downto 0);
    o_CarryOut: OUT STD_LOGIC
  ) ;
end fourBitAdderSubtractor ;

architecture arch of fourBitAdderSubtractor is

begin



end architecture ; -- arch