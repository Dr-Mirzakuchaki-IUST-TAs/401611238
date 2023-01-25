LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY SPI_tb IS
END SPI_tb;
 
ARCHITECTURE behavior OF SPI_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
--    COMPONENT SPI
--    PORT(
--         CLK_SYS : IN  std_logic;
--         start : IN  std_logic;
--         SDO : IN  std_logic;
--         reset : IN  std_logic;
--         CE : OUT  std_logic;
--         SCK : OUT  std_logic;
--         SDI : OUT  std_logic
--        );
--    END COMPONENT;
    

   --Inputs
   signal CLK_SYS : std_logic := '0';
   signal start : std_logic := '0';
   signal SDO : std_logic := '0';
   signal reset : std_logic := '0';
--	signal add_byte_int : STD_LOGIC_VECTOR (7 downto 0);
--	signal data_byte_int : STD_LOGIC_VECTOR (7 downto 0);

 	--Outputs
   signal CE : std_logic;
   signal SCK : std_logic;
   signal SDI : std_logic;

   -- Clock period definitions
   constant CLK_SYS_period : time := 200 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.SPI PORT MAP (
          CLK_SYS => CLK_SYS,
          start => start,
          SDO => SDO,
          reset => reset,
          CE => CE,
          SCK => SCK,
          SDI => SDI
        );

   -- Clock process definitions
   CLK_SYS_process :process
   begin
		CLK_SYS <= '0';
		wait for CLK_SYS_period/2;
		CLK_SYS <= '1';
		wait for CLK_SYS_period/2;
   end process;
	
	start_pro: process
	begin
		start <= '0', '1' after 1us, '0' after 1.5us, '1' after 6us, '0' after 6.5us;
		reset <= '0', '1' after 4us, '0' after 5us;
		wait;
	end process start_pro;

   -- Stimulus process
--   stim_proc: process
--   begin		
--      -- hold reset state for 100 ns.
--      wait for 100 ns;	
--
--      wait for CLK_SYS_period*10;
--
--      -- insert stimulus here 
--
--      wait;
--   end process;

END;
