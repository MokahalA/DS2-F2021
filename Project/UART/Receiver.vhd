----------------------------------------------------------------------------------------------
-- Title         : Receiver top-level entity
----------------------------------------------------------------------------------------------
-- File          : Receiver.vhd
----------------------------------------------------------------------------------------------
-- Description : The Receiver receives a serial input of bits, and outputs 8-bits to the data line in the correct order.
--                  When loadRSR triggers, the bit that is in RxD is input into the shift register.
--
--              Example input data (serial): 0 0 0 1 1 0 1 0    Example output: 00011010
-----------------------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Receiver is
  port (
    i_reset : IN STD_LOGIC;
    i_BClkx8 : IN STD_LOGIC;
    i_RxD : IN STD_LOGIC;
    i_RDRF : IN STD_LOGIC;
    o_RDRF : OUT STD_LOGIC;
    o_Data : OUT STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end Receiver ;

architecture arch of Receiver is
    SIGNAL int_loadRDR, int_loadRSR, int_RDRF : STD_LOGIC;
    SIGNAL int_Data, int_DataOut : STD_LOGIC_VECTOR(7 downto 0);

    component eightBitRegister is
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
            o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component eightBitShiftRegister is
        PORT(
            i_resetBar, i_load	: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            i_Value			: IN	STD_LOGIC;
            o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component receiverControl is
        port (
            i_reset : IN STD_LOGIC;
            i_BClkx8 : IN STD_LOGIC;
            i_RxD : IN STD_LOGIC;
            i_RDRF : IN STD_LOGIC;
            o_RDRF : OUT STD_LOGIC;
            o_loadRSR : OUT STD_LOGIC;
            o_loadRDR : OUT STD_LOGIC
          ) ;
    end component;

begin

    RDR: eightBitRegister port map(i_reset, int_loadRDR, i_BClkx8, int_Data, int_DataOut);

    RSR: eightBitShiftRegister port map(i_reset, int_loadRSR, i_BClkx8, i_RxD, int_Data);

    receiverCtrl: receiverControl port map(i_reset, i_BClkx8, i_RxD, i_RDRF, int_RDRF, int_loadRSR, int_loadRDR);

    --Output drivers
    o_RDRF <= int_RDRF;
    --- Reversing the order of output data (serial)
    o_Data(7) <= int_DataOut(0);
    o_Data(6) <= int_DataOut(1);
    o_Data(5) <= int_DataOut(2);
    o_Data(4) <= int_DataOut(3);
    o_Data(3) <= int_DataOut(4);
    o_Data(2) <= int_DataOut(5);
    o_Data(1) <= int_DataOut(6);
    o_Data(0) <= int_DataOut(7);

end architecture ; -- arch