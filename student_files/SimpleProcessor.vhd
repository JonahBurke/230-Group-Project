library ieee;
use ieee.std_logic_1164.all;

entity SimpleProcessor is
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
end SimpleProcessor;

architecture implementation of SimpleProcessor is
	component RegisterFile8by16Bit is
		port(
			clock, reset, RF_write			:in std_logic;
			AddressA, AddressB, AddressC	:in std_logic_vector(2 downto 0);
			InputC								:in std_logic_vector(15 downto 0);
			OutputA, OutputB   				:out std_logic_vector(15 downto 0);
			-- for debugging only
			debug_r1	: out std_logic_vector(15 downto 0);
			debug_r2	: out std_logic_vector(15 downto 0);
			debug_r3	: out std_logic_vector(15 downto 0);
			debug_r4	: out std_logic_vector(15 downto 0);
			debug_r5	: out std_logic_vector(15 downto 0);
			debug_r6	: out std_logic_vector(15 downto 0);
			debug_r7	: out std_logic_vector(15 downto 0)
		);
	end component;
	component ALU is
		port(
			ALU_op 			: in std_logic_vector(1 downto 0);
			A, B 				: in std_logic_vector(15 downto 0);
			A_inv, B_inv 	: in std_logic;
			C_in				: in std_logic;
			ALU_out 			: out std_logic_vector(15 downto 0);
			N, C, V, Z 		: out std_logic
		);
	end component;
	component Immediate is
		port(
			IR: in std_logic_vector(15 downto 0);
			PC: in std_logic_vector(15 downto 0);
			extend: in std_logic_vector(2 downto 0);
			extension: out std_logic_vector(15 downto 0)
		);
	end component;
	component ControlUnit is
		port(
			clock	: in  std_logic;
			reset	: in  std_logic;
			status: in  std_logic_vector(15 downto 0);
			MFC	: in  std_logic;
			IR		: in  std_logic_vector(15 downto 0);
			RF_write	: out std_logic;
			C_select	: out std_logic_vector(1 downto 0);
			B_select : out std_logic;
			Y_select	: out std_logic_vector(1 downto 0);
			ALU_op	: out std_logic_vector(1 downto 0);
			A_inv		: out std_logic;
			B_inv		: out std_logic;
			C_in		: out std_logic;
			MEM_read	: out std_logic;
			MEM_write: out std_logic;
			MA_select: out std_logic;
			IR_enable: out std_logic;
			PC_select: out std_logic_vector(1 downto 0);
			PC_enable: out std_logic;
			INC_select: out std_logic;
			extend	: out std_logic_vector(2 downto 0);
			Status_enable : out std_logic;
			-- for ModelSim debugging only
			debug_state	: out std_logic_vector(2 downto 0)
		);
	end component;
	component Adder16Bit is
		port(
			X, Y 	: in std_logic_vector(15 downto 0);
			C_in 	: in std_logic;
			S 		: out std_logic_vector(15 downto 0);
			C_out_14, C_out_15 : out std_logic
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
	component Mux2Input16Bit is
		port(
			s : in  std_logic;
			input0, input1 : in  std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0));
	end component;
	component Mux4Input16Bit is
		port(
			s : in  std_logic_vector(1 downto 0);
			input0, input1, input2, input3 : in  std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0));
	end component;
	component Mux4Input3Bit is
		port(
			s : in  std_logic_vector(1 downto 0);
			input0, input1, input2, input3 : in  std_logic_vector(2 downto 0);
			result : out std_logic_vector(2 downto 0));
	end component;

	-- component data
	signal Data_RFOutA,Data_RFOutB: std_logic_vector(15 downto 0);
	signal Data_MuxC 					: std_logic_vector(2 downto 0);
	signal Data_RA, Data_RB			: std_logic_vector(15 downto 0);
	signal Data_MuxB, Data_ALU		: std_logic_vector(15 downto 0);
	signal Data_RZ						: std_logic_vector(15 downto 0);
	signal Data_MuxY, Data_RY		: std_logic_vector(15 downto 0);
	signal Data_IR, Data_Extension: std_logic_vector(15 downto 0);
	signal Data_MuxInc, Data_Adder: std_logic_vector(15 downto 0);
	signal Data_MuxPC, Data_PC		: std_logic_vector(15 downto 0);
	signal Data_PC_temp				: std_logic_vector(15 downto 0);
	signal Data_Status				: std_logic_vector(15 downto 0);
	-- control signals
	signal	RF_write	: std_logic;
	signal 	C_select	: std_logic_vector(1 downto 0);
	signal	B_select : std_logic;
	signal 	Y_select	: std_logic_vector(1 downto 0);
	signal	ALU_op	: std_logic_vector(1 downto 0);
	signal	A_inv		: std_logic;
	signal	B_inv		: std_logic;
	signal	C_in		: std_logic;
	signal   N, C, V, Z : std_logic;
	signal	MA_select: std_logic;
	signal	IR_enable: std_logic;
	signal	PC_select: std_logic_vector(1 downto 0);
	signal	PC_enable: std_logic;
	signal	INC_select: std_logic;
	signal	extend	: std_logic_vector(2 downto 0);
	signal	Status_enable : std_logic;
	-- add your interal signals below
	
