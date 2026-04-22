-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Tue, 21 Apr 2026 22:25:51 GMT
-- Request id : cfwk-fed377c2-69e7f96fe7c9b

library ieee;
use ieee.std_logic_1164.all;

entity tb_gen_tri is
end tb_gen_tri;



architecture tb of tb_gen_tri is

constant G_BITS : positive := 3;
       

    component gen_tri
        port (clk : in std_logic;
              rst : in std_logic;
              en  : in std_logic;
              dac_out : out std_logic_vector (G_BITS - 1 downto 0));
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal en  : std_logic;
    signal dac_out : std_logic_vector (G_BITS - 1 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : gen_tri
    port map (clk => clk,
              rst => rst,
              en  => en,
              dac_out =>dac_out );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        en <= '1';
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;
        
       

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_gen_tri of tb_gen_tri is
    for tb
    end for;
end cfg_tb_gen_tri;