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

component CU IS
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
END component;

-- Definizione dei segnali interni

signal A, B: 				std_logic_vector(Nb-1 downto 0) := (others => '0');	 -- Segnali di input in uscita da REG_IN
signal ALU_out0, ALU_out1: 	std_logic_vector(Nb-1 downto 0);  -- Segnali di risultato in uscita dalla ALU (0 meno significativa, 1 più)
signal sel_alu, cu_ALU_s, IO_s, MODE_s: std_logic := '0'; -- Segnali di controllo in uscita dalla CU
signal reg_in_e, reg_out_ld, reg_out_e: std_logic; -- segnali per la logica di controllo 
signal clear: std_logic;

begin
	cu_component : CU port map (clk, g_reset, Cin, cu_ALU_s, IO_s, MODE_s);
	
	clear <= not(g_reset);
	reg_in_e <= g_enable AND not(IO_s) AND MODE_s;
	reg_out_ld <= g_enable AND not(MODE_s);
	reg_out_e <= g_enable AND MODE_s AND IO_s;
	
	reg_in : SIPO generic map (Nb => Nb) port map(Bin, clk, reg_in_e, clear, B, A);	
	
	alu_component : ALU generic map (Nb => Nb) port map(A, B, sel_alu, ALU_out0, ALU_out1);
	
	reg_out : PISO generic map (Nb => Nb) port map (ALU_out0, ALU_out1, clk, reg_out_e, clear, reg_out_ld, Output);
	
	
	process(clear, cu_ALU_s)
	begin
		if clear = '1' then
			sel_alu <= '0';
		else
			if cu_ALU_s'event and g_enable = '1' then
				sel_alu <= cu_ALU_s;
			end if;
		end if;
		
	end process;
	

end MOALU_bhv;