library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
	generic (Nb : integer);
	port(
	A, B:			in std_logic_vector(Nb-1 downto 0);
	selector:		in std_logic;
	out0, out1:		out std_logic_vector(Nb-1 downto 0)
	);
end ALU;


architecture ALU_bhv of ALU is
signal MP, Mx4: std_logic_vector(2*Nb -1 downto 0);

begin
	--MP <= (0.5*A + 2*B) / 2;
	Mx4 <= std_logic_vector(shift_left(resize(unsigned(B), 2*Nb), 2));
	MP <= std_logic_vector(  shift_right( shift_right(resize(unsigned(A), 2*Nb), 1) + shift_left(resize(unsigned(B), 2*Nb), 1) , 1) );
	
	out0 <= MP(Nb-1 downto 0) when (selector = '0') else Mx4(Nb-1 downto 0);
	out1 <= MP(2*Nb -1 downto Nb) when (selector = '0') else Mx4(2*Nb -1 downto Nb);
	
end ALU_bhv;

		
			
	
		