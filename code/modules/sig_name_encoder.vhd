library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity sig_name_encoder is
    port (
        cnt : in std_logic_vector(3 downto 0);     --! Signal select counter value
        data : out std_logic_vector(27 downto 0)   --! Data for display_driver module
    );
end entity sig_name_encoder;

-------------------------------------------------

architecture behavioral of sig_name_encoder is
begin

text_encoder : process (cnt) is
begin
    case cnt is
        when x"0" =>
            data <= b"1110000_1111010_1100010_1000011"; -- troJ
        when x"1" =>
            data <= b"1111111_1100010_1100000_1000010"; -- -obd
        when x"2" =>
            data <= b"0011000_1001111_1110001_0001000"; -- PILA
        when x"3" =>
            data <= b"1111111_0100100_1001111_1101001"; -- -SIn

        -- Default case
        when others =>
            data <= b"0000000_0000000_0000000_0000000";
    end case;
end process text_encoder;

end architecture behavioral;
