LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY pipeStatic IS
	PORT
		( clk 						: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END pipeStatic;

architecture behavior of pipeStatic is

SIGNAL ball_on					: std_logic;
SIGNAL sizex 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL sizey 					: std_logic_vector(9 DOWNTO 0); 
SIGNAL ball_y_pos, ball_x_pos	: std_logic_vector(9 DOWNTO 0);

BEGIN           

sizex <= CONV_STD_LOGIC_VECTOR(20,10);  -- changin to a rectanglular pipe spanning vertically
sizey <= CONV_STD_LOGIC_VECTOR(200,10);


ball_x_pos <= CONV_STD_LOGIC_VECTOR(590,10);
ball_y_pos <= CONV_STD_LOGIC_VECTOR(350,10);

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
