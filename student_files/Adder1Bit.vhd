library ieee;
use ieee.std_logic_1164.all;

entity Adder1Bit is
	port(
		X, Y, C_in : in std_logic;
		S, C_out : out std_logic
	);
end Adder1Bit;

architecture implementation of Adder1Bit is
begin
	S <= X xor Y xor C_in;
	C_out <=(X and Y) or (X and C_in) or (Y and C_in);
end implementation;