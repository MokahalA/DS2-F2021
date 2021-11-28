----------------------------------------------------------------------------------------------
-- Title         : Transmitter top-level entity
----------------------------------------------------------------------------------------------
-- File          : Transmitter.vhd
----------------------------------------------------------------------------------------------
-- Description : The transmitter receives an 8-bit data in parallel and outputs the bits 
--                serially in reverse order. (After the start bit is triggered from transmitterControl)
--
--              Example input data: 11110000,    Example output TxD (serial): 1 1 1 1 0 0 0 0 
-----------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Transmitter is
  port (
    i_reset : IN STD_LOGIC;
    i_BClk : IN STD_LOGIC;
    i_TDRE : IN STD_LOGIC;
    i_Data : IN STD_LOGIC_VECTOR(7 downto 0);
    o_TDRE : OUT STD_LOGIC;
    o_TxD : OUT STD_LOGIC
  ) ;
end Transmitter ;

architecture arch of Transmitter is
	SIGNAL int_loadTDR, int_loadTSR, int_startBit, int_shiftTSR : STD_LOGIC;
	SIGNAL int_tdrOut, int_TxD : STD_LOGIC_VECTOR(7 downto 0);

    COMPONENT eightBitRegister IS 
      PORT(
        i_resetBar, i_load	: IN	STD_LOGIC;
        i_clock			: IN	STD_LOGIC;
        i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
        o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;

    COMPONENT transmitterControl IS 
        port (
            i_reset : IN STD_LOGIC;
            i_BClk : IN STD_LOGIC;
            i_TDRE : IN STD_LOGIC;
            o_startBit : OUT STD_LOGIC;
            o_shiftTSR : OUT STD_LOGIC;
            o_loadTSR : OUT STD_LOGIC;
            o_loadTDR : OUT STD_LOGIC;
            o_setTDRE : OUT STD_LOGIC
        ) ;
    END COMPONENT;

    component trShiftRegister is 
      PORT(
        i_resetBar, i_clock	: IN	STD_LOGIC;
        i_load, i_clear, i_shift	: IN	STD_LOGIC;
        i_A			: IN	STD_LOGIC_VECTOR(7 downto 0);
        o_Z			: OUT	STD_LOGIC_VECTOR(7 downto 0));
    end component;

begin

  TDR: eightBitRegister port map(i_reset, int_loadTDR, i_BClk, i_Data, int_tdrOut);

  TSR: trShiftRegister port map(i_reset, i_BClk, int_loadTSR, '0', int_shiftTSR, int_tdrOut, int_TxD);

  transCtrl: transmitterControl port map(i_reset, i_BClk, i_TDRE, int_startBit, int_shiftTSR, int_loadTSR, int_loadTDR, o_TDRE);

  o_TxD <= int_TxD(7) when int_startBit = '0' else '0';

end architecture ; -- arch