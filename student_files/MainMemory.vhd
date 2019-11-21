library ieee;
use ieee.std_logic_1164.all;

library altera_mf;		-- to use the memory on the DE1 board
use altera_mf.all;

entity MainMemory is
	port(
			clock			: in std_logic;
			MEM_read		: in std_logic;
			MEM_write	: in std_logic;
			MFC			: out std_logic;
			Address		: in std_logic_vector(15 downto 0);
			Data_in		: in std_logic_vector(15 downto 0);
			Data_out 	: out std_logic_vector(15 downto 0)
	);
end MainMemory;

architecture implementation of MainMemory is
	component altsyncram
	generic (
		clock_enable_input_a		: STRING;
		clock_enable_output_a	: STRING;
		init_file					: STRING;
		intended_device_family	: STRING;
		lpm_hint						: STRING;
		lpm_type						: STRING;
		numwords_a					: NATURAL;
		operation_mode				: STRING;
		outdata_aclr_a				: STRING;
		outdata_reg_a				: STRING;
		power_up_uninitialized	: STRING;
		widthad_a					: NATURAL;
		width_a						: NATURAL;
		width_byteena_a			: NATURAL
	);
	port (
			address_a: in std_logic_vector(11 downto 0);
			clock0	: in std_logic;
			data_a	: in std_logic_vector(15 downto 0);
			wren_a	: in std_logic;
			q_a		: out std_logic_vector(15 downto 0)
	);
	end component;
begin
	altsyncram_component : altsyncram
	generic map(
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "MemoryInitialization.mif",
		intended_device_family => "Cyclone II",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 4096,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE",
		widthad_a => 12,
		width_a => 16,
		width_byteena_a => 1
	)
	port map(
		address_a => Address(11 downto 0),
		clock0 => clock,
		data_a => Data_in,
		wren_a => MEM_write,
		q_a => Data_out
	);

	MFC <= MEM_read or MEM_write;
end implementation;

