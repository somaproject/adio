library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

entity bufcapture is
  port (
    CLKA     : in  std_logic;
    DIN      : in  std_logic_vector(31 downto 0);
    DINEN    : in  std_logic;
    NEXTBUF  : in  std_logic;
    -- readout side
    CLKB     : in  std_logic;
    READADDR : in  std_logic_vector(11 downto 0);
    DOUT     : out std_logic_vector(35 downto 0)
    );
end bufcapture;

architecture Behavioral of bufcapture is

  signal bufaddr : std_logic_vector(2 downto 0) := (others => '0');

  signal wea : std_logic_vector(7 downto 0) := (others => '0');


  signal inaddr, inaddrl : std_logic_vector(8 downto 0)  := (others => '0');
  signal dinl            : std_logic_vector(31 downto 0) := (others => '0');

  type   dob_t is array (0 to 7) of std_logic_vector(31 downto 0);
  signal dob : dob_t := (others => (others => '0'));

  type   dop_t is array (0 to 7) of std_logic_vector(3 downto 0);
  signal dopb : dop_t := (others => (others => '0'));

  signal dipa, dipb : std_logic_vector(3 downto 0) := (others => '0');
  
begin  -- Behavioral
  rambuf : for i in 0 to 7 generate
    
    bufferA_inst : RAMB16_S36_S36
      generic map (
        SIM_COLLISION_CHECK => "NONE",
        -- Address 0 to 255
        INIT_00             => X"AAA1AAA2AAA3AAA4AAA5AAA6AAA7AAA8AAA9AAA01AAAA32AAFEDCB9876543210",
        INIT_01             => X"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB0DC2",
        INIT_02             => X"BCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0FE3",
        INIT_03             => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4",
        INIT_04             => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5",
        INIT_05             => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6",
        INIT_06             => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7",
        INIT_07             => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8",
        INIT_08             => X"FFF0000000000000000000000000000000000000000000000000000000000009",
        INIT_09             => X"000000000000000000000000000000000000000000000000000000000000000A")

      port map (
        DOA   => open,
        DOB   => dob(i),
        DOPA  => open,
        DOPB  => dopb(i),
        ADDRA => inaddrl,
        ADDRB => readaddr(8 downto 0),
        CLKA  => CLKA,
        CLKB  => CLKB,
        DIA   => dinl,
        DIB   => X"00000000",
        DIPA  => dipa,
        DIPB  => dipb,
        ENA   => '1',
        ENB   => '1',
        SSRA  => '0',
        SSRB  => '0',
        WEA   => wea(i),
        WEB   => '0'
        );
  end generate rambuf;

  DOUT <= dopb(0) & dob(0) when readaddr(11 downto 9) = "000" else
          dopb(1) & dob(1) when readaddr(11 downto 9) = "001" else
          dopb(2) & dob(2) when readaddr(11 downto 9) = "010" else
          dopb(3) & dob(3) when readaddr(11 downto 9) = "011" else
          dopb(4) & dob(4) when readaddr(11 downto 9) = "100" else
          dopb(5) & dob(5) when readaddr(11 downto 9) = "101" else
          dopb(6) & dob(6) when readaddr(11 downto 9) = "110" else
          dopb(7) & dob(7);
  
  main_a : process (CLKA)
  begin
    if rising_edge(CLKA) then

      if DINEN = '1' and bufaddr = "000" then
        wea(0) <= '1';
      else
        wea(0) <= '0';
      end if;


      if DINEN = '1' and bufaddr = "001" then
        wea(1) <= '1';
      else
        wea(1) <= '0';
      end if;


      if DINEN = '1' and bufaddr = "010" then
        wea(2) <= '1';
      else
        wea(2) <= '0';
      end if;


      if DINEN = '1' and bufaddr = "011" then
        wea(3) <= '1';
      else
        wea(3) <= '0';
      end if;


      if DINEN = '1' and bufaddr = "100" then
        wea(4) <= '1';
      else
        wea(4) <= '0';
      end if;


      if DINEN = '1' and bufaddr = "101" then
        wea(5) <= '1';
      else
        wea(5) <= '0';
      end if;


      if DINEN = '1' and bufaddr = "110" then
        wea(6) <= '1';
      else
        wea(6) <= '0';
      end if;


      if DINEN = '1' and bufaddr = "111" then
        wea(7) <= '1';
      else
        wea(7) <= '0';
      end if;


      if nextbuf = '1' then
      if bufaddr = "111" then
        null;
      else
        bufaddr <= bufaddr + 1;
      end if;
    end if;

    if nextbuf = '1' then
      inaddr <= (others => '0');
      dipa   <= "0001";
    else
      dipa <= "0000";
      if dinen = '1' and inaddr /= "111111111" then
        inaddr <= inaddr + 1;
      end if;
    end if;
    inaddrl <= inaddr;
    dinl    <= DIN;
    
    
  end if;
end process main_a;

end Behavioral;
