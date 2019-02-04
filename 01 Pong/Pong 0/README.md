# Pong 0

Index:

- [Code](#code)

- [Video](#video)

Snippet:

- main.lua

## Code

- resolutions is set in the form of screen width and height. Two constant variables are declared in the global scope:

    ```lua
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720
    ```

Notice again the lack of semicolons. Notice also the lack of a type or any identifier for the variable.

- love works <!-- in mysterious ways --> through two main functions: `love.load()` and `love.draw()`.

    `love.load()` runs once, as the game starts out. It is here that you ought to set those variables and options which initialize the games.

    `love.draw()` runs after a love2d update, to literally draw something on th screen.

- in the load function, the size of the screen is modified through the `setMode()` method. This alters the size of the window as follows:

      ```lua
      love.window.setMode(width, height, options)
      ```

     `options` relates to an object detailing additional settings on the window.

- in the draw function, text is printed on the screen through the `printf` method. It works as follows:

      ```lua
      love.graphics.printf(text, x, y, centerScope, centerKeyword)
      ``` 
    
    `x` and `y` dictacte where the text ought to be positioned. `centerScope` relates to the scope in which the text ought to be centered (in the snippet the text is centered in relation to the width if the screen). Finally `centerKeyword` is exactly that, a keyword like `center` to deetermine the actual position.

- last, but perhaps most importantly, comments are included following two dashes: `--`. Multi line comments follow up the two dashes with two sets of square brackets `--[[ ]]`.

## Video

The three main functions are:

- `love.load()`. Love2d will look in a main.lua file and run love.load(). This is akin to a startup function, where you ought to initialize the project.

- `love.update(dt)`. `dt` being delta time. Love2D calls this function on each frame, and you can use the argument to update the application according to the passage of time.

- `love.draw()`. Drawing and rendering behavior is encapsulated in this function.

Also important functions, but nested within the big three are:

- `love.graphics.printf()`. Drawing physically to the screen.

- `love.window.setMode()`. Setting up the window and a few parameters.

Beside these elements from the love2D framework, and regarding more the programming language, tables in lua are the equivalent of objects in JavaScript, and follow the syntax:

```lua
{
  property = value,
  property = value,
  property = value,
}
```

