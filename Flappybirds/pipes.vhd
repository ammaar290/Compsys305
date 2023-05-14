LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY pipes IS
	PORT
		( pb1, pb2, clk, vert_sync, horiz_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);
END pipes;

architecture behavior of pipes is

SIGNAL pipe_on					: std_logic;
SIGNAL pipe_width				: std_logic_vector(9 DOWNTO 0);
SIGNAL pipe_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL pipe_y_pos				: std_logic_vector(9 DOWNTO 0) := (OTHERS => '0');
SIGNAL pipe_x_motion			: std_logic_vector(10 DOWNTO 0);

BEGIN

pipe_width <= CONV_STD_LOGIC_VECTOR(4,10);

Move_Pipe: process (clk)
begin
	if rising_edge(clk) then
		-- Move pipe from right to left
		if pipe_x_pos <= '0' & pipe_width then
			pipe_x_pos <= CONV_STD_LOGIC_VECTOR(639, 11);
		else
			pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(1, 11);
		end if;
	end if;
end process Move_Pipe;

pipe_on <= '1' when ('0' & pixel_column >= '0' & pipe_x_pos) and ('0' & pixel_column <= '0' & pipe_x_pos + pipe_width)	-- pipe_x_pos <= pixel_column <= pipe_x_pos + pipe_width
           and ('0' & pixel_row >= pipe_y_pos) and ('0' & pixel_row <= pipe_y_pos + pipe_width)  -- pipe_y_pos <= pixel_row <= pipe_y_pos + pipe_width
           else '0';

-- Colors for pixel data on video signal
-- Changing the background and pipe color by pushbuttons
red <= pb1;
green <= not pb2 and not pipe_on;
blue <= not pipe_on;

END behavior;
