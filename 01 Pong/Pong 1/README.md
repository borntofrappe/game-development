Here you print a string in the center of a window.

You learn about the main functions behind the love2d game engine: `load()`, `update()`, `draw()`.

## Code

- resolutions is set in the form of screen width and height. These are declared in the global scope:

  ```lua
  WINDOW_WIDTH = 1280
  WINDOW_HEIGHT = 720
  ```

- `main.lua` describes two main functions: `love.load()` and `love.draw()`

  - `love.load()` runs once, as the game starts out. It is here where you initialize the game and its variables

  - `love.draw()` runs after a love2d update, to literally draw something on th screen.

- in the load function, the size of the screen is modified through the `setMode()` method. This alters the size of the window as follows:

      ```lua
      love.window.setMode(width, height, options)
      ```

  `options` relates to a table detailing additional settings on the window

- in the draw function, text is printed on the screen through the `printf` method. It works as follows:

      ```lua
      love.graphics.printf(text, x, y, centerScope, centerKeyword)
      ```

  `x` and `y` dictacte where the text ought to be positioned. `centerScope` relates to the scope in which the text ought to be centered (in the snippet the text is centered in relation to the width of the screen). Finally `centerKeyword` is a keyword like `center` to determine the actual position.

## Video

From the video, the lecturer highlights a few important functions.

The three main functions used by the love2d engine are:

- `love.load()`. The game engine will look in a `main.lua` file and run `love.load()`. This is akin to a startup function, and it is a good place in which to initialize the project and necessary variables

- `love.update(dt)`, where `dt` represents delta time. The engine calls `love.update(dt)` on each frame. Use this function to update the game, and the `dt` argument to consider the passage of time

- `love.draw()`. The game engine calls `love.draw()` to draw / render something in the window.

Also important functions, but nested within the previous ones:

- `love.graphics.printf()`. Draw text.

- `love.window.setMode()`. Set up the window.

Each function accepts a series of arguments to specify its behavior. Refer to the docs for the details.
