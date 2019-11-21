library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port(
		ALU_op 			: in std_logic_vector(1 downto 0);
		A, B 				: in std_logic_vector(15 downto 0);
		A_inv, B_inv 	: in std_logic;
		C_in				: in std_logic;
		ALU_out 			: out std_logic_vector(15 downto 0);
		N, C, V, Z 		: out std_logic
	);
end ALU;

architecture implementation of ALU is
	component Mux4Input16Bit is
	port(
		s : in  std_logic_vector(1 downto 0);
		input0, input1, input2, input3 : in  std_logic_vector(15 downto 0);
		result : out std_logic_vector(15 downto 0));
	end component;
	component Mux2Input16Bit is
	port(
		s : in  std_logic;
		input0, input1 : in  std_logic_vector(15 downto 0);
		result : out std_logic_vector(15 downto 0)
		);
	end component;
	component Adder16Bit is
	port(
		X, Y 	: in std_logic_vector(15 DOWNTO 0);
		C_in 	: in std_logic;
		S 		: out std_logic_vector(15 DOWNTO 0);
		C_out_14, C_out_15 : out std_logic
	);
	end component;
	signal NOTA, NOTB, Amux, Bmux : std_logic_vector(15 downto 0);
	signal ANDout, ORout, XORout, ADDout : std_logic_vector(15 downto 0);
	signal C_out_14, C_out_15 : std_logic;
begin
	NOTA <= not A;
	NOTB <= not B;
	M1: Mux2Input16Bit port map(A_inv, A, NOTA, Amux);
	M2: Mux2Input16Bit port map(B_inv, B, NOTB, Bmux);
	ANDout <= Amux and Bmux;
	ORout <= Amux or Bmux;
	XORout <= Amux xor Bmux;
	A1: Adder16Bit port map(Amux, Bmux, C_in, ADDout, C_out_14, C_out_15);
	M3: Mux4Input16Bit port map(ALU_op, ANDout, ORout, XORout, ADDout, ALU_out);
	N <= ADDout(15);
	C <= C_out_15;
	V <= C_out_14 xor C_out_15;
	Z <= not (ADDout(0) or ADDout(1) or ADDout(2) or ADDout(3) 
	     or ADDout(4) or ADDout(5) or ADDout(6) or ADDout(7) 
		  or ADDout(8) or ADDout(9) or ADDout(10) or ADDout(11) 
		  or ADDout(12) or ADDout(13) or ADDout(14) or ADDout(15));
end implementation;