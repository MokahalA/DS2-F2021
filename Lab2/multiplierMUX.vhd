--------------------------------------------------------------------------------
-- Title         : 8-bit 2 to 1 Multiplexer
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : multiplierMUX.vhd
-------------------------------------------------------------------------------
-- Description : This file creates an 8-bit 2-to-1 multiplexer used 
--                for the Multiplier circuit
--
-- Selects:     Psel = 0 is Psel0 (sends 00000000)
--              Psel = 1 is Psel1 (sends output of eightBitAddSub)
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity multiplierMUX is
  port (
    i_D0, i_D1 : IN STD_LOGIC_VECTOR(7 downto 0);
    Psel : IN STD_LOGIC; 
    o_q : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end multiplierMUX ;

architecture arch of multiplierMUX is

    SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

begin

    WITH Psel SELECT
        int_q <= i_D0 WHEN '0',  
                 i_D1 WHEN '1',   --this one for eightBitAddSub--
                "00000000" WHEN OTHERS;
            
    -- Output driver
    o_q <= int_q;

end architecture ; -- arch