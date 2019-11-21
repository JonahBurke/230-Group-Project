library ieee;
use ieee.std_logic_1164.all;

entity Decoder3Bit is
	port(
		x : in  std_logic_vector(2 downto 0);
		y : out std_logic_vector(7 downto 0));
end Decoder3Bit;

architecture implementation of Decoder3Bit is
begin
	y(0) <= not x(2) and not x(1) and not x(0);
	y(1) <= not x(2) and not x(1) and x(0);
	y(2) <= not x(2) and x(1) and not x(0);
	y(3) <= not x(2) and x(1) and x(0);
	y(4) <= x(2) and not x(1) and not x(0);
	y(5) <= x(2) and not x(1) and x(0);
	y(6) <= x(2) and x(1) and not x(0);
	y(7) <= x(2) and x(1) and x(0);
end implementation;

