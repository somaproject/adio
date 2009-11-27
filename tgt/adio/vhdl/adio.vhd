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

--  component devicelink
--    port (
--      TXCLKIN   : in  std_logic;
--      TXLOCKED  : in  std_logic;
--      TXDIN     : in  std_logic_vector(9 downto 0);
--      TXDOUT    : out std_logic_vector(7 downto 0);
--      TXKOUT    : out std_logic;
--      CLK       : out std_logic;
--      CLK2X     : out std_logic;
--      RESET     : out std_logic;
--      RXDIN     : in  std_logic_vector(7 downto 0);
--      RXKIN     : in  std_logic;
--      RXIO_P    : out std_logic;
--      RXIO_N    : out std_logic;
--      DECODEERR : out std_logic
--      );

--  end component;


--  signal txdata : std_logic_vector(7 downto 0) := (others => '0');
--  signal txk    : std_logic                    := '0';

--  signal rxdata, rxdatal : std_logic_vector(7 downto 0) := (others => '0');
--  signal rxk, rxkl       : std_logic                    := '0';

--  signal clk            : std_logic := '0';
--  signal reset, dlreset : std_logic := '1';
--  signal dcmlocked      : std_logic := '0';

--  signal decodeerrint : std_logic := '0';

--  signal ppiedata : std_logic_vector(7 downto 0) := (others => '0');
--  signal ppifs1   : std_logic                    := '0';

--  component decodemux
--    port (
--      CLK    : in std_logic;
--      DIN    : in std_logic_vector(7 downto 0);
--      KIN    : in std_logic;
--      LOCKED : in std_logic;

--      ECYCLE      : out std_logic;
--      EDATA       : out std_logic_vector(7 downto 0);
--      HEADERDONE  : out std_logic;
--      BSTARTCYCLE : out std_logic;

--      -- data interface
--      DGRANTA      : out std_logic;
--      EARXBYTEA    : out std_logic_vector(7 downto 0) := (others => '0');
--      EARXBYTESELA : in  std_logic_vector(3 downto 0) := (others => '0');

--      DGRANTB      : out std_logic;
--      EARXBYTEB    : out std_logic_vector(7 downto 0) := (others => '0');
--      EARXBYTESELB : in  std_logic_vector(3 downto 0) := (others => '0');

--      DGRANTC      : out std_logic;
--      EARXBYTEC    : out std_logic_vector(7 downto 0) := (others => '0');
--      EARXBYTESELC : in  std_logic_vector(3 downto 0) := (others => '0');

--      DGRANTD      : out std_logic;
--      EARXBYTED    : out std_logic_vector(7 downto 0) := (others => '0');
--      EARXBYTESELD : in  std_logic_vector(3 downto 0) := (others => '0')

--      );
--  end component;

--  component encodemux
--    port (
--      CLK         : in  std_logic;
--      ECYCLE      : in  std_logic;
--      DOUT        : out std_logic_vector(7 downto 0);
--      KOUT        : out std_logic;
--      -- data interface
--      DREQ        : in  std_logic;
--      DGRANT      : out std_logic;
--      DDONE       : in  std_logic;
--      DDATA       : in  std_logic_vector(7 downto 0);
--      DKIN        : in  std_logic;
--      DATAEN      : out std_logic;
--      -- event interface for DSPs
--      EDSPREQ     : in  std_logic_vector(3 downto 0);
--      EDSPGRANT   : out std_logic_vector(3 downto 0);
--      EDSPDONE    : in  std_logic_vector(3 downto 0);
--      EDSPDATAEN  : out std_logic;
--      EDSPDATAA   : in  std_logic_vector(7 downto 0);
--      EDSPDATAB   : in  std_logic_vector(7 downto 0);
--      EDSPDATAC   : in  std_logic_vector(7 downto 0);
--      EDSPDATAD   : in  std_logic_vector(7 downto 0);
--      -- event interface for EPROCs
--      EPROCREQ    : in  std_logic_vector(3 downto 0);
--      EPROCGRANT  : out std_logic_vector(3 downto 0);
--      EPROCDONE   : in  std_logic_vector(3 downto 0);
--      EPROCDATAEN : out std_logic;
--      EPROCDATAA  : in  std_logic_vector(7 downto 0);
--      EPROCDATAB  : in  std_logic_vector(7 downto 0);
--      EPROCDATAC  : in  std_logic_vector(7 downto 0);
--      EPROCDATAD  : in  std_logic_vector(7 downto 0);
--      DEBUG       : out std_logic_vector(63 downto 0));
--  end component;

--  component datamux
--    port (
--      CLK          : in  std_logic;
--      ECYCLE       : in  std_logic;
--      -- collection of grants
--      DGRANTIN     : in  std_logic_vector(3 downto 0);
--      -- datamux interface
--      ENCDOUT      : out std_logic_vector(7 downto 0);
--      ENCDNEXTBYTE : in  std_logic;
--      ENCDREQ      : out std_logic;
--      ENCDLASTBYTE : out std_logic;
--      -- individual datasport interfaces
--      DDATAA       : in  std_logic_vector(7 downto 0);
--      DDATAB       : in  std_logic_vector(7 downto 0);
--      DDATAC       : in  std_logic_vector(7 downto 0);
--      DDATAD       : in  std_logic_vector(7 downto 0);
--      DNEXTBYTE    : out std_logic_vector(3 downto 0);
--      DREQ         : in  std_logic_vector(3 downto 0);
--      DLASTBYTE    : in  std_logic_vector(3 downto 0)
--      );
--  end component;

--  component datasport
--    port (
--      CLK      : in  std_logic;
--      RESET    : in  std_logic;
--      -- serial IO
--      SERCLK   : in  std_logic;
--      SERDT    : in  std_logic;
--      SERTFS   : in  std_logic;
--      FULL     : out std_logic;
--      -- FiFO interface
--      REQ      : out std_logic;
--      NEXTBYTE : in  std_logic;
--      LASTBYTE : out std_logic;
--      DOUT     : out std_logic_vector(7 downto 0)); 
--  end component;


