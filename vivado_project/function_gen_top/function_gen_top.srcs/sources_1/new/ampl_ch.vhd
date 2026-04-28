----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2026 17:11:23
-- Design Name: 
-- Module Name: ampl_ch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ampl_ch is
    Port ( sw_1 : in STD_LOGIC_VECTOR(3 downto 0);
           ja :   in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end ampl_ch;

architecture Behavioral of ampl_ch is

signal   reg   : std_logic_vector(7 downto 0);
 
begin
    process(sw_1, ja)
    begin
        case sw_1 is
            when "0001" =>
                reg <= std_logic_vector(shift_right(unsigned(ja), 1));
            when "0010" =>
                reg <= std_logic_vector(shift_right(unsigned(ja), 2));
            when "0011" =>
                reg <= std_logic_vector(shift_right(unsigned(ja), 3));
            when others =>
                reg <= ja;
        end case;
    end process;
    
    data_out <= reg;
end Behavioral;

