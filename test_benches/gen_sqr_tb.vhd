-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 09 Apr 2026 14:20:30 GMT
-- Request id : cfwk-fed377c2-69d7b5aedb2b0

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity tb_gen_sqr is
end tb_gen_sqr;

architecture tb of tb_gen_sqr is

    component gen_sqr
        port (clk     : in std_logic;
              rst     : in std_logic;
              per_lim : in unsigned (9 downto 0);
              dac_out : out std_logic_vector (7 downto 0));
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal per_lim : unsigned (9 downto 0);
    signal dac_out : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : gen_sqr
    port map (clk     => clk,
              rst     => rst,
              per_lim => per_lim,
              dac_out => dac_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        per_lim <= to_unsigned(0,10);
        
        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        
        per_lim <= to_unsigned(1,10);
        
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        
        per_lim <= to_unsigned(2,10);
        
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        
        per_lim <= to_unsigned(3,10);
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

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