--  component encodedata
--    port (
--      CLK          : in  std_logic;     -- '0'
--      ECYCLE       : in  std_logic;
--      ENCODEEN     : in  std_logic;
--      HEADERDONE   : in  std_logic;
--      -- encodemux interface
--      DREQ         : out std_logic;
--      DGRANT       : in  std_logic;
--      DDONE        : out std_logic;
--      DDATA        : out std_logic_vector(7 downto 0);
--      DKIN         : out std_logic;
--      -- datamux interface
--      BSTARTCYCLE  : in  std_logic;
--      ENCDOUT      : in  std_logic_vector(7 downto 0);
--      ENCDNEXTBYTE : out std_logic;
--      ENCDREQ      : in  std_logic;
--      ENCDLASTBYTE : in  std_logic
--      );
--  end component;


--  signal ECYCLE : std_logic                    := '0';
--  signal EDATA  : std_logic_vector(7 downto 0) := (others => '0');

--  -- decodemux signals interface
--  signal dgrantin    : std_logic_vector(3 downto 0) := (others => '0');
--  signal headerdone  : std_logic                    := '0';
--  signal bstartcycle : std_logic                    := '0';

--  signal earxbytea    : std_logic_vector(7 downto 0) := (others => '0');
--  signal earxbytesela : std_logic_vector(3 downto 0) := (others => '0');
--  signal earxbyteb    : std_logic_vector(7 downto 0) := (others => '0');
--  signal earxbyteselb : std_logic_vector(3 downto 0) := (others => '0');
--  signal earxbytec    : std_logic_vector(7 downto 0) := (others => '0');
--  signal earxbyteselc : std_logic_vector(3 downto 0) := (others => '0');
--  signal earxbyted    : std_logic_vector(7 downto 0) := (others => '0');
--  signal earxbyteseld : std_logic_vector(3 downto 0) := (others => '0');

--  component dspcontproc
--    generic (
--      RAM_INIT_00 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_01 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_02 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_03 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_04 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_05 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_06 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_07 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_08 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_09 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_0A : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_0B : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_0C : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_0D : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_0E : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_0F : bit_vector(0 to 255) := (others => '0');

--      RAM_INIT_10 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_11 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_12 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_13 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_14 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_15 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_16 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_17 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_18 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_19 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_1A : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_1B : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_1C : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_1D : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_1E : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_1F : bit_vector(0 to 255) := (others => '0');

--      RAM_INIT_20 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_21 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_22 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_23 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_24 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_25 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_26 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_27 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_28 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_29 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_2A : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_2B : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_2C : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_2D : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_2E : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_2F : bit_vector(0 to 255) := (others => '0');

--      RAM_INIT_30 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_31 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_32 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_33 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_34 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_35 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_36 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_37 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_38 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_39 : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_3A : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_3B : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_3C : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_3D : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_3E : bit_vector(0 to 255) := (others => '0');
--      RAM_INIT_3F : bit_vector(0 to 255) := (others => '0');

--      RAM_INITP_00 : bit_vector(0 to 255) := (others => '0');
--      RAM_INITP_01 : bit_vector(0 to 255) := (others => '0');
--      RAM_INITP_02 : bit_vector(0 to 255) := (others => '0');
--      RAM_INITP_03 : bit_vector(0 to 255) := (others => '0');
--      RAM_INITP_04 : bit_vector(0 to 255) := (others => '0');
--      RAM_INITP_05 : bit_vector(0 to 255) := (others => '0');
--      RAM_INITP_06 : bit_vector(0 to 255) := (others => '0');
--      RAM_INITP_07 : bit_vector(0 to 255) := (others => '0'));
--    port (
--      CLK         : in  std_logic;
--      CLKHI       : in  std_logic;
--      RESET       : in  std_logic;
--      -- Event input
--      ECYCLE      : in  std_logic;
--      EARXBYTE    : in  std_logic_vector(7 downto 0);
--      EARXBYTESEL : out std_logic_vector(3 downto 0);
--      EDRX        : in  std_logic_vector(7 downto 0);
--      -- Event output 
--      ESENDREQ    : out std_logic;
--      ESENDGRANT  : in  std_logic;
--      ESENDDONE   : out std_logic;
--      ESENDDATA   : out std_logic_vector(7 downto 0);
--      ESENDDATAEN : in  std_logic;
--      -- DSP interface
--      DSPRESET    : out std_logic;
--      DSPSPIEN    : out std_logic;
--      DSPSPISS    : out std_logic;
--      DSPSPIMISO  : in  std_logic;
--      DSPSPIMOSI  : out std_logic;
--      DSPSPICLK   : out std_logic;
--      DSPSPIHOLD  : in  std_logic;
--      DSPUARTTX   : out std_logic;
--      LEDEVENT    : out std_logic;
--      DEBUGIN     : in  std_logic_vector(31 downto 0)
--      );
--  end component;

--  component eventrx
--    port (
--      CLK      : in  std_logic;
--      RESET    : in  std_logic;
--      SCLK     : in  std_logic;
--      MOSI     : in  std_logic;
--      SCS      : in  std_logic;
--      FIFOFULL : out std_logic;
--      DOUTEN   : in  std_logic;
--      DOUT     : out std_logic_vector(7 downto 0);
--      REQ      : out std_logic;
--      GRANT    : in  std_logic;
--      DONE     : out std_logic;
--      DEBUG    : out std_logic_vector(15 downto 0));
--  end component;

--  component dspiomux
--    port (
--      CLK         : in    std_logic;
--      PSEL        : in    std_logic;
--      -- dsp pins                      
--      SPISCLK     : inout std_logic;
--      SPIMOSI     : inout std_logic;
--      SPIMISO     : inout std_logic;
--      FLAG0       : out   std_logic;
--      FLAG1       : in    std_logic;
--      FLAG2       : out   std_logic;
--      FLAG4       : out   std_logic;
--      -- FPGA Master SPI interface
--      SPISSM      : in    std_logic;
--      SPISCLKM    : in    std_logic;
--      SPIMOSIM    : in    std_logic;
--      SPIMISOM    : out   std_logic;
--      BOOTHOLDOFF : out   std_logic;
--      -- FPGA Slave SPI interface
--      SPISSS      : out   std_logic;
--      SPISCLKS    : out   std_logic;
--      SPIMOSIS    : out   std_logic;
--      SPIMISOS    : in    std_logic;
--      EVTFIFOFULL : in    std_logic;
--      -- DATA SPORT IF interface
--      DATAFULL    : in    std_logic;
--      FIBERLINKUP : in    std_logic
--      );
--  end component;

