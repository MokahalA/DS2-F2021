--------------------------------------------------------------------------------
-- Title         : 4-bit 2x1 Multiplexer
-- Project       : Fixed-Point Arithmetic Lab2
-------------------------------------------------------------------------------
-- File          : Mux2x1div.vhd
-------------------------------------------------------------------------------
-- Description : This file creates an 4-bit 2 to 1 multiplexer for the division
--               operation.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Mux2x1div is
  port (
    i_sel : IN STD_LOGIC;
    i_D0, i_D1 : IN STD_LOGIC_VECTOR(3 downto 0);
	
	
    o_q :  out STD_LOGIC_VECTOR(3 downto 0)
  ) ;
end Mux2x1div ;

architecture i_sel of Mux2x1div is

  SIGNAL int_q : STD_LOGIC_VECTOR(3 downto 0);

begin
    WITH i_sel SELECT
        int_q <= i_D0 WHEN '0',
        	 i_D1 WHEN '1';
 
        

    -- Output driver
    o_q <= int_q;

end architecture ; -- arch