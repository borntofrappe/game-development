## 04 Super Mario Bros

The fifth lecture covers a 2D platformer inspired by Super Mario Bros.

<!-- ![A few frames from the assignment for "Super Mario Bros"](https://github.com/borntofrappe/game-development/blob/master/04%20Super%20Mario%20%Bros/super-mario-bros.gif) -->

## Topics

- tile maps, turning a series of IDs into a game world. The idea is to render individual tiles giving the illusion of a world

- 2D animation, specifically a frame animation alternating rapidly between different frames

- procedural level generation, creating levels with a certain degree of randomness

- basics of platformer physics, considering individual tiles and their IDs for a possible collision 

- basics of AI, with a snail chasing the player

- powerups, game objects for the player to pick up and modify the game

## Project structure

The game is introduced by a series of demos discussing specific topics. These are developed in the `Prep` folder:

- `Tiles`, how to render tiles and simulate movement with horizontal scroll

    0. render static tiles

    1. horizontal scroll the window to simulate movement

- `Character`, how to render, move, jump and animate the sprite making up the character

- `Level`, how to generate a level with different features

From these demos, there is a considerable learning curve to develop the full game, and the different `Super Mario Bros \*` demos are my attempt at building the game in increments.

<!-- 0. -->

Past the increments, `Super Mario Bros — Final` deescribes the version of the game most closely resembling the one introduced in the video. `Super Mario Bros — Assignment` finally includes the features requested in the assignment.

## Resources

- [Super Mario Bros](https://youtu.be/gvONAgleKPg)

- [push library](https://github.com/Ulydev/push)

- [class library](https://github.com/vrld/hump/blob/master/class.lua)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/4/assignment4.html)
