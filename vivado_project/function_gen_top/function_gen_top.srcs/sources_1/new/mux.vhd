library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
    generic (G_LENGTH : positive := 1);
    port (
        a : in std_logic_vector(G_LENGTH - 1 downto 0);
        b : in std_logic_vector(G_LENGTH - 1 downto 0);
        c : in std_logic_vector(G_LENGTH - 1 downto 0);
        d : in std_logic_vector(G_LENGTH - 1 downto 0);
        sel : in std_logic_vector(1 downto 0);
        output : out std_logic_vector(G_LENGTH - 1 downto 0)
    );
end entity mux;

architecture behavioral of mux is

begin
    with sel select
        output <= a when "00",
                  b when "01",
                  c when "10",
                  d when others;   -- catches "11"
end architecture behavioral;