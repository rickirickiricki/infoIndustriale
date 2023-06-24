library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SIPO is 
	generic (Nb : integer);
	port(
	bin:			in std_logic_vector(Nb-1 downto 0);
	clk, E, CL:		in std_logic;
	bout0, bout1:	out std_logic_vector(Nb-1 downto 0)
	);
end SIPO;


architecture SIPO_bhv of SIPO is
signal state0: std_logic_vector(Nb-1 downto 0) := (others => '0');
signal state1: std_logic_vector(Nb-1 downto 0) := (others => '0');
signal input_signal: std_logic_vector(Nb-1 downto 0) := (others => '0');
begin
	input_signal <= bin;

	
	process(clk, CL)
	begin
		if CL = '1' then
			state0 <= (others => '0');
			state1 <= (others => '0');
		else
			if clk'event and clk = '1' and E = '1' then
				state1 <= state0;
				state0 <= input_signal;
			end if;
		end if;
		
	end process;
	bout0 <= state0;
	bout1 <= state1;
	
end SIPO_bhv;

		
			
	
		