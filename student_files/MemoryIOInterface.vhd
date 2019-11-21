library ieee;
use ieee.std_logic_1164.all; 

entity MemoryIOInterface is
	port(
		clock 		: in std_logic;
		reset			: in std_logic;
		MEM_read		: in std_logic;
		MEM_write 	: in std_logic;
		MFC			: out std_logic;
		Address 		: in std_logic_vector(15 downto 0);
		Data_in 		: in std_logic_vector(15 downto 0);
		Data_out		: out std_logic_vector(15 downto 0);
		LEDR 			: out std_logic_vector(9 downto 0);
		LEDG 			: out std_logic_vector(7 downto 0);
		SW 			: in std_logic_vector(9 downto 0);
		KEY 			: in std_logic_vector(3 downto 1)
	);
end MemoryIOInterface;

architecture implementation of MemoryIOInterface is
	component MainMemory is
		port(
				clock			: in std_logic;
				MEM_read		: in std_logic;
				MEM_write	: in std_logic;
				MFC			: out std_logic;
				Address		: in std_logic_vector(15 downto 0);
				Data_in		: in std_logic_vector(15 downto 0);
				Data_out 	: out std_logic_vector(15 downto 0)
		);
	end component;
	component Reg16Bit is
		port(
			clock   : in std_logic;
			reset   : in std_logic;
			enable  : in std_logic;
			D		  : in std_logic_vector(15 downto 0);
			Q		  : out std_logic_vector(15 downto 0)
		);
	end component;

	signal IS_MEM, IS_SW, IS_KEY, IS_LEDG, IS_LEDR: std_logic;
	signal MFC_MEM : std_logic;
	signal Data_out_MEM: std_logic_vector(15 downto 0);
	signal Data_out_SW : std_logic_vector(15 downto 0);
	signal Data_out_KEY: std_logic_vector(15 downto 0);
	signal DE1_LEDR: std_logic_vector(15 downto 0);
	signal DE1_LEDG: std_logic_vector(15 downto 0);
	signal DE1_SW : std_logic_vector(15 downto 0);
	signal DE1_KEY: std_logic_vector(15 downto 0);
begin

	IS_MEM  <= '1' when Address(15 downto 12)="0000" else 
				  '0';
	IS_LEDR <= '1' when Address=x"1000" else
				  '0';
	IS_LEDG <= '1' when Address=x"1010" else
				  '0';
	IS_SW   <= '1' when Address=x"1040" else
				  '0';
	IS_KEY  <= '1' when Address=x"1050" else
				  '0';

	-- Memory
	Memory: MainMemory port map (clock=>clock, MEM_read=>IS_MEM and MEM_read, MEM_write=>IS_MEM and MEM_write,
			MFC=>MFC_MEM, Address=>Address, Data_in=>Data_in, Data_out=>Data_out_MEM);
	
	-- write only
	LEDRed: Reg16Bit port map(clock=>clock, reset=>reset, enable=>IS_LEDR and MEM_write,
				D=>Data_in, Q=>DE1_LEDR);
	LEDR <= DE1_LEDR(9 downto 0);
	
	-- write only
	LEDGreen: Reg16Bit port map(clock=>clock, reset=>reset, enable=>IS_LEDG and MEM_write,
				D=>Data_in, Q=>DE1_LEDG);
	LEDG <= DE1_LEDG(7 downto 0);
	
	-- read only
	SliderSwitch: Reg16Bit port map(clock=>clock, reset=>'0', enable=>'1',
				D=>DE1_SW, Q=>Data_out_SW);
	DE1_SW(9 downto 0) <= SW;
	DE1_SW(15 downto 10) <= (others => '0'); -- all other bits are 0
	
	-- read only
	PushButton: Reg16Bit port map(clock=>clock, reset=>'0', enable=>'1',
				D=>DE1_KEY, Q=>Data_out_KEY);
	DE1_KEY(3 downto 1) <= KEY;
	DE1_KEY(0) <= '0';
	DE1_KEY(15 downto 4) <= (others => '0');	-- all other bits are 0

	-- MFC to processor
	MFC <= MFC_MEM when IS_MEM='1' else
			 '1';
	
	-- Data to Processor
	Data_out <= Data_out_MEM when IS_MEM='1' and MEM_read='1' else
				   Data_out_SW  when IS_SW='1'  and MEM_read='1' else
					Data_out_KEY when IS_KEY='1' and MEM_read='1' else
					x"0000";
	
end implementation;