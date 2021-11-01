-----------------------------------------------------------------------------------
-- Title         : Divider Controlpath
-----------------------------------------------------------------------------------
-- File          : dividerCP.vhd
-----------------------------------------------------------------------------------
-- Description : This file creates the control path for the divider circuit.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity dividerCP is
  port (
    i_gresetBar : IN STD_LOGIC;
    i_gclock  : IN STD_LOGIC;
    isdone,rsubegb : IN STD_LOGIC;
    loadA,loadB,shiftA,loadR,shiftR,loadQ,count: OUT STD_LOGIC
  ) ;
end dividerCP ;

architecture arch of dividerCP is
  SIGNAL int_state, int_d : STD_LOGIC_VECTOR(6 downto 0);

  COMPONENT enardFF_2
    PORT(
      i_resetBar	: IN	STD_LOGIC;
      i_d		: IN	STD_LOGIC;
      i_enable	: IN	STD_LOGIC;
      i_clock		: IN	STD_LOGIC;
      o_q, o_qBar	: OUT	STD_LOGIC
    );

  END COMPONENT;

  component enasdFF
    PORT(
      i_resetBar	: IN	STD_LOGIC;
      i_d		: IN	STD_LOGIC;
      i_enable	: IN	STD_LOGIC;
      i_clock		: IN	STD_LOGIC;
      o_q, o_qBar	: OUT	STD_LOGIC);
  END component;

begin



  int_d(0) <= '0';
  int_d(1) <= (not(isdone) AND (int_state(0) or int_state(3) or int_state(4)));
  int_d(2) <= ( int_state(1));
  int_d(3) <= (rsubegb AND int_State(6));
  int_d(4) <= (not(rsubegb) AND int_State(6)); 
  int_d(5) <= (isdone AND (int_state(0) or int_state(3) or int_state(4)));
  int_d(6) <=  (int_State(2));


  state0: enasdFF port map(i_gresetBar,int_d(0), '1', i_gclock, int_State(0));
  state1: enardFF_2 port map(i_gresetBar, int_d(1), '1', i_gclock, int_State(1));
  state2: enardFF_2 port map(i_gresetBar, int_d(2), '1', i_gclock, int_State(2));
  state3: enardFF_2 port map(i_gresetBar, int_d(3), '1', i_gclock, int_State(3));
  state4: enardFF_2 port map(i_gresetBar, int_d(4), '1', i_gclock, int_State(4));
  state5: enardFF_2 port map(i_gresetBar, int_d(5), '1', i_gclock, int_State(5));
  state6: enardFF_2 port map(i_gresetBar, int_d(6), '1', i_gclock, int_State(6));

  -- Output Drivers
	 
  loadA<= int_state(0);
  loadB<= int_state(0);
  count <=int_State(6);
  shiftA <=int_State(1);
  shiftR <= int_State(2);
  loadR <= int_State(3);
  loadQ<=int_State(3) or int_State(4);

end architecture ; -- arch