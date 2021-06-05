# Pong 1

## Game loop

A game is an infinite loop. In this loop, we continuously go through a series of steps

- listen for input

- update the game according to the input

- render whatever was updated

## Functions

The engine expects a `main.lua` file and runs `love.load()`. `load` works as a startup function, and it is a good place in which to initialize the project and necessary variables.

Past `love.load`, the framework runs `love.draw()` after every update to draw something on th screen

To update the game LOVE executes the code in `love.update()`. The function receives delta time, as in the amount of time since the previous frame, and modifies the game as wanted.

_Please note:_ `main.lua` defines only the load and draw function, as the demo is not updated in any sort of way

## More functions

- `love.window.setMode` specifies the dimensions of the window through the value stored in two variables and at the top of the script.

  ```lua
  WINDOW_WIDTH = 1280
  WINDOW_HEIGHT = 720
  ```

- `printf` renders text on the screen

  ```lua
  love.graphics.printf(text, x, y, centerScope, centerKeyword)
  ```

  `x` and `y` dictate where the text ought to be positioned. `centerScope` relates to the scope in which the text ought to be centered (in the snippet the text is centered in relation to the width of the screen). Finally `centerKeyword` is a keyword like `center` to determine the actual position.

  ```lua
  love.graphics.printf('Hello World', 0, WINDOW_HEIGHT / 2 - 6, WINDOW_WIDTH, 'center')
  ```

  `6` is the default size for the text in LOVE2D.

  `love.graphics.print` includes text without a specific alignment

  ```lua
  love.graphics.print(text, x, y)
  ```
