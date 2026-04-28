library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ampl_ch is
    Port (sw_1 : in STD_LOGIC_VECTOR(1 downto 0);
          data_in : in STD_LOGIC_VECTOR (7 downto 0);
          data_out : out STD_LOGIC_VECTOR (7 downto 0));
end ampl_ch;

architecture Behavioral of ampl_ch is

signal reg : std_logic_vector(7 downto 0);

begin
    process(data_in)
    begin
        case sw_1 is
            when "01" =>
                reg <= std_logic_vector(shift_right(unsigned(data_in), 1));
            when "10" =>
                reg <= std_logic_vector(shift_right(unsigned(data_in), 2));
            when "11" =>
                reg <= std_logic_vector(shift_right(unsigned(data_in), 3));
            when others =>
                reg <= data_in;
        end case;
    end process;

    data_out <= reg;
end Behavioral;

