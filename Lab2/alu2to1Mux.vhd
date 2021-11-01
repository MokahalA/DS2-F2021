LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity alu2to1Mux is
  port (
    sel: IN STD_LOGIC;
    D0, D1 : IN STD_LOGIC_VECTOR(3 downto 0);
    o_q : OUT STD_LOGIC_VECTOR(3 downto 0)
  ) ;
end alu2to1Mux ;

architecture arch of alu2to1Mux is

    COMPONENT fourBitFullAdder
        port (
            i_A, i_B : IN STD_LOGIC_VECTOR(3 downto 0);   -- 4-bit inputs
            i_CarryIn : IN STD_LOGIC;
            o_Sum : OUT STD_LOGIC_VECTOR(3 downto 0);       -- 4-bit sum output
            o_carryOut: OUT STD_LOGIC   -- carry output
        ) ;
    END COMPONENT;

    signal int_q, int_qComplement : STD_LOGIC_VECTOR(3 downto 0);

begin

    adder: fourBitFullAdder port map(not(D0), "0001", '0', int_qComplement);

    WITH opSel SELECT
            int_q <= int_qComplement WHEN '0',  --msb is negative
             D1 WHEN '1',  --msb is positive
            "0000" WHEN OTHERS;

    o_q <= int_q;

end architecture ; -- arch