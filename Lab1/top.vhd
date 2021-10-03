--------------------------------------------------------------------------------
-- Title         : Top Entity filefor Lab 1
-------------------------------------------------------------------------------
-- File          : top.vhd
-------------------------------------------------------------------------------
-- Description : This file creates the top entity file for lab1.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity top is
  port (
    i_rightSwitch, i_leftSwitch : IN STD_LOGIC;
    i_gclock, i_greset : IN STD_LOGIC;
    o_DisplayOut : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end top ;

architecture arch of top is

    SIGNAL int_loadLSR, int_loadRSR, int_resetDisplay : STD_LOGIC;
    SIGNAL int_state, int_d : STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL int_rmask, int_lmask, int_rmaskORlmask, int_muxOut, int_Display : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_switchSelect : STD_LOGIC_VECTOR(1 downto 0);

    COMPONENT datapath
        port (
            i_gresetBar      : IN	STD_LOGIC;
            i_gclock			: IN	STD_LOGIC;
            i_left, i_right : IN    STD_LOGIC;
            i_loadLSR, i_loadRSR : IN STD_LOGIC;
            o_Display		: OUT	STD_LOGIC_VECTOR(7 downto 0)
        ) ;
    END COMPONENT;

    COMPONENT controlpath
        port (
            i_gresetBar : IN STD_LOGIC;
            i_gclock : IN STD_LOGIC;
            i_left, i_right : IN STD_LOGIC;
            o_loadLSR, o_loadRSR, o_resetDisplay : OUT STD_LOGIC;
            o_State : OUT STD_LOGIC_VECTOR(4 downto 0)
        ) ;
    END COMPONENT;

    COMPONENT eightBit4x1MUX
        PORT(
            i_sel : IN STD_LOGIC_VECTOR(1 downto 0);
            i_D0, i_D1, i_D2, i_D3 : IN STD_LOGIC_VECTOR(7 downto 0);
            o_q : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT eightBitRShift
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC;
            o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT eightBitLShift
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC;
            o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT eightBitOR
        PORT(
            i_A, i_B : IN STD_LOGIC_VECTOR(7 downto 0);
            o_Z : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT muxSelect 
        PORT(
            i_A, i_B : IN STD_LOGIC;
            o_Z : OUT STD_LOGIC_VECTOR(1 downto 0)
        );
    END COMPONENT;

    COMPONENT eightBitRegister 
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT enARdFF_2
        PORT(
            i_resetBar	: IN	STD_LOGIC;
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC);
    END COMPONENT;  

begin

    int_d(0) <= '0';
    int_d(1) <= ((int_state(0) AND i_leftSwitch AND i_rightSwitch) OR (int_state(1) AND i_leftSwitch AND i_rightSwitch));
    int_d(2) <= ((int_state(0) AND i_leftSwitch) OR (int_state(2) AND i_leftSwitch));
    int_d(3) <= ((int_state(0) AND i_rightSwitch) OR (int_state(3) AND i_rightSwitch));
    int_d(4) <= ((int_state(1) OR int_state(2) OR int_state(3)) AND i_rightSwitch);

    int_loadLSR <= int_state(0);
    int_loadRSR <= int_state(0);

    int_loadLSR <= int_state(1);
    int_loadRSR <= int_state(1);

    int_loadLSR <= int_state(2);

    int_loadRSR <= int_state(3);

    dp : datapath port map(i_greset, i_gclock, i_leftSwitch, i_rightSwitch, int_loadLSR, int_loadRSR, int_Display);
    control : controlpath port map(i_greset, i_gclock, i_leftSwitch, i_rightSwitch, int_loadLSR, int_loadRSR, int_resetDisplay, int_state);
    state0: enardFF_2 port map(i_greset, int_d(0), '1', i_gclock, int_state(0));
    state1: enardFF_2 port map(i_greset, int_d(1), '1', i_gclock, int_state(1));
    state2: enardFF_2 port map(i_greset, int_d(2), '1', i_gclock, int_state(2));
    state3: enardFF_2 port map(i_greset, int_d(3), '1', i_gclock, int_state(3));
    state4: enardFF_2 port map(i_greset, int_d(4), '1', i_gclock, int_state(4));
    LMASK : eightBitLShift port map(i_greset, '1', i_gclock, '1', int_lmask);
    RMASK : eightBitRShift port map(i_greset, '1', i_gclock, '1', int_rmask);
    switchSelect : muxSelect port map (i_rightSwitch, i_leftSwitch, int_switchSelect);
    OR_Gate : eightBitOR port map (int_lmask, int_rmask, int_rmaskORlmask);
    Multiplexer : eightBit4x1MUX port map(int_switchSelect, "00000000", int_rmask, int_lmask, int_rmaskORlmask, int_muxOut); 
    Display : eightBitRegister port map(i_greset, '1', i_gclock, int_muxOut, int_Display);

    -- Output Driver
    o_DisplayOut <= int_muxOut;


end architecture ; -- arch