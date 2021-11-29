----------------------------------------------------------------------------------------------
-- Title         : Baud Rate Generator top-level entity
-------------------------------------------------------------------------------
-- File          : BaudRateGenerator.vhd
-------------------------------------------------------------------------------
-- Description  : The baud rate generator is programmable by utilizing the three
--                control bits (SEL[2:0]) in SCCR.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity BaudRateGenerator is
	port(
			i_resetBar : IN	STD_LOGIC;
			i_clock	: IN	STD_LOGIC;
			i_SEL : IN	STD_LOGIC_VECTOR(2 downto 0);
			o_BClkx8 : OUT	STD_LOGIC;
			o_BClk : OUT STD_LOGIC
	);
end BaudRateGenerator;


architecture arch of BaudRateGenerator is

	SIGNAL int_out41, int_outMux : STD_LOGIC;
	SIGNAL int_out256, int_out8: STD_LOGIC_VECTOR(7 downto 0);


    component clkDivBy8
		port(
		i_clock : IN STD_LOGIC;
		o_clock	: OUT STD_LOGIC
		);
	end component;

    component clkDivBy41
		port(
		i_clock_25Mhz : IN	STD_LOGIC;
		o_clock_614KHz : OUT STD_LOGIC
		);
	end component;
	
    component clkDivBy256
		port(
		i_clk : IN STD_LOGIC;
		o_divClk : OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

	component MuxBRG
		port (
            i_sel : IN STD_LOGIC_VECTOR(2 downto 0);
            i_d : IN STD_LOGIC_VECTOR(7 downto 0);
            o_q : OUT STD_LOGIC 
		);
	end component;
	
begin

    DivideBy41 : clkDivBy41 port map (i_clock , int_out41);

    DivideBy256 : clkDivBy256 port map (int_out41 , int_out256);

    MUX : MuxBRG port map (i_SEL , int_out256 , int_outMux);

    DivideBy8: clkDivBy8 port map ( int_outMux , int_out8 );

    -- Output driver
    o_BClkx8 <= int_outMux;
    o_BClk <= int_out8;


end architecture ; -- arch