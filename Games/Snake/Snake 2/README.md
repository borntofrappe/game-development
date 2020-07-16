# Snake 2 - Refactor

This update is more about the structure of `main.lua`, of the code than the implementation of the game itself.

## Snake Direction

The way the direction is given to the square can be simplified, from considering a table in which to nest all possible arrow keys:

```lua
snake.direction = nil
```

To reference a single string variable. As there is no (current) need of storing anything different than the **last** arrow key, it is unnecessary to keep track of them all.

```lua
-- loop through the table of acceptable keys
for k, value in pairs(keys) do
  -- if the key matches one of the values, update the direction of the snake
  if key == value then
    snake.direction = key
  end
end
```

Checking the length of the table simply becomes checking the existence of a string. `nil` can be used in its stead.

```lua
if snake.direction then
  -- update dx and dy
end
```

Emptying the table becomes setting the variable back to `nil`.

## Dependencies and constants

Picking up from the @cs50 course, it is helpful to extract the constants in a separate file. As more and more files will be created, allowing to reduce the burden on `main.lua`, but most importantly to develop different features in dedicated locations, it is also useful to create a `Dependencies.lua` file. This one will require every necessary file and itself will be required by `main.lua`, meaning that it the central location there is only need for one statement.

```lua
require 'src/Dependencies'
```

In light of these changes, the project folder is structured with a `main.lua` file, read by Love2D to run the game, and sub-folders for every other asset. Code files are included in an `src` folder.

## Random Cell

This is a rather trivial update, but the initial location of the snake is attributed through a rather lengthy statement.

```lua
(math.random(WINDOW_WIDTH / CELL_SIZE) - 1) * CELL_SIZE
```

I decided to extract this logic in a function and have it return the desired value. This means the coordinate of the snake can be initialized by calling the dedicated function.

```lua
snake.x = randomCell

function randomCell()
  return (math.random(WINDOW_WIDTH / CELL_SIZE) - 1) * CELL_SIZE
end
```


## Snake Class

While **lua** technically doesn't have classes, and in the @cs50 course we leveraged a small library to facilitate working with such a construct, it is possible to work with tables to create instances from them. It is rather tricky and I need to go through [the manual](https://www.lua.org/pil/16.1.html) once more, but here's how it is implemented.

- create a table with default values,

  ```lua
  Snake = {
    x = 0,
    y = 0,
    width = SNAKE_WIDTH,
    height = SNAKE_HEIGHT,
    dx = 0,
    dy = 0,
    direction = nil
  }
  ```

- include a method to create an instance of the table, using the `setmetatable` function.

```lua
function Snake:init(o)
  o = o or {}
  self.__index = self
  setmetatable(o, self)
  return o
end
```

  Notice how `o` is used to initialize the table, with the values passed as argument or an empty table if there is no argument specified.

  `__index` allows to have the table pick up the fields from the `Snake` table, if need be.

- use function in `main.lua` to create the instance.

  ```lua
  snake = Snake:init()
  ```

  In the specific case of the project, `x` and `y` are detailed through the random values mentioned earlier in the project,


  ```lua
  snake = Snake:init({x = randomCell(), y = randomCell()})
  ```

And this is how `snake` is set up as an instance of the `Snake` class.

Beside `Snake:init()` it is possible to specify other functions, like `:render()` and `:update(dt)`. This is where the logic described in `main.lua` is delegated.

Just bear in mind that the addition of the `:` colon allows to have the functions use and modify the values of the table through the `self` keyword.

```lua
function Snake:render()
  love.graphics.setColor(0.224, 0.824, 0.604, 1)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
```
