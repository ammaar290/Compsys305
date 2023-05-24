LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY pipes IS
    PORT
        ( clk                      : IN std_logic;
          pixel_row, pixel_column  : IN std_logic_vector(9 DOWNTO 0);
          red, green, blue         : OUT std_logic);     
END pipes;

architecture behavior of pipes is

SIGNAL ball_on_upper, ball_on_lower  : std_logic;
SIGNAL sizex    : std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos_upper, ball_y_pos_lower : std_logic_vector(9 DOWNTO 0);
TYPE array_type is ARRAY (1 to 5) of std_logic_vector(9 DOWNTO 0);
SIGNAL x_pos_arr : array_type;
SIGNAL counter : integer range 0 to 333333 := 0;
SIGNAL init_done: std_logic := '0';

BEGIN           

sizex <= std_logic_vector(to_unsigned(20,10));  
ball_y_pos_upper <= std_logic_vector(to_unsigned(150,10));
ball_y_pos_lower <= std_logic_vector(to_unsigned(250,10));

process (clk)
begin
    if rising_edge(clk) then
        if init_done = '0' then
            x_pos_arr(1) <= std_logic_vector(to_unsigned(590,10));
            x_pos_arr(2) <= std_logic_vector(to_unsigned(480,10));
            x_pos_arr(3) <= std_logic_vector(to_unsigned(370,10));
            x_pos_arr(4) <= std_logic_vector(to_unsigned(260,10));
            x_pos_arr(5) <= std_logic_vector(to_unsigned(150,10));
            init_done <= '1';
        else
            counter <= counter + 1;  -- Increment the counter

            if counter >= 333333 then  -- If the counter reaches 333333...
                for i in 1 to 5 loop
                    if unsigned(x_pos_arr(i)) <= to_unsigned(0,10) then  -- If the pipe has moved to the left edge of the screen...
                        x_pos_arr(i) <= std_logic_vector(to_unsigned(590,10));  -- Reset the pipe's x-coordinate to its starting position
                    else
                        x_pos_arr(i) <= std_logic_vector(unsigned(x_pos_arr(i)) - 1);  -- Move the pipe one pixel to the left
                    end if;
                end loop;
                counter <= 0;  -- Reset the counter after moving the pipe
            end if;
        end if;
    end if;
end process;

process (pixel_row, pixel_column)
begin
    ball_on_upper <= '0';
    ball_on_lower <= '0';
    for i in 1 to 5 loop
        if ( unsigned('0' & x_pos_arr(i)) <= unsigned(pixel_column)
            and unsigned(pixel_column) < unsigned('0' & x_pos_arr(i)) + unsigned(sizex)
            and unsigned(pixel_row) < unsigned(ball_y_pos_upper)) then
            ball_on_upper <= '1';
        elsif ( unsigned('0' & x_pos_arr(i)) <= unsigned(pixel_column)
                and unsigned(pixel_column) < unsigned('0' & x_pos_arr(i)) + unsigned(sizex)
                and unsigned(pixel_row) >= unsigned(ball_y_pos_lower)) then
            ball_on_lower <= '1';
        end if;
    end loop;
end process;

-- Pipes in Green
Red <= not (ball_on_upper or ball_on_lower);
Green <= '1';
Blue <= not (ball_on_upper or ball_on_lower);

END behavior;