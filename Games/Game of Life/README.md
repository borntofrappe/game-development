# Game of Life

The goal of this demo is to set up a grid in which to recreate a version of [_Conway's Game of life_](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiD1qn7vvbsAhXwoosKHc_iDK4QFjABegQIAxAC&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FConway%2527s_Game_of_Life&usg=AOvVaw3Ren4zMW9qfyNBCmJvYMlL).

## Preface

On CodePen, I already experimented with the simulation [using the React framework](https://codepen.io/borntofrappe/pen/xxbKgMQ). The demo is also the basis for the UI used in this project. The project is more of a simulation than a game, but it does provide the option to modify the grid by selecting a specific cell, or again a pre-existing pattern.

The project is also simple enough to experiment with how Love2D sets up the gaming window. The goal is to consider the entirety of the window's width and height, so that the simulation will stretch fullscreen, based on the device running the script.

_Please note_: what follows is a series of notes carelessly jotted down as I develop the game. Eventually, I will try to elaborate the concepts in a more structured fashion.

## Fullscreen

- [`love.graphics.setMode`](https://love2d.org/wiki/love.window.setMode) with a value of `0` for the width or height

- [`love.graphics.getDimensions`](https://love2d.org/wiki/love.graphics.getDimensions) to find the resulting width and the height

- in order to position the grid at specific coordinates, in order to guarantee that the cells are square, all the while starting from a width and height which are not known, it is necessary to adjust the width or height depending on which value is greater

## Step

The function has the generation progress by 1. The logic is similar to that implemented in the game _Minesweeper_, whereby a loop is set up to consider the eight neighbors.

Be careful: it is necessary to loop through the grid twice. One to establish the number of alive neighbors, one to implement the rules based on the number itself. Otherwise you end up modifying the grid as you count the neighbors.
