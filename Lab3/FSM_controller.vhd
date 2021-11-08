--------------------------------------------------------------------------------
-- Title         : FSM Controller
-------------------------------------------------------------------------------
-- File          : FSM_controller.vhd
-------------------------------------------------------------------------------
-- Description : This file creates the FSM Controller component, which is the 
--                "Kernel" of the system, and drives all the system outputs, 
--                after making decisions depending on the system inputs.

--TODO: add the other inputs and outputs 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
entity FSM_controller is
  port (
    i_gresetBar : IN STD_LOGIC;
    i_gclock : IN STD_LOGIC;
    i_SSCS : IN STD_LOGIC;
    o_MSTL, o_SSTL : OUT STD_LOGIC_VECTOR(2 downto 0)
  ) ;
end FSM_controller ;

architecture arch of FSM_controller is
    SIGNAL int_y, int_Y, int_YBar: STD_LOGIC_VECTOR(1 downto 0);

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

  --See Circuit implementation in the report
  int_y(1) <= (int_YBar(1) AND int_Y(0)) OR (int_Y(1) AND int_YBar(0));
  int_y(0) <= (int_Y(1) AND int_YBar(0)) OR (i_SSCS AND int_YBar(0));

  D1: enardFF_2 port map(i_gresetBar, int_y(1), '1', i_gclock, int_Y(1),int_YBar(1));
  D0: enardFF_2 port map(i_gresetBar, int_y(0), '1', i_gclock, int_Y(0),int_YBar(0));

  -- Output Drivers
  o_MSTL(2) <= int_Y(1);
  o_MSTL(1) <= int_YBar(1) AND int_Y(0);
  o_MSTL(0) <= int_YBar(1) AND int_YBar(0);

  o_SSTL(2) <= int_YBar(1); 
  o_SSTL(1) <= int_Y(1) AND int_Y(0);
  o_SSTL(0) <= int_Y(1) AND int_YBar(0);

end architecture ; -- arch