----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2017 15:34:17
-- Design Name: 
-- Module Name: master_cpu - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity master_cpu is
--  Port ( );
PORT(
    HRESETn : IN STD_LOGIC;
    HCLK : IN STD_LOGIC;

    UART_TX: out std_logic;
    UART_RX: in std_logic;
    LAST_DATA_RX : out std_logic_vector(7 downto 0);
    ENABLE_TX: in std_logic;
    ENABLE_RX: in std_logic;
    UART_RX_CNT : out std_logic_vector(15 downto 0);
    CLK_MEM : IN STD_LOGIC;
    ENA_MEM : IN STD_LOGIC;
    
    HREADY : IN std_logic;
    HRESP : IN std_logic;
    HCLK : IN std_logic;
    HRESETn : IN std_logic;
    HRDATA : IN std_logic_vector (31 downto 0);
    
    HADDR : OUT std_logic_vector (15 downto 0);
    HWRITE : OUT std_logic;
    HSIZE : OUT std_logic_vector (2 downto 0);
    HBURST : OUT std_logic_vector (2 downto 0);
    HTRANS : OUT std_logic_vector (1 downto 0);
    HWDATA : OUT std_logic_vector (31 downto 0)

    );
end master_cpu;

architecture Behavioral of master_cpu is

component ARM_CPU 
	PORT (
    CLK_CPU : IN STD_LOGIC;
    RST : IN std_logic;
    WEA_MEM :  OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ADDR_MEM : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    DIN_MEM :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOUT_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END component;
	
TYPE STATE_TYPE IS (s0, s1, s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
SIGNAL state   : STATE_TYPE := s0;

signal sig_din_mem : std_logic vector(31 downto 0) := (others=>'0');
signal sig_dout_mem : std_logic vector(31 downto 0) := (others=>'0');
signal sig_wea_mem : std_logic vector(3 downto 0) := (others=>'0');
signal sig_addr_mem : std_logic vector(11 downto 0) := (others=>'0');

begin

master_cpu: ARM_CPU port map (
    CLK_CPU => HCLK , 
    RST => HRESETn,
    WEA_MEM => sig_wea_mem,
    ADDR_MEM => sig_addr_mem,
    DIN_MEM => sig_din_mem,
    DOUT_MEM => sig_dout_mem
);

process(HCLK)
	if HCLK='1' and HLK'event then
		if HRESETn='1' then
		    state <= s0;
		    sig_dout_mem <= ( others => '0');
		    HWRITE <= '0';
			HWDATA <= ( others => '0') ;
		else
			
	    
	    
    end if;
end process;

	
end Behavioral;
