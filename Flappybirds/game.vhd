LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY game IS
    PORT
        ( clk, vert_sync, pb1, pb2    : IN std_logic;
          pixel_row, pixel_column     : IN std_logic_vector(9 DOWNTO 0);
          red, green, blue            : OUT std_logic;
          x_output, y_output          : OUT std_logic_vector(9 DOWNTO 0));     
END game;

architecture behavior of game is

-- from bouncyBird
SIGNAL ball_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
SIGNAL ball_y_pos_T				: std_logic_vector(9 DOWNTO 0);
SIGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0):= std_logic_vector(to_unsigned(10, 10));

-- from pipes
SIGNAL ball_on_upper, ball_on_lower  : std_logic;
SIGNAL sizex    : std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos_upper, ball_y_pos_lower : std_logic_vector(9 DOWNTO 0);
TYPE array_type is ARRAY (1 to 5) of std_logic_vector(9 DOWNTO 0);
SIGNAL x_pos_arr : array_type;
SIGNAL counter : integer range 0 to 333333 := 0;
SIGNAL init_done: std_logic := '0';

BEGIN 

-- from bouncyBird 
size <= std_logic_vector(to_unsigned(8,10));
ball_x_pos <= std_logic_vector(to_unsigned(100,11));
Red <=  '0';
Green <= ball_on;
Blue <=  '0';

-- from pipes
sizex <= std_logic_vector(to_unsigned(20,10));  
ball_y_pos_upper <= std_logic_vector(to_unsigned(150,10));
ball_y_pos_lower <= std_logic_vector(to_unsigned(400,10));

Move_Ball: process (vert_sync)  	
begin
    -- Move ball once every vertical sync
    if (rising_edge(vert_sync)) then  
        -- Placed bouncy ball logic straight into push button.
        -- If pb1 is pressed, return ball_y_motion a process 
        if(pb1 = '1') then
            ball_y_motion <= std_logic_vector(to_unsigned(10,10));
        else
            ball_y_motion <= std_logic_vector(to_unsigned(-1,10));
        end if;
        
        ball_y_pos_T <= std_logic_vector(unsigned(ball_y_pos) + unsigned(ball_y_motion));
        ball_y_pos <= ball_y_pos_T;
    end if;

    x_output <= std_logic_vector(to_unsigned(100,11));
    y_output <= ball_y_pos;
end process Move_Ball;

-- process from pipes
process (clk)
begin
    if rising_edge(clk) then
        if init_done = '0' then
            for i in 1 to 5 loop
                x_pos_arr(i) <= std_logic_vector(to_unsigned(590 - (i-1)*128,10));
            end loop;
            init_done <= '1';
        else
            counter <= counter + 1;  -- Increment the counter

            if counter >= 333333 then  -- If the counter reaches 333333...
                for i in 1 to 5 loop
                    if (unsigned(x_pos_arr(i)) <= to_unsigned(0,10) 
                        or (unsigned(ball_x_pos) >= unsigned(x_pos_arr(i)) and unsigned(ball_x_pos) <= unsigned(x_pos_arr(i)) + unsigned(sizex)
                        and (unsigned(ball_y_pos) < unsigned(ball_y_pos_upper) or unsigned(ball_y_pos) >= unsigned(ball_y_pos_lower)))) then
                        -- If the pipe has moved to the left edge of the screen or there is a collision with the bird...
                        x_pos_arr(i) <= std_logic_vector(to_unsigned(590 + 128,10));  -- Reset the pipe's x-coordinate to its starting position + the distance between pipes
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

ball_on <= '1' when (unsigned('0' & ball_x_pos) <= unsigned('0' & pixel_column) + unsigned(size) and 
                      unsigned('0' & pixel_column) <= unsigned('0' & ball_x_pos) + unsigned(size) and
                      unsigned('0' & ball_y_pos) <= unsigned(pixel_row) + unsigned(size) and 
                      unsigned('0' & pixel_row) <= unsigned('0' & ball_y_pos) + unsigned(size)) else '0';

END behavior;
