library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity gen_tri is
    generic (
        G_BITS : positive := 3  --! Default number of bits
    );
    port (
        clk : in std_logic;
        rst : in  std_logic;                             --! Active high synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        dac_out : out std_logic_vector(G_BITS - 1 downto 0)  --! Counter value
    );
end entity gen_tri;

-------------------------------------------------

architecture triangle of gen_tri is
    signal sig_cnt  : unsigned(G_BITS - 1 downto 0) := (others => '0');
    signal up_down  : std_logic := '1'; 
begin

    p_triangle : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_cnt <= (others => '0');
                up_down <= '1';
            elsif en = '1' then
                
                -- 1. Logika čítání
                if up_down = '1' then
                    sig_cnt <= sig_cnt + 1;
                else
                    sig_cnt <= sig_cnt - 1;
                end if;

                -- 2. Logika otočení směru 
                if up_down = '1' and sig_cnt = (2**G_BITS - 2) then
                    up_down <= '0';
                elsif up_down = '0' and sig_cnt = 1 then
                    up_down <= '1';
                end if;
                
            end if;
        end if;
    end process p_triangle;

    dac_out <= std_logic_vector(sig_cnt);

end architecture triangle;