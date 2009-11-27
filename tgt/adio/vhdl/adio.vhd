library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;


entity adio is
  port (
    -- DeviceLink Serial Interface
    REFCLKIN  : in  std_logic;
    REFCLKOUT : out std_logic;
    RXCLKIN   : in  std_logic;
    RXLOCKED  : in  std_logic;
    RXDIN     : in  std_logic_vector(9 downto 0);
    TXIO_P    : out std_logic;
    TXIO_N    : out std_logic;
    -- STATUS LEDS
    LEDLINK   : out std_logic;
    LEDEVENT  : out std_logic);
end adio;

architecture Behavioral of adio is

  component devicelink
    port (
      TXCLKIN   : in  std_logic;
      TXLOCKED  : in  std_logic;
      TXDIN     : in  std_logic_vector(9 downto 0);
      TXDOUT    : out std_logic_vector(7 downto 0);
      TXKOUT    : out std_logic;
      CLK       : out std_logic;
      CLK2X     : out std_logic;
      RESET     : out std_logic;
      RXDIN     : in  std_logic_vector(7 downto 0);
      RXKIN     : in  std_logic;
      RXIO_P    : out std_logic;
      RXIO_N    : out std_logic;
      DECODEERR : out std_logic
      );

  end component;


  signal txdata : std_logic_vector(7 downto 0) := (others => '0');
  signal txk    : std_logic                    := '0';

  signal rxdata, rxdatal : std_logic_vector(7 downto 0) := (others => '0');
  signal rxk, rxkl       : std_logic                    := '0';

  signal clk            : std_logic := '0';
  signal reset, dlreset : std_logic := '1';
  signal dcmlocked      : std_logic := '0';

  signal decodeerrint : std_logic := '0';

  component decodemux
    port (
      CLK    : in std_logic;
      DIN    : in std_logic_vector(7 downto 0);
      KIN    : in std_logic;
      LOCKED : in std_logic;

      ECYCLE : out std_logic;
      EDATA  : out std_logic_vector(7 downto 0);

      -- data interface
      DGRANTA      : out std_logic;
      EARXBYTEA    : out std_logic_vector(7 downto 0) := (others => '0');
      EARXBYTESELA : in  std_logic_vector(3 downto 0) := (others => '0');

      DGRANTB      : out std_logic;
      EARXBYTEB    : out std_logic_vector(7 downto 0) := (others => '0');
      EARXBYTESELB : in  std_logic_vector(3 downto 0) := (others => '0');

      DGRANTC      : out std_logic;
      EARXBYTEC    : out std_logic_vector(7 downto 0) := (others => '0');
      EARXBYTESELC : in  std_logic_vector(3 downto 0) := (others => '0');

      DGRANTD      : out std_logic;
      EARXBYTED    : out std_logic_vector(7 downto 0) := (others => '0');
      EARXBYTESELD : in  std_logic_vector(3 downto 0) := (others => '0')

      );
  end component;

  component encodemux
    port (
      CLK        : in  std_logic;
      ECYCLE     : in  std_logic;
      DOUT       : out std_logic_vector(7 downto 0);
      KOUT       : out std_logic;
      -- data interface
      DREQ       : in  std_logic;
      DGRANT     : out std_logic;
      DDONE      : in  std_logic;
      DDATA      : in  std_logic_vector(7 downto 0);
      -- event interface for DSPs
      EDSPREQ    : in  std_logic_vector(3 downto 0);
      EDSPGRANT  : out std_logic_vector(3 downto 0);
      EDSPDONE   : in  std_logic_vector(3 downto 0);
      EDSPDATAA  : in  std_logic_vector(7 downto 0);
      EDSPDATAB  : in  std_logic_vector(7 downto 0);
      EDSPDATAC  : in  std_logic_vector(7 downto 0);
      EDSPDATAD  : in  std_logic_vector(7 downto 0);
      -- event interface for EPROCs
      EPROCREQ   : in  std_logic_vector(3 downto 0);
      EPROCGRANT : out std_logic_vector(3 downto 0);
      EPROCDONE  : in  std_logic_vector(3 downto 0);
      EPROCDATAA : in  std_logic_vector(7 downto 0);
      EPROCDATAB : in  std_logic_vector(7 downto 0);
      EPROCDATAC : in  std_logic_vector(7 downto 0);
      EPROCDATAD : in  std_logic_vector(7 downto 0);
      DEBUG      : out std_logic_vector(15 downto 0));
  end component;

  signal eprocreq   : std_logic_vector(3 downto 0) := (others => '0');
  signal eprocgrant : std_logic_vector(3 downto 0) := (others => '0');
  signal eprocdone  : std_logic_vector(3 downto 0) := (others => '0');

  signal eprocdataa   : std_logic_vector(7 downto 0) := (others => '0');
  signal eprocdatab   : std_logic_vector(7 downto 0) := (others => '0');
  signal eprocdatac   : std_logic_vector(7 downto 0) := (others => '0');
  signal eprocdatad   : std_logic_vector(7 downto 0) := (others => '0');
  signal earxbytea    : std_logic_vector(7 downto 0) := (others => '0');
  signal earxbytesela : std_logic_vector(3 downto 0) := (others => '0');

  signal earxbyteal    : std_logic_vector(7 downto 0) := (others => '0');
  signal earxbyteselal : std_logic_vector(3 downto 0) := (others => '0');

  signal earxbyteaout    : std_logic_vector(7 downto 0) := (others => '0');

  signal clk2x, clk2xint : std_logic := '0';

  signal ecycle : std_logic                    := '0';
  signal EDATA  : std_logic_vector(7 downto 0) := (others => '0');

  signal linkup   : std_logic            := '0';
  component adioproc
    generic (
      RAM_INIT_00 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_01 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_02 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_03 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_04 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_05 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_06 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_07 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_08 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_09 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_0A : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_0B : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_0C : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_0D : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_0E : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_0F : bit_vector(0 to 255) := (others => '0');

      RAM_INIT_10 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_11 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_12 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_13 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_14 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_15 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_16 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_17 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_18 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_19 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_1A : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_1B : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_1C : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_1D : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_1E : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_1F : bit_vector(0 to 255) := (others => '0');

      RAM_INIT_20 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_21 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_22 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_23 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_24 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_25 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_26 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_27 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_28 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_29 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_2A : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_2B : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_2C : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_2D : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_2E : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_2F : bit_vector(0 to 255) := (others => '0');

      RAM_INIT_30 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_31 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_32 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_33 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_34 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_35 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_36 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_37 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_38 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_39 : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_3A : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_3B : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_3C : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_3D : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_3E : bit_vector(0 to 255) := (others => '0');
      RAM_INIT_3F : bit_vector(0 to 255) := (others => '0');

      RAM_INITP_00 :     bit_vector(0 to 255) := (others => '0');
      RAM_INITP_01 :     bit_vector(0 to 255) := (others => '0');
      RAM_INITP_02 :     bit_vector(0 to 255) := (others => '0');
      RAM_INITP_03 :     bit_vector(0 to 255) := (others => '0');
      RAM_INITP_04 :     bit_vector(0 to 255) := (others => '0');
      RAM_INITP_05 :     bit_vector(0 to 255) := (others => '0');
      RAM_INITP_06 :     bit_vector(0 to 255) := (others => '0');
      RAM_INITP_07 :     bit_vector(0 to 255) := (others => '0') );
    port (
      CLK          : in  std_logic;
      CLKHI        : in  std_logic;
      RESET        : in  std_logic;
      -- Event input
      ECYCLE       : in  std_logic;
      EARXBYTE     : in  std_logic_vector(7 downto 0);
      EARXBYTESEL  : out std_logic_vector(3 downto 0);
      EDRX         : in  std_logic_vector(7 downto 0);
      -- Event output 
      ESENDREQ     : out std_logic;
      ESENDGRANT   : in  std_logic;
      ESENDDONE    : out std_logic;
      ESENDDATA    : out std_logic_vector(7 downto 0);
      -- STATUS
      LEDEVENT     : out std_logic
      );
  end component;


  signal cnt : std_logic_vector(23 downto 0) := (others => '0');

  signal jtagcapture : std_logic := '0';
  signal jtagdrck1   : std_logic := '0';
  signal jtagdrck2   : std_logic := '0';
  signal jtagsel1    : std_logic := '0';
  signal jtagsel2    : std_logic := '0';
  signal jtagshift   : std_logic := '0';
  signal jtagtdi     : std_logic := '0';
  signal jtagtdo1    : std_logic := '0';
  signal jtagtdo2    : std_logic := '0';
  signal jtagupdate  : std_logic := '0';

  signal jtagwordout : std_logic_vector(47 downto 0) := (others => '0');
  signal jtagout     : std_logic_vector(63 downto 0) := (others => '0');

  signal ecyclecnt : std_logic_vector(23 downto 0) := (others => '0');
  