--  component acqserial
--    port (
--      CLK         : in  std_logic;
--      CLKHI       : in  std_logic;
--      RESET       : in  std_logic;
--      FIBERIN     : in  std_logic;
--      FIBEROUT    : out std_logic;
--      NEWCMDDEBUG : out std_logic;
--      SERCLK      : in  std_logic;
--      -- SPORT outputs
--      DSPASERDT   : out std_logic;
--      DSPASERTFS  : out std_logic;
--      DSPBSERDT   : out std_logic;
--      DSPBSERTFS  : out std_logic;
--      -- uart interfaces
--      DSPAUARTRX  : in  std_logic;
--      DSPBUARTRX  : in  std_logic;
--      -- link status
--      DSPALINKUP  : out std_logic;
--      DSPBLINKUP  : out std_logic;
--      DEBUG       : out std_logic_vector(31 downto 0)
--      );
--  end component;

--  component evtendianrev
--    port (
--      CLK    : in  std_logic;
--      DIN    : in  std_logic_vector(7 downto 0);
--      DINEN  : in  std_logic;
--      DOUT   : out std_logic_vector(7 downto 0);
--      DOUTEN : out std_logic);
--  end component;

--  signal dreq      : std_logic_vector(3 downto 0) := (others => '0');
--  signal dnextbyte : std_logic_vector(3 downto 0) := (others => '0');
--  signal dlastbyte : std_logic_vector(3 downto 0) := (others => '0');

--  signal encddata     : std_logic_vector(7 downto 0) := (others => '0');
--  signal encdnextbyte : std_logic                    := '0';
--  signal encdreq      : std_logic                    := '0';
--  signal encdlastbyte : std_logic                    := '0';


--  signal edspreq   : std_logic_vector(3 downto 0) := (others => '0');
--  signal edspgrant : std_logic_vector(3 downto 0) := (others => '0');
--  signal edspdone  : std_logic_vector(3 downto 0) := (others => '0');

--  signal eprocreq   : std_logic_vector(3 downto 0) := (others => '0');
--  signal eprocgrant : std_logic_vector(3 downto 0) := (others => '0');
--  signal eprocdone  : std_logic_vector(3 downto 0) := (others => '0');

--  signal eprocdataen : std_logic := '0';

--  signal eprocdataa : std_logic_vector(7 downto 0) := (others => '0');
--  signal eprocdatab : std_logic_vector(7 downto 0) := (others => '0');
--  signal eprocdatac : std_logic_vector(7 downto 0) := (others => '0');
--  signal eprocdatad : std_logic_vector(7 downto 0) := (others => '0');

--  signal edspdataen : std_logic                    := '0';
--  signal edspdataa  : std_logic_vector(7 downto 0) := (others => '0');
--  signal edspdatab  : std_logic_vector(7 downto 0) := (others => '0');
--  signal edspdatac  : std_logic_vector(7 downto 0) := (others => '0');
--  signal edspdatad  : std_logic_vector(7 downto 0) := (others => '0');

--  signal procdspspiena   : std_logic := '0';
--  signal procdspspissa   : std_logic := '0';
--  signal procdspspimisoa : std_logic := '0';
--  signal procdspspimosia : std_logic := '0';
--  signal procdspspiclka  : std_logic := '0';

--  signal dspissa , dspissal : std_logic := '0';
--  signal dspimisoa          : std_logic := '0';
--  signal dspimosia          : std_logic := '0';
--  signal dspiclka           : std_logic := '0';
--  signal dspspiholda        : std_logic := '0';
--  signal devtfifofulla      : std_logic := '0';

--  signal ddataa    : std_logic_vector(7 downto 0) := (others => '0');
--  signal datafulla : std_logic                    := '0';

--  signal procdspspienb   : std_logic                    := '0';
--  signal procdspspissb   : std_logic                    := '0';
--  signal procdspspimisob : std_logic                    := '0';
--  signal procdspspimosib : std_logic                    := '0';
--  signal procdspspiclkb  : std_logic                    := '0';
--  signal dspissb         : std_logic                    := '0';
--  signal dspimisob       : std_logic                    := '0';
--  signal dspimosib       : std_logic                    := '0';
--  signal dspiclkb        : std_logic                    := '0';
--  signal dspspiholdb     : std_logic                    := '0';
--  signal devtfifofullb   : std_logic                    := '0';
--  signal ddatab          : std_logic_vector(7 downto 0) := (others => '0');
--  signal datafullb       : std_logic                    := '0';

--  signal procdspspienc   : std_logic                    := '0';
--  signal procdspspissc   : std_logic                    := '0';
--  signal procdspspimisoc : std_logic                    := '0';
--  signal procdspspimosic : std_logic                    := '0';
--  signal procdspspiclkc  : std_logic                    := '0';
--  signal dspissc         : std_logic                    := '0';
--  signal dspimisoc       : std_logic                    := '0';
--  signal dspimosic       : std_logic                    := '0';
--  signal dspiclkc        : std_logic                    := '0';
--  signal dspspiholdc     : std_logic                    := '0';
--  signal devtfifofullc   : std_logic                    := '0';
--  signal ddatac          : std_logic_vector(7 downto 0) := (others => '0');
--  signal datafullc       : std_logic                    := '0';

--  signal procdspspiend   : std_logic                    := '0';
--  signal procdspspissd   : std_logic                    := '0';
--  signal procdspspimisod : std_logic                    := '0';
--  signal procdspspimosid : std_logic                    := '0';
--  signal procdspspiclkd  : std_logic                    := '0';
--  signal dspissd         : std_logic                    := '0';
--  signal dspimisod       : std_logic                    := '0';
--  signal dspimosid       : std_logic                    := '0';
--  signal dspiclkd        : std_logic                    := '0';
--  signal dspspiholdd     : std_logic                    := '0';
--  signal devtfifofulld   : std_logic                    := '0';
--  signal ddatad          : std_logic_vector(7 downto 0) := (others => '0');
--  signal datafulld       : std_logic                    := '0';

--  signal datadataen : std_logic                    := '0';
--  signal datadreq   : std_logic                    := '0';
--  signal datadgrant : std_logic                    := '0';
--  signal dataddone  : std_logic                    := '0';
--  signal dataddata  : std_logic_vector(7 downto 0) := (others => '0');
--  signal datadkin   : std_logic                    := '0';



