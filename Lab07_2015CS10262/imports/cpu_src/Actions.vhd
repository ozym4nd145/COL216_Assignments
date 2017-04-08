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
		instruction : out word;
		operation : in optype;
		op1_alu : out word;
		op2_alu : out word;
		result_alu : in word;
		op1_mul: out word;
		op2_mul: out word;
		result_mul: in word;
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

component ARM_rf is
    port (
        inp1 : in std_logic_vector (3 downto 0);
        inp2 : in std_logic_vector (3 downto 0);
        data : in std_logic_vector (31 downto 0);
        is_write : in std_logic;
        out1 : out std_logic_vector (31 downto 0);
        out2 : out std_logic_vector (31 downto 0)
    );
end component;

signal inp1_sig :std_logic_vector (3 downto 0); 
signal inp2_sig :std_logic_vector (3 downto 0); 
signal data_sig :std_logic_vector (31 downto 0); 
signal is_write_sig :std_logic; 
signal out1_sig :std_logic_vector (31 downto 0); 
signal out2_sig :std_logic_vector (31 downto 0); 
signal instr: std_logic_vector (31 downto 0);

signal flags_sig: nibble;

signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal C: std_logic_vector(31 downto 0);
signal D: std_logic_vector(31 downto 0);
signal O: std_logic_vector(31 downto 0);
signal E: std_logic_vector(31 downto 0);
signal Res: std_logic_vector(31 downto 0);
signal DR: std_logic_vector(31 downto 0);

begin
	

RF: ARM_rf port map (
        inp1=>      inp1_sig,
        inp2 =>     inp2_sig,
        data=>      data_sig,
        is_write => is_write_sig,
        out1 =>     out1_sig,
        out2 => out2_sig
);


process(control_state,result_alu,result_mul,DOUT_MEM,not_implemented,undefined,Shifter_out,predicate,rst,out1,out2)
case control_state is
     when s0 =>
		  WEA_MEM <= "0000";
          inp1_sig <= "1111";
          PC <= out1_sig; 
		  is_write_sig <= '0';
     when s1 =>   
          inp1_sig <= instr(19 downto 16);
          inp2_sig <= instr(3 downto 0);
          A <= out1_sig;
          B <= out2_sig;
		  is_write_sig <= '0';
     when s2 =>
        D <= std_logic_vector(rotate_right(unsigned(instr(7 downto 0)), (to_integer(unsigned(instr(11 downto 8))))*2) );
     when s3 =>   
        Shifter_in <= B;
        Shift_amount <= instr (11 downto 7) ;
        Shift_type <= instr (6 downto 5);
        D <= Shifter_out;
		is_write_sig <= '0';
     when s4 =>
        is_write <= 0;
        inp1_sig <= instr(11 downto 8);
        C <= out1_sig;
		is_write_sig <= '0';
     when s5 =>   
          Shifter_in <= B;
          Shift_amount <= C ;
          Shift_type <= instr (6 downto 5);
          D <= Shifter_out;
		is_write_sig <= '0';
     when s6 =>   
        op1_alu <= A;
        op2_alu <= D;
        Flags <= flags_sig;
        Res <= result_alu;
		is_write_sig <= '0';
     when s7 =>
         flags_sig <= nextFlags;   
         inp2_sig <= instr ( 15 downto 12 );
         data_sig <= Res;
         is_write_sig <= predicate;
     when s8 =>
	 	inp1_sig <= instr(11 downto 8);
		A <= out1;
	 	inp2_sig <= instr(15 downto 12);
		C <= out2;
		is_write_sig <= '0';
	 when s9 =>
	 	op1_mul <= A;
	 	op2_mul <= B;
		D <= result_mul;
		is_write_sig <= '0';
     when s10 =>   
	 	op1_alu <= C;
	 	op2_alu <= D;
		nextFlags <= flags_sig;
		Res <= result_alu;
		is_write_sig <= '0';
     when s11 =>   
		flags_sig <= Flags;
	 	inp2_sig <= instr(19 downto 16);
		data_sig <= Res;
		is_write_sig <= predicate;
     when s12 =>
	 	inp2_sig <= "1110";
		data_sig <= PC;
		is_write_sig <= predicate;
     when s13 =>   
	 	inp2_sig <= "1111";
		data_sig <= std_logic_vector(to_integer(unsigned(instr(23 downto 0)))+to_integer(signed(PC))+4,32);
		is_write_sig <= predicate;
     when s14 =>   
		O <= X"00000" & instr (11 downto 0);
		inp1_sig <= instr(15 downto 12);
		C <= out1_sig;
	   	is_write_sig <= '0';
     when s15 =>   
       Shifter_in <= B;
       Shift_amount <= instr( 11 downto 7) ;
       Shift_type <= instr (6 downto 5);
       O <= Shifter_out;
       inp1_sig <= instr(15 downto 12);
       C <= out1_sig;
	   is_write_sig <= '0';
     when s16 =>   
        inp1_sig <= instr(15 downto 12);
        C <= out1_sig;
        O <= B;     
		is_write_sig <= '0';
     when s17 =>   
        inp1_sig <= instr(15 downto 12);
        C <= out1_sig;
        O <= X"000000" & instr(11 downto 8) & instr (3 downto 0) ;
		is_write_sig <= '0';
     when s18 =>   
        op1_alu <= A;
        op2_alu <= O;
        Flags <= flags_sig;
        D <= result_alu;  
		is_write_sig <= '0';
		
     when s19 =>   
	 	inp2_sig <= instr(19 downto 16);
        data_sig <= D;
		is_write_sig <= predicate;
	
	-- TODO: Half word, signed half word, signed byte, unsigned byte and word.
     when s20 =>   
		WEA_MEM <= "0000";
	 	if (instr(24) = '0') then
			ADDR_MEM <= A(11 downto 0)
		else
			ADDR_MEM <= D(11 downto 0)
		end if;
		DR <= DOUT_MEM;
     when s21 =>   
		DIN_MEM <= C;
		if (instr(24) = '0') then
			ADDR_MEM <= A(11 downto 0)
		else
			ADDR_MEM <= D(11 downto 0)
		end if;
		WEA_MEM <= "1111";
				
     when s22 =>   
	 	inp2_sig <= instr(15 downto 12);
		data_sig <= DR;
		is_write_sig <= predicate;
		 
end case;

end Behavioral;

