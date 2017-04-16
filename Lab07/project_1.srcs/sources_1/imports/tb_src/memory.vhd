----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2017 15:34:17
-- Design Name: 
-- Module Name: memory - Behavioral
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

entity memory_uart is
--  Port ( );
PORT(
--    CLK : in std_logic;
--    RST : in std_logic;

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
--    WEA_MEM : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--    ADDR_MEM : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
--    DIN_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    DOUT_MEM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    
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
end memory_uart;

architecture Behavioral of memory_uart is

component uart port(
    reset: IN STD_LOGIC;
    txclk    : IN STD_LOGIC;
    ld_tx_data     : IN STD_LOGIC;
    tx_data        : IN STD_LOGIC_VECTOR(7 downto 0);
    tx_enable      : IN STD_LOGIC;
    tx_out         : OUT STD_LOGIC;
    tx_empty       : OUT STD_LOGIC;
    rxclk          : IN STD_LOGIC;
    uld_rx_data    : IN STD_LOGIC;
    rx_data        : OUT STD_LOGIC_VECTOR(7 downto 0);
    rx_enable      : IN STD_LOGIC;
    rx_in          : IN STD_LOGIC;
    rx_empty: OUT STD_LOGIC
    );
end component;

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

component rng_xoroshiro128plus 
    generic (
        -- Default seed value.
        init_seed:  std_logic_vector(127 downto 0) );
    port (
        -- Clock, rising edge active.
        clk:        in  std_logic;
        -- Synchronous reset, active high.
        rst:        in  std_logic;
        -- High to request re-seeding of the generator.
        reseed:     in  std_logic;
        -- New seed value (must be valid when reseed = '1').
        newseed:    in  std_logic_vector(127 downto 0);
        -- High when the user accepts the current random data word
        -- and requests new random data for the next clock cycle.
        out_ready:  in  std_logic;
        -- High when valid random data is available on the output.
        -- This signal is low during the first clock cycle after reset and
        -- after re-seeding, and high in all other cases.
        out_valid:  out std_logic;
        -- Random output data (valid when out_valid = '1').
        -- A new random word appears after every rising clock edge
        -- where out_ready = '1'.
        out_data:   out std_logic_vector(63 downto 0) );
end component;

signal CLK : std_logic;
signal RST : std_logic;
signal WEA_MEM : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal ADDR_MEM : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal DIN_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal DOUT_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal prng_data: std_logic_vector(63 downto 0);
signal addr_rx: std_logic_vector(31 downto 0) := X"00000000";
signal addr_tx: std_logic_vector(31 downto 0) := X"00000000";
signal serial_data: std_logic;
signal data_rx: std_logic_vector(7 downto 0);
signal data_tx: std_logic_vector(7 downto 0);
signal rx_empty: std_logic;
signal rx_empty_not: std_logic;
signal rx_empty_not_delayed: std_logic;
signal tx_empty: std_logic;
signal tx_clk : std_logic;
signal rx_clk : std_logic;
signal count_txclk: std_logic_vector(13 downto 0);
signal count_rxclk: std_logic_vector(13 downto 0);
signal dout_mem_uart: std_logic_vector(31 downto 0);
signal count_rx : std_logic_vector(15 downto 0);
constant BIT_TMR_MAX : std_logic_vector(13 downto 0) := "00000101000101"; --10416/16 = (round(100MHz / 9600*16)) - 1 //for 9600 BR
constant BIT_TMR_MAX_TX : std_logic_vector(13 downto 0) := "01010001011000"; --10416/16 = (round(100MHz / 9600*16)) - 1 //for 9600 BR
--constant BIT_TMR_MAX : std_logic_vector(13 downto 0) := "00000000011011"; --10416/16 = (round(100MHz / 9600*16)) - 1 //for 115200 BR

signal data_count : std_logic_vector(3 downto 0);
--signal rx_empty_not: std_logic;
signal mem_write_mode : std_logic;
signal mem_clkb, mem_enb : std_logic;
signal mem_web : std_logic_vector(0 downto 0);
signal mem_addrb : std_logic_vector(31 downto 0);
signal mem_dinb : std_logic_vector(7 downto 0);

begin

with ENABLE_TX select 
    mem_write_mode <= '0' when '1',
                      ENABLE_RX when others;
                      
with mem_write_mode select
    mem_clkb <=  rx_clk when '1', tx_clk when others;
    
with mem_write_mode select
    mem_enb <=  rx_empty_not_delayed when '1', '1' when others;
        
with mem_write_mode select
    mem_web <=  (others=>'1') when '1', (others=>'0') when others;
    
with mem_write_mode select
    mem_addrb <=  addr_rx when '1', addr_tx when others;     
                                    
with mem_write_mode select
    mem_dinb <=  data_rx when '1', (others=>'0') when others;       

bram_0: blk_mem_gen_0 port map(
    clka => CLK_MEM,
    ena => ENA_MEM,
    wea => WEA_MEM,
    addra => ADDR_MEM,
    dina => DIN_MEM,
    douta => DOUT_MEM,
    clkb => mem_clkb,
    enb => mem_enb,
    web => mem_web,
    addrb => mem_addrb(13 downto 0),
    dinb => mem_dinb,
    doutb => dout_mem_uart(7 downto 0)
);


pdelay_rx_empty_not: process (rx_clk) begin
if (rx_clk'event and rx_clk = '1') then
    rx_empty_not_delayed <= rx_empty_not;
end if;
end process;

paddr_rx: process(rx_clk, RST) begin
if (RST = '1') then
    addr_rx <= (others => '0');
    count_rx <= (others => '0');
elsif (rx_clk'event and rx_clk = '1') then
    if (rx_empty_not_delayed = '1') then
        addr_rx <= addr_rx + 1;
        count_rx <= count_rx+1;
    end if;
end if;    
end process;

paddr_tx: process(tx_clk, RST) begin
if (RST = '1') then
    addr_tx <= (others => '0');
elsif (tx_clk'event and tx_clk = '1') then
    if (tx_empty = '1') then
        addr_tx <= addr_tx + 1;
    end if;
end if;    
end process;

pdiv_rxclk: process(CLK, RST) begin
if (RST = '1') then
    rx_clk <= '0';
    count_rxclk <= (others => '0');
elsif (CLK'event and CLK = '1') then
    count_rxclk <= count_rxclk + 1;
    if (count_rxclk = BIT_TMR_MAX) then
        rx_clk <= not rx_clk;
        count_rxclk <= (others => '0');
    end if;    
end if; 
end process;


pdiv_txclk: process(CLK, RST) begin
if (RST = '1') then
    tx_clk <= '0';
    count_txclk <= (others => '0');
elsif (CLK'event and CLK = '1') then
    count_txclk <= count_txclk + 1;
    if (count_txclk = BIT_TMR_MAX_TX) then
        tx_clk <= not tx_clk;
        count_txclk <= (others => '0');        
    end if;    
end if; 
end process;

--data_tx <= X"42"; --send char B for testing purpose
data_tx <= dout_mem_uart(7 downto 0); 
--data_tx <= prng_data(7 downto 0);     --send random data.
--data_tx <= X"41" + data_count(3 downto 0);

Pdata: process (CLK, RST) begin

if (RST = '1') then
    data_count <= (others => '0');
elsif (CLK = '1' and CLK'event) then
  if (tx_empty = '1') then
    data_count <= data_count + 1;
  end if;
end if;    

end process;

LAST_DATA_RX(7 downto 0) <= data_rx;
UART_RX_CNT <= count_rx;

uart_inst: uart port map (
    reset => RST,
    txclk => tx_clk         ,
    ld_tx_data  => '1'   ,
    tx_data     =>  data_tx  ,
    tx_enable   => ENABLE_TX  ,
    tx_out      => UART_TX   ,
    tx_empty    => tx_empty,  
    rxclk       => rx_clk   ,
    uld_rx_data => (rx_empty_not)   ,
    rx_data     => data_rx   ,
    rx_enable   => ENABLE_RX   ,
    rx_in       => UART_RX   ,
    rx_empty    => rx_empty
);

rx_empty_not <= not rx_empty;

end Behavioral;
