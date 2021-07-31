## 03 Match Tree

The fourth video moves on to create a game in which you match tiles of the same shape and color.

![A few frames from the assignment for "Match Three"](https://github.com/borntofrappe/game-development/blob/master/03%20Match%20Three/match-three.gif)

## Topics

- anonymous functions

- tweening, interpolating a value over time

- timers, to have something happen at intervals, or after a certain amount of time

- solving matches and repopulating the level

- procedural grids, generating levels with some degree of randomness

- sprite art and palettes, using a restricted set of color

## Increments

The `Prep` folder includes several demos to discuss different topics:

- `Timer`: consider time events

  0.  count the number of seconds with delta time and dedicated variables

  1.  keep track of multiple intervals with multiple variables

  2.  keep track of multiple intervals through the `knife/timer` library

- `Tween`: interpolate between values over time

  0. move a static image computing the distance over time

  1. move multiple images at different rates and through different variables

  2. move multiple images with the `knife/timer` library

- `Chain`: have operations happen in sequence

  0. move a static image around the corners of the window with a few controlling variables

  1. move a static image around the corners of the window chaining functions with the `knife/timer` library

- `Swap`: swap two tiles

  0. render a static grid of tiles

  1. select, highlight, and finally swap tiles

  2. tween the position of the tiles

Past these folders, the game is developed in `Match Three *` folders:

0. set up the game and the board in the play state

1. detect a match of three or more shapes.

2. remove matches

3. update the board to move the tiles in the empty spaces

4. fill the board

5. refactor the way the board is updated, checking for matches until no match is found

6. add a title screen

7. animate the title in the title screen

8. animate the transition between the title screen and the play state

9. introduce the gameover state

10. complete the gameplay with goals, levels and an increasing timer

<!-- 0. -->

## Resources

- [Match Three](https://youtu.be/64TbMmCgRv0)

- [push library](https://github.com/Ulydev/push)

- [class library](https://github.com/vrld/hump/blob/master/class.lua)

- [knife library](https://github.com/airstruck/knife)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/3/assignment3.html)
