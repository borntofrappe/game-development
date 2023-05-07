# Pong AI

A "game" of pong where two AI-controlled paddles try to make up for the lost time.

![Pong AI](https://github.com/borntofrappe/game-development/blob/main/Practice/Pong%20AI/pong-ai.gif)

## Game

- pick a side to support

- the chosen side receives the ball

- the winner takes double the points if it was **not** chosen

- game ends at 5

- you are notified of how many times you supported the victor

## Dev notes

The project follows the development of "00 Pong", and the lessons learned up the final version and the accompanying assignment.

There are a few things worth remembering.

### Window

Aside from `love.window.setTitle`, the project leans on `love.window:setMode` to set up the window. There are a few notes updating the logic described in the course.

- `vsync` is a number, and no longer a boolean; it is enabled by default

- `resizable` is set to `false` by default

### Text

Love2D has a couple of functions to handle text, and specifically the text's dimensions:

- `font:getHeight()` returns the height of the font

  Technically you set the height when you create the font with `love.graphics.newFont`, but the helper is useful after the first declaration. You can skip having a separate variable or using a hard-coded offset

- `font:getWidth(text)` returns the width for the font _and_ the input string

In terms of Lua, there are also a couple of functions to format the text:

- `string.upper(text)`, or `text:upper()` if you prefer the colon character, returns the uppercase string. It does not mutate the original piece

- `string.format(rule)` helps to format input values, such as numbers, with directives. The directives are taken directly from the C language, and in the project help to format the percentage with two numbers after the decimal point

```lua
string.format("%.2f%%", game.score)
```
