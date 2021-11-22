--------------------------------------------------------------------------------
--	File name: Mux4to1
--	
--	Description: This file creates a 1-bit output 4-to-1 multiplexer 
-- 				  used to filter the "TimerExpired" signal
--
---- For selects (sel0sel1)
-- 00 outputs D0  (MSC)
-- 01 outputs D1  (MST)
-- 10 outputs D2  (SSC)
-- 11 outputs D3  (SST)
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity Mux4to1 is
	port(	sel0, sel1 : IN STD_LOGIC;
			D3, D2, D1, D0 : IN STD_LOGIC;
			S : OUT STD_LOGIC);
end Mux4to1;

architecture Mux4to1 of Mux4to1 is

begin
	S <= ((not sel0)and(not sel1)and(D0)) or ((not sel0)and(sel1)and(D1))
			or ((sel0)and(not sel1)and(D2)) or ((sel0)and(sel1)and(D3));
end Mux4to1;


