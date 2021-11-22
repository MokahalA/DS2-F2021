--------------------------------------------------------------------------------
--	File name: Datapath
--	
--	Description: This creates the Datapath file which regulates 
-- 				 the inputs & outputs to and from the FSM controller
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Datapath is
	port (
		clk, gReset : IN STD_LOGIC;
		sel0, sel1 : IN STD_LOGIC;
		i_SSCS : IN STD_LOGIC;
		mscMax, sscMax : IN STD_LOGIC_VECTOR(3 downto 0); --Programmable counters
		o_timerOut : OUT STD_LOGIC_VECTOR(3 downto 0);
		o_TimerExpired : OUT STD_LOGIC
	);
end Datapath;

architecture arch of Datapath is

	component fourBitCounter is
		port(	clk, load: in std_logic;
				reset : in std_logic;
				q : out std_logic_vector(3 downto 0));
	end component fourBitCounter;

	component fourBitComparator is
		port(	A, B : in std_logic_vector(3 downto 0);
				S : out std_logic);
	end component fourBitComparator;

	component Mux4to1 is
		port(	sel0, sel1 : IN STD_LOGIC;
				D3, D2, D1, D0 : IN STD_LOGIC;
				S : OUT STD_LOGIC);
	end component Mux4to1;

	component resetComp is
		port(	clk, TimerExpired: in std_logic;
				reset : out std_logic );
	end component resetComp;


	signal int_reset : STD_LOGIC; 
	signal int_q : STD_LOGIC_VECTOR(3 downto 0);
	signal int_MSC, int_SSC, int_MST, int_SST : STD_LOGIC;
	constant mstValue : STD_LOGIC_VECTOR(3 downto 0) := "0010"; --Preset delay of ~2 seconds
	constant sstValue : STD_LOGIC_VECTOR(3 downto 0) := "0010"; --Preset delay of ~2 seconds
	signal int_resetOut, int_R, int_T, int_notT : STD_LOGIC; 


begin

	int_reset <= (not(sel0) and not(sel1) and int_T and i_SSCS) or (not( not(sel0) and not(sel1)) and int_T );
	int_resetOut <= int_R or gReset;
	int_notT <= not(int_T);

	rst: resetComp port map (clk, int_reset, int_R);
	cnt: fourBitCounter port map (clk, int_notT, int_resetOut, int_q);
	compMSC: fourBitComparator port map (int_q, mscMax, int_MSC);
	compSSC: fourBitComparator port map (int_q, sscMax, int_SSC);
	compMST: fourBitComparator port map (int_q, mstValue, int_MST);
	compSST: fourBitComparator port map (int_q, sstValue, int_SST);
 	muxDP: Mux4to1 port map (sel0, sel1, int_SST, int_SSC, int_MST, int_MSC, int_T);

 	o_TimerExpired <= int_T;
 	o_timerOut <= int_q;

	
end arch;