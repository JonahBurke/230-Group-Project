library ieee;
use ieee.std_logic_1164.all;

entity Immediate is
	port(
		IR: in std_logic_vector(15 downto 0);
		PC: in std_logic_vector(15 downto 0);
		extend: in std_logic_vector(2 downto 0);
		extension: out std_logic_vector(15 downto 0)
	);
end Immediate;

-- this is a combinational circuit 
architecture implementation of Immediate is
      signal imm7: std_logic_vector(6 downto 0);
      signal imm9: std_logic_vector(8 downto 0);
      signal imm13: std_logic_vector(12 downto 0);
begin
       process(IR, PC, extend, imm7, imm9, imm13)
       begin
			imm7 <= IR(9 downto 3);
       	imm9 <= IR(15 downto 7);
       	imm13 <= IR(15 downto 3);
       	case extend is
			when "000"  =>
					if(imm7(6) = '0') then
						extension <= "000000000" & imm7;
					else 
						extension <= "111111111" & imm7;
					end if;
			when "001" =>	
						extension <= "000000000" & imm7;
			when "010" =>	
						extension <= imm7 & "000000000";
			when "011"  =>
					if(imm9(8) = '0') then
						extension <= "0000000" & imm9;
					else 
						extension <= "1111111" & imm9;
					end if;
			when others =>	
					extension <= PC(15 downto 13) & imm13;
			end case;
       end process;
end implementation;

