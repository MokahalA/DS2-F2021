--------------------------------------------------------------------------------
-- Title         : 8-bit Adder Subtractor
-------------------------------------------------------------------------------
-- File          : eightBitAddSub.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 8-bit adder subtractor circuit.
--                addSub = 0 for addition      addSub = 1 for subtraction

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity eightBitAddSub is
  port (
    addSub : IN STD_LOGIC;    -- add'Sub
    i_X, i_Y : IN STD_LOGIC_VECTOR(7 downto 0); -- 7-bits inputs
    o_Sum : OUT STD_LOGIC_VECTOR(7 downto 0); -- 7-bit sum output
    o_CarryOut: OUT STD_LOGIC  -- carry output
  ) ;
end eightBitAddSub ;

architecture arch of eightBitAddSub is
    SIGNAL int_Sum, int_CarryOut: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_Y : STD_LOGIC_VECTOR(7 downto 0);

    COMPONENT oneBitFullAdder
      port (
        i_A, i_B : IN STD_LOGIC;   -- 1-bit inputs
        i_carryIn : IN STD_LOGIC;  -- carry input
        o_S : OUT STD_LOGIC;        -- sum output
        o_carryOut: OUT STD_LOGIC   -- carry output
      ) ;
    END COMPONENT;

begin

    -- Signals 
    int_Y(7) <= i_Y(7) xor addSub;
    int_Y(6) <= i_Y(6) xor addSub;
    int_Y(6) <= i_Y(6) xor addSub;
    int_Y(5) <= i_Y(5) xor addSub;
    int_Y(4) <= i_Y(4) xor addSub;
    int_Y(3) <= i_Y(3) xor addSub;
    int_Y(2) <= i_Y(2) xor addSub;
    int_Y(1) <= i_Y(1) xor addSub;
    int_Y(0) <= i_Y(0) xor addSub;

    -- MSB is 7
    fa0: oneBitFullAdder port map(i_X(0), int_Y(0), addSub, int_Sum(0), int_CarryOut(0));
    fa1: oneBitFullAdder port map(i_X(1), int_Y(1), int_CarryOut(0), int_Sum(1), int_CarryOut(1));
    fa2: oneBitFullAdder port map(i_X(2), int_Y(2), int_CarryOut(1), int_Sum(2), int_CarryOut(2));
    fa3: oneBitFullAdder port map(i_X(3), int_Y(3), int_CarryOut(2), int_Sum(3), int_CarryOut(3));
    fa4: oneBitFullAdder port map(i_X(4), int_Y(4), int_CarryOut(3), int_Sum(4), int_CarryOut(4));
    fa5: oneBitFullAdder port map(i_X(5), int_Y(5), int_CarryOut(4), int_Sum(5), int_CarryOut(5));
    fa6: oneBitFullAdder port map(i_X(6), int_Y(6), int_CarryOut(5), int_Sum(6), int_CarryOut(6));
    fa7: oneBitFullAdder port map(i_X(7), int_Y(7), int_CarryOut(6), int_Sum(7), int_CarryOut(7));

    -- Output Driver
	o_Sum <= int_Sum;
	o_carryOut <= int_CarryOut(7);

end architecture ; -- arch