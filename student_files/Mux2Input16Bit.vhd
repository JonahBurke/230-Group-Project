library ieee;
use ieee.std_logic_1164.all;

entity Mux2Input16Bit is
	port(
		s : in  std_logic;
		input0, input1 : in  std_logic_vector(15 downto 0);
		result : out std_logic_vector(15 downto 0));
end Mux2Input16Bit;

architecture implementation of mux2Input16Bit is
begin
	with s select
		result <=   input0 when '0',
						input1 when others;
end implementation;
