# Pong 1

- print a string in the center of a window

- learn about the main functions in LOVE: `load()`, `update(dt)`, `draw()`

## Dimensions

`love.window.setMode` specifies the dimensions of the window through the value stored in two variables and at the top of the script.

```lua
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
```

## Functions

The engine expects a `main.lua` file and runs `love.load()`. `load` works as a startup function, and it is a good place in which to initialize the project and necessary variables.

Past `love.load`, the framework runs `love.draw()` after every update to draw something on th screen

To update the game LOVE executes the code in `love.update()`. The function receives delta time, as in the amount of time since the previous frame, and modifies the game as wanted.

_Please note:_ `main.lua` defines only the load and draw function, as the demo is not updated in any sort of way

## Print

Text is rendered on the screen through the `printf` method. It works as follows:

```lua
love.graphics.printf(text, x, y, centerScope, centerKeyword)
```

`x` and `y` dictate where the text ought to be positioned. `centerScope` relates to the scope in which the text ought to be centered (in the snippet the text is centered in relation to the width of the screen). Finally `centerKeyword` is a keyword like `center` to determine the actual position.
