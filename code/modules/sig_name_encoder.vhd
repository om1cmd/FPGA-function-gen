library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity sig_name_encoder is
    port (
        cnt : in std_logic_vector(3 downto 0);     --! Signal select counter value
        data : out std_logic_vector(15 downto 0)   --! Data for display_driver module
    );
end entity sig_name_encoder;

-------------------------------------------------

architecture behavioral of sig_name_encoder is
begin

text_encoder : process (cnt) is
begin
    case cnt is
        when x"0" =>
            data <= b"1111_1111_1111_1111";
        when x"1" =>
            data <= b"1111_1111_1111_1111";
        when x"2" =>
            data <= b"1111_1111_1111_1111";
        when x"3" =>
            data <= b"1111_1111_1111_1111";

        -- Default case
        when others =>
            data <= b"0000_0000_0000_0000";
    end case;
end process text_encoder;

end architecture behavioral;
