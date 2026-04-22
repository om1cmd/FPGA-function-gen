library ieee;
use ieee.std_logic_1164.all;

entity tb_sig_name_encoder is
end tb_sig_name_encoder;

architecture tb of tb_sig_name_encoder is

    component sig_name_encoder
        port (cnt_sig : in std_logic_vector (1 downto 0);
              cnt_per : in std_logic_vector (1 downto 0);
              data    : out std_logic_vector (55 downto 0));
    end component;

    signal cnt_sig : std_logic_vector (1 downto 0);
    signal cnt_per : std_logic_vector (1 downto 0);
    signal data    : std_logic_vector (55 downto 0);

begin

    dut : sig_name_encoder
    port map (cnt_sig => cnt_sig,
              cnt_per => cnt_per,
              data    => data);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        cnt_sig <= "00";
        cnt_per <= "00";

        wait for 100 ns;

        cnt_sig <= "01";
        cnt_per <= "01";

        wait for 100 ns;

        cnt_sig <= "10";
        cnt_per <= "10";

        wait for 100 ns;

        cnt_sig <= "11";
        cnt_per <= "11";

        wait for 100 ns;

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_sig_name_encoder of tb_sig_name_encoder is
    for tb
    end for;
end cfg_tb_sig_name_encoder;