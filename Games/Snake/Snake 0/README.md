# Snake 0 - Green Square on a Screen

Through the first update I set out to include a rectangle which can be freely moved through the arrow, or awsd, keys. This is more to rehearse how to set up a `main.lua` than to delve in the game's own dynamics.

A **Love2D** project revolves around three main functions:

- `love.load`, running once to set up the game;

- `love.update(dt)`, running every time the game refreshes to literally update the game, its appearance and logic;

- `love.draw()`, running every time `update(dt)` alters a drawable, to have the game actually rendered on screen.

### love.load

- set the title of the application through `love.window.setTitle()`;

- set the size of the window through `love.window.setMode()`;

### love.draw

- include a solid background through `love.graphics.clear`

- include a rectangle through `love.graphics.rectangle`;

- change the color of the drawable **before** adding the necessary graphic and through `love.graphics.draw`.

Just remember that colors are included through **rgba** codes, with values ranging in [0-1] intervals.

```lua
love.graphics.clear(0.035, 0.137, 0.298, 1)
love.graphics.setColor(0.224, 0.824, 0.604, 1)

love.graphics.rectangle('fill', 0, 0, 10, 10)
```

This effectively pops up a small window with the appropriate name and a solid square in the top left corner.

### variables and constants

Instead of describing the values for the size and the position of the square wherever needed, it is better to create a variable which is then used throughout the codebase. This allows to change a value in one location and have it ripple through the entirety of the application.

This practice is useful not only for variables, but also constants, such as those included in the `love.window.setMode()` function for the width and height of the screen.

The constants are included before `love.load`:

```lua
WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SNAKE_WIDTH = 10
SNAKE_HEIGHT = 10
```

While the variables for the square are initialized in the load function itself.

```lua
snake = {
  x = 0,
  y = 0,
  width = SNAKE_WIDTH,
  height = SNAKE_HEIGHT
}
```

`love.draw` is appropriately modified to include the variables.

```lua
love.graphics.rectangle('fill', snake.x, snake.y, snake.width, snake.height)
```

## x and y

Instead of having the square always positioned in the top left corner, I decided to include a bit of randomness in where the shape is spawned. Instead of including a completely random value however, I also decided to have the square always positioned at a multiple of its width and height. This will become useful in a later update, as I plan to move the square in a grid of fixed values. The idea is to have a 10x10 square, for instance, always move in multiples of 10. (0, 0), (10, 40) being accetable coordinates.

In terms of initial location this requires a bit of math, but it is rather understandable. For the `x` coordinate:

- divide the width of the screen by the width of the shape. This gives the possible number of locations.

  ```lua
  (WINDOW_WIDTH / SNAKE_WIDTH)
  ```

  Consider absurd sizes, like 500 for the width of the screen and  250 for the width of the snake. This division gives 2.

- have a random number up to the number of locations.

  ```lua
  math.random(WINDOW_WIDTH / SNAKE_WIDTH)
  ```

  With the arbitrary absurd numbers in mind, this gives a value at random between 1 and 2.

- decrement the random number by 1.

  ```lua
  (math.random(WINDOW_WIDTH / SNAKE_WIDTH) - 1)
  ```

  This is because the snake needs to be positioned in an interval ranging between 0 and (the width of the screen - the width of the shape).

  With the given numbers, the value is now 0 or 1.

- multiply the value by the width of the shape.

  ```lua
  x = (math.random(WINDOW_WIDTH / SNAKE_WIDTH) - 1) * SNAKE_WIDTH
  ```

  Finally, this leads to the desired coordinate. For the numbers, a value representing 0 or 250.

The same logic is applied for the vertical coordinate. As long as the width and height of the screen are a multiple of the counterpart measures for the shape, the result is to have the shape exactly in a cell of a made-up grid, divided to accommodate for the exact size of the square.

One important note about `math.random()`: to have the return value truly random you need to set a random seed. The time of the operating system is conventionally used for this task.

```lua
math.randomseed(os.time())
```
