-----------------------------------------------------------------------------------
-- Title         : Multilplier Controlpath
-----------------------------------------------------------------------------------
-- File          : multiplierCP.vhd
-----------------------------------------------------------------------------------
-- Description : This file creates the control path for the Multiplier circuit.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity multiplierCP is
  port (
    i_resetBar, i_clock : IN STD_LOGIC;
    i_BeqZero, i_b0, i_DONE : IN STD_LOGIC;
    o_loadA, o_shiftA : OUT STD_LOGIC;
    o_loadB, o_shiftB : OUT STD_LOGIC;
    o_loadP : OUT STD_LOGIC;
    o_addSub, o_Psel : OUT STD_LOGIC;
    o_setDone, o_resetDoneBar : OUT STD_LOGIC;
    o_state : OUT STD_LOGIC_VECTOR(0 to 5)
  ) ;
end multiplierCP ;

architecture arch of multiplierCP is

  -- components --
  COMPONENT enASdFF
    PORT (
      i_resetBar : IN STD_LOGIC;
      i_d	: IN STD_LOGIC;
      i_clock : IN STD_LOGIC;
      i_enable : IN STD_LOGIC; 
      o_q, o_qBar : OUT STD_LOGIC); 
  END COMPONENT;

  COMPONENT enARdFF_2
    PORT (
      i_resetBar	: IN	STD_LOGIC;
      i_d		: IN	STD_LOGIC;
      i_enable	: IN	STD_LOGIC;
      i_clock		: IN	STD_LOGIC;
      o_q, o_qBar	: OUT	STD_LOGIC);
  END COMPONENT;

  -- signals --
  SIGNAL int_d, int_state : STD_LOGIC_VECTOR(0 to 5);


begin

  int_d(0) <= '0';
  int_d(1) <= int_state(0);
  int_d(2) <= (int_state(1) and not(i_BeqZero) and i_b0); 
  int_d(3) <= (int_state(2) or (int_state(1) and not(i_BeqZero) and not(i_b0)));
  int_d(4) <= int_state(3);
  int_d(5) <= i_BeqZero;


  -- flip flop instantiation -- 
  s0: enASdFF port map(i_resetBar, int_d(0), i_clock, '1', int_state(0));
  s1: enARdFF_2 port map(i_resetBar, int_d(1), '1', i_clock, int_state(1));
  s2: enARdFF_2 port map(i_resetBar, int_d(2), '1', i_clock, int_state(2));
  s3: enARdFF_2 port map(i_resetBar, int_d(3), '1', i_clock, int_state(3));
  s4: enARdFF_2 port map(i_resetBar, int_d(4), '1', i_clock, int_state(4));
  s5: enARdFF_2 port map(i_resetBar, int_d(5), '1', i_clock, int_state(5));

  -- output drivers -- 

  o_loadB <= int_state(0);

  o_resetDoneBar <= int_state(1);
  o_loadA <= int_state(1);

  o_Psel <= int_state(2);
  o_loadP <= int_state(2);

  o_shiftA <= int_state(3);

  o_shiftB <= int_state(4);

  o_setDone <= int_state(5);

  o_state <= int_state;

end architecture ; -- arch