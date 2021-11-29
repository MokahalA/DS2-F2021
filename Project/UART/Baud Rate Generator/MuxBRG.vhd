-------------------------------------------------------------------------------
-- File          : MuxBRG.vhd
-------------------------------------------------------------------------------
-- Description : This file creates a 8 to 1 multiplexer.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity MuxBRG is
  port (
    i_sel : IN STD_LOGIC_VECTOR(2 downto 0);
    i_d : IN STD_LOGIC_VECTOR(7 downto 0);
    o_q : OUT STD_LOGIC 
  ) ;
end MuxBRG ;

architecture i_sel of MuxBRG is

    SIGNAL int_q : STD_LOGIC ;

begin
    WITH i_sel SELECT
        int_q <= i_d(0) WHEN "000",
                 i_d(1) WHEN "001",
                 i_d(2) WHEN "010",
                 i_d(3) WHEN "011",
                 i_d(4) WHEN "100",
                 i_d(5) WHEN "101",
                 i_d(6) WHEN "110",
                 i_d(7) WHEN "111",
        	     '0' WHEN OTHERS;

    -- Output driver
    o_q <= int_q;

end architecture ; -- arch