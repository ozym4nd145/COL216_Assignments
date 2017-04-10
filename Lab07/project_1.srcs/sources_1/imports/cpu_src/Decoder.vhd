----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:47:38 02/27/2017 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
    Port ( instruction : in  word := (others => '0');
           instr_class : out  instr_class_type;
           DT_subclass: out DT_subclass_type;
           DP_subclass: out DP_subclass_type;
           operation : out optype;
           undefined : out  STD_LOGIC;
           not_implemented : out  STD_LOGIC);
end Decoder;

architecture Behavioral of Decoder is
	
begin
  process(instruction)
  begin
      not_implemented <= '0';
      undefined <= '0';    
      case instruction (27 downto 26) is
        when "00" =>
          if(instruction(25)='1') then
            DP_subclass <= IMM;
          else
            if (instruction(4)='0') then
              DP_subclass <= SFT_IMM;
            elsif (instruction(7)='0') then
              DP_subclass <= SFT_REG;
            end if;
          end if;
          instr_class <= "00";
          case instruction (24 downto 21) is 
            when "0000" =>
                  operation <= ANDD;
            when "0001" =>
                  operation <= EOR;
            when "0010" =>
                  operation <= SUB;
            when "0011" =>
                  operation <= RSB;
            when "0100" =>
                  operation <= ADD;
            when "0101" =>
                  operation <= ADC;
            when "0110" =>
                  operation <= SBC;
            when "0111" =>
                  operation <= RSC;
            when "1000" =>
                  operation <= TST;
            when "1001" =>
                  operation <= TEQ;
            when "1010" =>
                  operation <= CMP;
            when "1011" =>
                  operation <= CMN;
            when "1100" =>
                  operation <= ORR;
            when "1101" =>
                  operation <= MOV;
            when "1110" =>
                  operation <= BIC;
            when others =>
                  operation <= MVN;
          end case;
          if ((instruction(25) = '0') and (instruction(11 downto 7)="11110") and (instruction(4)='1')) then
            not_implemented <= '1';
          elsif ((instruction(25 downto 23) = "000") and (instruction(7 downto 4)="1001")) then
            instr_class <= "01";                  
            if (instruction(21)='0') then
              -- MUL case
              operation <= MOV;
            else
              -- MLA case
              operation <= ADD;
            end if;
          elsif ((instruction(25 downto 23) = "001") and (instruction(7 downto 4)="1001")) then
            not_implemented <= '1';
          elsif ((instruction(25 downto 24) = "01") and (instruction(7 downto 4)="1001")) then
            not_implemented <= '1';
          elsif ((instruction(25) = '0') and (instruction(7) = '1') and (instruction(4) = '1')and (instruction(6 downto 5)/="00")) then
            instr_class <= "10";                
            DT_subclass <= HWRD;
            case instruction (23) is
                when '0' =>
                    operation <= SUB;
                when others =>
                    operation <= ADD;
            end case;
          end if;
        when "01" =>
          instr_class <= "10";
          DT_subclass <= WRD;
          if ( (instruction(25)='1') and (instruction(4)='1')) then
            undefined <= '1';
          else
            case instruction (23) is
              when '0' =>
                operation <= SUB;
              when others =>
                operation <= ADD;
            end case;
          end if;
        when "10" =>
          instr_class <= "11";
          if ( (instruction(25)='0')) then
            not_implemented <= '1';
          end if;
        when others =>
          not_implemented <= '1';
      end case;
  end process;

end Behavioral;

