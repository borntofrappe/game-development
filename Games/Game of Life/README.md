# Game of Life

The goal of this demo is to set up a grid in which to recreate a version of [_Conway's Game of life_](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiD1qn7vvbsAhXwoosKHc_iDK4QFjABegQIAxAC&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FConway%2527s_Game_of_Life&usg=AOvVaw3Ren4zMW9qfyNBCmJvYMlL).

## Preface

The project is more of a simulation than a game, but it does provide the option to modify the grid by selecting a specific cell, or again a pre-existing pattern.

The goal is also simple enough to experiment with how Love2D sets up the gaming window. The idea is to use [`love.graphics.getDimensions`](https://love2d.org/wiki/love.graphics.getDimensions) so that the simulation fills the entire window.
