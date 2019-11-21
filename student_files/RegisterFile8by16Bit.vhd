library ieee;
use ieee.std_logic_1164.all;

entity RegisterFile8by16Bit is
	port(
		clock, reset, RF_write			:in std_logic;
		AddressA, AddressB, AddressC	:in std_logic_vector(2 downto 0);
		InputC								:in std_logic_vector(15 downto 0);
		OutputA, OutputB   				:out std_logic_vector(15 downto 0);
		-- for ModelSim debugging only
		debug_r1	: out std_logic_vector(15 downto 0);
		debug_r2	: out std_logic_vector(15 downto 0);
		debug_r3	: out std_logic_vector(15 downto 0);
		debug_r4	: out std_logic_vector(15 downto 0);
		debug_r5	: out std_logic_vector(15 downto 0);
		debug_r6	: out std_logic_vector(15 downto 0);
		debug_r7	: out std_logic_vector(15 downto 0)
	);
end RegisterFile8by16Bit;

architecture implementation of RegisterFile8by16Bit is
	component Reg16Bit is
		port(
			clock   : in std_logic;
			reset   : in std_logic;
			enable  : in std_logic;
			D		  : in std_logic_vector(15 downto 0);
			Q		  : out std_logic_vector(15 downto 0)
		);
	end component;
	component Mux8Input16Bit is
		port(
			s : in  std_logic_vector(2 downto 0);
			input0, input1, input2, input3 : in  std_logic_vector(15 downto 0);
			input4, input5, input6, input7 : in  std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0)
		);	
	end component;
	component Decoder3Bit is
		port(
			x : in  std_logic_vector(2 downto 0);
			y : out std_logic_vector(7 downto 0)
		);
	end component;
	signal Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7: std_logic_vector(15 downto 0);
	signal DecodedAddressC : std_logic_vector(7 downto 0);
begin
	D1: Decoder3Bit port map (x=>AddressC, y=>DecodedAddressC);
	Q0 <= (others => '0');									-- set every bit to 0
	R1: Reg16Bit port map (clock => clock, reset => reset, enable => RF_write and DecodedAddressC(1), D => InputC, Q => Q1);
	R2: Reg16Bit port map (clock => clock, reset => reset, enable => RF_write and DecodedAddressC(2), D => InputC, Q => Q2);
	R3: Reg16Bit port map (clock => clock, reset => reset, enable => RF_write and DecodedAddressC(3), D => InputC, Q => Q3);
	R4: Reg16Bit port map (clock => clock, reset => reset, enable => RF_write and DecodedAddressC(4), D => InputC, Q => Q4);
	R5: Reg16Bit port map (clock => clock, reset => reset, enable => RF_write and DecodedAddressC(5), D => InputC, Q => Q5);
	R6: Reg16Bit port map (clock => clock, reset => reset, enable => RF_write and DecodedAddressC(6), D => InputC, Q => Q6);
	R7: Reg16Bit port map (clock => clock, reset => reset, enable => RF_write and DecodedAddressC(7), D => InputC, Q => Q7);
	M1: Mux8Input16Bit port map (AddressA, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, OutputA);
	M2: Mux8Input16Bit port map (AddressB, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, OutputB);
	
	-- for debugging only
	debug_r1 <= Q1;
	debug_r2 <= Q2;
	debug_r3 <= Q3;
	debug_r4 <= Q4;
	debug_r5 <= Q5;
	debug_r6 <= Q6;
	debug_r7 <= Q7;
end implementation;