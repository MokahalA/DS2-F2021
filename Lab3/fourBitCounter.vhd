--------------------------------------------------------------------------------
--	File name: fourBitCounter
--	
--	Description: This file creates a 4-bit counter.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fourBitCounter is
	port(	clk, load: in std_logic;
			reset : in std_logic;
			q : out std_logic_vector(3 downto 0));
end fourBitCounter;

architecture arch of fourBitCounter is 

    COMPONENT enasdFF_2 
    PORT(
        i_resetBar  : IN  STD_LOGIC;
        i_d   : IN  STD_LOGIC;
        i_enable  : IN  STD_LOGIC;
        i_clock   : IN  STD_LOGIC;
        o_q, o_qBar : OUT STD_LOGIC
    );
    END COMPONENT;
	
	signal int_d, int_q, int_notq: std_logic_vector(3 downto 0);

begin
	df0: enasdFF_2 port map(reset, int_d(0), load, clk, int_q(0), int_notq(0));
	df1: enasdFF_2 port map(reset, int_d(1), load, clk, int_q(1), int_notq(1));
	df2: enasdFF_2 port map(reset, int_d(2), load, clk, int_q(2), int_notq(2));
	df3: enasdFF_2 port map(reset, int_d(3), load, clk, int_q(3), int_notq(3));
	
	int_d(0)<= (int_notq(0));
	q(0)<= int_q(0) ;
	int_d(1)<= (int_q(0) xor int_q(1));
	q(1)<= int_q(1);
	int_d(2)<= ((int_q(0) and int_q(1)) xor int_q(2));
	q(2)<= int_q(2);
	int_d(3)<= ((int_q(0) and int_q(1) and int_q(2)) xor int_q(3));
	q(3)<= int_q(3);

end arch;