library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity ARM_alu is
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
end;

architecture behavioural of ARM_alu is
------------------------------------------------------------------------------------------------------------------------
--IMPORTANT INSTRUCTIONS FOR STUDENTS
--fill up the below portion of the code as a part of assignment-5
--No change in any other part of the code is expected from this assignment and will cause unwanted failures.
------------------------------------------------------------------------------------------------------------------------
signal temp_result: STD_LOGIC_VECTOR (31 downto 0) := (others=>'0');
signal carry_last_second: STD_LOGIC := '0';
signal carry_last: STD_LOGIC := '0';
signal valid_instruction: STD_LOGIC := '1';
signal force_set: STD_LOGIC := '0';
signal is_set: STD_LOGIC := '0';

begin
    is_set <= '1'; --force_set or instruction(20);
    next_N <= (is_set and valid_instruction and temp_result(31)) or ((not is_set) and N_in);
    with temp_result select
        next_Z <=  (is_set and valid_instruction and '1') or ((not is_set) and Z_in) when X"00000000",
                   (is_set and valid_instruction and '0') or ((not is_set) and Z_in) when others ;
    carry_last_second <= temp_result(31) xor operand1(31) xor operand2(31);
    carry_last <= ((operand1(31) and operand2(31))or(operand1(31) and carry_last_second)or(operand2(31) and carry_last_second));
    next_C <= (is_set and valid_instruction and carry_last) or ((not is_set) and C_in);
    next_V <= (is_set and valid_instruction and (carry_last xor carry_last_second)) or ((not is_set) and V_in);

    result <= temp_result ;
    
    process(operand1,operand2,N_in,V_in,C_in,Z_in,instruction,valid_instruction,is_set,force_set)
    begin
--        predicate <= '1';
        case instruction( 31 downto 28) is 
            when "0000" =>
                predicate <= valid_instruction and (Z_in);
            when "0001" =>
                predicate <= valid_instruction and (not Z_in);
            when "0010" =>
                predicate <= valid_instruction and (C_in);
            when "0011" =>
                predicate <= valid_instruction and (not C_in);
            when "0100" =>
                predicate <= valid_instruction and (N_in);
            when "0101" =>
                predicate <= valid_instruction and (not N_in);
            when "0110" =>
                predicate <= valid_instruction and (V_in);
            when "0111" =>
                predicate <= valid_instruction and (not V_in);
            when "1000" =>
                predicate <= valid_instruction and (C_in and (not Z_in));
            when "1001" =>
                predicate <= valid_instruction and ((not C_in) or (Z_in));
            when "1010" =>
                predicate <= valid_instruction and (not (N_in xor V_in));
            when "1011" =>
                predicate <= valid_instruction and ((N_in xor V_in));
            when "1100" =>
                predicate <= valid_instruction and ((not Z_in) and (not (N_in xor V_in)));
            when "1101" =>
                predicate <= valid_instruction and ((Z_in) or (N_in xor V_in));
            when "1110" =>
                predicate <= valid_instruction and ('1');
            when others =>
                predicate <= valid_instruction and ('0' );
        end case;




        case instruction (27 downto 26) is
            when "00" =>
                case instruction (24 downto 21) is 
                  when "0000" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= (operand1 and operand2);
                  when "0001" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <=  (operand1 xor operand2);
                  when "0010" =>
                        valid_instruction <= '1';
                        force_set <= '0';
--                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand1))-to_integer(signed(operand2))),32));
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(not operand2))+to_integer(unsigned'('0'&'1'))),32));
                  when "0011" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(not operand1))+to_integer(signed(operand2))+to_integer(unsigned'('0'&'1'))),32));
--                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))-to_integer(signed(operand1))),32));
                  when "0100" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))),32)) ;
                  when "0101" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))+to_integer(unsigned'('0'&C_in))),32));
                  when "0110" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(not operand2))+to_integer(unsigned'('0'&C_in))),32));
                  when "0111" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(not operand1))+to_integer(unsigned'('0'&C_in))),32));
                  when "1000" =>
                        valid_instruction <= '1';
                        temp_result <=  (operand1 and operand2);
                        force_set <= '1';
                  when "1001" =>
                        valid_instruction <= '1';
                        temp_result <=  (operand1 xor operand2);
                        force_set <= '1';

                  when "1010" =>
                        valid_instruction <= '1';
                        force_set <= '1';
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(not operand2)))+1,32)) ;
                  when "1011" =>
                        valid_instruction <= '1';
                        force_set <= '1';
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(operand2))),32));
                  when "1100" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= (operand1 or operand2);
                  when "1101" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= (operand2) ;
                  when "1110" =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= (operand1 and (not operand2));
                  when others =>
                        valid_instruction <= '1';
                        force_set <= '0';
                        temp_result <= (not operand2) ;
                end case;
                if ((instruction(25) = '0') and (instruction(11 downto 7)="11110") and (instruction(4)='1')) then
                    temp_result <= X"00000000";
                    valid_instruction <= '0';
                elsif ((instruction(25 downto 23) = "000") and (instruction(7 downto 4)="1001")) then
                    if (instruction(21)='0') then
                        temp_result <= operand2;
                    else
                        temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))),32)) ;
                    end if;
                    valid_instruction <= '1';
                elsif ((instruction(25 downto 23) = "001") and (instruction(7 downto 4)="1001")) then
                        temp_result <= X"00000000";
                        valid_instruction <= '0';
                elsif ((instruction(25 downto 24) = "01") and (instruction(7 downto 4)="1001")) then
                        temp_result <= X"00000000";
                        valid_instruction <= '0';
                elsif ((instruction(25) = '0') and (instruction(7) = '1') and (instruction(4) = '1')and (instruction(6 downto 5)/="00")) then
                    case instruction (23) is
                        when '0' =>
                            valid_instruction <= '1';
                            force_set <= '0';
                            temp_result <= std_logic_vector(to_signed((to_integer(signed(operand1))-to_integer(signed(operand2))),32));
                        when others =>
                            valid_instruction <= '1';
                            force_set <= '0';
                            temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))),32)) ;
                    end case;
                end if;
            when "01" =>
                if ( (instruction(25)='1') and (instruction(4)='1')) then
                    temp_result <= X"00000000";
                    valid_instruction <= '0';
                else
                    case instruction (23) is
                        when '0' =>
                            valid_instruction <= '1';
                            force_set <= '0';
                            temp_result <= std_logic_vector(to_signed((to_integer(signed(operand1))-to_integer(signed(operand2))),32));
                        when others =>
                            valid_instruction <= '1';
                            force_set <= '0';
                            temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))),32)) ;
                    end case;
                end if;
            when "10" =>
                if ( (instruction(25)='1')) then
                    valid_instruction <= '1';
                    force_set <= '0';
                    temp_result <= std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))),32)) ;
                else
                    temp_result <= X"00000000";
                    valid_instruction <= '0';
                end if;
            when others =>
                force_set <= '0';
                valid_instruction <= '0';
                temp_result <= X"00000000";
        end case;
    end process;
        
end behavioural;

