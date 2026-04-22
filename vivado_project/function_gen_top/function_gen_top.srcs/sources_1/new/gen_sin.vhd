library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_sin is
    generic(
        NUM_POINTS : integer := 32;
        MAX_AMPLITUDE : integer := 255
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        en      : in  std_logic;
        dac_out : out std_logic_vector(7 downto 0)
    );
end gen_sin;

architecture Behavioral of gen_sin is

    signal i : integer range 0 to NUM_POINTS - 1 := 0;

    type memory_type is array (0 to NUM_POINTS-1) of integer range 0 to MAX_AMPLITUDE;

    signal sine : memory_type := (
        128, 152, 176, 198, 218, 234, 245, 253,
        255, 253, 245, 234, 218, 198, 176, 152,
        128, 103, 79, 57, 37, 21, 10, 2,
        0, 2, 10, 21, 37, 57, 79, 103
    );

    -- 🔧 interní registr (klíčová oprava)
    signal dac_reg : std_logic_vector(7 downto 0) := (others => '0');

begin

    -- výstup je vždy definovaný
    dac_out <= dac_reg;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                dac_reg <= "10000000";  -- střed (128)
                i <= 0;

            elsif en = '1' then
                dac_reg <= std_logic_vector(to_unsigned(sine(i), 8));

                if i = NUM_POINTS - 1 then
                    i <= 0;
                else
                    i <= i + 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;