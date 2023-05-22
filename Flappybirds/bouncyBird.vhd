LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncyBird IS
	PORT
		( pb1, pb2, clk, vert_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END bouncyBird;

architecture behavior of bouncyBird is

SIGNAL ball_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(100,11);

ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
-- Changing the background and ball colour by pushbuttons
Red <=  '1';
Green <= ball_on;
Blue <=  ball_on;


Move_Ball: process (vert_sync)  	
begin
	-- Move ball once every vertical sync
	if (rising_edge(vert_sync)) then		
	
		

		-- Placed bouncy ball logic straight into push button.
		-- Should show bouncy ball, if not look at logic for bouncyball and return result and see accordingly
		-- If pb1 is pressed, return ball_y_motion a process 
		
		if(pb1 = '1') then
			ball_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
		else
			ball_y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
		end if;
		
		ball_y_pos <= ball_y_pos + ball_y_motion;
		
	end if;
end process Move_Ball;

END behavior;