--  signal sportsclk : std_logic := '0';

--  signal linkup : std_logic := '0';

--  signal fiberlinkupa, fiberlinkupb, fiberlinkupc, fiberlinkupd : std_logic := '0';

--  signal clk2, clk2int : std_logic := '0';

--  signal clk2x, clk2xint : std_logic := '0';

--  signal clkacqint, clkacq : std_logic := '0';


--  signal dspresetaint  : std_logic := '0';
--  signal dspresetaintn : std_logic := '0';

--  signal dspresetbint  : std_logic := '0';
--  signal dspresetbintn : std_logic := '0';

--  signal dspresetcint  : std_logic := '0';
--  signal dspresetcintn : std_logic := '0';

--  signal dspresetdint  : std_logic := '0';
--  signal dspresetdintn : std_logic := '0';

--  signal inword, inwordl : std_logic_vector(15 downto 0) := (others => '0');
--  signal fifofullcnta    : std_logic_vector(7 downto 0)  := (others => '0');
--  signal procspienacnt   : std_logic_vector(7 downto 0)  := (others => '0');
--  signal devtfifofullal  : std_logic                     := '0';
--  signal procdspspienal  : std_logic                     := '0';
--  signal eventrxdebug_a   : std_logic_vector(15 downto 0) := (others => '0');
--  signal eventrxdebug_b   : std_logic_vector(15 downto 0) := (others => '0');
--  signal eventrxreqcnt   : std_logic_vector(15 downto 0) := (others => '0');
--  signal reql            : std_logic                     := '0';
--  signal reqll           : std_logic                     := '0';

--  signal datafullcnta       : std_logic_vector(15 downto 0) := (others => '0');
--  signal datadebug          : std_logic_vector(15 downto 0) := (others => '0');
--  signal asdebuga, asdebugb : std_logic_vector(31 downto 0) := (others => '0');

--  signal ledcnt : std_logic_vector(19 downto 0) := (others => '0');

--  signal rxlockedl   : std_logic                     := '0';
--  signal linkdropcnt : std_logic_vector(7 downto 0)  := (others => '0');
--  signal linkdebug   : std_logic_vector(31 downto 0) := (others => '0');

--  signal encode_debug : std_logic_vector(63 downto 0) := (others => '0');

----  -----------------------------------------------------------------------------
----  -- JTAG DEBUGGING
----  -----------------------------------------------------------------------------

--  component jtaginterface
--    generic (
--      JTAG1N : integer := 128;
--      JTAG2N : integer := 32);
--    port (
--      CLK     : in  std_logic;
--      DIN1    : in  std_logic_vector(JTAG1N-1 downto 0);
--      DOUT1   : out std_logic_vector(JTAG1N-1 downto 0);
--      DOUT1EN : out std_logic;
--      DIN2    : in  std_logic_vector(JTAG2N-1 downto 0);
--      DOUT2   : out std_logic_vector(JTAG2N-1 downto 0);
--      DOUT2EN : out std_logic
--      );
--  end component;

--  component bufcapture
--    port (
--      CLKA     : in  std_logic;
--      DIN      : in  std_logic_vector(31 downto 0);
--      DINEN    : in  std_logic;
--      NEXTBUF  : in  std_logic;
--      -- readout side
--      CLKB     : in  std_logic;
--      READADDR : in  std_logic_vector(11 downto 0);
--      DOUT     : out std_logic_vector(35 downto 0)
--      );
--  end component;

--  signal txkl : std_logic := '0';



--  signal jtag_din1    : std_logic_vector(127 downto 0) := (others => '0');
--  signal jtag_dout1   : std_logic_vector(127 downto 0) := (others => '0');
--  signal jtag_dout1en : std_logic                      := '0';

--  signal jtag_din2    : std_logic_vector(63 downto 0) := (others => '0');
--  signal jtag_dout2   : std_logic_vector(63 downto 0) := (others => '0');
--  signal jtag_dout2en : std_logic                     := '0';

--  signal capture_din                    : std_logic_vector(31 downto 0) := (others => '0');
--  signal capture_dinl                   : std_logic_vector(31 downto 0) := (others => '0');
--  signal capture_dinll                  : std_logic_vector(31 downto 0) := (others => '0');
--  signal capture_dinen, capture_nextbuf : std_logic                     := '0';


--  type   debugcnt_t is array (0 to 3) of std_logic_vector(7 downto 0);
--  signal datareqcnt      : debugcnt_t := (others => (others => '0'));
--  signal datanextbytecnt : debugcnt_t := (others => (others => '0'));
--  signal datalastbytecnt : debugcnt_t := (others => (others => '0'));

--  signal dataddonecnt : std_logic_vector(15 downto 0) := (others => '0');

--  signal bstartcyclecnt : std_logic_vector(7 downto 0) := (others => '0');

--  signal eventreqcnt : debugcnt_t := (others => (others => '0'));
--  signal eventgrantcnt : debugcnt_t := (others => (others => '0'));
--  signal eventdonecnt : debugcnt_t := (others => (others => '0'));
  
begin  -- Behavioral


--  devicelinkinst : devicelink
--    port map (
--      TXCLKIN   => RXCLKIN,
--      TXLOCKED  => RXLOCKED,
--      TXDIN     => RXDIN,
--      TXDOUT    => rxdata,
--      TXKOUT    => rxk,
--      CLK       => clk,
--      CLK2X     => clk2xint,
--      RESET     => dlreset,
--      RXDIN     => txdata,
--      RXKIN     => txk,
--      RXIO_P    => TXIO_P,
--      RXIO_N    => TXIO_N,
--      DECODEERR => decodeerrint);

--  -- we need a second DCM because the first one is
--  -- using DLL_FREQUENCY_MODE = HIGH and port CLK2X is unavailable in
--  -- this mode

--  maindcm : dcm
--    generic map (
--      CLKFX_DIVIDE   => 5,              -- Can be any interger from 1 to 32
--      CLKFX_MULTIPLY => 8,              -- Can be any integer from 2 to 32
--      CLKIN_PERIOD   => 15.0,
--      CLK_FEEDBACK   => "1X")
--    port map (
--      CLKIN  => clk,
--      CLKFB  => clk2,
--      RST    => dlreset,
--      CLK0   => clk2int,
---- CLK2x => clk2xint,
--      CLKFX  => clkacqint,
--      LOCKED => dcmlocked);