begin
	-- for debugging only
	debug_PC <= Data_PC;
	debug_IR <= Data_IR;
	debug_RA <= Data_RA;
	debug_RB <= Data_RB;
	debug_Extension <= Data_Extension;
	debug_RZ <= Data_RZ;
	debug_RY <= Data_RY;

	-- Connect processor components below
	
	-- Register file
	RF: RegisterFile8by16Bit
		port map (
			clock => clock,
			reset => reset,
			RF_write => RF_write,
			AddressA => Data_IR(15 downto 13),
			AddressB => Data_IR(12 downto 10),
			AddressC => Data_MuxC,
			InputC => Data_RY,
			OutputA => Data_RFOutA,
			OutputB => Data_RFOutB,
			debug_r1 => debug_r1,
			debug_r2 => debug_r2,
			debug_r3 => debug_r3,
			debug_r4 => debug_r4,
			debug_r5 => debug_r5,
			debug_r6 => debug_r6,
			debug_r7 => debug_r7
		);

	-- Inputs for Register File
	RY: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => '1',
			D => Data_MuxY,
			Q => Data_RY
		);
	
	MuxC: Mux4Input3Bit
		port map (
			s => C_select,
			input0 => Data_IR(12 downto 10),
			input1 => Data_IR(9 downto 7),
			input2 => "111",
			input3 => '0',
			result => Data_MuxC
		);

	IR: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => IR_Enable,
			D => Data_from_Mem,
			Q => Data_IR
		);

	-- Output for Register File and Inputs for ALU
	RA: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => '1',
			D => Data_RFOutA,
			Q => Data_RA
		);

	RB: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => '1',
			D => Data_RFOutB,
			Q => Data_RB
		);

	-- This is input for the ALU
	MuxB: Mux2Input16Bit
		port map (
			s => B_select,
			input0 => Data_RB,
			input1 => Data_Extension,
			result => Data_MuxB
		);
	
	-- ALU
	ALU: ALU
		port map (
			ALU_op => ALU_op,
			A => Data_RA,
			B => Data_MuxB,
			A_inv => A_inv,
			B_inv => B_inv,
			C_in => C_in,
			ALU_out => Data_ALU,
			N => N,
			C => C,
			V => V,
			Z => Z
		);

	-- Out from the ALU
	RZ: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => '1',
			D => Data_ALU,
			Q => Data_RZ
		);

	-- This is also output from RB
	RM: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => '1',
			D => Data_RFOutB,
			Q => Data_to_Mem
		);
	
	-- Output from RZ, Mem, and PC
	MuxY: Mux4Input16Bit
		port map (
			s => Y_select,
			input0 => Data_RZ,
			input1 => Data_from_Mem,
			input2 => Data_PC_temp,
			input3 => '0',
			result => Data_MuxY
		);

	-- Status and Control unit
	-- Status get data from ALU
	Status: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => Status_enable,
			D(0) => Z,
			D(1) => V,
			D(2) => C,
			D(3) => N,
			D(15 downto 4) => "000000000000",
			Q => Data_Status
		);

	-- Control Unit gets input from IR and outputs control signals
	CU: ControlUnit
		port map (
			clock => clock,
			reset => reset,
			status => Data_Status,
			MFC => MFC,
			IR => Data_IR,
			RF_write => RF_write,
			C_select => C_select,
			B_select => B_select,
			Y_select => Y_select,
			ALU_op => ALU_op,
			A_inv => A_inv,
			B_inv => B_inv,
			C_in => C_in,
			MEM_read => MEM_read,
			MEM_write => MEM_write,
			MA_select => MA_select,
			IR_enable => IR_enable,
			PC_select => PC_select,
			PC_enable => PC_eneable,
			INC_select => INC_select,
			extend => extend,
			Status_enable => Status_enable,
			debug_state => debug_state
		);

	-- Immediate Extender gets input from IR and PC
	ImmExtend: Immediate
		port map (
			IR => Data_IR,
			PC => Data_PC,
			extend => extend,
			extension => Data_Extension
		);
	
	-- MuxINC feeds into an adder for MuxPC
	MuxINC: Mux2Input16Bit
		port map (
			s => INC_select,
			input0 => "0000000000000001",
			input1 => Data_Extension,
			result => Data_MuxInc
		);

	-- Adder gets input from PC and MuxInc and feeds into MuxPC
	Adder: Adder16Bit
		port map (
			X => Data_MuxInc,
			Y => Data_PC,
			C_in => '0',
			S => Data_Adder
		);

	-- MuxPC gets input from the immediate extender, the adder, and RA
	MuxPC: Mux4Input16Bit
		port map (
			s => PC_select,
			input0 => Data_RA,
			input1 => Data_Adder,
			input2 => Data_Extension,
			input3 => '0',
			result => Data_MuxPC
		);

	-- PC gets input from MuxPC and outputs to PC temp, MuxMA, the adder, and the immediate extender
	PC: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => PC_enable,
			D => Data_MuxPC,
			Q => Data_PC
		);

	-- MuxMA gets input from RZ and PC and feeds into memory
	MuxMA: Mux2Input16Bit
		port map (
			s => MA_select,
			input0 => Data_RZ,
			input1 => Data_PC,
			result => MEM_address
		);

	-- PC temp gets input from PC and feeds into MuxY
	PCtemp: Reg16Bit
		port map (
			clock => clock,
			reset => reset,
			enable => '1',
			D => Data_MPC,
			Q => Data_PC_temp
		);

end implementation;