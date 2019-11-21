library ieee;
use ieee.std_logic_1164.all;

entity SimpleComputer is
	port(
		clock			: in std_logic;
		LEDR 			: out std_logic_vector(9 downto 0);
		LEDG 			: out std_logic_vector(7 downto 0);
		SW 			: in std_logic_vector(9 downto 0);
		KEY 			: in std_logic_vector(3 downto 0); -- reset = not KEY0
		-- for ModelSim debugging only
		debug_PC	: out std_logic_vector(15 downto 0);
		debug_IR	: out std_logic_vector(15 downto 0);
		debug_state : out std_logic_vector(2 downto 0);
		debug_r1	: out std_logic_vector(15 downto 0);
		debug_r2	: out std_logic_vector(15 downto 0);
		debug_r3	: out std_logic_vector(15 downto 0);
		debug_r4	: out std_logic_vector(15 downto 0);
		debug_r5	: out std_logic_vector(15 downto 0);
		debug_r6	: out std_logic_vector(15 downto 0);
		debug_r7	: out std_logic_vector(15 downto 0);
		debug_RA	: out std_logic_vector(15 downto 0);
		debug_RB	: out std_logic_vector(15 downto 0);
		debug_Extension : out std_logic_vector(15 downto 0);
		debug_RZ	: out std_logic_vector(15 downto 0);
		debug_RY	: out std_logic_vector(15 downto 0)
	);
end SimpleComputer;

architecture implementation of SimpleComputer is
	component SimpleProcessor is
		port(
			clock			: in std_logic;
			reset			: in std_logic;
			MEM_read		: out std_logic;
			MEM_write	: out std_logic;
			MFC			: in std_logic;
			MEM_address	: out std_logic_vector(15 downto 0);
			Data_to_Mem	: out std_logic_vector(15 downto 0);
			Data_from_Mem : in std_logic_vector(15 downto 0);
			-- for ModelSim debugging only
			debug_PC	: out std_logic_vector(15 downto 0);
			debug_IR	: out std_logic_vector(15 downto 0);
			debug_state : out std_logic_vector(2 downto 0);
			debug_r1	: out std_logic_vector(15 downto 0);
			debug_r2	: out std_logic_vector(15 downto 0);
			debug_r3	: out std_logic_vector(15 downto 0);
			debug_r4	: out std_logic_vector(15 downto 0);
			debug_r5	: out std_logic_vector(15 downto 0);
			debug_r6	: out std_logic_vector(15 downto 0);
			debug_r7	: out std_logic_vector(15 downto 0);
			debug_RA	: out std_logic_vector(15 downto 0);
			debug_RB	: out std_logic_vector(15 downto 0);
			debug_Extension : out std_logic_vector(15 downto 0);
			debug_RZ	: out std_logic_vector(15 downto 0);
			debug_RY	: out std_logic_vector(15 downto 0)
		);
	end component;
	component MemoryIOInterface is
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
	end component;
	
	signal	MFC, MEM_read, MEM_write: std_logic;
	signal	Address, Data_from_Mem, Data_to_Mem: std_logic_vector(15 downto 0);
begin

	-- processor uses the rising edge, and is reset when pushing KEY0
	P: SimpleProcessor port map (clock=>clock, reset=>not KEY(0), 
			MEM_read=>MEM_read, MEM_write=>MEM_write,
			MFC=>MFC, MEM_address=>Address,
			Data_to_Mem=>Data_to_Mem, Data_from_Mem=>Data_from_Mem,
			debug_PC=>debug_PC, debug_IR=>debug_IR, debug_state=>debug_state,
			debug_r1=>debug_r1, debug_r2=>debug_r2, debug_r3=>debug_r3,
			debug_r4=>debug_r4, debug_r5=>debug_r5, debug_r6=>debug_r6, debug_r7=>debug_r7,
			debug_RA=>debug_RA, debug_RB=>debug_RB, debug_Extension=>debug_Extension,
			debug_RZ=>debug_RZ, debug_RY=>debug_RY);
					
	
	-- memory and IO use the falling edge, and is reset when pushing KEY0
	MemIO: MemoryIOInterface port map (clock=>not clock, reset=>not KEY(0), 
			MEM_read=>MEM_read, MEM_write=>MEM_write,
			MFC=>MFC, Address=>Address, 
			Data_in=>Data_to_Mem, Data_out=>Data_from_Mem,
			KEY=>KEY(3 downto 1), SW=>SW, LEDG=>LEDG, LEDR=>LEDR);
			
end implementation;
