library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity clkDivBy41 is
  port (
    i_clock_25MHz : IN STD_LOGIC;
    o_clock_614kHz : OUT STD_LOGIC
  ) ;
end clkDivBy41 ;

architecture arch of clkDivBy41 is
    SIGNAL int_clock : STD_LOGIC := '0';
    SIGNAL count : STD_LOGIC_VECTOR(5 downto 0) := "000000";

begin
    process
        begin 
            -- Divide by 41
            WAIT UNTIL i_clock_25MHz'EVENT and i_clock_25MHz = '1';
                IF count < 40 THEN 
                    count <= count + 1;
                ELSE 
                    count <= "000000"; 
                END IF;
                IF count < 20 THEN 
                    int_clock <= '0';
                ELSE 
                    int_clock <= '1';
                END IF;
    end process;
    o_clock_614kHz <= int_clock;

end architecture ; -- arch