library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter_tb is  
end counter_tb;


architecture counter_tb_bhv of counter_tb is

component clock_generator is
	generic ( Half_period : time) ;
	port( clock_out: out std_logic);
end component;

component counter is
	generic ( Nbit : integer );
	port(
	T: 			in std_logic;
	clk:		in std_logic;
	out_count: 	out std_logic_vector(Nbit-1 downto 0)
	);
end component;

constant clk_half_period: time := 10 ns;
constant counter_nbit: integer := 3;
signal clock: std_logic;
signal count: std_logic_vector(counter_nbit-1 downto 0);   

begin
	
	clk_gen : clock_generator generic map (Half_period => clk_half_period) port map (clock);
	
	counter_tb : counter generic map (Nbit => counter_nbit)
	port map('1', clock, count);

end counter_tb_bhv;

	

