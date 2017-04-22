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

signal sig_wea_mem : std_logic vector(3 downto 0) := (others=>'0');
signal temp_wea_mem : std_logic vector(3 downto 0) := (others=>'0');
signal is_write : std_logic := '0';
signal sig_addr_mem : std_logic vector(11 downto 0) := (others=>'0');
signal sig_din_mem : std_logic vector(31 downto 0) := (others=>'0');
signal sig_dout_mem : std_logic vector(31 downto 0) := (others=>'0');
signal temp_dout_mem : std_logic vector(31 downto 0) := (others=>'0');

TYPE STATE_TYPE IS (s0, s1, s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
SIGNAL state   : STATE_TYPE := s0;
begin

mem_slave: memory_uart port map (
    CLK  => HCLK,
    RST  => HRESETn,
    UART_TX => UART_TX,
    UART_RX => UART_RX,
    LAST_DATA_RX  => LAST_DATA_RX,
    ENABLE_TX => ENABLE_TX,
    ENABLE_RX => ENABLE_RX,
    UART_RX_CNT  => UART_RX_CNT,
    CLK_MEM  => CLK_MEM,
    ENA_MEM  => ENA_MEM,
    WEA_MEM  => sig_wea_mem,
    ADDR_MEM  => sig_addr_mem,
    DIN_MEM  => sig_din_mem,
    DOUT_MEM  => sig_dout_mem
);

HRESP <= '0';
HRDATA <= sig_dout_mem;

process(HCLK)
    if HCLK='1' and HLK'event then
        if HRESETn='1' then
            state <= s0;
            sig_wea_mem <= "0000";
            HREADYOUT <= '1';
            is_write <= '0';
        else
            case state is
                when s0 =>
                    if(HWRITE = '1') then
                        is_write <= '1';
                    else
                        is_write <= '0';
                    end if;

                    sig_wea_mem <= "0000";

                    if(HTRANS = "00") then
                        HREADYOUT <= '1';
                    elsif (HTRANS="10" and HBURST="000")
                        sig_addr_mem <= HADDR(15 downto 4);
                        temp_wea_mem <= HADDR(3 downto 0);
                        HREADYOUT <= '0';
                        if(HWRITE = '1') then
                            state <= s1;
                        else
                            state <= s2;
                        end if;
                    elsif (HBURST="010")
                        sig_addr_mem <= HADDR(15 downto 4);
                        temp_wea_mem <= HADDR(3 downto 0);
                        HREADYOUT <= '0';
                        state <= s3;
                    end if;
                when s1 =>
                -- single read start
                    sig_wea_mem <= "0000";
                    HREADYOUT <= '0';
                    state <= s4;
                when s2 =>
                -- single write start
                    sig_wea_mem <= temp_wea_mem;
                    sig_din_mem <= HWDATA;
                    HREADYOUT <= '0';
                    state <= s6;
                when s3 =>
                -- BURST mode start
                    
                when s4 =>
                -- middle stage of read single
                    temp_dout_mem <= sig_dout_mem;
                    HWDATA <= sig_dout_mem;
                    sig_wea_mem <= "0000";
                    HREADYOUT <= '0';
                    state <= s5;
                when s5 =>
                -- last stage of read single
                    sig_wea_mem <= "0000";
                    HRDATA <= temp_dout_mem;
                    HREADYOUT <= '1';
                    state <= s0;
                when s6 =>
                -- middle stage of write single
                    HREADYOUT <= '0';
                    state <= s7;
                when s7 =>
                -- final stage of write single
                    HREADYOUT <= '1';
                    state <= s0;
                when s8 =>
                when s9 =>
                when s10 =>
            end case;
        end if;
    end if;
end process;

end Behavioral;


