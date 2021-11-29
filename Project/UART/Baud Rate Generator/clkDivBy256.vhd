library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity clkDivBy256 is
  port (
    i_clk :  IN STD_LOGIC;
    o_divClk : OUT STD_LOGIC_VECTOR(7 downto 0) --Outputs 8 multiples of 2 (max of 256)
  ) ;
end clkDivBy256 ;

architecture arch of clkDivBy256 is
    SIGNAL int_divClk : STD_LOGIC_VECTOR(7 downto 0);

    COMPONENT clkDivBy2 IS
        port (
            i_clk : IN STD_LOGIC;
            o_clk : OUT STD_LOGIC
        ) ;
    END COMPONENT; 

begin
    
    clkDiv2: clkDivBy2 port map(i_clk, int_divClk(0)); 

    clkDiv4: clkDivBy2 port map(int_divClk(0), int_divClk(1));

    clkDiv8: clkDivBy2 port map(int_divClk(1), int_divClk(2));

    clkDiv16: clkDivBy2 port map(int_divClk(2), int_divClk(3));

    clkDiv32: clkDivBy2 port map(int_divClk(3), int_divClk(4));

    clkDiv64: clkDivBy2 port map(int_divClk(4), int_divClk(5));

    clkDiv128: clkDivBy2 port map(int_divClk(5), int_divClk(6));

    clkDiv256: clkDivBy2 port map(int_divClk(6), int_divClk(7));

    o_divClk <= int_divClk; --Output driver

end architecture ; -- arch