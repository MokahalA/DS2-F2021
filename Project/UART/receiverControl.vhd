----------------------------------------------------------------------------------------------
-- Title         : Receiever Control 
----------------------------------------------------------------------------------------------
-- File          : receieverControl.vhd
----------------------------------------------------------------------------------------------
-- Description : The receiver control circuit handles the FSM (5 states) for the receiving of data.
--
--  Note: Must reset at the beginning to initialize the counters!
-----------------------------------------------------------------------------------------------


library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity receiverControl is
  port (
    i_reset : IN STD_LOGIC;
    i_BClkx8 : IN STD_LOGIC;
    i_RxD : IN STD_LOGIC;
    i_RDRF : IN STD_LOGIC;
    o_RDRF : OUT STD_LOGIC;
    o_loadRSR : OUT STD_LOGIC;
    o_loadRDR : OUT STD_LOGIC
  ) ;
end receiverControl ;

architecture arch of receiverControl is

    TYPE state_type IS (IDLE, START, DATA, PAUSE, STORE);
    SIGNAL presentState, nextState: state_type;
    SIGNAL incrementCount4, incrementCount8, incrementRSR : STD_LOGIC;
    SIGNAL count8 : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL count4 : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL rsrCount : STD_LOGIC_VECTOR(3 downto 0);

begin
    -- State machine
    process(presentState, i_RxD, count8, count4, rsrCount, i_RDRF)
        begin
            CASE presentState IS
			WHEN IDLE 		=>	IF i_RxD = '0' THEN
										nextState <= START;
									ELSE 
										nextState <= IDLE;
									END IF;
									
			WHEN START		=> IF count4 = "11" THEN
										nextState <= PAUSE;
									ELSE
										nextState <= START;
									END IF;
									
			WHEN DATA		=>		nextState <= PAUSE;				
								
			WHEN PAUSE  	=> IF rsrCount = "1000" AND count8  = "111" THEN
										nextState <= STORE;
									ELSIF count8 = "111" THEN
										nextState <= DATA;
									ELSE
										nextState <= PAUSE;
									END IF;
									
			WHEN STORE      => nextState <= IDLE;
		END CASE;
	end process;

    -- Reset state machine (back to IDLE)
	PROCESS (i_BClkx8, i_reset)
        BEGIN
            IF (i_reset ='1') THEN
                presentState <= state_type'LEFT; -- First state
            ELSIF (i_BClkx8'EVENT AND i_BClkx8 = '1') THEN
                presentState <= nextState;
            END IF;
        END PROCESS;


    -- Count up to 4
    PROCESS(i_reset, i_BClkx8, incrementCount4, count4)
        BEGIN
            IF(i_reset = '1' OR incrementCount4 = '0') THEN
                count4 <= "00";
            ELSIF (i_BClkx8'EVENT AND i_BClkx8 = '1') THEN
                count4 <= count4 +1;
            END IF;
        END PROCESS;

    -- Count up to 8
    PROCESS(i_reset, i_BClkx8, incrementCount8, count8)
        BEGIN
            IF(i_reset = '1' OR incrementCount8 = '0') THEN
                count8 <= "001";
            ELSIF (i_BClkx8'EVENT AND i_BClkx8 = '1') THEN
                count8 <= count8 +1;
            END IF;
        END PROCESS;

    -- Count up for RSR
    process(i_reset, incrementRSR, i_BClkx8)
        BEGIN
            IF i_reset = '1' THEN
                rsrCount <= "0000";		
            ELSIF (i_BClkx8'EVENT AND i_BClkx8 = '1' and incrementRSR = '1' )THEN
                IF incrementRSR = '1' THEN
                    IF rsrCount = "1000" THEN
                        rsrCount <="0000";
                    ELSE
                        rsrCount <= rsrCount + 1;
                    END IF;
                END IF;
            END IF;
        END PROCESS;

        -- Output signals for each state
        PROCESS (presentState)
		BEGIN
			CASE presentState is 	
				when IDLE	=> o_loadRSR <= '0'; o_loadRDR <= '0'; o_RDRF <= '0'; incrementCount4 <= '0'; incrementCount8 <= '0'; incrementRSR <= '0';
				when START  => o_loadRSR <= '0'; o_loadRDR <= '0'; o_RDRF <= '0'; incrementCount4 <= '1'; incrementCount8 <= '0'; incrementRSR <= '0';
				when DATA 	=> o_loadRSR <= '1'; o_loadRDR <= '0'; o_RDRF <= '0'; incrementCount4 <= '0'; incrementCount8 <= '0'; incrementRSR <= '1';
				when PAUSE  => o_loadRSR <= '0'; o_loadRDR <= '0'; o_RDRF <= '0'; incrementCount4 <= '0'; incrementCount8 <= '1'; incrementRSR <= '0';
				when STORE 	=> o_loadRSR <= '0'; o_loadRDR <= '1'; o_RDRF <= '1'; incrementCount4 <= '0'; incrementCount8 <= '0'; incrementRSR <= '1';
			END CASE;
		END PROCESS;


end architecture ; -- arch