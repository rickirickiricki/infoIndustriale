library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MOALU_tb is
end MOALU_tb;


architecture MOALU_tb_bhv of MOALU_tb is

component clock_generator is
	generic ( Half_period : time) ;
	port( clock_out: out std_logic);
end component;

component counter is
	generic ( Nbit : integer );
	port(
	T: 			in std_logic;
	clk:		in std_logic;  
	CL: 		in std_logic;
	out_count: 	out std_logic_vector(Nbit-1 downto 0)
	);
end component;	

component MOALU is 
	generic (Nb : integer);
	port(
	Bin:			in std_logic_vector(Nb-1 downto 0);
	Cin:			in std_logic;
	clk:			in std_logic;
	g_reset:		in std_logic;
	g_enable:		in std_logic;
	Output:			out std_logic_vector(Nb-1 downto 0)
	);
end component;

constant clk_half_period: time := 10 ns;
constant clk_period: time := 2 * clk_half_period;
constant moalu_nbit: integer := 2;
constant counter_nbit: integer := moalu_nbit;

signal clock, clear_counter, clear_moalu: std_logic;
signal counter_out: std_logic_vector(counter_nbit-1 downto 0);	 
signal cin : std_logic;
signal Output: std_logic_vector(moalu_nbit-1 downto 0);							


begin
	clk_gen : clock_generator generic map (Half_period => clk_half_period) port map (clock);
	
	counter_tb : counter generic map (Nbit => counter_nbit) port map('1', clock, clear_counter, counter_out); 
	
	moalu_tb : MOALU generic map (Nb => moalu_nbit) port map(counter_out, cin, clock, clear_moalu, '1', Output);
	
	
	cin_gen : process
	begin 
		cin <= '0'; wait for 2 * clk_period; -- rx (00, 01)
		cin <= '1'; wait for clk_period;  -- md
	end process;
	
	clear_counter_gen : process
	begin
		clear_counter <= '1'; wait for 3 ns;
		clear_counter <= '0'; wait;
		
	end process;
	
	clear_moalu_gen : process
	begin
		clear_moalu <= '1'; wait for 70 ns;
		clear_moalu <= '0'; wait for 3 ns;
		
	end process;
	
		

end MOALU_tb_bhv;