library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clock_generator_tb is  
end clock_generator_tb;


architecture clock_generator_tb_bhv of clock_generator_tb is

component clock_generator is
	generic ( Half_period : time) ;
	port( clock_out: out std_logic);
end component;

constant clk_half_period: time := 10 ns;
signal clock: std_logic;

begin
	clk_gen : clock_generator generic map (clk_half_period)
	port map (clock);
end clock_generator_tb_bhv;

