--------------------------------------------------------------------------------
-- Title         : 4-bit Full Adder
-------------------------------------------------------------------------------
-- File          : fourBitFullAdder.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 4-bit full adder circuit

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fourBitFullAdder is
  port (
    i_A, i_B : IN STD_LOGIC_VECTOR(3 downto 0);   -- 4-bit inputs
    o_Sum : OUT STD_LOGIC_VECTOR(3 downto 0);       -- 4-bit sum output
    o_carryOut: OUT STD_LOGIC   -- carry output
  ) ;
end fourBitFullAdder ;

architecture arch of fourBitFullAdder is
    SIGNAL int_Sum, int_CarryOut : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL gnd : STD_LOGIC;

	COMPONENT oneBitFullAdder
        port (
            i_A, i_B : IN STD_LOGIC;   -- 1-bit inputs
            i_carryIn : IN STD_LOGIC;  -- carry input
            o_S : OUT STD_LOGIC;        -- sum output
            o_carryOut: OUT STD_LOGIC   -- carry output
        ) ;
	END COMPONENT;

begin
    -- Concurrent Signal Assignment
	gnd <= '0';

    -- MSB is 3
    add0: oneBitFullAdder port map(i_A(0), i_B(0), gnd, int_Sum(0), int_CarryOut(0));
    add1: oneBitFullAdder port map(i_A(1), i_B(1), int_CarryOut(0), int_Sum(1), int_CarryOut(1));
    add2: oneBitFullAdder port map(i_A(2), i_B(2), int_CarryOut(1), int_Sum(2), int_CarryOut(2));
    add3: oneBitFullAdder port map(i_A(3), i_B(3), int_CarryOut(2), int_Sum(3), int_CarryOut(3));

    -- Output Driver
	o_Sum <= int_Sum;
	o_carryOut <= int_CarryOut(3);

end architecture ; -- arch