begin  -- adio

  devicelinkinst : devicelink
    port map (
      TXCLKIN   => RXCLKIN,
      TXLOCKED  => RXLOCKED,
      TXDIN     => RXDIN,
      TXDOUT    => rxdata,
      TXKOUT    => rxk,
      CLK       => clk,
      CLK2X     => clk2xint,
      RESET     => dlreset,
      RXDIN     => txdata,
      RXKIN     => txk,
      RXIO_P    => TXIO_P,
      RXIO_N    => TXIO_N,
      DECODEERR => decodeerrint);

  reset<= dlreset; 
  clk2x_bufg : BUFG
    port map (
      O => clk2x,
      I => clk2xint);


  REFCLKOUT <= REFCLKIN;

  decodemux_inst : decodemux
    port map (
      CLK          => CLK,
      DIN          => rxdatal,
      KIN          => rxkl,
      LOCKED       => linkup,
      ECYCLE       => ecycle,
      EDATA        => edata,
      DGRANTA      => open,
      EARXBYTEA    => earxbytea,
      EARXBYTESELA => earxbytesela,
      DGRANTB      => open,
      EARXBYTEB    => open,
      EARXBYTESELB => open,
      DGRANTC      => open,
      EARXBYTEC    => open,
      EARXBYTESELC => open,
      DGRANTD      => open,
      EARXBYTED    => open,
      EARXBYTESELD => open );
  
  linkup <= not reset;
  
  encodemux_inst : encodemux
    port map (
      CLK        => CLK,
      ECYCLE     => ECYCLE,
      DOUT       => txdata,
      KOUT       => txk,
      DREQ       => '0',
      DGRANT     => open,
      DDONE      => '0',
      DDATA      => X"00",
      EDSPREQ    => "0000",
      EDSPGRANT  => open,
      EDSPDONE   => "0000",
      EDSPDATAA  => X"00",
      EDSPDATAB  => X"00",
      EDSPDATAC  => X"00",
      EDSPDATAD  => X"00",
      EPROCREQ   => EPROCREQ,
      EPROCGRANT => eprocgrant,
      EPROCDONE  => eprocdone,
      EPROCDATAA => eprocdataa,
      EPROCDATAB => eprocdatab,
      EPROCDATAC => eprocdatac,
      EPROCDATAD => eprocdatad);



  adioproc_inst : adioproc
    port map (
      CLK         => clk,
      CLKHI       => clk2x,
      RESET       => reset,
      ECYCLE      => ecycle,
      EARXBYTE    => earxbytea,
      EARXBYTESEL => earxbytesela,
      EDRX        => edata,
      ESENDREQ    => eprocreq(0),
      ESENDGRANT  => eprocgrant(0),
      ESENDDONE   => eprocdone(0),
      ESENDDATA   => eprocdataa,
      LEDEVENT    => LEDEVENT
      );

  process(jtagDRCK1, clk)
  begin
    if jtagupdate = '1' then
      jtagout    <= X"1234" & jtagwordout;
    else
      if rising_edge(jtagDRCK1) then
        jtagout  <= '0' & jtagout(63 downto 1);
        jtagtdo1 <= jtagout(0);
      end if;

    end if;
  end process;

  jtagwordout(23 downto 0) <= ecyclecnt;
  jtagwordout(39 downto 32) <= earxbyteaout; 

  BSCAN_SPARTAN3_inst : BSCAN_SPARTAN3
    port map (
      CAPTURE => jtagcapture,
      DRCK1   => jtagdrck1,
      DRCK2   => jtagDRCK2,
      SEL1    => jtagSEL1,
      SEL2    => jtagSEL2,
      SHIFT   => jtagSHIFT,
      TDI     => jtagTDI,
      UPDATE  => jtagUPDATE,
      TDO1    => jtagtdo1,
      TDO2    => jtagtdo2
      );


  process(CLK2x)
    begin
      if rising_edge(clk2x) then
        earxbyteal <= earxbytea;
        
        earxbyteselal <= earxbytesela;

        if earxbytesela = "0001" and earxbyteselal = "0000" then
          earxbyteaout <= earxbyteal; 
        end if;
      end if;

    end process; 
  process(CLK)

  begin
    if RESET = '1' then
    else
      if rising_edge(clk) then
        rxdatal <= rxdata;
        rxkl    <= rxk;
        cnt <= cnt + 1;
        LEDLINK <= ecycle; -- cnt(23);
        --LEDLINK <= RXLOCKED;
        --
        if ecycle = '1' then
          ecyclecnt <= ecyclecnt + 1; 

        end if;
      end if;
    end if;
  end process;

end Behavioral;
