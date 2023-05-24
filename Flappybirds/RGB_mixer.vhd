library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY RGB_Mixer IS
     PORT
     ( 
         ball_on: IN std_logic;
         ball_on_upper: IN std_logic;
         ball_on_lower: IN std_logic;
         red, green, blue: OUT std_logic 
     );
 END RGB_Mixer;

 ARCHITECTURE behavior OF RGB_Mixer IS
 BEGIN
     red <= ball_on OR NOT(ball_on_upper OR ball_on_lower);
     green <= (ball_on_upper OR ball_on_lower) OR NOT(ball_on OR ball_on_upper OR ball_on_lower);
     blue <= NOT(ball_on OR ball_on_upper OR ball_on_lower);  -- blue = '0' for red ball and green pipe, '1' for white background
 END behavior;