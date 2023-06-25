library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU_tb is
end ALU_tb;



architecture ALU_tb_bhv of ALU_tb is

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

component ALU is 
	generic (Nb : integer);
	port(
	A, B:			in std_logic_vector(Nb-1 downto 0);
	selector:		in std_logic;
	out0, out1:		out std_logic_vector(Nb-1 downto 0)
	);
end component;

constant clk_half_period: time := 10 ns;
constant bus_nbit: integer := 3;
constant counter_nbit: integer := 2 * bus_nbit;

signal clock: std_logic;
signal counter_out: std_logic_vector(counter_nbit-1 downto 0); 	  

signal alu_in_a, alu_in_b, alu_out0, alu_out1: std_logic_vector(bus_nbit-1 downto 0);
signal alu_out_f: std_logic_vector(2*bus_nbit-1 downto 0);

begin
	clk_gen : clock_generator generic map (Half_period => clk_half_period) port map (clock);
	
	counter_tb : counter generic map (Nbit => counter_nbit) port map('1', clock, counter_out); 
	
	alu_in_a <= counter_out(bus_nbit*2 -1 downto bus_nbit);
	alu_in_b <= counter_out(bus_nbit-1 downto 0);
	
	alu_tb : ALU generic map (Nb => bus_nbit) port map(alu_in_a, alu_in_b, '0', alu_out0, alu_out1);
	
	alu_out_f <= alu_out1 & alu_out0;
	
end ALU_tb_bhv;

		
			
	
		