
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity gen_sqr is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           per_lim : in unsigned (9 downto 0);
           dac_out : out STD_LOGIC_VECTOR (7 downto 0));
end gen_sqr;

architecture Behavioral of gen_sqr is
    signal s_cnt : unsigned(9 downto 0) := (others => '0');
    signal sqr_state :  std_logic := '0';
    
begin

    process (clk) is
    begin
        if rising_edge(clk) then  
            if rst = '1' then    
               s_cnt <= (others => '0');
               sqr_state <= '0';  

            elsif s_cnt > per_lim then
                s_cnt <= (others => '0');
                sqr_state <= '1';

            else
                s_cnt <= s_cnt + 1;
                
            end if;  
        end if;      
    end process;
    dac_out <= (others => '1') when (sqr_state = '1') else (others => '0');


end Behavioral;
