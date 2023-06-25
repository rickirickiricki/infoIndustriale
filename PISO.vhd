library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PISO is 
	generic (Nb : integer);
	port(
	parallel_in0, parallel_in1:	in std_logic_vector(Nb-1 downto 0);
	clk, E, CL, LD:				in std_logic;
	parallel_out:				out std_logic_vector(Nb-1 downto 0)
	);
end PISO;


architecture PISO_bhv of PISO is
signal state0, state1: std_logic_vector(Nb-1 downto 0) := (others => '0');
signal in0_signal, in1_signal: std_logic_vector(Nb-1 downto 0) := (others => '0');
begin
	in0_signal <= parallel_in0;
	in1_signal <= parallel_in1;

	
	process(clk, CL)
	begin
		if CL = '1' then
			state0 <= (others => '0');
			state1 <= (others => '0');
		else
			if clk'event and clk = '1' and E = '1' then
				if LD = '1' then
					state0 <= in0_signal;
					state1 <= in1_signal;
				else
					state0 <= state1;
					state1 <= (others => '0');
				end if;
			end if;
		end if;
		
	end process;
	parallel_out <= state0;

end PISO_bhv;

		
			
	
		