LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY pipes IS
	PORT
		( clk 						: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END pipes;

architecture behavior of pipes is

SIGNAL ball_on  : std_logic;
SIGNAL sizex    : std_logic_vector(9 DOWNTO 0);  
SIGNAL sizey    : std_logic_vector(9 DOWNTO 0); 
SIGNAL ball_y_pos, ball_x_pos : std_logic_vector(9 DOWNTO 0);
SIGNAL counter : integer range 0 to 10000 := 0; -- Add a counter

BEGIN           

sizex <= CONV_STD_LOGIC_VECTOR(20,10);  -- changing to a rectangular pipe spanning vertically
sizey <= CONV_STD_LOGIC_VECTOR(200,10);

ball_x_pos <= CONV_STD_LOGIC_VECTOR(590,10);
ball_y_pos <= CONV_STD_LOGIC_VECTOR(350,10);

process (clk)  -- New process to update ball_x_pos
begin
    if rising_edge(clk) then
        counter <= counter + 1;  -- Increment the counter

        if counter >= 10000 then  -- If the counter reaches 10000...
            counter <= 0;  -- Reset the counter

            if ball_x_pos = "0000000000" then  -- If the pipe has moved to the left edge of the screen...
                ball_x_pos <= CONV_STD_LOGIC_VECTOR(590,10);  -- Reset the pipe's x-coordinate to its starting position
            else
                ball_x_pos <= ball_x_pos - 1;  -- Move the pipe one pixel to the left
            end if;
        end if;
    end if;
end process;

ball_on <= '1' when ( ('0' & ball_x_pos <= pixel_column + sizex) and ('0' & pixel_column <= ball_x_pos + sizex) 	-- x_pos - size <= pixel_column <= x_pos + size
                    and ('0' & ball_y_pos <= pixel_row + sizey) and ('0' & pixel_row <= ball_y_pos + sizey) )  else	-- y_pos - size <= pixel_row <= y_pos + size
            '0';


-- Colours for pixel data on video signal
-- Keeping background white and square in red
Red <=  not ball_on;
-- Turn off Green and Blue when displaying square
Green <= '1';
Blue <=  not ball_on;

END behavior;