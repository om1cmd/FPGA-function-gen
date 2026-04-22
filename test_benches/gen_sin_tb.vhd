
-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 22 Apr 2026 08:49:45 GMT
-- Request id : cfwk-fed377c2-69e88ba918ca8

library ieee;
use ieee.std_logic_1164.all;

entity tb_gen_sin is
end tb_gen_sin;

architecture tb of tb_gen_sin is

    component gen_sin
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

    dut : gen_sin
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
        
        en <= '0';
        rst <= '1';
        wait for 150 ns;
        
       
        rst <= '0';
        wait for 100 ns;

        
        en <= '1'; 
        wait for 100 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;



configuration cfg_tb_gen_sin of tb_gen_sin is
    for tb
    end for;
end cfg_tb_gen_sin;