----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2017 15:34:17
-- Design Name: 
-- Module Name: slave_mem - Behavioral
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

entity slave_memory is
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
    
    HSELx : IN STD_LOGIC;
    HADDR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    HWRITE: IN_STD_LOGIC;
    HSIZE:  IN_STD_LOGIC_VECTOR(2 DOWNTO 0);
    HBURST:  IN_STD_LOGIC_VECTOR(2 DOWNTO 0);
--    HPROT:  IN_STD_LOGIC_VECTOR(3 DOWNTO 0);
    HTRANS:  IN_STD_LOGIC_VECTOR(1 DOWNTO 0);
--    HMASTLOCK:  IN_STD_LOGIC;
    HREADY:  IN_STD_LOGIC;
    
    HWDATA:  IN_STD_LOGIC_VECTOR(31 DOWNTO 0);

    HREADYOUT: OUT STD_LOGIC;
    HRESP: OUT STD_LOGIC;

    HRDATA: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
end slave_mem;

architecture Behavioral of slave_mem is


component memory_uart PORT(
    CLK : in std_logic;
    RST : in std_logic;
    UART_TX: out std_logic;
    UART_RX: in std_logic;
    LAST_DATA_RX : out std_logic_vector(7 downto 0);
    ENABLE_TX: in std_logic;
    ENABLE_RX: in std_logic;
    UART_RX_CNT : out std_logic_vector(15 downto 0);
    CLK_MEM : IN STD_LOGIC;
    ENA_MEM : IN STD_LOGIC;
    WEA_MEM : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ADDR_MEM : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    DIN_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOUT_MEM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component;

begin

mem_slave: memory_uart port map (
    CLK  => ,
    RST  => ,
    UART_TX => ,
    UART_RX => ,
    LAST_DATA_RX  => ,
    ENABLE_TX => ,
    ENABLE_RX => ,
    UART_RX_CNT  => ,
    CLK_MEM  => ,
    ENA_MEM  => ,
    WEA_MEM  => ,
    ADDR_MEM  => ,
    DIN_MEM  => ,
    DOUT_MEM  => 
);

end Behavioral;


