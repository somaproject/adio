library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;


entity digitaltest is
  port (
    -- DeviceLink Serial Interface
    REFCLKIN  : in  std_logic;
    DOUT : out std_logic_vector(31 downto 0);
    -- STATUS LEDS
    LEDLINK   : out std_logic;
    LEDEVENT  : out std_logic);
end digitaltest;


architecture Behavioral of digitaltest is
  signal clk : std_logic := '0';
  signal cnt : std_logic_vector(23 downto 0) := (others => '0');
  
begin  -- Behavioral

  clk <= REFCLKIN;

  process(CLK)
    begin
      if rising_edge(CLK) then
        cnt <= cnt + 1;

        LEDLINK <= cnt(23);
        LEDEVENT <= cnt(22);

        DOUT <= (others => cnt(21)); 
      end if;
    end process; 

end Behavioral;
