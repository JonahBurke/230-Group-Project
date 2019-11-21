library ieee;
use ieee.std_logic_1164.all;

entity Mux4Input16Bit is
	port(
		s : in  std_logic_vector(1 downto 0);
		input0, input1, input2, input3 : in  std_logic_vector(15 downto 0);
		result : out std_logic_vector(15 downto 0));
end Mux4Input16Bit;

architecture implementation of mux4Input16Bit is
begin
	with s select
		result <=   input0 when "00",
						input1 when "01",
						input2 when "10",
						input3 when others;
end implementation;
