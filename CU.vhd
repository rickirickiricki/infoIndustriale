---------------------------------------------------------------------------------------------------
-- Deeds (Digital Electronics Education and Design Suite)
-- VHDL Code generated on (25/06/2023, 17:53:29)
--      by the Deeds (Finite State Machine Simulator)(Deeds-FsM)
--      Ver. 2.50.200 (Feb 18, 2022)
-- Copyright (c) 2002-2022 University of Genoa, Italy
--      Web Site:  https://www.digitalelectronicsdeeds.com
---------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CU IS
  PORT( ----------------------------------->Cloclk & CL:
        clk:    IN std_logic;
        CL: IN std_logic;
        ----------------------------------->Inputs:
        X:  IN std_logic;
        ----------------------------------->Outputs:
        ALU_s: OUT std_logic;
        IO_s: OUT std_logic;
        MODE_s: OUT std_logic
        -------------------------------------------
        );
END CU;

ARCHITECTURE CU_bhv OF CU IS       -- (Behavioral Description)
  TYPE states is ( state_rx,
                   state_md,
                   state_b4,
                   state_tx );
  SIGNAL State,
         Next_State: states;
BEGIN

  -- Next State Combinational Logic ----------------------------------
  FSM: process( State, X )
  begin
    CASE State IS
      when state_rx =>
                 if (X = '1') then
                   Next_State <= state_md;
                 else
                   Next_State <= state_rx;
                 end if;
      when state_md =>
                 if (X = '1') then
                   Next_State <= state_tx;
                 else
                   Next_State <= state_b4;
                 end if;
      when state_b4 =>
                 if (X = '1') then
                   Next_State <= state_md;
                 else
                   Next_State <= state_rx;
                 end if;
      when state_tx =>
                 if (X = '1') then
                   Next_State <= state_tx;
                 else
                   Next_State <= state_b4;
                 end if;
    END case;
  end process;

  -- State Register --------------------------------------------------
  REG: process( clk, CL )
  begin
    if (CL = '0') then
              State <= state_rx;
    elsif rising_edge(clk) then
              State <= Next_State;
       end if;
  end process;

  -- Outputs Combinational Logic -----------------------------------
  OUTPUTS: process( State, X )
  begin
    -- Set output defaults:
    ALU_s <= '0';
    IO_s <= '0';
    MODE_s <= '0';

    -- Set output as function of current state and input:
    CASE State IS
      when state_rx =>
                 MODE_s <= '1';
      when state_b4 =>
                 ALU_s <= '1';
      when state_tx =>
                 IO_s <= '1';
                 MODE_s <= '1';
      when OTHERS =>
                 ALU_s <= '0';
                 IO_s <= '0';
                 MODE_s <= '0';
    END case;
  end process;

END CU_bhv;