--  reset <= dlreset;


--  clk2_bufg : BUFG port map (
--    O => clk2,
--    I => clk2int);

--  clk2x_bufg : BUFG
--    port map (
--      O => clk2x,
--      I => clk2xint);

--  clkacq_bufg : BUFG
--    port map (
--      O => clkacq,
--      I => clkacqint);

--  REFCLKOUT <= REFCLKIN;
--  linkup    <= not RESET;

--  DSPCLKA <= CLK;
--  DSPCLKB <= CLK;
--  DSPCLKC <= CLK;
--  DSPCLKD <= CLK;

--  DSPPPICLK <= not clk;

--  decodemux_inst : decodemux
--    port map (
--      CLK          => CLK,
--      DIN          => rxdatal,
--      KIN          => rxkl,
--      LOCKED       => linkup,
--      HEADERDONE   => headerdone,
--      BSTARTCYCLE  => bstartcycle,
--      ECYCLE       => ecycle,
--      EDATA        => edata,
--      DGRANTA      => dgrantin(0),
--      EARXBYTEA    => earxbytea,
--      EARXBYTESELA => earxbytesela,
--      DGRANTB      => dgrantin(1),
--      EARXBYTEB    => earxbyteb,
--      EARXBYTESELB => earxbyteselb,
--      DGRANTC      => dgrantin(2),
--      EARXBYTEC    => earxbytec,
--      EARXBYTESELC => earxbyteselc,
--      DGRANTD      => dgrantin(3),
--      EARXBYTED    => earxbyted,
--      EARXBYTESELD => earxbyteseld);

--  dspcontproc_a : dspcontproc
--    port map (
--      CLK         => clk,
--      CLKHI       => clk2x,
--      RESET       => reset,
--      ECYCLE      => ecycle,
--      EARXBYTE    => earxbytea,
--      EARXBYTESEL => earxbytesela,
--      EDRX        => edata,
--      ESENDREQ    => eprocreq(0),
--      ESENDGRANT  => eprocgrant(0),
--      ESENDDONE   => eprocdone(0),
--      ESENDDATA   => eprocdataa,
--      ESENDDATAEN => eprocdataen,
--      -- dsp interface
--      DSPRESET    => dspresetaint,
--      DSPSPIEN    => procdspspiena,
--      DSPSPISS    => procdspspissa,
--      DSPSPIMISO  => procdspspimisoa,
--      DSPSPIMOSI  => procdspspimosia,
--      DSPSPICLK   => procdspspiclka,
--      DSPSPIHOLD  => dspspiholda,
--      DSPUARTTX   => DSPUARTTXA,
--      LEDEVENT    => LEDEVENTA,
--      DEBUGIN     => linkdebug);

--  DSPRESETA     <= dspresetaint;
--  dspresetaintn <= not dspresetaint;


--  dspiomux_a : dspiomux
--    port map (
--      CLK         => CLK,
--      PSEL        => procdspspiena,
--      -- IO Pins
--      SPISCLK     => DSPSPICLKA,
--      SPIMOSI     => DSPSPIMOSIA,
--      SPIMISO     => DSPSPIMISOA,
--      FLAG0       => DSPFLAG0A,
--      FLAG1       => DSPFLAG1A,
--      FLAG2       => DSPFLAG2A,
--      FLAG4       => DSPFLAG4A,
--      -- FPGA EPROC master SPI interface
--      SPISSM      => procdspspissa,
--      SPISCLKM    => procdspspiclka,
--      SPIMOSIM    => procdspspimosia,
--      SPIMISOM    => procdspspimisoa,
--      BOOTHOLDOFF => dspspiholda,
--      -- DSP slave SPI interface
--      SPISSS      => dspissa,
--      SPISCLKS    => dspiclka,
--      SPIMOSIS    => dspimosia,
--      SPIMISOS    => dspimisoa,
--      EVTFIFOFULL => devtfifofulla,
--      -- DATA SPORT IF interface
--      DATAFULL    => datafulla,
--      -- FIBER IF
--      FIBERLINKUP => fiberlinkupa
--      );

--  eventrx_a : eventrx
--    port map (
--      CLK      => CLK,
--      RESET    => procdspspiena,
--      SCLK     => dspiclka,
--      MOSI     => dspimosia,
--      SCS      => dspissa,
--      FIFOFULL => devtfifofulla,
--      DOUTEN   => edspdataen,
--      DOUT     => edspdataa,
--      REQ      => edspreq(0),
--      GRANT    => edspgrant(0),
--      DONE     => edspdone(0),
--      DEBUG    => eventrxdebug_a);

--  datasport_a : datasport
--    port map (
--      CLK      => CLK,
--      RESET    => dspresetaintn,
--      SERCLK   => sportsclk,
--      SERDT    => DSPSPORT1DTA,
--      SERTFS   => DSPSPORT1TFSA,
--      FULL     => datafulla,
--      REQ      => dreq(0),
--      NEXTBYTE => dnextbyte(0),
--      LASTBYTE => dlastbyte(0),
--      DOUT     => ddataa); 


--  dspcontproc_b : dspcontproc
--    port map (
--      CLK         => clk,
--      CLKHI       => clk2x,
--      RESET       => reset,
--      ECYCLE      => ecycle,
--      EARXBYTE    => earxbyteb,
--      EARXBYTESEL => earxbyteselb,
--      EDRX        => edata,
--      ESENDREQ    => eprocreq(1),
--      ESENDGRANT  => eprocgrant(1),
--      ESENDDONE   => eprocdone(1),
--      ESENDDATA   => eprocdatab,
--      ESENDDATAEN => eprocdataen,
--      -- dsp interface
--      DSPRESET    => dspresetbint,
--      DSPSPIEN    => procdspspienb,
--      DSPSPISS    => procdspspissb,
--      DSPSPIMISO  => procdspspimisob,
--      DSPSPIMOSI  => procdspspimosib,
--      DSPSPICLK   => procdspspiclkb,
--      DSPSPIHOLD  => dspspiholdb,
--      DSPUARTTX   => DSPUARTTXB,

--      LEDEVENT => LEDEVENTB,
--      DEBUGIN  => X"00000000");


--  DSPRESETb     <= dspresetbint;
--  dspresetbintn <= not dspresetbint;


