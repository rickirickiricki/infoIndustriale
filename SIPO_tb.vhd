library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SIPO_tb is
end SIPO_tb;


architecture SIPO_tb_bhv of SIPO_tb is

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

component SIPO is 
	generic (Nb : integer);
	port(
	bin:			in std_logic_vector(Nb-1 downto 0);
	clk, E, CL:		in std_logic;
	bout0, bout1:	out std_logic_vector(Nb-1 downto 0)
	);
end component;

constant clk_half_period: time := 10 ns;
constant sipo_nbit: integer := 3;
constant counter_nbit: integer := 0 + sipo_nbit;

signal clock: std_logic;
signal counter_out: std_logic_vector(counter_nbit-1 downto 0); 	  

signal sipo_out0, sipo_out1, sipo_in: std_logic_vector(sipo_nbit-1 downto 0);
signal enable, clear: std_logic;

begin
	
	clk_gen : clock_generator generic map (Half_period => clk_half_period) port map (clock);
	
	counter_tb : counter generic map (Nbit => counter_nbit) port map('1', clock, counter_out); 
	
	-- clear <= counter_out(counter_nbit-1);
	-- enable <= counter_out(counter_nbit-2);
	sipo_in <= counter_out(sipo_nbit-1 downto 0);
	
	
	-- sipo_c : SIPO generic map (Nb => sipo_nbit) port map(sipo_in, clock, enable, clear, sipo_out0, sipo_out1);
	sipo_c : SIPO generic map (Nb => sipo_nbit) port map(sipo_in, clock,'0', '1' , sipo_out0, sipo_out1);

end SIPO_tb_bhv;