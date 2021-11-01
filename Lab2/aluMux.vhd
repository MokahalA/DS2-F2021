LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity aluMux is
  port (
    opSel : IN STD_LOGIC_VECTOR(1 downto 0);
    D0, D1, D2, D3 : IN STD_LOGIC_VECTOR(7 downto 0);
    o_z : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end aluMux ;

architecture arch of aluMux is

    SIGNAL int_z : STD_LOGIC_VECTOR(7 downto 0); 

begin

    WITH opSel SELECT
        int_z <= D0 WHEN "00",  
                D1 WHEN "01", 
                D2 WHEN "10",
                D3 WHEN "11",
                "00000000" WHEN OTHERS;
            
    -- Output driver
    o_z <= int_z;



end architecture ; -- arch