--  eventrx_b : eventrx
--    port map (
--      CLK      => CLK,
--      RESET    => dspresetbintn,
--      SCLK     => dspiclkb,
--      MOSI     => dspimosib,
--      SCS      => dspissb,
--      FIFOFULL => devtfifofullb,
--      DOUTEN   => edspdataen,
--      DOUT     => edspdatab,
--      REQ      => edspreq(1),
--      GRANT    => edspgrant(1),
--      DONE     => edspdone(1),
--      DEBUG => eventrxdebug_b);


--  dspiomux_b : dspiomux
--    port map (
--      CLK         => CLK,
--      PSEL        => procdspspienb,
--      -- IO Pins
--      SPISCLK     => DSPSPICLKB,
--      SPIMOSI     => DSPSPIMOSIB,
--      SPIMISO     => DSPSPIMISOB,
--      FLAG0       => DSPFLAG0B,
--      FLAG1       => DSPFLAG1B,
--      FLAG2       => DSPFLAG2B,
--      FLAG4       => DSPFLAG4B,
--      -- FPGA EPROC master SPI interface
--      SPISSM      => procdspspissb,
--      SPISCLKM    => procdspspiclkb,
--      SPIMOSIM    => procdspspimosib,
--      SPIMISOM    => procdspspimisob,
--      BOOTHOLDOFF => dspspiholdb,
--      -- DSP slave SPI interface
--      SPISSS      => dspissb,
--      SPISCLKS    => dspiclkb,
--      SPIMOSIS    => dspimosib,
--      SPIMISOS    => dspimisob,
--      EVTFIFOFULL => devtfifofullb,
--      -- DATA SPORT IF interface
--      DATAFULL    => datafullb,
--      -- FIBER IF
--      FIBERLINKUP => fiberlinkupb

--      );

--  datasport_b : datasport
--    port map (
--      CLK      => CLK,
--      RESET    => dspresetbintn,
--      SERCLK   => sportsclk,
--      SERDT    => DSPSPORT1DTB,
--      SERTFS   => DSPSPORT1TFSB,
--      FULL     => datafullb,
--      REQ      => dreq(1),
--      NEXTBYTE => dnextbyte(1),
--      LASTBYTE => dlastbyte(1),
--      DOUT     => ddatab);


--  dspcontproc_c : dspcontproc
--    port map (
--      CLK         => clk,
--      CLKHI       => clk2x,
--      RESET       => reset,
--      ECYCLE      => ecycle,
--      EARXBYTE    => earxbytec,
--      EARXBYTESEL => earxbyteselc,
--      EDRX        => edata,
--      ESENDREQ    => eprocreq(2),
--      ESENDGRANT  => eprocgrant(2),
--      ESENDDONE   => eprocdone(2),
--      ESENDDATA   => eprocdatac,
--      ESENDDATAEN => eprocdataen,
--      -- dsp interface
--      DSPRESET    => DSPRESETCint,
--      DSPSPIEN    => procdspspienc,
--      DSPSPISS    => procdspspissc,
--      DSPSPIMISO  => procdspspimisoc,
--      DSPSPIMOSI  => procdspspimosic,
--      DSPSPICLK   => procdspspiclkc,
--      DSPSPIHOLD  => DSPSPIHOLDC,
--      --DSPSPIHOLD  => '0',      
--      DSPUARTTX   => DSPUARTTXC,

--      LEDEVENT => LEDEVENTC,
--      DEBUGIN  => asdebugb);

--  DSPRESETC     <= dspresetcint;
--  dspresetcintn <= not dspresetcint;

--  dspiomux_c : dspiomux
--    port map (
--      CLK         => CLK,
--      PSEL        => procdspspienc,
--      -- IO Pins
--      SPISCLK     => DSPSPICLKC,
--      SPIMOSI     => DSPSPIMOSIC,
--      SPIMISO     => DSPSPIMISOC,
--      FLAG0       => DSPFLAG0C,
--      FLAG1       => DSPFLAG1C,
--      FLAG2       => DSPFLAG2C,
--      FLAG4       => DSPFLAG4C,
--      -- FPGA EPROC master SPI interface
--      SPISSM      => procdspspissc,
--      SPISCLKM    => procdspspiclkc,
--      SPIMOSIM    => procdspspimosic,
--      SPIMISOM    => procdspspimisoc,
--      BOOTHOLDOFF => dspspiholdc,
--      -- DSP slave SPI interface
--      SPISSS      => dspissc,
--      SPISCLKS    => dspiclkc,
--      SPIMOSIS    => dspimosic,
--      SPIMISOS    => dspimisoc,
--      EVTFIFOFULL => devtfifofullc,
--      -- DATA SPORT IF interface
--      DATAFULL    => datafullc,
--      -- FIBER IF
--      FIBERLINKUP => fiberlinkupc
--      );

--  eventrx_c : eventrx
--    port map (
--      CLK      => CLK,
--      RESET    => dspresetcintn,
--      SCLK     => dspiclkc,
--      MOSI     => dspimosic,
--      SCS      => dspissc,
--      DOUTEN   => edspdataen,
--      FIFOFULL => devtfifofullc,
--      DOUT     => edspdatac,
--      REQ      => edspreq(2),
--      GRANT    => edspgrant(2),
--      DONE     => edspdone(2));


--  datasport_c : datasport
--    port map (
--      CLK      => CLK,
--      RESET    => dspresetcintn,
--      SERCLK   => sportsclk,
--      SERDT    => DSPSPORT1DTC,
--      SERTFS   => DSPSPORT1TFSC,
--      FULL     => datafullc,
--      REQ      => dreq(2),
--      NEXTBYTE => dnextbyte(2),
--      LASTBYTE => dlastbyte(2),
--      DOUT     => ddatac); 


--  dspcontproc_d : dspcontproc
--    port map (
--      CLK         => clk,
--      CLKHI       => clk2x,
--      RESET       => reset,
--      ECYCLE      => ecycle,
--      EARXBYTE    => earxbyted,
--      EARXBYTESEL => earxbyteseld,
--      EDRX        => edata,
--      ESENDREQ    => eprocreq(3),
--      ESENDGRANT  => eprocgrant(3),
--      ESENDDONE   => eprocdone(3),
--      ESENDDATA   => eprocdatad,
--      ESENDDATAEN => eprocdataen,
--      -- dsp interface
--      DSPRESET    => DSPRESETDint,
--      DSPSPIEN    => procdspspiend,
--      DSPSPISS    => procdspspissd,
--      DSPSPIMISO  => procdspspimisod,
--      DSPSPIMOSI  => procdspspimosid,
--      DSPSPICLK   => procdspspiclkd,
--      DSPSPIHOLD  => DSPSPIHOLDD,
--      DSPUARTTX   => DSPUARTTXD,

--      LEDEVENT => LEDEVENTD,
--      DEBUGIN  => X"00000000");

