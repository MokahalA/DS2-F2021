--------------------------------------------------------------------------------
-- Title         : 4-bit Adder Subtractor
-------------------------------------------------------------------------------
-- File          : fourBitAddSub.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 4-bit adder subtractor circuit.
--                addSub = 0 for addition      addSub = 1 for subtraction

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fourBitAddSub is
  port (
    addSub : IN STD_LOGIC;    -- add'Sub
    i_X, i_Y : IN STD_LOGIC_VECTOR(3 downto 0); -- 4-bits inputs
    o_Sum : OUT STD_LOGIC_VECTOR(3 downto 0); -- 4-bit sum output
    o_CarryOut: OUT STD_LOGIC  -- carry output
  ) ;
end fourBitAddSub ;

architecture arch of fourBitAddSub is
    SIGNAL int_Sum, int_CarryOut : STD_LOGIC_VECTOR(3 downto 0);

    COMPONENT oneBitFullAddSub
    port (
        addSub : IN STD_LOGIC; -- add'Sub
        i_A, i_B : IN STD_LOGIC;   -- 1-bit inputs
        i_carryIn : IN STD_LOGIC;  -- carry input
        o_S : OUT STD_LOGIC;        -- sum output
        o_carryOut: OUT STD_LOGIC   -- carry output
    ) ;
    END COMPONENT;

begin

    -- MSB is 3
    add0: oneBitFullAddSub port map(addSub, i_X(0), i_Y(0), addSub , int_Sum(0), int_CarryOut(0));
    add1: oneBitFullAddSub port map(addSub, i_X(1), i_Y(1), int_CarryOut(0), int_Sum(1), int_CarryOut(1));
    add2: oneBitFullAddSub port map(addSub, i_X(2), i_Y(2), int_CarryOut(1), int_Sum(2), int_CarryOut(2));
    add3: oneBitFullAddSub port map(addSub, i_X(3), i_Y(3), int_CarryOut(2), int_Sum(3), int_CarryOut(3));

    -- Output Driver
	o_Sum <= int_Sum;
	o_carryOut <= int_CarryOut(3);

end architecture ; -- arch