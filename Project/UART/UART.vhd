----------------------------------------------------------------------------------------------
-- Title         : UART top level entity
----------------------------------------------------------------------------------------------
-- File          : UART.vhd
----------------------------------------------------------------------------------------------
-- Description :  UART is composed of four main components: the receiver, the transmitter, the
--                baud rate generator and the UART registers. We suppose that the UART is connected
--                to a microcontroller by a data bus and an address bus, to allow the CPU to read
--                and write the register of the UART.
-----------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity UART is
  port (
    i_clock : IN STD_LOGIC;
    i_reset : IN STD_LOGIC;
    i_Data : IN STD_LOGIC_VECTOR(1 downto 0);  --Input from the BUS
    i_SEL : IN STD_LOGIC_VECTOR(2 downto 0); 
    i_RxD : IN STD_LOGIC;
    o_Data : OUT STD_LOGIC_VECTOR(7 downto 0); --Output to the BUS
    o_TxD : OUT STD_LOGIC
  ) ;
end UART ;

architecture arch of UART is
    --- Transmitter ---
    component Transmitter
      port (
        i_reset : IN STD_LOGIC;
        i_BClk : IN STD_LOGIC;
        i_TDRE : IN STD_LOGIC;
        i_Data : IN STD_LOGIC_VECTOR(1 downto 0);
        o_TDRE : OUT STD_LOGIC;
        o_TxD : OUT STD_LOGIC
      ) ;
    end component ;

    --- Receiver ---
    component Receiver 
      port (
        i_reset : IN STD_LOGIC;
        i_BClkx8 : IN STD_LOGIC;
        i_RxD : IN STD_LOGIC;
        i_RDRF : IN STD_LOGIC;
        o_RDRF : OUT STD_LOGIC;
        o_Data : OUT STD_LOGIC_VECTOR(7 downto 0)
      ) ;
    end component ;

    --- Baud Rate Generator ---
    component BaudRateGenerator 
      port(
          i_resetBar : IN	STD_LOGIC;
          i_clock	: IN	STD_LOGIC;
          i_SEL : IN	STD_LOGIC_VECTOR(2 downto 0);
          o_BClkx8 : OUT	STD_LOGIC;
          o_BClk : OUT STD_LOGIC
      );
    end component;

    --- enASdFF --- (For TDRE & RDRF)
    component enASdFF_2
		port(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	  end component;

    SIGNAL int_BClk, int_BClkx8, ToSCSR_RDRF, ToSCSR_TDRE, FromSCSR_RDRF, FromSCSR_TDRE : STD_LOGIC;

begin

  rcvr: Receiver port map (i_reset, int_BClkx8, i_RxD, FromSCSR_RDRF, ToSCSR_RDRF, o_Data);

  brg: BaudRateGenerator port map (i_reset, i_clock, i_SEL, int_BClkx8, int_BClk);

  trans1: Transmitter port map (i_reset, int_BClk, FromSCSR_TDRE, i_Data, ToSCSR_TDRE, o_TxD);

  RDRF: enASdFF_2 port map (i_reset, ToSCSR_RDRF, '1', i_clock, FromSCSR_RDRF);

  TDRE: enASdFF_2 port map (i_reset, ToSCSR_TDRE, '1', i_clock, FromSCSR_TDRE);



end architecture ; -- arch