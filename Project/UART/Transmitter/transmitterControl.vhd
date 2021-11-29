----------------------------------------------------------------------------------------------
-- Title         : Transmitter Control 
----------------------------------------------------------------------------------------------
-- File          : transmitterControl.vhd
----------------------------------------------------------------------------------------------
-- Description : The transmitter control circuit handles the FSM (6 states) for the transmission of data.
--
-----------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity transmitterControl is
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
end transmitterControl ;

architecture arch of transmitterControl is
    TYPE state_type IS (IDLE, DETECTED, READY, START, DATA, STOP); -- States A -> F in the design
    SIGNAL presentState, nextState : state_type;
    SIGNAL setCount : STD_LOGIC;
    SIGNAL count8: STD_LOGIC_VECTOR	(3 downto 0);
    
begin
    process(presentState, i_TDRE, count8) 
    begin 
        case presentState is 
            when IDLE => IF i_TDRE = '0' THEN 
                            nextState <= IDLE;
                         ELSE 
                            nextState <= DETECTED;
                        END IF;

            when DETECTED => nextState <= READY;

            when READY => nextState <= START;

            when START => nextState <= DATA;

            when DATA => IF count8 = "1000" THEN
                            nextState <= STOP;
                         ELSE
                            nextState <= DATA;
                         END IF;

            when STOP => nextState <= IDLE;
        end case;
    end process;

	PROCESS (i_Bclk, i_reset)
	BEGIN
		IF (i_reset ='1') THEN
			presentState <= state_type'LEFT;  -- First state (IDLE)
		ELSIF (i_BClk'EVENT AND i_BClk = '1') THEN
			presentState <= nextState;
		END IF;
	END PROCESS;

    -- Count up to 8 --
    process (i_BClk, count8, setCount, i_reset)
	BEGIN
		IF i_reset = '1' OR setCount = '0' THEN
			count8 <= "0000";
		ELSIF (i_BClk'EVENT AND i_BClk = '1') THEN
			IF (setCount = '1') THEN
				count8 <= count8 + 1;
			END IF;
		END IF;
	END PROCESS;
	
    PROCESS (presentState)
    BEGIN
        CASE presentState is 	
            when IDLE => 		o_startBit <='0'; o_shiftTSR <= '0'; o_loadTSR <= '0'; o_loadTDR <= '0'; o_setTDRE <= '1'; setCount <= '0';
            when DETECTED	=>  o_startBit <='0'; o_shiftTSR <= '0'; o_loadTSR <= '0'; o_loadTDR <= '1'; o_setTDRE <= '0'; setCount <= '0';
            when READY  =>		o_startBit <='0'; o_shiftTSR <= '0'; o_loadTSR <= '1'; o_loadTDR <= '0'; o_setTDRE <= '1'; setCount <= '0';
            when START 	=>		o_startBit <='1'; o_shiftTSR <= '0'; o_loadTSR <= '0'; o_loadTDR <= '0'; o_setTDRE <= '1'; setCount <= '0';
            when DATA 	=>  	o_startBit <='0'; o_shiftTSR <= '1'; o_loadTSR <= '0'; o_loadTDR <= '0'; o_setTDRE <= '1'; setCount <= '1';
            when STOP 	=>  	o_startBit <='0'; o_shiftTSR <= '0'; o_loadTSR <= '0'; o_loadTDR <= '0'; o_setTDRE <= '0'; setCount <= '0';
        END CASE;
    END PROCESS;


end architecture ; -- arch