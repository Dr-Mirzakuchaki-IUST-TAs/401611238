library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI is
    Port ( 
			  -- Inputs
			  CLK_SYS : in  STD_LOGIC;
           start : in  STD_LOGIC;
			  SDO : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  -- Outputs
           CE : out  STD_LOGIC;
			  SCK : out  STD_LOGIC;
			  SDI : out STD_LOGIC);
end SPI;

architecture Behavioral of SPI is
	-- In/Outs
	signal start_int : STD_LOGIC := '0';
	signal reset_int : STD_LOGIC := '0';
	signal SCK_int : STD_LOGIC := 'Z';
	signal CE_int : STD_LOGIC := '0';
	signal SDI_int : STD_LOGIC := '0';
	signal SDO_int : STD_LOGIC := 'Z';
	signal add_byte_int : STD_LOGIC_VECTOR (7 downto 0);
	signal data_byte_int : STD_LOGIC_VECTOR (7 downto 0);
	-- Control Signals
	signal bit_cnt : unsigned (3 downto 0) := "0000";
	-- states
	type FSM is (idle,starter,starter_dly,read_data,write_data,rw_dly);
	signal state : FSM := idle;
	
	constant add_byte : STD_LOGIC_VECTOR (7 downto 0) := "01010101";
	constant data_byte : STD_LOGIC_VECTOR (7 downto 0) := "01010101";
	
begin

	CE <= CE_int;
	SDO_int <= SDO;
	SDI <= SDI_int;
	SCK <= SCK_int;
	reset_int <= reset;
	
	process (CLK_SYS)
	begin
	
		if (rising_edge (CLK_SYS)) then
			if (reset_int = '1') then
				CE_int <= '0';
				state <= idle;
				SDI_int <= '0';
				SDO_int <= 'Z';
			else
				add_byte_int <= add_byte;
				start_int <= start;
			
				case state is
					when idle =>
						bit_cnt <= "0111";
					
						if (start_int = '1') then
							state <= starter;
							CE_int <= '1';
						else
							state <= idle;
							CE_int <= '0';
						end if;
				
				
					when starter =>
						CE_int <= '1';
						SDI_int <= add_byte_int (to_integer(bit_cnt));
					
					
						if (bit_cnt /= 0) then
							state <= starter;
							bit_cnt <= bit_cnt - 1;
						else 
							bit_cnt <= "1000";
							state <= starter_dly;

						end if;
				
					when starter_dly =>
						CE_int <= '1';
						SDI_int <= 'Z';
						bit_cnt <= bit_cnt - 1;
							if (add_byte_int(7) = '0') then
							state <= read_data;
						
							else
							state <= write_data;
							data_byte_int <= data_byte;
							end if;	
					
				
					when read_data =>
						CE_int <= '1';
						data_byte_int (to_integer(bit_cnt)) <= SDO_int;
					
					
						if (bit_cnt /= 0) then
							state <= read_data;
							bit_cnt <= bit_cnt - 1;
						else
							state <= rw_dly;
						end if;
				
					when write_data =>
						
						CE_int <= '1';
						SDI_int <= data_byte_int (to_integer(bit_cnt));
					
					
						if (bit_cnt /= 0) then
							state <= write_data;
							bit_cnt <= bit_cnt - 1;
						else
							state <= rw_dly;
						end if;
					
					when rw_dly =>
						state <= idle;
						CE_int <= '0';
						bit_cnt <= "0111";
					
				end case;
			end if;
		end if;
		if (CE_int = '1' and state /= idle) then
			SCK_int <= not (CLK_SYS);
		else
			SCK_int <= 'Z';
		end if;
	end process;

end Behavioral;

