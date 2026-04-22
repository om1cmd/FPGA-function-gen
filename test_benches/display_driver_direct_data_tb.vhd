library ieee;
use ieee.std_logic_1164.all;

entity tb_display_driver_direct_data is
end tb_display_driver_direct_data;

architecture tb of tb_display_driver_direct_data is

    component display_driver_direct_data
        port (clk   : in std_logic;
              rst   : in std_logic;
              data  : in std_logic_vector (55 downto 0);
              seg   : out std_logic_vector (6 downto 0);
              anode : out std_logic_vector (7 downto 0));
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal data  : std_logic_vector (55 downto 0);
    signal seg   : std_logic_vector (6 downto 0);
    signal anode : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver_direct_data
    port map (clk   => clk,
              rst   => rst,
              data  => data,
              seg   => seg,
              anode => anode);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        data <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        data <= b"0011100_0111110_1000001_1110000_0001111_1010101_1111111_0000000";

        wait for 1000 ns;

        data <= b"1110000_1111010_1100010_1000011_1001111_1111111_0110000_0000110";

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_display_driver_direct_data of tb_display_driver_direct_data is
    for tb
    end for;
end cfg_tb_display_driver_direct_data;