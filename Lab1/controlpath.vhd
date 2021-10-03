--------------------------------------------------------------------------------
-- Title         : Control Path for Lab 1
-------------------------------------------------------------------------------
-- File          : controlpath.vhd
-------------------------------------------------------------------------------
-- Description : This file creates the control path for lab 1.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
entity controlpath is
  port (
    i_gresetBar : IN STD_LOGIC;
    i_gclock : IN STD_LOGIC;
    i_left, i_right : IN STD_LOGIC;
    o_loadLSR, o_loadRSR, o_resetDisplay : OUT STD_LOGIC;
    o_State : OUT STD_LOGIC_VECTOR(4 downto 0)
  ) ;
end controlpath ;

architecture arch of controlpath is
    SIGNAL int_state, int_d : STD_LOGIC_VECTOR(4 downto 0);

    COMPONENT enardFF_2 
        PORT(
            i_resetBar	: IN	STD_LOGIC;
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC
        );
    END COMPONENT;

begin

    int_d(0) <= '0';
    int_d(1) <= ((int_state(0) AND i_left AND i_right) OR (int_state(1) AND i_left AND i_right));
    int_d(2) <= ((int_state(0) AND i_left) OR (int_state(2) AND i_left));
    int_d(3) <= ((int_state(0) AND i_right) OR (int_state(3) AND i_right));
    int_d(4) <= ((int_state(1) OR int_state(2) OR int_state(3)) AND i_right);

    state0: enardFF_2 port map(i_gresetBar, int_d(0), '1', i_gclock, int_State(0));
    state1: enardFF_2 port map(i_gresetBar, int_d(1), '1', i_gclock, int_State(1));
    state2: enardFF_2 port map(i_gresetBar, int_d(2), '1', i_gclock, int_State(2));
    state3: enardFF_2 port map(i_gresetBar, int_d(3), '1', i_gclock, int_State(3));
    state4: enardFF_2 port map(i_gresetBar, int_d(4), '1', i_gclock, int_State(4));

    -- Output Drivers
    o_State <= int_state;

    o_loadLSR <= int_state(0);
    o_loadRSR <= int_state(0);

    o_loadLSR <= int_state(1);
    o_loadRSR <= int_state(1);

    o_loadLSR <= int_state(2);

    o_loadRSR <= int_state(3);

    o_resetDisplay <= int_state(4);

end architecture ; -- arch