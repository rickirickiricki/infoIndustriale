library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clock_generator is
	generic (Half_period : time);
	port( clock_out: out std_logic);
end clock_generator;


architecture clock_generator_bhv of clock_generator is
begin
	
	process
	begin
		clock_out <= '0'; wait for half_period;
		clock_out <= '1'; wait for half_period;
	end process;

end clock_generator_bhv;