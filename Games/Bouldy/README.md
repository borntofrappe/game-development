# Bouldy

The game has a ball roll inside of a maze, and gaining speed for every cell of uninterrupted movement. With enough speed, the ball is able to destroy the maze's gate and pass through the otherwise solid constraint. It is an excellent excuse to implement a maze structure with the recursive backtracker algorithm, create a GUI element in the form of a progress bar and rehearse with Love2D particle system.

## Maze

Picking up from the code developed for [borntofrappe/code/Maze Algorithms](https://github.com/borntofrappe/code/tree/master/Maze%20Algorithms), the game creates a maze with the recursive backtracker algorithm.

## Prep

In the `prep` folder I re-introduce the particle system provided by Love2D, in order to create two effects: dust and debris. The first is programmed to show the movement of the player inside of the maze, and creates a cloud of dust with increasing intensity; the idea is to show the varying speed by emitting a different number of particles. The second is scheduled to display a gate in the maze being destroyed; given the solid nature of the wall, the visual used in this instance is a rectangle instead of a circle.
