library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity counter is
	generic ( Nbit : integer );
	port(
	T: 			in std_logic;
	clk:		in std_logic;
	CL:			in std_logic;
	out_count: 	out std_logic_vector(Nbit-1 downto 0)
	);
end counter;


architecture counter_bhv of counter is	
constant vector_ovf1: std_logic_vector(Nbit-1 downto 0) := (others => '1');
begin
	process(clk, CL)
	variable count: std_logic_vector(Nbit-1 downto 0) := (others => '0');
	
	begin
		if CL = '1' then
			count := (others => '0');
		else
			if clk'event and clk = '0' and T = '1' then
				if count = vector_ovf1 then
					count := (others => '0');
				else
					count := count + '1'; 
				end if;
			end if;	 
		end if;	   
		out_count <= count;
	end process;
	
end counter_bhv;
			
			
					
					
				
			

