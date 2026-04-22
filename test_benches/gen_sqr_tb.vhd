library ieee;
use ieee.std_logic_1164.all;

entity tb_gen_sqr is
end tb_gen_sqr;

architecture tb of tb_gen_sqr is

    component gen_sqr
        port (clk     : in std_logic;
              rst     : in std_logic;
              en      : in std_logic;
              dac_out : out std_logic_vector (7 downto 0));
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal en      : std_logic;
    signal dac_out : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : gen_sqr
    port map (clk     => clk,
              rst     => rst,
              en      => en,
              dac_out => dac_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        en <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        en <= '1';
        wait for 100 ns;
        en <= '0';
        wait for 100 ns;

        en <= '1';
        wait for 100 ns;
        en <= '0';
        wait for 100 ns;

        en <= '1';
        wait for 100 ns;
        en <= '0';
        wait for 100 ns;

        en <= '1';
        wait for 100 ns;
        en <= '0';
        wait for 100 ns;

        en <= '1';
        wait for 100 ns;
        en <= '0';
        wait for 100 ns;

        en <= '1';
        wait for 300 ns;
        en <= '0';
        wait for 300 ns;

        en <= '1';
        wait for 300 ns;
        en <= '0';
        wait for 300 ns;

        en <= '1';
        wait for 300 ns;
        en <= '0';
        wait for 300 ns;

        en <= '1';
        wait for 300 ns;
        en <= '0';
        wait for 300 ns;

        en <= '1';
        wait for 300 ns;
        en <= '0';
        wait for 300 ns;

        en <= '1';
        wait for 300 ns;
        en <= '0';
        wait for 300 ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_gen_sqr of tb_gen_sqr is
    for tb
    end for;
end cfg_tb_gen_sqr;