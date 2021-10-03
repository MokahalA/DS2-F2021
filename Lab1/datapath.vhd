--------------------------------------------------------------------------------
-- Title         : Datapath for Lab 1
-------------------------------------------------------------------------------
-- File          : datapath.vhd
-------------------------------------------------------------------------------
-- Description : This file creates the datapath for lab 1.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity datapath is
  port (
    i_gresetBar      : IN	STD_LOGIC;
    i_gclock			: IN	STD_LOGIC;
    i_left, i_right : IN    STD_LOGIC;
    i_loadLSR, i_loadRSR : IN STD_LOGIC;
    o_Display		: OUT	STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end datapath ;

architecture arch of datapath is

    SIGNAL int_rmask, int_lmask, int_rmaskORlmask, int_muxOut, int_Display : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_switchSelect :STD_LOGIC_VECTOR(1 downto 0);
    
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

begin    

    LMASK : eightBitLShift port map(i_gresetBar, i_loadLSR, i_gclock, '1', int_lmask);
    RMASK : eightBitRShift port map(i_gresetBar, i_loadRSR, i_gclock, '1', int_rmask);
    switchSelect : muxSelect port map (i_right, i_left, int_switchSelect);
    OR_Gate : eightBitOR port map (int_lmask, int_rmask, int_rmaskORlmask);
    Multiplexer : eightBit4x1MUX port map(int_switchSelect, "00000000", int_rmask, int_lmask, int_rmaskORlmask, int_muxOut); 
    Display : eightBitRegister port map(i_gresetBar, '1', i_gclock, int_muxOut, int_Display);

    -- Output Driver
    o_Display <= int_Display;


end architecture ; -- arch