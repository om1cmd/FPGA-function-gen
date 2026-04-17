library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity function_gen_top is
    Port ( clk : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnr : in STD_LOGIC;
           btnc : in STD_LOGIC;
           dp : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           ja : out STD_LOGIC_VECTOR (7 downto 0));
end function_gen_top;

architecture Behavioral of function_gen_top is

    component debounce is
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            btn_in : in STD_LOGIC;
            btn_state : out STD_LOGIC;
            btn_press : out STD_LOGIC
        );
    end component debounce;
    
    component bidir_counter is
        Generic (
            G_BITS : positive := 2
        );
        Port (
            clk : in STD_LOGIC;
            up : in STD_LOGIC;
            down : in STD_LOGIC;
            rst : in STD_LOGIC;
            en : in STD_LOGIC;
            cnt : out STD_LOGIC_VECTOR(G_BITS - 1 downto 0)            
        );
    end component bidir_counter;

    component sig_name_encoder is
        Port (
            cnt : in STD_LOGIC_VECTOR(1 downto 0);
            data : out STD_LOGIC_VECTOR(27 downto 0)
        );
    end component sig_name_encoder;
    
    component display_driver_direct_data is
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            data : in STD_LOGIC_VECTOR(27 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0);
            anode : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component display_driver_direct_data;
    
    signal sig_btnu : STD_LOGIC;
    signal sig_btnd : STD_LOGIC;
    signal sig_btnr : STD_LOGIC;
    signal sig_btnl : STD_LOGIC;
    signal sig_sig_select : STD_LOGIC_VECTOR(1 downto 0);
    signal sig_per_select : STD_LOGIC_VECTOR(1 downto 0);
    signal sig_sig_name : STD_LOGIC_VECTOR(27 downto 0);

begin

    debounce_u : debounce
        port map (
            clk => clk,
            rst => btnc,
            btn_in => btnu,
            btn_press => sig_btnu,
            btn_state => open
        );

    debounce_d : debounce
        port map (
            clk => clk,
            rst => btnc,
            btn_in => btnd,
            btn_press => sig_btnd,
            btn_state => open
        );    

    debounce_r : debounce
        port map (
            clk => clk,
            rst => btnc,
            btn_in => btnr,
            btn_press => sig_btnr,
            btn_state => open
        );

    debounce_l : debounce
        port map (
            clk => clk,
            rst => btnc,
            btn_in => btnl,
            btn_press => sig_btnl,
            btn_state => open
        );

    counter_sig_select : bidir_counter
        generic map (G_BITS => 2)
        port map (
            clk => clk,
            up => sig_btnu,
            down => sig_btnd,
            rst => btnc,
            en => '1',
            cnt => sig_sig_select
        );

    counter_per_select : bidir_counter
        generic map (G_BITS => 2)
        port map (
            clk => clk,
            up => sig_btnr,
            down => sig_btnl,
            rst => btnc,
            en => '1',
            cnt => sig_per_select
        );

    sig_name_encoder_inst : sig_name_encoder
        port map (
            cnt => sig_sig_select,
            data => sig_sig_name
        );
    
    display_driver_direct_data_inst : display_driver_direct_data
        port map (
            clk => clk,
            rst => btnc,
            data => sig_sig_name,
            seg => seg,
            anode => an(7 downto 4)
        );
    
    an(3 downto 0) <= b"1111";
    dp <= '1';
end Behavioral;