-------------------------------------------------------------------------------
-- File          : fsmController.vhd
-------------------------------------------------------------------------------
-- Description : This file creates the FSM Controller component, which is the 
--                "Kernel" of the system, and drives all the system outputs, 
--                after making decisions depending on the system inputs.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fsmController is
  port (
    i_clk, i_reset : IN STD_LOGIC; -- Reset on '1'
    i_SSCS : IN STD_LOGIC;  -- Debounced Car Sensor Bit
    i_TimerExpired : IN STD_LOGIC; -- Timers (MST and SST)
    o_MSTL, o_SSTL : OUT STD_LOGIC_VECTOR(2 downto 0); -- LED Control Bits
    o_sel1, o_sel0 : OUT STD_LOGIC -- Current State
  ) ;
end fsmController ;

architecture arch of fsmController is

    SIGNAL int_D1, int_D0 : STD_LOGIC; -- Next State 
    SIGNAL int_Y1, int_notY1, int_Y0, int_notY0 : STD_LOGIC; -- Present state

    COMPONENT enasdFF_2 
    PORT(
        i_resetBar  : IN  STD_LOGIC;
        i_d   : IN  STD_LOGIC;
        i_enable  : IN  STD_LOGIC;
        i_clock   : IN  STD_LOGIC;
        o_q, o_qBar : OUT STD_LOGIC
    );
    END COMPONENT;

begin

    dFF1: enasdFF_2 port map(i_reset, int_D1, '1', i_clk, int_Y1, int_notY1);
    dFF0: enasdFF_2 port map(i_reset, int_D0, '1', i_clk, int_Y0, int_notY0);

    int_D1 <= ((int_Y1 and not(i_SSCS) and not(i_TimerExpired)) or (int_notY1 and int_Y0 and i_TimerExpired) or (int_Y1 and int_notY0 and i_TimerExpired) or (int_Y1 and int_Y0 and not (i_TimerExpired))); 
    int_D0 <= ((int_Y0 and not(i_TimerExpired)) or (int_Y1 and int_notY0 and i_TimerExpired) or (int_Y1 and int_notY0 and i_SSCS) or (int_notY0 and i_SSCS and i_TimerExpired));

    o_MSTL(2) <= (((int_Y1 and int_notY0) or (int_notY1 and int_Y0 and i_TimerExpired) or (int_Y1 and not(i_TimerExpired))));
    o_MSTL(1) <= ((int_notY1 and int_Y0 and not(i_TimerExpired)) or (int_notY1 and int_notY0 and i_SSCS and i_TimerExpired));
    o_MSTL(0) <= ((int_notY1 and int_notY0 and not(i_TimerExpired)) or (int_notY1 and int_notY0 and not(i_SSCS)) or (int_Y1 and int_Y0 and i_TimerExpired));
  
    o_SSTL(2) <= ((int_notY1 and int_notY0) or (int_notY1 and not(i_TimerExpired)) or (int_Y1 and int_Y0 and i_TimerExpired));
    o_SSTL(1) <= ((int_Y1 and int_Y0 and not(i_TimerExpired)) or (int_Y1 and int_notY0 and i_TimerExpired));
    o_SSTL(0) <= ((int_notY1 and int_Y0 and i_TimerExpired) or (int_Y1 and int_notY0 and not(i_TimerExpired)));

    o_sel1 <= int_Y1;
    o_sel0 <= int_Y0;


end architecture ; -- arch