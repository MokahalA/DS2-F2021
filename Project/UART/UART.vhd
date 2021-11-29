--- This file will include: Receiver, Transmitter, BaudRateGenerator ---
entity UART is
  port (
    i_clock : IN STD_LOGIC;
    i_reset : IN STD_LOGIC;
    i_Data : IN STD_LOGIC_VECTOR(7 downto 0);  --Input from the BUS
    i_SEL : IN STD_LOGIC_VECTOR(2 downto 0); 
    i_RxD : IN STD_LOGIC;
    o_Data : OUT STD_LOGIC_VECTOR(7 downto 0); --Output to the BUS
    o_TxD : OUT STD_LOGIC
  ) ;
end UART ;

architecture arch of UART is
    --- Transmitter ---

    --- Receiver ---

    --- Baud Rate Generator ---

    --- enASdFF --- (For TDRE & RDRF)

begin



end architecture ; -- arch