library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity clkDivBy2 is
  port (
    i_clk : IN STD_LOGIC;
    o_clk : OUT STD_LOGIC
  ) ;
end clkDivBy2 ;

architecture arch of clkDivBy2 is
    SIGNAL int_clk : STD_LOGIC := '0';
begin
    -- To divide by 2
    process
        begin 
            WAIT UNTIL i_clk'EVENT and i_clk = '1'; --rising edge
                int_clk <= not(int_clk);
        end process;
        
    o_clk <= int_clk;
end architecture ; -- arch