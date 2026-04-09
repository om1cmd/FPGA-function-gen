library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------

entity display_driver is
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        data  : in  STD_LOGIC_VECTOR(27 downto 0);
        seg   : out STD_LOGIC_VECTOR(7 downto 0);
        anode : out STD_LOGIC_VECTOR(3 downto 0)
    );
end display_driver;

-------------------------------------------------

architecture Behavioral of display_driver is

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
 
    -- Component declaration for binary counter
    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;
 
    -- Internal signals
    signal sig_en    : std_logic;
    signal sig_digit : std_logic_vector(1 downto 0);
    signal sig_seg   : std_logic_vector(6 downto 0);
    
begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_en_0 : clk_en
        generic map ( G_MAX => 800_000 )  -- Adjust for flicker-free multiplexing
        port map (                        -- For simulation: 8
            clk => clk,                   -- For implementation: 800_000
            rst => rst,
            ce  => sig_en
        );

    ------------------------------------------------------------------------
    -- N-bit counter for digit selection
    ------------------------------------------------------------------------
    counter_0 : counter
        generic map ( G_BITS => 1 )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
    sig_seg <= data(6 downto 0) when sig_digit = "00" else
               data(13 downto 7) when sig_digit = "01" else
               data(20 downto 14) when sig_digit = "10" else
               data(27 downto 21);

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "00" =>
                anode <= "1110";
            when "01" =>
                anode <= "1101";
            when "10" =>
                anode <= "1011";
            when "11" =>
                anode <= "0111";
            when others =>
                anode <= "1111";  -- All off
        end case;
    end process;

end Behavioral;