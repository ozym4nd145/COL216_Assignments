----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:10:04 03/24/2017 
-- Design Name: 
-- Module Name:    ARM_CPU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.MyTypes.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ARM_CPU is
	PORT (
    CLK_CPU : in STD_LOGIC;
    RST : in std_logic;
    WEA_MEM : out STD_LOGIC_VECTOR(3 DOWNTO 0);
    ADDR_MEM : out STD_LOGIC_VECTOR(11 DOWNTO 0);
    DIN_MEM : out STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOUT_MEM : in STD_LOGIC_VECTOR(31 DOWNTO 0)
	 );
end ARM_CPU;

architecture Behavioral of ARM_CPU is


component ARM_alu
	port (
		operand1 : in word;
		operand2 : in word;
		result : out word;
		condition : in nibble;
		operation : in optype;
		not_implemented : in std_logic;
		undefined : in std_logic;
		Flags : in nibble;
		nextFlags : out nibble;
		shifter_carry : in std_logic;
		predicate : out std_logic
	);
end component;
component Control_FSM
    Port ( instr_class : in  instr_class_type;
			  instr_mode : in instr_mode_type;
			  DP_subclass : in DP_subclass_type;
			  instr_24 : in std_logic;
			  instr_20 : in std_logic;
			  rst : in std_logic;
           control_state_out : out  control_state_type;
			  clock : in std_logic);
end component;
component Shifter
	port (
		Shifter_in : in word;
		Shifter_out : out word;
		Shift_type : in bit_pair;
		Shift_amount : in Shift_amount_type;
		c_in : in std_logic;
		c_out : out std_logic
	);
end component;
component Decoder
    Port ( instruction : in  word;
           instr_class : out  instr_class_type;
           instr_mode : out  instr_mode_type;
			  DP_subclass : out DP_subclass_type;
			  operation : out optype;
           undefined : out  STD_LOGIC;
           not_implemented : out  STD_LOGIC);
end component;
component Actions
	port (
		clock : in std_logic;
		control_state : in control_state_type;
      instr_mode : in  instr_mode_type;
		instruction : out word;
		operation : in optype;
		operand1 : out word;
		operand2 : out word;
		result : in word;
		nextFlags : in nibble;
		Flags : out nibble;
		rst : in std_logic;
		predicate : in std_logic;
		Shifter_in : out word;
		Shifter_out : in word;
		Shift_amount : out Shift_amount_type;
		Shift_type : out bit_pair;
		WEA_MEM : out nibble;
		ADDR_MEM : out STD_LOGIC_VECTOR(11 DOWNTO 0);
		DIN_MEM : out word;
		DOUT_MEM : in word;
		not_implemented : in std_logic;
		undefined : in std_logic
   );
end component;
begin
--write your code here

end Behavioral;

