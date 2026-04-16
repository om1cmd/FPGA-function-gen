library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity bidir_counter is
    generic (
        G_BITS : positive := 4  --! Default number of bits
    );
    port (
        clk : in std_logic;
        up : in  std_logic;                              --! Count up
        down : in  std_logic;                            --! Count down
        rst : in  std_logic;                             --! Active high synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        cnt : out std_logic_vector(G_BITS - 1 downto 0)  --! Counter value
    );
end entity bidir_counter;

-------------------------------------------------

architecture behavioral of bidir_counter is

    -- Maximum counter value = 2^G_BITS - 1
    constant C_MAX : integer := 2**G_BITS - 1;
    signal sig_cnt : integer range 0 to C_MAX;

begin
    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then                        -- Synchronous, active-high reset
                    sig_cnt <= 0;
            elsif en = '1' then                      -- clock enable activated
                if up = '1' and down = '0' then      -- count UP
                    sig_cnt <= sig_cnt + 1;
                elsif down = '1' and up = '0' then   -- count DOWN
                    sig_cnt <= sig_cnt - 1;
                end if;
            end if;
        end if;
    end process p_counter;

    -- Convert integer to std_logic_vector
    cnt <= std_logic_vector(to_unsigned(sig_cnt, G_BITS));

end architecture behavioral;
