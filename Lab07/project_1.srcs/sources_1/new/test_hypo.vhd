----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2017 12:38:37 AM
-- Design Name: 
-- Module Name: test_hypo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_hypo is
    Port ( clk : in STD_LOGIC);
end test_hypo;

architecture Behavioral of test_hypo is
signal s1 : std_logic := '0';
signal s2 : std_logic := '0';
signal s3: std_logic := '0';
begin

process(clk)
begin
    if(clk = '1' and clk'event) then
        s1 <= '1';
        if s1 = '1' then
            s3 <= '1';
        end if;
    end if;
end process;

process(clk)
begin
    if(clk = '1' and clk'event) then
        if s3 = '1' then
            s2 <= '1';
        end if;
    end if;
end process;


end Behavioral;
