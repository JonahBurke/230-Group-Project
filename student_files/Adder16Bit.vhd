library ieee;
use ieee.std_logic_1164.all;

entity Adder16Bit is
	port(
		X, Y 	: in std_logic_vector(15 downto 0);
		C_in 	: in std_logic;
		S 		: out std_logic_vector(15 downto 0);
		C_out_14, C_out_15 : out std_logic
	);
end Adder16Bit;

architecture implementation of Adder16Bit is
	component Adder1Bit is
		port(
			X, Y, C_in 	: in std_logic;
			S, C_out 	: out std_logic
		);
	end component;
	signal C : std_logic_vector(15 downto 0);
begin
	S0: Adder1Bit port map(X(0), Y(0), C_in, S(0), C(0));
	S1: Adder1Bit port map(X(1), Y(1), C(0), S(1), C(1));
	S2: Adder1Bit port map(X(2), Y(2), C(1), S(2), C(2));
	S3: Adder1Bit port map(X(3), Y(3), C(2), S(3), C(3));
	S4: Adder1Bit port map(X(4), Y(4), C(3), S(4), C(4));
	S5: Adder1Bit port map(X(5), Y(5), C(4), S(5), C(5));
	S6: Adder1Bit port map(X(6), Y(6), C(5), S(6), C(6));
	S7: Adder1Bit port map(X(7), Y(7), C(6), S(7), C(7));
	S8: Adder1Bit port map(X(8), Y(8), C(7), S(8), C(8));
	S9: Adder1Bit port map(X(9), Y(9), C(8), S(9), C(9));
	S10: Adder1Bit port map(X(10), Y(10), C(9), S(10), C(10));
	S11: Adder1Bit port map(X(11), Y(11), C(10), S(11), C(11));
	S12: Adder1Bit port map(X(12), Y(12), C(11), S(12), C(12));
	S13: Adder1Bit port map(X(13), Y(13), C(12), S(13), C(13));
	S14: Adder1Bit port map(X(14), Y(14), C(13), S(14), C(14));
	S15: Adder1Bit port map(X(15), Y(15), C(14), S(15), C(15));
	C_out_14 <= C(14);
	C_out_15 <= C(15);
end implementation;