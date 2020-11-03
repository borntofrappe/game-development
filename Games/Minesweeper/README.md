# Minesweeper

The goal is to create the game minesweeper with Lua and Love2D.

## Introductory remarks

The project works more as an exercise in the language than in the game engine. This is because the gameplay requires Lua to create a grid, populate it with mines and then populate it again with hints. It is also necessary to recursively clear cells when no mine is available in the neighboring cells. That being said, the project introduces also a few Love2D features, noted here for posterity's sake:

- `Font:getWidth(text)` allows to find the width necessary to render the input text with the chosen font.

  ```lua
  gFonts["normal"]:getWidth("10")
  ```

  The function is useful to have the flag icon positioned to the left of the text displaying the number of mines.

## Design

The project takes inspiration from [a coding challenge](https://thecodingtrain.com/CodingChallenges/071-minesweeper.html) published on the [coding train website](https://thecodingtrain.com/). The challenge explains the game in the context of Processing.

In terms of UI, the idea is to replcate the style of the game Minesweeper as built-in the android application "Google Play Games".
