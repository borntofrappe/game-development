# Minesweeper

The goal is to create the game minesweeper with Lua and Love2D. This works more as an exercise in the language than in the game engine, as the gameplay requires Lua to create a grid, populate it with mines and then populate it again with the hints. It is also necessary to recursively clear cells when no mine is available in the neighboring cells.

## Introductory remarks

[A coding challenge](https://thecodingtrain.com/CodingChallenges/071-minesweeper.html) from the [coding train website](https://thecodingtrain.com/) works to explain the game in the context of Processing.

The built-in version available from the "Google Play Games" app works as an inspiration for the design and graphics.

## Features

The game is actively in development, and the following works more as a wishlist more than a collection of available features.

- mouse and keyboard input

- easy, medium, hard mode, changing the number of mines and the size of the grid as detailed in the following table

  | Mode   | Mines | Columns | Rows |
  | ------ | ----- | ------- | ---- |
  | Easy   | 10    | 7       | 11   |
  | Medium | 35    | 11      | 17   |
  | Hard   | 75    | 15      | 23   |

- optional audio
