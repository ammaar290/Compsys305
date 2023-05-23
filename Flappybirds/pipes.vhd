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

SIGNAL ball_on  : std_logic;
SIGNAL sizex    : std_logic_vector(9 DOWNTO 0);  
SIGNAL sizey    : std_logic_vector(9 DOWNTO 0); 
SIGNAL ball_y_pos, ball_x_pos : std_logic_vector(9 DOWNTO 0) := std_logic_vector(to_unsigned(590,10)); -- Initialize at right edge of screen
SIGNAL counter : integer range 0 to 333333 := 0;

BEGIN           

sizex <= std_logic_vector(to_unsigned(20,10));  
sizey <= std_logic_vector(to_unsigned(200,10));
ball_y_pos <= std_logic_vector(to_unsigned(350,10));

process (clk)  -- New process to update ball_x_pos
begin
    if rising_edge(clk) then
        counter <= counter + 1;  -- Increment the counter

        if counter >= 333333 then  -- If the counter reaches 333333...
            if unsigned(ball_x_pos) <= to_unsigned(0,10) then  -- If the pipe has moved to the left edge of the screen...
                ball_x_pos <= std_logic_vector(to_unsigned(590,10));  -- Reset the pipe's x-coordinate to its starting position
            else
                ball_x_pos <= std_logic_vector(unsigned(ball_x_pos) - 1);  -- Move the pipe one pixel to the left
            end if;
            counter <= 0;  -- Reset the counter after moving the pipe
        end if;
    end if;
end process;

ball_on <= '1' when ( (unsigned('0' & ball_x_pos) <= unsigned(pixel_column) + unsigned(sizex)) and (unsigned('0' & pixel_column) <= unsigned(ball_x_pos) + unsigned(sizex))  -- x_pos - size <= pixel_column <= x_pos + size
                    and (unsigned('0' & ball_y_pos) <= unsigned(pixel_row) + unsigned(sizey)) and (unsigned('0' & pixel_row) <= unsigned(ball_y_pos) + unsigned(sizey)) )  else    -- y_pos - size <= pixel_row <= y_pos + size
            '0';

-- Colours for pixel data on video signal
-- Keeping background white and square in red
Red <=  not ball_on;
-- Turn off Green and Blue when displaying square
Green <= '1';
Blue <=  not ball_on;

END behavior;
