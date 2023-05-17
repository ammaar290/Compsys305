LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY notVeryFlappy IS
    PORT
        ( clk, vert_sync                : IN std_logic;
          pixel_row, pixel_column       : IN std_logic_vector(9 DOWNTO 0);
          red, green, blue              : OUT std_logic);     
END notVeryFlappy;

architecture behavior of notVeryFlappy is

    -- Signals for the bouncy_ball component
    SIGNAL ball_on                    : std_logic;
    SIGNAL ball_y_direction            : std_logic;
    SIGNAL size                        : std_logic_vector(9 DOWNTO 0);  
    SIGNAL ball_y_pos                  : std_logic_vector(9 DOWNTO 0);
    SIGNAL ball_x_pos                  : std_logic_vector(10 DOWNTO 0);
    SIGNAL ball_y_motion               : std_logic_vector(9 DOWNTO 0);

    -- Signals for the pipeDynamic component
    SIGNAL pipe_on                     : std_logic;
    SIGNAL pipe_size                   : std_logic_vector(9 DOWNTO 0);
    SIGNAL pipe1_y_pos, pipe2_y_pos    : std_logic_vector(9 DOWNTO 0);
    SIGNAL gap_height                  : integer := 100;
    SIGNAL pipe_x_pos                  : std_logic_vector(9 DOWNTO 0);

BEGIN           

    -- bouncy_ball component
    ball_on <= '1' when ( (unsigned(ball_x_pos) <= unsigned(pixel_column) + unsigned(size)) and (unsigned(pixel_column) <= unsigned(ball_x_pos) + unsigned(size))
                    and (unsigned(ball_y_pos) <= unsigned(pixel_row) + unsigned(size)) and (unsigned(pixel_row) <= unsigned(ball_y_pos) + unsigned(size)) ) else '0';

    -- pipeDynamic component
    pipe_on <= '1' when ( (unsigned(pipe_x_pos) <= unsigned(pixel_column)) and (unsigned(pixel_column) <= unsigned(pipe_x_pos) + unsigned(pipe_size))
                    and (( (unsigned(pipe1_y_pos) <= unsigned(pixel_row)) and (unsigned(pixel_row) <= unsigned(pipe1_y_pos) + unsigned(pipe_size)) )
                    or  ( (unsigned(pipe2_y_pos) <= unsigned(pixel_row)) and (unsigned(pixel_row) <= unsigned(pipe2_y_pos) + unsigned(pipe_size)) ))) else '0';

    -- Colours for pixel data on video signal
    -- Changing the background and ball colour by pushbuttons
    red <= (not ball_on) and (not pipe_on);
    green <= ball_on;
    blue <=  not ball_on;

   process (vert_sync)  
begin
    if rising_edge(vert_sync) then          
        -- Bounce off top or bottom of the screen
        if unsigned(ball_y_pos) >= (to_unsigned(479,10) - unsigned(size)) then
            ball_y_direction <= '1';  -- move downwards
        elsif unsigned(ball_y_pos) <= unsigned(size) then 
            ball_y_direction <= '0';  -- move upwards
        end if;

        -- Compute next ball Y position
        if ball_y_direction = '0' then
            ball_y_pos <= std_logic_vector(unsigned(ball_y_pos) - to_unsigned(2,10));
        else
            ball_y_pos <= std_logic_vector(unsigned(ball_y_pos) + to_unsigned(2,10));
        end if;
    end if;
end process;


END behavior;
