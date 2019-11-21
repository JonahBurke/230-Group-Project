library ieee;
use ieee.std_logic_1164.all;

entity Reg1Bit is
	port(
		clock   : in std_logic;
		reset   : in std_logic;
		enable  : in std_logic;
		D		  : in std_logic;
		Q		  : out std_logic
	);
end Reg1Bit;

architecture implementation of Reg1Bit is
begin
	process(clock, reset)
	begin
		if (reset='1') then
			Q <= '0';
		elsif (rising_edge(clock)) then
			if (enable = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end implementation;