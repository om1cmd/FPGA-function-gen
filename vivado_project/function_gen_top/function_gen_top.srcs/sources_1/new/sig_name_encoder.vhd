library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity sig_name_encoder is
    port (
        cnt_sig : in std_logic_vector(1 downto 0);     -- Signal select counter value
        cnt_per : in std_logic_vector(1 downto 0);     -- Period select counter value
        data : out std_logic_vector(55 downto 0)       -- Data for display_driver module
    );
end entity sig_name_encoder;

-------------------------------------------------

architecture behavioral of sig_name_encoder is

begin
    text_encoder : process (cnt_sig, cnt_per) is
        variable left : std_logic_vector(27 downto 0);
        variable right : std_logic_vector(27 downto 0);
    begin
        case cnt_sig is
            when b"00" =>
                left := b"0011000_1001111_1110001_0001000"; -- PILA
            when b"01" =>
                left := b"1111111_1100010_1100000_1000010"; -- -obd
            when b"10" =>
                left := b"1110000_1111010_1100010_1000011"; -- troJ
            when b"11" =>
                left := b"1111111_0100100_1001111_1101010"; -- -SIn

            -- Default case
            when others =>
                left := b"0000000_0000000_0000000_0000000";
        end case;

        case cnt_per is
            when b"00" =>
                right := b"1001111_1111111_0110000_0000110"; -- 1-E3
            when b"01" =>
                right := b"1001111_1111111_0110000_1001100"; -- 1-E4
            when b"10" =>
                right := b"1001111_1111111_0110000_0100100"; -- 1-E5
            when b"11" =>
                right := b"0010010_1111111_0110000_0100100"; -- 1-E6

            -- Default case
            when others =>
                right := b"0000000_0000000_0000000_0000000";
        end case;

        data <= left & right;

end process text_encoder;

end architecture behavioral;
