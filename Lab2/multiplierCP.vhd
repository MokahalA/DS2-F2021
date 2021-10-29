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
    o_addSub, o_Psel : OUT STD_LOGIC;
    o_setDone, o_resetDoneBar : OUT STD_LOGIC;
    o_state : OUT STD_LOGIC_VECTOR(0 to 3)
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
  SIGNAL int_d, int_state : STD_LOGIC_VECTOR(0 to 3);


begin

  int_d(0) <= '0';
  int_d(1) <= not(i_BeqZero) and i_b0;
  int_d(2) <= int_state(1) or (not(i_BeqZero) and not(i_b0));
  int_d(3) <= i_BeqZero;


  -- flip flop instantiation -- 
  s0: enASdFF port map(i_resetBar, int_d(0), i_clock, '1', int_state(0));
  s1: enARdFF_2 port map(i_resetBar, int_d(1), '1', i_clock, int_state(1));
  s2: enARdFF_2 port map(i_resetBar, int_d(2), '1', i_clock, int_state(2));
  s3: enARdFF_2 port map(i_resetBar, int_d(3), '1', i_clock, int_state(3));

  -- output drivers -- 
  o_state <= int_state;

  o_resetDone <= int_state(0);
  o_loadA <= int_state(0);
  o_loadB <= int_state(0);
  o_Psel <= not(int_state(0));  --Psel0

  o_Psel <= int_state(1); --Psel1

  o_shiftA <= int_state(2);
  o_shiftB <= int_state(2);

  o_setDone <= int_state(3);

end architecture ; -- arch