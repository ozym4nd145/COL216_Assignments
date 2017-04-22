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
--		HPROT:   OUT std_logic_vector (3 downto 0);
    HTRANS : OUT std_logic_vector (1 downto 0);
--		HMASTLOCK: OUT std_logic;
    HWDATA : OUT std_logic_vector (31 downto 0)

    );
end master_cpu;

architecture Behavioral of master_cpu is

component ARM_CPU 
	PORT (
--		CLK_CPU : IN STD_LOGIC;
--		RST : IN std_logic;
		
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
END component;


begin

master_cpu: ARM_CPU port map (
    HREADY  , 
		HRESP ,
		HCLK ,
		HRESETn ,
		HRDATA ,				
		HADDR ,
		HWRITE ,
		HSIZE ,
		HBURST ,
		HTRANS ,
		HWDATA
);

end Behavioral;
