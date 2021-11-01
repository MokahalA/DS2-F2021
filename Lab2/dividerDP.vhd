-----------------------------------------------------------------------------------
-- Title         : Divider Datapath
-----------------------------------------------------------------------------------
-- File          : dividerDP.vhd
-----------------------------------------------------------------------------------
-- Description : This file creates the datapath for the Divider circuit.
-----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity dividerDP is
	port (
		A ,B : IN STD_LOGIC_VECTOR(3 downto 0);
		loadA,loadB,shiftA,loadR,shiftR,loadQ,clk,resetbar,count: in std_LOGIC ;
		outQ, outR,outA,outB : OUT std_LOGIC_VECTOR(3 downto 0);
		out_w,countdone,rsupb : out std_LOGIC
	) ;
end dividerDP ;

architecture arch of dividerDP is

	COMPONENT RegAdiv is 
		PORT(
		i_resetBar, i_load, i_shift	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0);
		w : OUT STD_LOGIC );
				
	end component;
		
	COMPONENT regRdiv is 
		PORT(
		i_resetBar, i_load, i_shift	: IN	STD_LOGIC;
		i_clock,w			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0));
	end Component;
			
	COMPONENT  fourBitRegisterdiv
		PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0));
	end component;

	COMPONENT fourBitAddSub 
		port (
		sub : IN STD_LOGIC;   
		i_X, i_Y : IN STD_LOGIC_VECTOR(3 downto 0); 
		o_Som : OUT STD_LOGIC_VECTOR(3 downto 0); 
		o_CarOut: OUT STD_LOGIC  
		) ;
	end component ;

	COMPONENT Mux2x1div
		port (
		i_sel : IN STD_LOGIC;
		i_D0, i_D1 : IN STD_LOGIC_VECTOR(3 downto 0);
		o_q :  out STD_LOGIC_VECTOR(3 downto 0)
		) ;
	end component ;

	COMPONENT counterdiv
		PORT(
			i_rstBar, i_inc	: IN	STD_LOGIC;
			i_clk			: IN	STD_LOGIC;
			isdone			: Out	STD_LOGIC
		);
	END COMPONENT;

	COMPONENT threeBitComparatordiv
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(3 downto 0);
			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
	END component;

	COMPONENT regQdiv
		PORT(
			i_resetBar, i_shift	: IN	STD_LOGIC;
			i_clock,w			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0)
				);
	END component;

	signal wator , sup,inf,eg : std_LOGIC;
	signal muxtoR , RtoAddi,BtoAddi,AdditoMuxR,btomux :std_LOGIC_VECTOR(3 downto 0 );
	

	begin   
	
	rA : regAdiv port map(resetbar,loadA,shiftA,clk,A,outA,wator);
	rR : regRdiv port map(resetbar,loadR,shiftR,clk,wator,muxtoR,RtoAddi);
	rB : fourBitRegisterdiv port map(resetbar,loadB,clk,B,btomux);
	rQ : regQdiv port map( resetbar,loadQ,clk,not(inf),"0000",outQ);
	substra : fourBitAddSub port map('1',RtoAddi,btomux,muxtoR);
	compteur4: counterdiv port map (resetbar,count,clk,countdone);
	comparateur : threeBitComparatordiv port map(RtoAddi,btomux,sup,inf,eg);
	
	out_w<=wator;
	outR<=RtoAddi;
	outB<=btomux;
	rsupb<=sup or eg;
	 
end architecture ; -- arch