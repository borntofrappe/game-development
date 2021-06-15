# 02 Breakout

After Pong and Flappy Bird, the course proceeds to recreate the game Breakout.

## Topics

- spritesheets, loading a single image and displaying portions of the larger whole

- procedural generation, with bricks of different color and type

- state, with state machine

- levels, with a progression system

- player health, with an arbitrary number of lives

- particle systems, particles spawned to create a visual effect like a puff of smoke

- collision detection, between paddles and bricks

- persistent data, keeping track of the high score in local storage

## Increments

0. set up the game and the start screen

1. render an image with a spritesheet

2. add a pause state

3. have a ball moving and bouncing in the play state

4. add bricks in rows and columns

5. improve the collision between paddle and ball

6. add a serve and gameover state. Show health and score

7. modify the table returned by `LevelMarker:createMap()`, to provide a more varied, random configuration of bricks

8. modify the way bricks react to a collision, iterating through the tiers until the brick is finally destroyed

9. show particles when the ball hits a brick

10. complete a level when every brick is destroyed

11. include high scores in a local file and in a separate game state

12. enter a high score following a gameover

13. allow to choose a paddle

## Resources

- [Breakout](https://youtu.be/pGpn2YMXtdg)

- [push library](https://github.com/Ulydev/push/blob/master/push.lua)

- [class library](https://github.com/vrld/hump/blob/master/class.lua)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/2/assignment2.html)
