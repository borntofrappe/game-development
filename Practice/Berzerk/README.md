# Berzerk

## Sprites

The structure of the spritesheet might change as I consider the efficiency of the position and the convenience of the structure from the quads perspective

- player: idle, walking (two frames), shooting, gameover

- enemies (with multiple frames): idle, moving up, right, down or left

- particles for the enemies

## Colors

- player 0.949, 0.545, 0.694
- enemies 0.824, 0.824, 0.824
- background 0.09, 0.09, 0.09
- walls 0.427, 0.459, 0.906

## Entities, player and enemies

Picking up from `04 Super Mario Bros` the idea is to have a class dedicated to the entities of the game. With this class the player and enemies share a few common features, like a state machine or a `bump` function.

## State stack

State stack to allow a transition overlay.

Transition out, not in.

## Room

A table to describe the position of the walls. The idea is to create walls for contiguous `x` characters. Once you retrieve the size of the grid, the columns and rows, the idea is to loop through the sequence twice to consider the horizontal and vertical walls. Having a wall described by an `x`, `y` coordinate, `width` and `height` dimensions should make it easier to later consider a collision with the enemies/player.
