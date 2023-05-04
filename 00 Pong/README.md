# 00 Pong

[GD50](https://youtu.be/jZqYXSmgDuM) introduces the [Lua programming language](https://www.lua.org/) and the [LOVE2D framework](http://love2d.org/) by creating the game Pong.

![](https://github.com/borntofrappe/game-development/blob/main/00%20Pong/pong.gif)

## Topics

- Lua as the programming language

- Love2D as the game framework

- delta time to keep track of the amount of time lapsed since the previous frame

- velocity to manage movement

- game state to manage multiple screens

- object-oriented programming to encapsulate data and logic

- hitboxes to check the collision of boxes

- sound effects with [bfxr](https://www.bfxr.net/)

## Increments

The game is developed step by step in `Pong *` folders:

0. launch LOVE2D

1. learn about the game loop and a few LOVE2D functions

2. change the resolution with the `push.lua` library

3. include a custom font and render rectangle shapes

4. draw the score and move the paddles

5. limit the paddles movement, move the puck in a specific _state_

6. refactor the code with multiple files and classes

7. display frames per seconds

8. detect collision between ball and paddles

9. increment the score when the ball exeeds the horizontal edges

10. include a serving player and a serving state

11. declare a winner

12. add audio

13. allow to resize window

## Resources

- [Pong with Lua](https://youtu.be/jZqYXSmgDuM)

- [push library](https://github.com/Ulydev/push/blob/master/push.lua)

- [class library](https://github.com/vrld/hump/blob/master/class.lua)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/0/assignment0.html)
