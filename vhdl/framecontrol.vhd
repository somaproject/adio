library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

entity framecontrol is
  port (
    CLK  : in  std_logic;
    FRAMESTART : in std_logic; 
    X    : out std_logic_vector(9 downto 0);
    Y    : out std_logic_vector(8 downto 0);
    DCLK : out std_logic;
    HD   : out std_logic;
    VD   : out std_logic;
    DENA : out std_logic; 
    ROUT : out std_logic_vector(5 downto 0);
    GOUT : out std_logic_vector(5 downto 0);
    BOUT : out std_logic_vector(5 downto 0);
    RIN : in std_logic_vector(5 downto 0);
    GIN : in std_logic_vector(5 downto 0);
    BIN : in std_logic_vector(5 downto 0)    
    );
end framecontrol;

architecture Behavioral of framecontrol is

  constant hbplen : std_logic_vector(9 downto 0) := "0000010000";
  constant hlen : std_logic_vector(9 downto 0) := "0101000000";
  constant hfplen : std_logic_vector(9 downto 0) := "0000001000";
  
  constant vbplen : std_logic_vector(8 downto 0) := "000001001";
  constant vlen : std_logic_vector(8 downto 0) := "111100000";
  constant vfplen : std_logic_vector(8 downto 0) := "000001000";

  signal tcnt : integer range 0 to 7 := 0; 
  
  signal xreset,  xinc : std_logic := '0';
  signal xint : std_logic_vector(9 downto 0) := (others => '0');
  
  signal yreset,  yinc : std_logic := '0';
  signal yint : std_logic_vector(8 downto 0) := (others => '0');

  signal lhd, lvd : std_logic := '0';
  signal ldena : std_logic := '0';

  signal l1dclk, l2dclk, l3dclk, l4dclk : std_logic := '0';


  signal rstart, rdone : std_logic := '0';
  
  type hstates is (none, bpalign, bpout, bpinc,
                   pixalign, pixout, pixinc,
                   fpalign, fpout, fpinc, hdone);

  signal hcs, hns : hstates := none; 

  type vstates is (none,
                   bpalign, bpout, bpinc,
                   rowalign, rowout, rowinc,
                   fpalign, fpout, fpinc, vdone);

  signal vcs, vns : vstates := none;
  
  
