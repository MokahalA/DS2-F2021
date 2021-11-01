-----------------------------------------------------------------------------------
-- Title         : Multilplier Top-level Entity
-----------------------------------------------------------------------------------
-- File          : multiplierTop.vhd
-----------------------------------------------------------------------------------
-- Description : This file creates the top-level entity for the Multiplier

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity multiplierTop is
  port (
    GClock, GReset : IN STD_LOGIC;
    i_A, i_B : IN STD_LOGIC_VECTOR(3 downto 0);
    o_P : OUT STD_LOGIC_VECTOR(7 downto 0);
    o_CarryOut : OUT STD_LOGIC
  ) ;
end multiplierTop ;

architecture arch of multiplierTop is

    -- components -- 
    COMPONENT multiplierDP
        port (
            --inputs--
            GClock, GReset : IN STD_LOGIC;
            i_A, i_B : IN STD_LOGIC_VECTOR(3 downto 0); 
            loadA, shiftA : IN STD_LOGIC;  -- set clearA always 0
            loadB, shiftB : IN STD_LOGIC;  -- set clearB always 0 
            addSub, Psel : IN STD_LOGIC; -- addSub = 0 for addition, Psel = 1 for int_Sum 
            setDone, resetDoneBar : IN STD_LOGIC; -- resetDoneBar = 1 for reset
            -- outputs
            BeqZero, b0, DONE : OUT STD_LOGIC; 
            pOut : OUT STD_LOGIC_VECTOR(7 downto 0);
            o_CarryOut : OUT STD_LOGIC
        ) ;
    END COMPONENT;

    COMPONENT multiplierCP
        port (
            i_resetBar, i_clock : IN STD_LOGIC;
            i_BeqZero, i_b0, i_DONE : IN STD_LOGIC;
            o_loadA, o_shiftA : OUT STD_LOGIC;
            o_loadB, o_shiftB : OUT STD_LOGIC;
            o_addSub, o_Psel : OUT STD_LOGIC;
            o_setDone, o_resetDoneBar : OUT STD_LOGIC;
            o_state : OUT STD_LOGIC_VECTOR(0 to 5)
        ) ;
    END COMPONENT;
    
    -- control signals --
    SIGNAL int_loadA, int_shiftA, int_loadB, int_shiftB, int_loadP : STD_LOGIC;
    SIGNAL int_addSub, int_Psel : STD_LOGIC;
    SIGNAL int_setDone, int_resetDoneBar : STD_LOGIC;
    SIGNAL int_state : STD_LOGIC_VECTOR(0 to 5);
    
    -- datapath signals --
    SIGNAL int_BeqZero, int_b0, int_DONE : STD_LOGIC;  -- status signals from DP --
    SIGNAL int_P : STD_LOGIC_VECTOR(7 downto 0); 
    SIGNAL int_CarryOut : STD_LOGIC;

begin
    -- instantiation -- 
    mulDp: multiplierDP port map(GClock, GReset, i_A, i_B, int_loadA, int_shiftA, int_loadB, int_shiftB, int_loadP, int_addSub, int_Psel, int_setDone, int_resetDoneBar, int_BeqZero, int_b0, int_DONE, int_P, int_CarryOut);
    mulCp: multiplierCP port map(GReset, GClock, int_BeqZero, int_b0, int_DONE, int_loadA, int_shiftA, int_loadB, int_shiftB, int_loadP, int_addSub, int_Psel, int_setDone, int_resetDoneBar, int_state);

    -- output drivers --
    o_P <= int_P;
    o_CarryOut <= int_CarryOut;

end architecture ; -- arch