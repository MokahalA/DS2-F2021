--- This file will include: UART FSM ---LIBRARY ieee;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity uartControl is
  port (
    GReset : IN STD_LOGIC;
    GClock : IN STD_LOGIC;
    MSC_MAX, SSC_MAX : IN STD_LOGIC_VECTOR(3 downto 0);
    SSCS : IN STD_LOGIC;
    baudSelect: IN STD_LOGIC_VECTOR(2 downto 0);
    MSTL, SSTL : OUT STD_LOGIC_VECTOR(2 downto 0);
    BCD1, BCD2 : OUT STD_LOGIC_VECTOR(6 downto 0);
    o_IO : OUT STD_LOGIC; --TxD
    o_Data : OUT STD_LOGIC_VECTOR(7 downto 0) 
  ) ;
end uartControl ;

architecture arch of uartControl is

    SIGNAL int_MSTL, int_SSTL : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL i_UART : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL IO : STD_LOGIC; --Input/Output TxD/RxD
    SIGNAL int_State : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL int_clkdivsec, int_ez : STD_LOGIC;


	component clk_div2 is
		port(clock	: IN STD_LOGIC;	
			clock_1s : OUT	STD_LOGIC);
	end component clk_div2;	

    COMPONENT UART IS
        port (
            i_clock : IN STD_LOGIC;
            i_reset : IN STD_LOGIC;
            i_Data : IN STD_LOGIC_VECTOR(1 downto 0);  --Input from the BUS
            i_SEL : IN STD_LOGIC_VECTOR(2 downto 0); 
            i_RxD : IN STD_LOGIC;
            o_Data : OUT STD_LOGIC_VECTOR(7 downto 0); --Output to the BUS
            o_TxD : OUT STD_LOGIC
        ) ;
    END COMPONENT;

    COMPONENT lab3Top IS
        port(
            GClock, GReset, SSCS : IN STD_LOGIC;
            MSC, SSC : IN STD_LOGIC_VECTOR(3 downto 0);
            timer : OUT STD_LOGIC_VECTOR(6 downto 0);
            timerDec : OUT STD_LOGIC_VECTOR(6 downto 0);
            MSTL, SSTL : OUT STD_LOGIC_VECTOR(2 downto 0);
            State : OUT STD_LOGIC_VECTOR(1 downto 0) -- State information output
        );
    END COMPONENT;
    
begin

    --i_UART <= int_MSTL & int_SSTL & "00";
    SSTL <= int_SSTL;
    MSTL <= int_MSTL;
    int_clkdivsec <= int_ez;

    TLC: lab3Top port map(int_clkdivsec, GReset, SSCS, MSC_MAX, SSC_MAX, BCD1, BCD2, int_MSTL, int_SSTL, int_State);
    UART1: UART port map(int_clkdivsec, GReset, int_State, baudSelect, IO, o_Data, o_IO);
    clkdiv2: clk_div2 port map(GClock, int_ez);

end architecture ; -- arch