----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:48:14 02/28/2017 
-- Design Name: 
-- Module Name:    Control_FSM - Behavioral 
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
use work.MyTypes.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control_FSM is
    Port ( instr_class : in  instr_class_type;
		   instr_mode : in instr_mode_type;
		   DP_subclass : in DP_subclass_type;
           instr_24 : in std_logic;
		   instr_20 : in std_logic;
           rst : in std_logic;
           control_state_out : out  control_state_type;
		   clock : in std_logic);
end Control_FSM;

architecture Behavioral of Control_FSM is
	
begin
	--write your code here
end Behavioral;

