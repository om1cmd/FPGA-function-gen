library ieee;
use ieee.std_logic_1164.all;

entity tb_ampl_ch_top is
end tb_ampl_ch_top;

architecture tb of tb_ampl_ch_top is

    component ampl_ch_top
        port (sw_1      : in std_logic_vector (3 downto 0);
              clk       : in std_logic;
              rst       : in std_logic;
              data_out1 : out std_logic_vector (7 downto 0));
    end component;

    signal sw_1      : std_logic_vector (3 downto 0) := (others => '0');
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal data_out1 : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 1 ns; -- Zrychleno pro běžnou simulaci
    signal TbClock    : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : ampl_ch_top
    port map (sw_1      => sw_1,
              clk       => clk,
              rst       => rst,
              data_out1 => data_out1);

    -- Generování hodin
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        -- 1. Resetování systému
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 20 ns;

        -- 2. Stimuly pro sw_1
        sw_1 <= "0001";
       
        wait for TbPeriod*1000;
        
        
        
        

        -- 3. Ukončení simulace
        TbSimEnded <= '1';
        
        wait; 
    end process;

end tb;