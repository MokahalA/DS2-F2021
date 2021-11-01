--------------------------------------------------------------------------------
-- Title         : Top Entity file for divider 
-------------------------------------------------------------------------------
-- File          : topdiv.vhd
-------------------------------------------------------------------------------
-- Description : This file creates the top entity file for the fixed-point divider
--               for lab2.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity topdiv is
  port (
    A,B : IN STD_LOGIC_VECTOR(3 downto 0);
    i_gclock, i_greset : IN STD_LOGIC;
    QQ,RR,AA,BB: OUT STD_LOGIC_VECTOR(3 downto 0)
  ) ;
end topdiv ;

architecture arch of topdiv is

  SIGNAL loadAdp,loadBdp,shiftAdp,loadRdp,shiftRdp,loadQdp,countdp ,wshift,countok,greteq : STD_LOGIC ;
	 
  COMPONENT dividerDP
    port (
      A ,B : IN STD_LOGIC_VECTOR(3 downto 0);
      loadA,loadB,shiftA,loadR,shiftR,loadQ,clk,resetbar,count: in std_LOGIC ;
      outQ, outR,outA,outB : OUT std_LOGIC_VECTOR(3 downto 0);
	    out_w,countdone,rsupb : out std_LOGIC
	  ) ;
  END COMPONENT;

  COMPONENT dividerCP
    port (
      i_gresetBar : IN STD_LOGIC;
      i_gclock  : IN STD_LOGIC;
      isdone,rsubegb : IN STD_LOGIC;
	    loadA,loadB,shiftA,loadR,shiftR,loadQ,count: OUT STD_LOGIC
    ) ;
  END COMPONENT;
	 
begin

  data: dividerDP port map (A,B,loadAdp,loadBdp,shiftAdp,loadRdp,shiftRdp,loadQdp,i_gclock,not(i_greset),countdp,QQ,RR,AA,BB,wshift,countok,greteq);
  control: dividerCP port map(not(i_greset),i_gclock,countok,greteq,loadAdp,loadBdp,shiftAdp,loadRdp,shiftRdp,loadQdp,countdp);

end architecture ; -- arch