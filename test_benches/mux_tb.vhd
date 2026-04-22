library ieee;
use ieee.std_logic_1164.all;

entity tb_mux is
end tb_mux;

architecture tb of tb_mux is

    component mux
        port (a      : in std_logic_vector (2 downto 0);
              b      : in std_logic_vector (2 downto 0);
              c      : in std_logic_vector (2 downto 0);
              d      : in std_logic_vector (2 downto 0);
              sel    : in std_logic_vector (1 downto 0);
              output : out std_logic_vector (2 downto 0));
    end component;

    signal a      : std_logic_vector (2 downto 0);
    signal b      : std_logic_vector (2 downto 0);
    signal c      : std_logic_vector (2 downto 0);
    signal d      : std_logic_vector (2 downto 0);
    signal sel    : std_logic_vector (1 downto 0);
    signal output : std_logic_vector (2 downto 0);

begin

    dut : mux
    port map (a      => a,
              b      => b,
              c      => c,
              d      => d,
              sel    => sel,
              output => output);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        a <= b"000";
        b <= b"111";
        c <= b"101";
        d <= b"010";
        sel <= (others => '0');

        -- ***EDIT*** Add stimuli here
        sel <= b"00";
        wait for 100 ns;

        sel <= b"01";
        wait for 100 ns;

        sel <= b"10";
        wait for 100 ns;

        sel <= b"11";
        wait for 100 ns;

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_mux of tb_mux is
    for tb
    end for;
end cfg_tb_mux;