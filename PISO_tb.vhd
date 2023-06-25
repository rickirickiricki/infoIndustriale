library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PISO_tb is
end PISO_tb;


architecture PISO_tb_bhv of PISO_tb is

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

component PISO is 
	generic (Nb : integer);
	port(
	parallel_in0, parallel_in1:	in std_logic_vector(Nb-1 downto 0);
	clk, E, CL, LD:				in std_logic;
	parallel_out:				out std_logic_vector(Nb-1 downto 0)
	);
end component;

constant clk_half_period: time := 10 ns;
constant piso_nbit: integer := 2;
constant counter_nbit: integer := 2 + 2 * piso_nbit;

signal clock: std_logic;
signal counter_out: std_logic_vector(counter_nbit-1 downto 0); 	  

signal piso_out, piso_in0, piso_in1: std_logic_vector(piso_nbit-1 downto 0);
signal enable, clear, load: std_logic;

begin
	
	clk_gen : clock_generator generic map (Half_period => clk_half_period) port map (clock);
	
	counter_tb : counter generic map (Nbit => counter_nbit) port map('1', clock, counter_out); 
	
	-- clear <= counter_out(counter_nbit-1);
	-- enable <= counter_out(counter_nbit-2);
	load <= counter_out(counter_nbit-2);
	piso_in0 <= counter_out(piso_nbit*2 -1 downto piso_nbit);
	piso_in1 <= counter_out(piso_nbit-1 downto 0);
	
	
	piso_tb : PISO generic map (Nb => piso_nbit) port map(piso_in0, piso_in1, clock, '1', '0', load, piso_out);
	--piso_tb : PISO generic map (Nb => piso_nbit) port map(piso_in0, piso_in1, clock, enable, clear, load, piso_out);

end PISO_tb_bhv;