LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY pipeDynamic IS
    PORT
        ( clk                       : IN std_logic;
          pixel_row, pixel_column    : IN std_logic_vector(9 DOWNTO 0);
          red, green, blue           : OUT std_logic);      
END pipeDynamic;

architecture behavior of pipeDynamic is

SIGNAL ball_on                   : std_logic;
SIGNAL sizex                     : std_logic_vector(9 DOWNTO 0);  
SIGNAL sizey                     : std_logic_vector(9 DOWNTO 0); 
SIGNAL ball_y_pos, ball_x_pos    : std_logic_vector(9 DOWNTO 0);

BEGIN           

sizex <= CONV_STD_LOGIC_VECTOR(20,10);  
sizey <= CONV_STD_LOGIC_VECTOR(200,10);

-- Remove these lines
-- ball_x_pos <= CONV_STD_LOGIC_VECTOR(590,10);
-- ball_y_pos <= CONV_STD_LOGIC_VECTOR(350,10);

process(clk)
begin
    if rising_edge(clk) then
        if ball_x_pos = CONV_STD_LOGIC_VECTOR(0,10) then
            ball_x_pos <= CONV_STD_LOGIC_VECTOR(840,10);  
        else
            ball_x_pos <= ball_x_pos - CONV_STD_LOGIC_VECTOR(1,10);  
        end if;
    end if;
end process;

ball_on <= '1' when ( ('0' & ball_x_pos <= pixel_column + sizex) and ('0' & pixel_column <= ball_x_pos + sizex)  
                    and ('0' & ball_y_pos <= pixel_row + sizey) and ('0' & pixel_row <= ball_y_pos + sizey) )  
            else '0';

Red <=  not ball_on;
Green <= ball_on;
Blue <=  not ball_on;

-- add initialization for ball_y_pos and ball_x_pos within an initial process.
process
begin
    ball_x_pos <= CONV_STD_LOGIC_VECTOR(590,10);
    ball_y_pos <= CONV_STD_LOGIC_VECTOR(350,10);
    wait for 2ns;
end process;

END behavior;