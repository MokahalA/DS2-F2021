-----------------------------------------------------------------------------------
-- Title         : Multiplier Datapath
-----------------------------------------------------------------------------------
-- File          : multiplierDP.vhd
-----------------------------------------------------------------------------------
-- Description : This file creates the datapath for the Multiplier circuit.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity multiplierDP is
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
end multiplierDP ;

architecture arch of multiplierDP is
    -- signals --
    SIGNAL int_A : STD_LOGIC_VECTOR(7 downto 0); -- Register A (Multiplicand)
    SIGNAL int_B : STD_LOGIC_VECTOR(3 downto 0); --  Register B (Multiplier)
    SIGNAL int_Sum : STD_LOGIC_VECTOR(7 downto 0); -- output of Adder/Subtractor 
    SIGNAL int_muxOut : STD_LOGIC_VECTOR(7 downto 0); -- output of the Multiplexer 
    SIGNAL int_P : STD_LOGIC_VECTOR(7 downto 0); -- output of the Product register
    SIGNAL int_CarryOut, int_BeqZero, int_DONE : STD_LOGIC; 

    -- components
    COMPONENT eightBitLSR IS  -- register A
        PORT(
            i_resetBar, i_clock	: IN	STD_LOGIC;
            i_load, i_clear, i_shift	: IN	STD_LOGIC;
            i_A			: IN	STD_LOGIC_VECTOR(3 downto 0);
            o_Z			: OUT	STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    COMPONENT fourBitRSR IS -- register B
        PORT(
            i_resetBar, i_clock	: IN	STD_LOGIC;
            i_load, i_clear, i_shift	: IN	STD_LOGIC;
            i_A			: IN	STD_LOGIC_VECTOR(3 downto 0);
            o_Z			: OUT	STD_LOGIC_VECTOR(3 downto 0));
    END COMPONENT;

    COMPONENT eightBitAddSub 
        port (
            addSub : IN STD_LOGIC;    -- add'Sub
            i_X, i_Y : IN STD_LOGIC_VECTOR(7 downto 0); -- 7-bits inputs
            o_Sum : OUT STD_LOGIC_VECTOR(7 downto 0); -- 7-bit sum output
            o_CarryOut: OUT STD_LOGIC  -- carry output
        );
    END COMPONENT;

    COMPONENT eightBitRegister -- register P (Product)
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    COMPONENT oneBitRegister -- register DONE 
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            setDone			: IN	STD_LOGIC;
            o_Value			: OUT	STD_LOGIC);
    END COMPONENT;

    COMPONENT fourBitNOR 
        port (
            i_A, i_B : IN STD_LOGIC_VECTOR(3 downto 0);
            o_q : OUT STD_LOGIC
        ) ;
    END COMPONENT;

    COMPONENT multiplierMUX 
        port (
            i_D0, i_D1 : IN STD_LOGIC_VECTOR(7 downto 0);
            Psel : IN STD_LOGIC; 
            o_q : OUT STD_LOGIC_VECTOR(7 downto 0)
        ) ;
    END COMPONENT;

begin
    -- port maps -- 
    Multiplicand: eightBitLSR port map(GReset, GClock, loadA, '0', shiftA, i_A, int_A);
    Multiplier: fourBitRSR port map(GReset, GClock, loadB, '0', shiftB, i_B, int_B);
    Adder: eightBitAddSub port map(addSub, int_A, int_P, int_Sum, int_CarryOut);
    mulMux: multiplierMUX port map("00000000", int_Sum, Psel, int_muxOut);
    Product: eightBitRegister port map(GReset, '1', GClock, int_muxOut, int_P);
    BisZero: fourBitNOR port map("0000", int_B, int_BeqZero); 
    DoneBit: oneBitRegister port map(GReset, '1', GClock, setDone, int_DONE);

    -- drive outputs --
    b0 <= int_B(0) NOR '0';
    BeqZero <= int_BeqZero;
    pOut <= int_P;
    o_CarryOut <= int_CarryOut;
    DONE <= int_DONE;


end architecture ; -- arch