# Game of Life

Set up a grid in which to recreate a version of [_Conway's Game of life_](https://en.wikipedia.org/wiki/Game_of_life).

## Preface

On CodePen, I already experimented with the simulation [using the React framework](https://codepen.io/borntofrappe/pen/xxbKgMQ).

The project is more of an experiment than a game, but it does provide a modicum of interaction, by pressing buttons or again a cell in the grid. The project is also simple enough to experiment with how Love2D sets up the gaming window. The goal is to consider the entirety of the window's width and height, and scale the grid and buttons accordingly.

## Game

The rules specifically dictate that:

- a cell dies if there are less than two or more than three neighbors

- a cell is born if there are exactly three neighbors

Two approaches:

- `aliveNeighbors` value on the `Cell` class; loop through the table twice

- separate `cells` table where you initialize new instances altogether. It loops through the table once, before replacing the entire table
