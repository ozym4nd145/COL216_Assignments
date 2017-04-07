----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:17:32 03/22/2017 
-- Design Name: 
-- Module Name:    Actions - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.MyTypes.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Actions is
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
end Actions;


architecture Behavioral of Actions is
	
begin

--write your code here	

end Behavioral;

