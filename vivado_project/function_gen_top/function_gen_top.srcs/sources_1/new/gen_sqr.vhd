library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------

entity gen_sqr is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        dac_out : out std_logic_vector(7 downto 0)
    );
end entity gen_sqr;

-------------------------------------------------

architecture Behavioral of gen_sqr is

    component clk_en is
       Generic( G_MAX : positive := 5);
       Port(
           clk : in std_logic;
           rst : in std_logic;
           ce : out std_logic
       );
    end component clk_en;

signal sqr_state : std_logic;
signal sig_cnt : std_logic_vector(7 downto 0);
signal sig_en : std_logic;

begin
     clk_en_1 : clk_en
         generic map(G_MAX => 256)
         port map(
            clk => en,
            rst => rst,
            ce  => sig_en
        );

    process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
               dac_out <= (others => '0');
               sqr_state <= '0';
        
            elsif sig_en = '1' then
                if sqr_state = '0' then
                    sqr_state <= '1';
                    dac_out <= (others => '1');

                elsif sqr_state = '1' then
                    sqr_state <= '0';
                    dac_out <= (others => '0');
                end if;
            end if;
        end if;
    end process;

end Behavioral;
