![image](https://github.com/yura-poj/mario_bros/assets/85958170/79b670f4-d88d-4963-950a-42abf2906eb8)![image](https://github.com/yura-poj/mario_bros/assets/85958170/f8d4d2b4-5818-44b6-b4c2-e18c19021ed6)Mario 

![Online Converter output (1)](https://github.com/yura-poj/mario_bros/assets/85958170/c73ff0c4-7b87-4abf-83b4-24eea0c98b87)

User Manual
To run our game, follow these steps:
1.	Download Logisim from official website: http://www.cburch.com/logisim/download.html
2.	Install Logisim.
3.	Download and install Developer tools for Coco-de-Mer processors following the instructions in the repository.
4.	Download and unarchive our project.
5.	Open directory with project files in Visual Studio Code.
6.	Open project_demo.circ in Logisim, follow the prompts in the pop-up windows.
7.	Start CdM Debugger in Logisim, next run debug in vscode.
8.	Play the game and enjoy!



Hardware
In our project, we have a main circuit called main and 8 sub-schemes:

6 schemes for rendering sprites:
-	super_mux and sprite for rendering the character’s sprite
-	super_mux2, super_mux3, and sprite2, sprite3 for rendering the enemies.
We use super_mux to determine the specific column in which to draw a part of the 3x3 sprite, but more on that later.

And two other schemes:
- scoreboard - a scheme that displays the player's score on the screen. It implements the conversion from hexadecimal to decimal numbering system.
- chip - the most important sub-scheme, responsible for rendering everything on the screen in a specific column of the matrix located in the main.

Let's delve deeper into the operation of the main circuit.

Everything happens on a 32x32 matrix, under the matrix we have 32 chips that draw each of the 32 columns on the display.

Under the hood there is a chip scheme that, as we said, renders everything on the screen in a specific column from right to left.

To the left of the matrix is a clever circuit of comparators that converts the coordinate format from the code to the matrix coordinate format. In assembler the coordinates start at the bottom left corner, while in Logisim they start at the top right corner, so that with this conversion we can display everything correctly on the screen.

Above that we have the scoreboard scheme:
<img width="292" alt="image" src="https://github.com/yura-poj/mario_bros/assets/85958170/7c46d583-c979-453b-a699-a804b8b9c6ec">

To make it clearer, here is a schematic diagram of the circuit operation:
<img width="468" alt="image" src="https://github.com/yura-poj/mario_bros/assets/85958170/be558e02-d0b9-4848-80e8-0d1256914545">



GAME LOGIC
We decided to implement the entire logic of the game on CdM-16. So, let's first fully understand the logic of the game and then look at its implementation on the CDM-16. We have all the basic elements of a typical platformer: a map with generated obstacles, a main hero, 1 flying enemy and 2 ground enemies. 

It all starts in the main.asm file, which, as you can see from its name, is the main file that sets up an interrupt vector table, handles exceptions, and executes the main game loop which includes initializations, moving game characters (Mario and enemies), processing inputs, and updating the game screen in a game.

But how exactly everything works?
We have 5 files: 
1.	main.asm
2.	mario.asm
3.	map.asm
4.	enemies.asm
5.	trigger.asm

Let's go through each of the files and take a closer look at how the program is organized.
![image](https://github.com/yura-poj/mario_bros/assets/85958170/b9671836-8cb5-49db-ada6-88cb7413ab07)
First, we call the subroutines set_up from map.asm and set_coordinates from enemies.asm.
The purpose of set_up is to initialise the column values, i.e. map, while set_coordinates places the enemies and the character.
Secondly, we enter the while loop to execute the game logic. How is it executed? By calling subroutines from helper files. After the first step, we already have a map and placed enemies with character. To start, we increase the score for the player being alive using inc_points.
It loads specific memory address (0xff0f) to r1 and increment the value stored in this memory location by 1.

Then we move the ground enemy towards the main character using move_earth_enemies. To get it right, we should use the subroutines check_map_left and check_map_right to make sure the enemy doesn't fall off the platform, and check_pixel to make sure the enemy is standing on it.

Let's not forget about the flying enemies, they swoop right down on the character when they are above him, also check if the enemy has landed on the platform using check_sky_enemy_under_map and check_under_pixel. The code logic is the same as for ground enemies.

Important parts are the mechanics of killing enemies or getting killed by them. So, to kill him we can check for collisions between the player and enemies. In the case of a collision, we check whether the player is falling or not; if the player is falling, he kills the enemy, otherwise, he gets killed.

Then we move Mario based on the player’s actions. To do this accurately, we check that Mario does not leave the map, otherwise, we prevent the player from doing so. If Mario moves beyond half the map, we move the map itself while keeping Mario in place. In case of a jump, we check whether the player is on the ground or a platform. Since there is gravity in the game, we continuously decrease y.

It would be tedious to cite the whole code of collision handling, so let us just describe it. We store the state in r5, if it is 1 the character falls, otherwise 0. As it was mentioned above, if the character does not fall, then when he collides with an enemy, he takes damage and dies. If he does fall, he kills the enemy and gets points by calling inc_points subroutine.

In general terms, we have already explained the workings of all five files:
-	mario.asm is used purely for character control, i.e. right, left and jump movements.
-	map.asm is used to initialise and move the map, as well as to move enemies with the map.
-	enemies.asm controls enemy placement and movement on the map
-	last but not least, trigger.asm is responsible for handling collisions between the character and enemies.
Now we can see the general scheme of the code operation, for clarity we will show it below:
<img width="468" alt="image" src="https://github.com/yura-poj/mario_bros/assets/85958170/293f6133-603d-47f8-8718-5a7ca4c3a380">

CdM-16 communicates with Logisim components by means of 16 registers, the function of which is predetermined in the code.

When we need to write something to a register from CdM-16 we access the memory location at address 0xff00 - 0xff10 and together with the memory the value gets into the register.
If we need to get a value from Logisim we access the memory location 0xfefe - 0xfeff, but here Logisim intercepts this access and instead of the value in memory it outputs another value, in our case it is the joystick value.
<img width="468" alt="image" src="https://github.com/yura-poj/mario_bros/assets/85958170/c0a6370c-733f-43f6-a9a9-a3b7707daa47">

Conclusion

It was a difficult challenge to make this game in Assembler and Logisim, but it allows us to think more deeply and perhaps create something more global.

Circuit contains a total of 9 sub-schemes and the programme has 871 lines of code.