begin  -- Behavioral

  rdone <= '1' when hcs = hdone else '0'; 

  X <= xint;
  Y <= yint; 
  main: process(clk)
    begin
      if rising_edge(CLK) then

        -- fsms
        hcs <= hns;
        vcs <= vns; 
               
        if tcnt = 7 then
          tcnt <= 0;
        else
          tcnt <= tcnt + 1; 
        end if;

        if xreset = '1' then
          xint <= (others => '0');
        else
          if xinc = '1'  then
            xint <= xint + 1;
          end if;
        end if;

        if yreset = '1' then
          yint <= (others => '0');
        else
          if yinc = '1'  then
            yint <= yint + 1;
          end if;
        end if;

        if tcnt > 3 then
          l1dclk <= '0';
        else
          l1dclk <= '1'; 
        end if;
        l2dclk <= l1dclk;
        l3dclk <= l2dclk;
        l4dclk <= l3dclk;
        DCLK <= l4dclk;
        
        HD <= lhd;
        VD <=   lvd;
        DENA <= ldena; 
        ROUT <= RIN;
        GOUT <= GIN;
        BOUT <= BIN;
        
      end if;
    end process main; 
  
    horizontal_fsm: process(hcs, rstart, tcnt, xint)
      begin
        case hcs is
          when none =>
            lhd <= '1';
            xinc <= '0';
            xreset <= '1';
            ldena <= '0';
            if rstart = '1' then
              hns <= bpalign;
            else
              hns <= none; 
            end if;

          when bpalign =>
            lhd <= '0';
            xinc <= '0';
            xreset <= '1';
            ldena <= '0';
            if tcnt = 7 then
              hns <= bpout; 
            else
              hns <= bpalign; 
            end if;

          when bpout =>
            lhd <= '0';
            xinc <= '0';
            xreset <= '0';
            ldena <= '0';
            if tcnt = 6 then
              hns <= bpinc; 
            else
              hns <= bpout; 
            end if;

          when bpinc =>
            lhd <= '0';
            xinc <= '1';
            xreset <= '0';
            ldena <= '0';
            if xint = hbplen - 1 then
              hns <= pixalign; 
            else
              hns <= bpout; 
            end if;

          when pixalign =>
            lhd <= '1';
            xinc <= '0';
            xreset <= '1';
            ldena <= '0';
            if tcnt = 7 then 
              hns <= pixout; 
            else
              hns <= pixalign; 
            end if;

          when pixout =>
            lhd <= '1';
            xinc <= '0';
            xreset <= '0';
            ldena <= '1';
            if tcnt = 6  then 
              hns <= pixinc; 
            else
              hns <= pixout; 
            end if;

          when pixinc =>
            lhd <= '1';
            xinc <= '1';
            xreset <= '0';
            ldena <= '1';
            if xint = hlen - 1 then
              hns <= fpalign; 
            else
              hns <= pixout; 
            end if;

          when fpalign =>
            lhd <= '1';
            xinc <= '0';
            xreset <= '1';
            ldena <= '0';
            if tcnt = 7 then
              hns <= fpout; 
            else
              hns <= fpalign; 
            end if;

          when fpout =>
            lhd <= '1';
            xinc <= '0';
            xreset <= '0';
            ldena <= '0';
            if tcnt = 6 then
              hns <=  fpinc; 
            else
              hns <= fpout; 
            end if;

          when fpinc =>
            lhd <= '1';
            xinc <= '1';
            xreset <= '0';
            ldena <= '0';
            if xint = hfplen - 1 then
              hns <=  hdone; 
            else
              hns <= fpout; 
            end if;

          when hdone =>
            lhd <= '1';
            xinc <= '1';
            xreset <= '0';
            ldena <= '0';
            hns <= none; 

          when others =>
            lhd <= '1';
            xinc <= '0';
            xreset <= '1';
            ldena <= '0';
            hns <= none;
            
        end case;
      end process horizontal_fsm; 

    vertical_fsm: process(vcs, framestart, rdone,  tcnt, yint)
      begin
        case vcs is
          when none =>
            lvd <= '0';
            yinc <= '0';
            yreset <= '1';
            rstart <= '0';             
            if framestart = '1' then
              vns <= bpalign;
            else
              vns <= none; 
            end if;

          when bpalign =>
            lvd <= '0';
            yinc <= '0';
            yreset <= '1';
            rstart <= '0'; 
            vns <= bpout;
            
          when bpout =>
            lvd <= '0';
            yinc <= '0';
            yreset <= '0';
            rstart <= '1'; 
            if rdone = '1'  then
              vns <= bpinc; 
            else
              vns <= bpout; 
            end if;

          when bpinc =>
            lvd <= '0';
            yinc <= '1';
            yreset <= '0';
            rstart <= '0'; 
            if yint = vbplen - 1 then
              vns <= rowalign; 
            else
              vns <= bpout; 
            end if;

          when rowalign =>
            lvd <= '1';
            yinc <= '0';
            yreset <= '1';
            rstart <= '0'; 
            vns <= rowout; 

          when rowout =>
            lvd <= '1';
            yinc <= '0';
            yreset <= '0';
            rstart <= '1'; 
            if rdone = '1' then
              vns <= rowinc; 
            else
              vns <= rowout; 
            end if;

          when rowinc =>
            lvd <= '1';
            yinc <= '1';
            yreset <= '0';
            rstart <= '0'; 
            if yint = vlen - 1 then
              vns <= fpalign; 
            else
              vns <= rowout; 
            end if;

          when fpalign =>
            lvd <= '1';
            yinc <= '0';
            yreset <= '0';
            rstart <= '0';             
            if tcnt = 7 then
              vns <= fpout; 
            else
              vns <= fpalign; 
            end if;

          when fpout =>
            lvd <= '1';
            yinc <= '0';
            yreset <= '0';
            rstart <= '0'; 
            if tcnt = 6 then
              vns <=  fpinc; 
            else
              vns <= fpout; 
            end if;

          when fpinc =>
            lvd <= '1';
            yinc <= '1';
            yreset <= '0';
            rstart <= '0'; 
            if yint = vfplen - 1 then
              vns <=  vdone; 
            else
              vns <= fpout; 
            end if;

          when vdone =>
            lvd <= '1';
            yinc <= '1';
            yreset <= '0';
            rstart <= '0'; 
            vns <= none; 

          when others =>
            lvd <= '1';
            yinc <= '0';
            yreset <= '1';
            rstart <= '0';
            vns <= none; 
        end case;
      end process vertical_fsm; 


 end Behavioral;
