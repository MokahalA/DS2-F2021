-----------------------------------------------------------------------------------
-- Title         : Fixed Point ALU top-level entity
-----------------------------------------------------------------------------------
-- File          : fixedPointALU.vhd
-----------------------------------------------------------------------------------
-- Description : This file creates the top-level entity for the fixedPointALU

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity fixedPointALU is
  port (
    GClock, GReset: IN STD_LOGIC;
    opA, opB : IN STD_LOGIC_VECTOR(3 downto 0);
    opSelect : IN STD_LOGIC_VECTOR(1 downto 0);
    muxOut : OUT STD_LOGIC_VECTOR(7 downto 0);
    CarryOut, ZeroOut, OverflowOut : OUT STD_LOGIC
  ) ;
end fixedPointALU ;

architecture arch of fixedPointALU is

  -- components --

  component fourBitAddSub 
    port (
      addSub : IN STD_LOGIC;    -- add'Sub
      i_X, i_Y : IN STD_LOGIC_VECTOR(3 downto 0); -- 4-bits inputs
      o_Sum : OUT STD_LOGIC_VECTOR(3 downto 0); -- 4-bit sum output
      o_CarryOut: OUT STD_LOGIC  -- carry output
    ) ;
  END COMPONENT;


  COMPONENT multiplierTop
    port (
      GClock, GReset : IN STD_LOGIC;
      i_A, i_B : IN STD_LOGIC_VECTOR(3 downto 0);
      o_P : OUT STD_LOGIC_VECTOR(7 downto 0);
      o_CarryOut : OUT STD_LOGIC
    ) ;
  END COMPONENT;

  COMPONENT aluMux --main mux for operations
    port (
      opSel : IN STD_LOGIC_VECTOR(1 downto 0);
      D0, D1, D2, D3 : IN STD_LOGIC_VECTOR(7 downto 0);
      o_z : OUT STD_LOGIC_VECTOR(7 downto 0)
    ) ;
  END COMPONENT;

  COMPONENT alu2to1Mux  --mux used for 2s complement for negative numbers
    port (
      sel: IN STD_LOGIC;
      D0, D1 : IN STD_LOGIC_VECTOR(3 downto 0);
      o_q : OUT STD_LOGIC_VECTOR(3 downto 0)
    ) ;
  END COMPONENT;

  -- internal signals --
  SIGNAL int_opA, int_opB : STD_LOGIC_VECTOR(3 downto 0); --use these for multiplication/division
  SIGNAL int_A, int_B : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL int_sum : STD_LOGIC_VECTOR(3 downto 0);
  SIGNAL int_muxOut, int_sumOut, int_prodOut, int_divOut : STD_LOGIC_VECTOR(7 downto 0);
  SIGNAL int_CarryOut : STD_LOGIC;

begin

  -- passing inputs to check if positive/negative --
  checkOpA: alu2to1Mux port map(opA(3), opA, opA, int_opA);
  checkOpB: alu2to1Mux port map(opB(3), opB, opB, int_opB);
 
  -- padding inputs with zeros --
  int_A(7) <= '0';
  int_A(6) <= '0';
  int_A(5) <= '0';
  int_A(4) <= '0';

  int_B(7) <= '0';
  int_B(6) <= '0';
  int_B(5) <= '0';
  int_B(4) <= '0';


  int_A(3) <= int_opA(3);
  int_A(2) <= int_opA(2);
  int_A(1) <= int_opA(1);
  int_A(0) <= int_opA(0);

  int_B(3) <= int_opB(3);
  int_B(2) <= int_opB(2);
  int_B(1) <= int_opB(1);
  int_B(0) <= int_opB(0);

  adderSub: fourBitAddSub port map(opSelect(0), opA, opB, int_sum, int_CarryOut);
  mult: multiplierTop port map(GClock, GReset, int_opA, int_opB, int_prodOut, int_CarryOut);
  --div: divider port map goes here (GClock, GReset, int_opA, int_opB, int_divOut, int_CarryOut) --
  
  int_sumOut(7) <= '0';
  int_sumOut(6) <= '0';
  int_sumOut(5) <= '0';
  int_sumOut(4) <= '0';
  int_sumOut(3) <= int_sum(3);
  int_sumOut(2) <= int_sum(2);
  int_sumOut(1) <= int_sum(1);
  int_sumOut(0) <= int_sum(0);

  opMux: aluMux port map(opSelect, int_sumOut, int_prodOut, int_divOut, int_muxOut);

  muxOut <= int_muxOut;
  CarryOut <= int_CarryOut;
  ZeroOut <= (not(int_muxOut(7) or int_muxOut(6) or int_muxOut(5) or int_muxOut(4) or int_muxOut(3) or int_muxOut(2) or int_muxOut(1) or int_muxOut(0)));
  OverflowOut <= (int_muxOut(3) XOR int_muxOut(2));

end architecture ; -- arch