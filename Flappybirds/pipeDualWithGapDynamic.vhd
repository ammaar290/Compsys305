LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY pipeDualWithGapDynamic IS
	PORT
		( clk 						: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END pipeDualWithGapDynamic;

architecture behavior of pipeDualWithGapDynamic is

SIGNAL ball_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL pipe1_y_pos, pipe2_y_pos	: std_logic_vector(9 DOWNTO 0);
SIGNAL gap_height 				: integer := 100; -- Adjust the gap height as desired
SIGNAL pipe_x_pos 				: std_logic_vector(9 DOWNTO 0); -- Horizontal position of the pipes

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(100,10);  -- Size of the pipes
pipe1_y_pos <= CONV_STD_LOGIC_VECTOR(200,10); -- Vertical position of the first pipe
pipe2_y_pos <= pipe1_y_pos + CONV_STD_LOGIC_VECTOR(gap_height, 10); -- Vertical position of the second pipe

process(clk)
begin
	if rising_edge(clk) then
		if pipe_x_pos = CONV_STD_LOGIC_VECTOR(0,10) then
			pipe_x_pos <= CONV_STD_LOGIC_VECTOR(840,10);  -- reset position to the right corner when it reaches the left edge
		else
			pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(1,10);  -- decrement the x-position by 1 in each clock cycle
		end if;
	end if;
end process;

ball_on <= '1' when (
	-- Pipe 1 condition
	(('0' & pipe_x_pos <= pixel_column) and ('0' & pixel_column <= pipe_x_pos + size) and 
	 ('0' & pipe1_y_pos <= pixel_row) and ('0' & pixel_row <= pipe1_y_pos + size)) or
	-- Pipe 2 condition
	(('0' & pipe_x_pos <= pixel_column) and ('0' & pixel_column <= pipe_x_pos + size) and 
	 ('0' & pipe2_y_pos <= pixel_row) and ('0' & pixel_row <= pipe2_y_pos + size))
) else '0';

-- Colours for pixel data on video signal
-- Keeping background white and pipes in green
Red <= not ball_on;  -- Change the color to green
Green <= '1';
Blue <= not ball_on;

END behavior;
