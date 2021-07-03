# Game of Life

[On CodePen](https://codepen.io/borntofrappe/pen/xxbKgMQ), I explored [_Conway's Game of life_](https://en.wikipedia.org/wiki/Game_of_life) with the React framework. The goal of this project is to recreate the simulation with Lua and Love2D,

The project is more of an experiment than a game, but it does provide a modicum of interaction, by pressing buttons or again a cell in the grid. The project is also simple enough to highlight how Love2D sets up the gaming window. The goal is to consider the entirety of the window's width and height, and scale the grid and buttons accordingly.

![Game of Life in a few frames](https://github.com/borntofrappe/game-development/blob/master/Showcase/game-of-life.gif)

## Game

The game sees a grid of cells that are either alive or dead. With each successive generation, the simulation progresses by considering two rules:

- a cell dies if there are less than two or more than three neighbors

- a cell is born if there are exactly three neighbors

The `step` function is responsible for implementing the two rules. I personally see two approaches to create the new generation of cells:

1. loop through the `cells` table twice, one time to count the number of alive neighbors, one time to implement the mentioned rules. This is the approach I ultimately included in the grid class

2. create a new table where you initialize an entirely different set of cells. Here the idea is to consider, without modifying, the cells of the previous iteration, and finally replace the table altogether

## Menu

The menu includes a series of buttons which themselves receive a series of arguments. Here I want to focus on `callback`, which describes a callback function like the following.

```lua
["callback"] = function()
  grid:step()
end
```

By calling `button.callback()` it is possible to execute the function as needed.

## Fullscreen

By calling the `setMode()` function with two `0` values it is possible to have Love2D stretch the game fullscreen.

```lua
love.window.setMode(0, 0)
```

Past this operation, the grid and menu are sized according to the window's width and height. The approach is rather finnicky, and works best for a window that is wider than taller. That being said, it relies on the dimensions of the window as obtained through the `getDimensions()` function.

```lua
WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
```
