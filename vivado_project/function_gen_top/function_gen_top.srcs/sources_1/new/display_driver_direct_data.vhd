library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------

entity display_driver_direct_data is
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        data  : in  STD_LOGIC_VECTOR(55 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        anode : out STD_LOGIC_VECTOR(7 downto 0)
    );
end display_driver_direct_data;

-------------------------------------------------

architecture Behavioral of display_driver_direct_data is

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
    signal sig_digit : std_logic_vector(2 downto 0);
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
        generic map ( G_BITS => 3 )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
    sig_seg <=  data(6 downto 0)   when sig_digit = "000" else
                data(13 downto 7)  when sig_digit = "001" else
                data(20 downto 14) when sig_digit = "010" else
                data(27 downto 21) when sig_digit = "011" else
                data(34 downto 28) when sig_digit = "100" else
                data(41 downto 35) when sig_digit = "101" else
                data(48 downto 42) when sig_digit = "110" else
                data(55 downto 49);

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when "000" =>
                anode <= "11111110";
            when "001" =>
                anode <= "11111101";
            when "010" =>
                anode <= "11111011";
            when "011" =>
                anode <= "11110111";
            when "100" =>
                anode <= "11101111";
            when "101" =>
                anode <= "11011111";
            when "110" =>
                anode <= "10111111";
            when "111" =>
                anode <= "01111111";
            when others =>
                anode <= "11111111";  -- All off
        end case;
    end process;

end Behavioral;