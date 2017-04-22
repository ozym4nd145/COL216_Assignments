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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY master_cpu IS
	-- Port ();
	PORT 
	(
		HRESETn       : IN STD_LOGIC;
		HCLK          : IN STD_LOGIC;

		UART_TX       : OUT std_logic;
		UART_RX       : IN std_logic;
		LAST_DATA_RX  : OUT std_logic_vector(7 DOWNTO 0);
		ENABLE_TX     : IN std_logic;
		ENABLE_RX     : IN std_logic;
		UART_RX_CNT   : OUT std_logic_vector(15 DOWNTO 0);
		CLK_MEM       : IN STD_LOGIC;
		ENA_MEM       : IN STD_LOGIC;
 
		HREADY        : IN std_logic;
		HRESP         : IN std_logic;
		HCLK          : IN std_logic;
		HRESETn       : IN std_logic;
		HRDATA        : IN std_logic_vector (31 DOWNTO 0);
 
		HADDR         : OUT std_logic_vector (15 DOWNTO 0);
		HWRITE        : OUT std_logic;
		HSIZE         : OUT std_logic_vector (2 DOWNTO 0);
		HBURST        : OUT std_logic_vector (2 DOWNTO 0);
		HTRANS        : OUT std_logic_vector (1 DOWNTO 0);
		HWDATA        : OUT std_logic_vector (31 DOWNTO 0)
	);
END master_cpu;

ARCHITECTURE Behavioral OF master_cpu IS

	COMPONENT ARM_CPU
		PORT 
		(
			CLK_CPU   : IN STD_LOGIC;
			RST       : IN std_logic;
			WEA_MEM   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			ADDR_MEM  : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			DIN_MEM   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DOUT_MEM  : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
 
	TYPE STATE_TYPE IS (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
	SIGNAL state : STATE_TYPE := s0;

	SIGNAL sig_din_mem : std_logic vector(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sig_dout_mem : std_logic vector(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sig_wea_mem : std_logic vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL sig_addr_mem : std_logic vector(11 DOWNTO 0) := (OTHERS => '0');

BEGIN
	master_cpu : ARM_CPU
	PORT MAP
	(
		CLK_CPU   => HCLK, 
		RST       => HRESETn, 
		WEA_MEM   => sig_wea_mem, 
		ADDR_MEM  => sig_addr_mem, 
		DIN_MEM   => sig_din_mem, 
		DOUT_MEM  => sig_dout_mem
	);

	PROCESS (HCLK)
	IF HCLK = '1' AND HLK'EVENT THEN
		IF HRESETn = '1' THEN
			state <= s0;
			sig_dout_mem <= (OTHERS => '0');
			HWRITE <= '0';
			HTRANS <= "00";
			HWDATA <= (OTHERS => '0');
		ELSE
			CASE state IS
				WHEN s0 => 
					IF (WEA_MEM = "0000") THEN
						state <= s1;
						HADDR <= sig_wea_mem & sig_addr_mem;
						HWRITE <= '0';
						HBURST <= "000";
						HTRANS <= "10";
						--read --
					ELSE
						state <= s2;
						HTRANS <= "10";
						HBURST <= "000";
						HADDR <= sig_wea_mem & sig_addr_mem;
						HWRITE <= '1';
					END IF;
				WHEN s1 => 
					state <= s3; 
				WHEN s2 => 
					HWDATA <= sig_din_mem;
					state <= s6;
				WHEN s3 => 
					state <= s4; 
				WHEN s4 => 
					state <= s5; 
				WHEN s5 => 
					sig_dout_mem <= HRDATA;
					state <= s0;
				WHEN s6 => 
					state <= s7;
				WHEN s7 => 
					state <= s8;
				WHEN s8 => 
					state <= s9;
				WHEN s9 => 
					state <= s0;
			END CASE;
 
		END IF;
	END IF;
END PROCESS;

 
END Behavioral;
