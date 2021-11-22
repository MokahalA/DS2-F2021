-------------------------------------------------------------------------------
-- File          : lab3Top
-------------------------------------------------------------------------------
-- Description : This file creates the Top-level entity for the
--				 Traffic Light Controller system, it outputs to 2 sets of 
-- 				 LEDs and a BCD 7-segment display (to track the system timer)
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity lab3Top is 
	port(
		GClock, GReset, SSCS : IN STD_LOGIC;
		MSC, SSC : IN STD_LOGIC_VECTOR(3 downto 0);
		timer : OUT STD_LOGIC_VECTOR(6 downto 0);
		timerDec : OUT STD_LOGIC_VECTOR(6 downto 0);
		MSTL, SSTL : OUT STD_LOGIC_VECTOR(2 downto 0);
		State : OUT STD_LOGIC_VECTOR(1 downto 0) -- State information output
	);
end lab3Top;

architecture arch of lab3Top is 

	component clk_div2 is
		port(clock	: IN STD_LOGIC;	
			clock_1s : OUT	STD_LOGIC);
	end component clk_div2;	

	component debouncer is
		PORT(
			i_raw			: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			o_clean			: OUT	STD_LOGIC);
	end component debouncer;

	component Datapath is
		port (
			clk, gReset : IN STD_LOGIC;
			sel0, sel1 : IN STD_LOGIC;
			i_SSCS : IN STD_LOGIC;
			mscMax, sscMax : IN STD_LOGIC_VECTOR(3 downto 0); --Programmable counters
			o_timerOut : OUT STD_LOGIC_VECTOR(3 downto 0);
			o_TimerExpired : OUT STD_LOGIC
		);
	end component Datapath;

	component fsmController is
		  port (
		    i_clk, i_reset : IN STD_LOGIC; -- Reset on '1'
		    i_SSCS : IN STD_LOGIC;  -- Debounced Car Sensor Bit
		    i_TimerExpired : IN STD_LOGIC; -- Timers (MST and SST)
		    o_MSTL, o_SSTL : OUT STD_LOGIC_VECTOR(2 downto 0); -- LED Control Bits
		    o_sel1, o_sel0 : OUT STD_LOGIC -- Current State
		  ) ;
	end component fsmController;

	component bcd7Seg 
		port(	
				timer : in std_logic_vector(3 downto 0);
				decout: out  std_logic_vector(6 downto 0 );
				bcdout : out std_logic_vector(6 downto 0 ));
	end component;


	signal int_TimerExpired, int_clkdivsec, int_dSCSS, int_ez : STD_LOGIC;
	signal int_sel : STD_LOGIC_VECTOR(1 downto 0);
	signal int_timertoseg : std_logic_vector(3 downto 0);
	signal int_MSTL, int_SSTL : STD_LOGIC(2 downto 0);

begin 

	int_clkdivsec <= int_ez;
	--State <= int_sel; --State information being output for the UART FSM
	State(0) <=  ( not(int_MSTL(2)) and not(int_MSTL(0)) and int_MSTL(1) and int_SSTL(2) and not(int_SSTL(1)) and not(int_SSTL(0)) ) or ( not(int_MSTL(1)) and not(int_MSTL(0)) and not(int_SSTL(2)) and int_MSTL(2) and int_SSTL(1) );
	State(1) <= ( int_MSTL(2) and not(int_MSTL(1)) and not(int_MSTL(0)) and not(int_SSTL(2)) and not(int_SSTL(1)) and int_SSTL(0)   ) or ( int_MSTL(2)  not(int_MSTL(1)) and not(int_MSTL(0)) and not(int_SSTL(2)) and int_SSTL(1) and not(int_SSTL(0)));

	seg7 : bcd7Seg port map (timer=>int_timertoseg,bcdout=>timer, decout=>timerDec);
	clkdivider: clk_div2 port map(GClock, int_ez);
	deb: debouncer port map(SSCS, int_clkdivsec, int_dSCSS);
	dp : Datapath port map(int_clkdivsec, GReset, int_sel(0), int_sel(1), int_dSCSS, MSC, SSC, int_timertoseg, int_TimerExpired);
	ctrl: fsmController port map(int_clkdivsec, GReset, int_dSCSS, int_TimerExpired, int_MSTL, int_SSTL, int_sel(1), int_sel(0));

	MSTL <= int_MSTL;
	SSTL <= int_SSTL;
	
end arch;