--  DSPRESETd     <= dspresetdint;
--  dspresetdintn <= not dspresetdint;


--  dspiomux_d : dspiomux
--    port map (
--      CLK         => CLK,
--      PSEL        => procdspspiend,
--      -- IO Pins
--      SPISCLK     => DSPSPICLKD,
--      SPIMOSI     => DSPSPIMOSID,
--      SPIMISO     => DSPSPIMISOD,
--      FLAG0       => DSPFLAG0D,
--      FLAG1       => DSPFLAG1D,
--      FLAG2       => DSPFLAG2D,
--      FLAG4       => DSPFLAG4D,
--      -- FPGA EPROC master SPI interface
--      SPISSM      => procdspspissd,
--      SPISCLKM    => procdspspiclkd,
--      SPIMOSIM    => procdspspimosid,
--      SPIMISOM    => procdspspimisod,
--      BOOTHOLDOFF => dspspiholdd,
--      -- DSP slave SPI interface
--      SPISSS      => dspissd,
--      SPISCLKS    => dspiclkd,
--      SPIMOSIS    => dspimosid,
--      SPIMISOS    => dspimisod,
--      EVTFIFOFULL => devtfifofulld,
--      -- DATA SPORT IF interface
--      DATAFULL    => datafulld,
--      -- FIBER IF
--      FIBERLINKUP => fiberlinkupd);

--  eventrx_d : eventrx
--    port map (
--      CLK      => CLK,
--      RESET    => dspresetdintn,
--      SCLK     => dspiclkd,
--      MOSI     => dspimosid,
--      SCS      => dspissd,
--      FIFOFULL => devtfifofulld,
--      DOUTEN   => edspdataen,
--      DOUT     => edspdatad,
--      REQ      => edspreq(3),
--      GRANT    => edspgrant(3),
--      DONE     => edspdone(3));

--  datasport_d : datasport
--    port map (
--      CLK      => CLK,
--      RESET    => dspresetdintn,
--      SERCLK   => sportsclk,
--      SERDT    => DSPSPORT1DTD,
--      SERTFS   => DSPSPORT1TFSD,
--      FULL     => datafulld,
--      REQ      => dreq(3),
--      NEXTBYTE => dnextbyte(3),
--      LASTBYTE => dlastbyte(3),
--      DOUT     => ddatad);

--  datamux_inst : datamux
--    port map (
--      CLK          => CLK,
--      ECYCLe       => ECYCLE,
--      DGRANTIN     => dgrantin,
--      ENCDOUT      => encddata,
--      ENCDNEXTBYTE => encdnextbyte,
--      ENCDREQ      => encdreq,
--      ENCDLASTBYTE => encdlastbyte,
--      DDATAA       => ddataa,
--      DDATAB       => ddatab,
--      DDATAC       => ddatac,
--      DDATAD       => ddatad,
--      DNEXTBYTE    => dnextbyte,
--      DREQ         => dreq,
--      DLASTBYTE    => dlastbyte);

--  encodedata_inst : encodedata
--    port map (
--      CLK          => CLK,
--      ECYCLE       => ecycle,
--      ENCODEEN     => datadataen,
--      HEADERDONE   => headerdone,
--      DREQ         => datadreq,
--      DGRANT       => datadgrant,
--      DDONE        => dataddone,
--      DDATA        => dataddata,
--      DKIN         => datadkin,
--      -- to data mux
--      BSTARTCYCLE  => bstartcycle,
--      ENCDOUT      => encddata,
--      ENCDNEXTBYTE => encdnextbyte,
--      ENCDREQ      => encdreq,
--      ENCDLASTBYTE => encdlastbyte
--      );

--  encodemux_inst : encodemux
--    port map (
--      CLK    => CLK,
--      ECYCLE => ECYCLE,
--      DOUT   => txdata,
--      KOUT   => txk,

--      DREQ   => datadreq,
--      DGRANT => datadgrant,
--      DDONE  => dataddone,
--      DDATA  => dataddata,
--      DKIN   => datadkin,
--      DATAEN => datadataen,

--      EDSPREQ     => EDSPREQ,
--      EDSPGRANT   => edspgrant,
--      EDSPDONE    => edspdone,
--      EDSPDATAA   => edspdataa,
--      EDSPDATAB   => edspdatab,
--      EDSPDATAC   => edspdatac,
--      EDSPDATAD   => edspdatad,
--      EDSPDATAEN  => edspdataen,
--      EPROCREQ    => EPROCREQ,
--      EPROCGRANT  => eprocgrant,
--      EPROCDONE   => eprocdone,
--      EPROCDATAA  => eprocdataa,
--      EPROCDATAB  => eprocdatab,
--      EPROCDATAC  => eprocdatac,
--      EPROCDATAD  => eprocdatad,
--      EPROCDATAEN => eprocdataen,
--      DEBUG       => encode_debug);

--  acqserial_ab : acqserial
--    port map (
--      CLK         => clk,
--      CLKHI       => clkacq,
--      RESET       => '0',
--      FIBERIN     => FIBERINAB,
--      FIBEROUT    => FIBEROUTAB,
--      NEWCMDDEBUG => open,
--      SERCLK      => SPORTSCLK,
--      DSPASERDT   => DSPSPORT0DRA,
--      DSPASERTFS  => DSPSPORT0RFSA,
--      DSPBSERDT   => DSPSPORT0DRB,
--      DSPBSERTFS  => DSPSPORT0RFSB,
--      DSPAUARTRX  => DSPUARTRXA,
--      DSPBUARTRX  => DSPUARTRXB,
--      DSPALINKUP  => fiberlinkupa,
--      DSPBLINKUP  => fiberlinkupb,
--      DEBUG       => asdebuga);

