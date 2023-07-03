library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MOALU is 
	generic (Nb : integer);
	port(
	Bin:			in std_logic_vector(Nb-1 downto 0);
	Cin:			in std_logic;
	clk:			in std_logic;
	g_reset:		in std_logic;
	g_enable:		in std_logic;
	Output:			out std_logic_vector(Nb-1 downto 0)
	);
end MOALU;


architecture MOALU_bhv of MOALU is

-- Definizione dei componenti interni
component SIPO is 
	generic (Nb : integer);
	port(
	bin:			in std_logic_vector(Nb-1 downto 0);
	clk, E, CL:		in std_logic;
	bout0, bout1:	out std_logic_vector(Nb-1 downto 0)
	);
end component;

component ALU is 
	generic (Nb : integer);
	port(
	A, B:			in std_logic_vector(Nb-1 downto 0);
	selector:		in std_logic;
	out0, out1:		out std_logic_vector(Nb-1 downto 0)
	);
end component;

component PISO is 
	generic (Nb : integer);
	port(
	parallel_in0, parallel_in1:	in std_logic_vector(Nb-1 downto 0);
	clk, E, CL, LD:				in std_logic;
	serial_out:				out std_logic_vector(Nb-1 downto 0)
	);
end component;

component CU is
  PORT( ----------------------------------->Cloclk & Reset:
        clk:    IN std_logic;
        Reset: IN std_logic;
        ----------------------------------->Inputs:
        X:   IN std_logic;
        GE:  IN std_logic;
        ----------------------------------->Outputs:
        ALU_s: OUT std_logic;
        EIN: OUT std_logic;
        ELD: OUT std_logic;
        EOU: OUT std_logic
        -------------------------------------------
        );
end component;

-- Definizione dei segnali interni

signal A, B: 				std_logic_vector(Nb-1 downto 0) := (others => '0');	 -- Segnali di input in uscita da REG_IN
signal ALU_out0, ALU_out1: 	std_logic_vector(Nb-1 downto 0);  -- Segnali di risultato in uscita dalla ALU (0 meno significativa, 1 più)
signal ALU_s, EIN, ELD, EOU: std_logic := '0'; -- Segnali di controllo in uscita dalla CU
signal clear: std_logic;

begin
	cu_component : CU port map (clk, g_reset, Cin, g_enable, ALU_s, EIN, ELD, EOU);
	
	clear <= not(g_reset);
	
	reg_in : SIPO generic map (Nb => Nb) port map(Bin, clk, EIN, clear, B, A);	
	
	alu_component : ALU generic map (Nb => Nb) port map(A, B, ALU_s, ALU_out0, ALU_out1);
	
	reg_out : PISO generic map (Nb => Nb) port map (ALU_out0, ALU_out1, clk, EOU, clear, ELD, Output);
	

end MOALU_bhv;