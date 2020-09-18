The fifth video covers a 2D platformer inspired by Super Mario Bros.

## TODO

The project is actively under development. As I found bugs/missing features, I'll list them here for future consideration:

### Done

- player can't move to the very end of the level. Solved: Super Mario Bros 0 uses `self.player.x` to limit the movement instead of `self.player.width`

- update demos in the "Prep" folder to consider the new height of the background image

## Topics

- tile maps

- 2D animation

- procedural level generation

- platformer physics

- basic AI

- powerups

## Project structure

<!-- In _Super Mario Bros — Final_ find the version of the game as developed alongside the video.

In _Super Mario Bros — Assignment_ find the version including the assignments. -->

The game is introduced by a series of demos discussing specific topics. These are developed in the "Prep" folder:

1. _Tiles_, how to render tiles and fake movement with horizontal scroll

2. _Character_, how to render, move, jump and animate the sprite making up the character

3. _Level_, how to generate a level with different features

From these demos, there is a considerable learning curve to develop the full game, and therefore I decided to develop a few updates to incorporate the lecturer's code.

## Resources

- [Super Mario Bros](https://youtu.be/gvONAgleKPg)

- [push library](https://github.com/Ulydev/push)

- [class library](https://github.com/vrld/hump/blob/master/class.lua)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/4/assignment4.html)