--  acqserial_cd : acqserial
--    port map (
--      CLK         => clk,
--      CLKHI       => clkacq,
--      RESET       => '0',
--      FIBERIN     => FIBERINCD,
--      FIBEROUT    => FIBEROUTCD,
--      NEWCMDDEBUG => open,
--      SERCLK      => SPORTSCLK,
--      DSPASERDT   => DSPSPORT0DRC,
--      DSPASERTFS  => DSPSPORT0RFSC,
--      DSPBSERDT   => DSPSPORT0DRD,
--      DSPBSERTFS  => DSPSPORT0RFSD,
--      DSPAUARTRX  => DSPUARTRXC,
--      DSPBUARTRX  => DSPUARTRXD,
--      DSPALINKUP  => fiberlinkupc,
--      DSPBLINKUP  => fiberlinkupd,
--      DEBUG       => asdebugb);

--  evtendianrev_inst : evtendianrev
--    port map (
--      CLK    => CLK,
--      DIN    => edata,
--      DINEN  => ecycle,
--      DOUT   => ppiedata,
--      DOUTEN => ppifs1);



----  process(REFCLKIN)
----    begin
----      if rising_edge(REFCLKIN) then
----        rxlockedl <= rxlocked;
----        -- i'm pretty sure rxlocked is active low
----        if rxlockedl = '1' and rxlocked  = '0'then
----          linkdropcnt <= linkdropcnt + 1;
----        end if;
----      end if;
----    end process;


--  process(CLK)
--    variable scnt : integer range 0 to 2 := 0;
--  begin
--    if RESET = '1' then
--    else

--      if rising_edge(clk) then
--        rxdatal  <= rxdata;
--        rxkl     <= rxk;
--        LEDPOWER <= decodeerrint;       -- ledcnt(19);
--        ledcnt   <= ledcnt + 1;

--        rxlockedl <= rxlocked;
--        -- i'm pretty sure rxlocked is active low
--        if rxlockedl = '1' and rxlocked = '0'then
--          linkdropcnt <= linkdropcnt + 1;
--        end if;

--        linkdebug(31 downto 16) <= X"ABCD";
--        linkdebug(7 downto 0)   <= linkdropcnt;

--        if datafulla = '1' then
--          datafullcnta <= datafullcnta + 1;
--        end if;

--        if scnt = 2 then
--          scnt := 0;
--        else
--          scnt := scnt + 1;
--        end if;

--        if scnt = 1 then
--          sportsclk <= '1';
--        else
--          sportsclk <= '0';
--        end if;

--        DSPSPORTSCLKA <= sportsclk;
--        DSPSPORTSCLKB <= sportsclk;
--        DSPSPORTSCLKC <= sportsclk;
--        DSPSPORTSCLKD <= sportsclk;

--        DSPPPIDOUT <= ppiedata;
--        DSPPPIFS1A <= ppifs1 and linkup;
--        DSPPPIFS1B <= ppifs1 and linkup;
--        DSPPPIFS1C <= ppifs1 and linkup;
--        DSPPPIFS1D <= ppifs1 and linkup;

--        devtfifofullal <= devtfifofulla;
--        procdspspienal <= procdspspiena;

--        if devtfifofulla = '1' and devtfifofullal = '0' then
--          fifofullcnta <= fifofullcnta + 1;
--        end if;

--        if procdspspienal /= procdspspiena then
--          procspienacnt <= procspienacnt + 1;
--        end if;

--        reql     <= edspreq(0);
--        reqll    <= reql;
--        dspissal <= dspissa;

--      end if;
--    end if;
--  end process;

-------------------------------------------------------------------------------
---- JTAG DEBUGGING
-------------------------------------------------------------------------------
--  jtagif_inst : jtaginterface
--    generic map (
--      JTAG1N => 128,
--      JTAG2N => 64)
--    port map (
--      CLK     => clk,
--      DIN1    => jtag_din1,
--      DOUT1   => jtag_dout1,
--      DOUT1EN => jtag_dout1en,
--      DIN2    => jtag_din2,
--      DOUT2   => jtag_dout2,
--      DOUT2EN => jtag_dout2en);

--  jtag_din1 <= eventreqcnt(0) & eventreqcnt(1) & eventreqcnt(2) & eventreqcnt(3) & 
--           eventgrantcnt(0) & eventgrantcnt(1) & eventgrantcnt(2) & eventgrantcnt(3) & 
--           eventdonecnt(0) & eventdonecnt(1) & eventdonecnt(2) & eventdonecnt(3) & 
--           eventrxdebug_a & eventrxdebug_b; 

--  jtag_din2 <= asdebuga & asdebugb; 

--  data_gen : for i in 0 to 3 generate
    
--    process(CLK)
--    begin
--      if rising_edge(CLK) then
--        if edspreq(i) = '1' then
--          eventreqcnt(i) <= eventreqcnt(i) + 1; 
--        end if;

--        if edspgrant(i) = '1' then
--          eventgrantcnt(i) <= eventgrantcnt(i) + 1; 
--        end if;

--        if edspdone(i) = '1' then
--          eventdonecnt(i) <= eventdonecnt(i) + 1; 
--        end if;

--      end if;
--    end process;
--  end generate data_gen;

--  process(CLK)
--  begin
--    if rising_edge(CLK) then
--      if dataddone = '1' then
--        dataddonecnt <= dataddonecnt + 1;
--      end if;

--      if bstartcycle = '1' then
--        bstartcyclecnt <= bstartcyclecnt + 1;
--      end if;
--    end if;
--  end process;

----  bufcapture_inst: bufcapture
----    port map (
----      CLKA     => CLK,
----      DIN      => capture_dinll,
----      DINEN    => capture_dinen,
----      NEXTBUF  => capture_nextbuf,
----      CLKB     => CLK,
----      READADDR => jtag_dout1(11 downto 0),
----      DOUT     => jtag_din1(35 downto 0));

----  jtag_din1(11 + 48 downto 48) <= jtag_dout1(11 downto 0);


----  capture_dinen <= '1';

----  capture_nextbuf <= '1' when txk = '1' and txkl = '0' else '0';

----  process(CLK)
----    begin
----      if rising_edge(CLK) then
----        txkl <= txk; 
----        capture_din <= X"00000" & txk & "000" & txdata;
----        capture_dinl <= capture_din; 
----        capture_dinll <= capture_dinl; 
----      end if;
----    end process ;



end Behavioral;
