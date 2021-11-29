library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY clkDivBy8 IS

	PORT
	(
		i_clock				: IN	STD_LOGIC;
		o_clock				: OUT	STD_LOGIC);
	
END clkDivBy8;

ARCHITECTURE arch OF clkDivBy8 IS
	SIGNAL  int_clock: STD_LOGIC := '0';
	SIGNAL	count: STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	
BEGIN
	PROCESS 
        -- Divide by 8
        BEGIN
            WAIT UNTIL i_clock'EVENT and i_clock = '1';
                IF count < "111" THEN
                    count <= count + 1;
                ELSE
                    count <= "000";
                END IF;
                IF count < 3 THEN
                    int_clock <= '0';
                ELSE
                    int_clock <= '1';
                END IF;
                IF count = "111" THEN
                    int_clock <= '0';
                END IF;
	END PROCESS;	
    o_clock <= int_clock;
END arch;