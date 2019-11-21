library ieee;
use ieee.std_logic_1164.all;

entity Mux8Input16Bit is
	port(
		s : in  std_logic_vector(2 downto 0);
		input0, input1, input2, input3 : in  std_logic_vector(15 downto 0);
		input4, input5, input6, input7 : in  std_logic_vector(15 downto 0);
		result : out std_logic_vector(15 downto 0));
end Mux8Input16Bit;

architecture implementation of mux8Input16Bit is
begin
	with s select
		result <=   input0 when "000",
						input1 when "001",
						input2 when "010",
						input3 when "011",
						input4 when "100",
						input5 when "101",
						input6 when "110",
						input7 when others;
end implementation;
