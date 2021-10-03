--------------------------------------------------------------------------------
-- Title         : 8-bit 4x1 Multiplexer
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : eightBit4x1MUX.vhd
-------------------------------------------------------------------------------
-- Description : This file creates an 8-bit 4 to 1 multiplexer.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity eightBit4x1MUX is
  port (
    i_sel : IN STD_LOGIC_VECTOR(1 downto 0);
    i_D0, i_D1, i_D2, i_D3 : IN STD_LOGIC_VECTOR(7 downto 0);
    o_q : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end eightBit4x1MUX ;

architecture i_sel of eightBit4x1MUX is

    SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

begin
    WITH i_sel SELECT
        int_q <= i_D0 WHEN "00",
        	 i_D1 WHEN "01",
       		 i_D2 WHEN "10",
        	 i_D3 WHEN "11",
        	 "00000000" WHEN OTHERS;

    -- Output driver
    o_q <= int_q;

end architecture ; -- arch