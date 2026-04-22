library IEEE;
use IEEE.std_logic_1164.ALL;

entity function_gen_top is
    Port (
        clk : in std_logic;
        btnu : in std_logic;
        btnd : in std_logic;
        btnl : in std_logic;
        btnr : in std_logic;
        btnc : in std_logic;
        dp : out std_logic;
        seg : out std_logic_vector (6 downto 0);
        an : out std_logic_vector (7 downto 0);
        ja : out std_logic_vector (7 downto 0)
    );
end function_gen_top;

architecture Behavioral of function_gen_top is

    component debounce is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            btn_in : in std_logic;
            btn_state : out std_logic;
            btn_press : out std_logic
        );
    end component debounce;

    component bidir_counter is
        Generic (
            G_BITS : positive := 2
        );
        Port (
            clk : in std_logic;
            up : in std_logic;
            down : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component bidir_counter;

    component sig_name_encoder is
        Port (
            cnt_sig : in std_logic_vector(1 downto 0);
            cnt_per : in std_logic_vector(1 downto 0);
            data : out std_logic_vector(55 downto 0)
        );
    end component sig_name_encoder;

    component display_driver_direct_data is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            data : in std_logic_vector(55 downto 0);
            seg : out std_logic_vector(6 downto 0);
            anode : out std_logic_vector(7 downto 0)
        );
    end component display_driver_direct_data;

    component clk_en is
       Generic( G_MAX : positive := 5);
       Port(
           clk : in std_logic;
           rst : in std_logic;
           ce : out std_logic
       );
    end component clk_en;

    component mux is
        Generic(G_LENGTH : positive := 1); -- length of muxed signal
        Port (
            a : in std_logic_vector(G_LENGTH - 1 downto 0);
            b : in std_logic_vector(G_LENGTH - 1 downto 0);
            c : in std_logic_vector(G_LENGTH - 1 downto 0);
            d : in std_logic_vector(G_LENGTH - 1 downto 0);
            sel : in std_logic_vector(1 downto 0);
            output : out std_logic_vector(G_LENGTH - 1 downto 0)
        );
    end component mux;

    component gen_sqr is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
            dac_out : out std_logic_vector(7 downto 0)
        );
    end component gen_sqr;

    component counter is
        Generic (
            G_BITS : positive := 8
        );
        Port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;

    component gen_sin is
        generic(
            NUM_POINTS : integer := 32;
            MAX_AMPLITUDE : integer := 255
        );
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            en      : in  std_logic;
            dac_out : out std_logic_vector(7 downto 0)
        );
    end component gen_sin;

    component gen_tri is
        generic (
        G_BITS : positive := 8  --! Default number of bits
    );
    port (
        clk : in std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        dac_out : out std_logic_vector(G_BITS - 1 downto 0)
    );
    end component gen_tri;

    ---------- buttons ----------
    signal sig_btnu : std_logic;
    signal sig_btnd : std_logic;
    signal sig_btnr : std_logic;
    signal sig_btnl : std_logic;

    ---------- counters ----------
    signal sig_sig_select : std_logic_vector(1 downto 0);
    signal sig_per_select : std_logic_vector(1 downto 0);

    ---------- display ----------
    signal sig_sig_name : std_logic_vector(55 downto 0);

    ---------- clock enable ----------
    signal sig_en_1 : std_logic;
    signal sig_en_2 : std_logic;
    signal sig_en_3 : std_logic;
    signal sig_en_4 : std_logic;

    ---------- multuplexors ----------
    signal sig_en : std_logic;

    ---------- generators ----------
    signal sig_saw : std_logic_vector(7 downto 0);
    signal sig_sqr : std_logic_vector(7 downto 0);
    signal sig_tri : std_logic_vector(7 downto 0);
    signal sig_sin : std_logic_vector(7 downto 0);

begin

---------- debouncers ----------
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

---------- counters ----------

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

---------- display ----------

    sig_name_encoder_inst : sig_name_encoder
        port map (
            cnt_sig => sig_sig_select,
            cnt_per => sig_per_select,
            data => sig_sig_name
        );

    display_driver_direct_data_inst : display_driver_direct_data
        port map (
            clk => clk,
            rst => btnc,
            data => sig_sig_name,
            seg => seg,
            anode => an
        );

---------- clock enable ----------

     clk_en_1 : clk_en
         generic map(G_MAX => 100_000)
         port map(
            clk => clk,
            rst => btnc,
            ce  => sig_en_1
         );

     clk_en_2 : clk_en
         generic map(G_MAX => 10_000)
         port map(
            clk => clk,
            rst => btnc,
            ce  => sig_en_2
         );

      clk_en_3 : clk_en
         generic map(G_MAX => 1000)
         port map(
            clk => clk,
            rst => btnc,
            ce  => sig_en_3
         );

      clk_en_4 : clk_en
         generic map(G_MAX => 100)
         port map(
            clk => clk,
            rst => btnc,
            ce  => sig_en_4
         );

---------- multiplexors ----------
    en_select : mux
     generic map(G_LENGTH => 1)
     port map(
        a(0) => sig_en_1,
        b(0) => sig_en_2,
        c(0) => sig_en_3,
        d(0) => sig_en_4,
        sel => sig_per_select,
        output(0) => sig_en
    );

    sig_select: mux
     generic map(G_LENGTH => 8)
     port map(
        a => sig_saw,
        b => sig_sqr,
        c => sig_tri,
        d => sig_sin,
        sel => sig_sig_select,
        output => ja
    );

---------- generators ----------
    gen_sqr_inst: gen_sqr
     port map(
        clk => clk,
        rst => btnc,
        en => sig_en,
        dac_out => sig_sqr
    );

    gen_saw: counter
     generic map(G_BITS => 8)
     port map(
        clk => clk,
        rst => btnc,
        en => sig_en,
        cnt => sig_saw
    );

    gen_sin_inst: gen_sin
     generic map(
        NUM_POINTS => 32,
        MAX_AMPLITUDE => 255
    )
     port map(
        clk => clk,
        rst => btnc,
        en => sig_en,
        dac_out => sig_sin
    );

    gen_tri_inst: gen_tri
     generic map(
        G_BITS => 8
    )
     port map(
        clk => clk,
        rst => btnc,
        en => sig_en,
        dac_out => sig_tri
    );

    dp <= '1';
end Behavioral;