# Flappy Bird 5

_Please note:_ `main.lua` depends on a few assets in the `res` folder:

- `push.lua` and `class.lua` in `res/lib`

- a series of images in `res/graphics`

## Pipes

Pipes are included much similarly to the bird:

- define a class

  ```lua
  Pipe = Class{}
  ```

- include the graphic through the `newImage` function

  ```lua
  function Pipe:init()
      self.image = love.graphics.newImage('res/graphics/pipe.png')
      self.width = self.image:getWidth()
      self.height = self.image:getHeight()

      self.x = VIRTUAL_WIDTH / 4 * 3
      self.y = VIRTUAL_HEIGHT - self.height
  end
  ```

  `x` and `y` are here hard-coded just to illustrate how to include the graphic

- render the visual with the `draw` function

  ```lua
  function Pipe:render()
      love.graphics.draw(self.image, self.x, self.y)
  end
  ```

In `main.lua` initialize an object.

```lua
require 'Pipe'

local pipe = Pipe()
```

Here I include just a copy, again to illustrate the class. Ultimately, the game will include more than a pipe, and it makes sense to use a table more than a variable.

```lua
function love.draw()
  pipe:render()
end
```

The image is `288` pixels tall, which means the pipe occupies the entirety of the game window. Ultimately however, this won't be a problem as the image is positioned above and below the game window to create a gap.

### Update

The previous section illustrates how to include the pipe similarly to the bird. For efficiency's sake however, it is better to load the image of the pipe outside of the `init` function.

```lua
local PIPE_IMAGE = love.graphics.newImage('res/graphics/pipe.png')
```

In this manner the image is loaded only once, and not every time an object is instantiated. As more and more pipes are created, they all use the same asset described in `PIPE_IMAGE`.

In `Pipe.lua`, update the code to then use the variable `PIPE_IMAGE` instead of `self.image`, which is no longer required.

## Movement

The pipe(s) is(are) meant to move horizontally.

```lua
local PIPE_SCROLL = 60

function Pipe:update(dt)
    self.x = self.x - PIPE_SCROLL * dt
end
```

Just be sure to update the graphic in `main.lua`

```lua
function love.update(dt)
  pipe:update(dt)
end
```

## Pipes

As mentioned, the game needs to display multiple copies of the pipe asset. In `main.lua` initialize a table instead of a variable.

```lua
local pipes = {}
```

With the `table` module then, include the pipes with the `insert` function.

```lua
table.insert(pipes, Pipe())
```

And to render every instance in the table, loop through the `pipes` table with `pairs`.

```lua
function love.draw()
  for k, pipe in pairs(pipes) do
    pipe:render()
  end
end
```

Similarly, loop through the table to update the position of the assets.

```lua
function love.update(dt)
  for k, pipe in pairs(pipes) do
    pipe:update(dt)
  end
end
```

## Time

You can manually add instances of the pipe class, for instance following user input.

```lua
function love.keypressed(key)
  if key == 'p' then
    table.insert(pipes, Pipe())
  end
end
```

This is also handy for debugging purposes.

For the purpose of the game however, it is preferable to add pipes at an interval.

In `main.lua`, initialize two variables:

- `timer` to keep track of the passing of time

- `interval` to dictate how often to include pipes

```lua
local timer = 0
local interval = 3
```

In `love.update(dt)` then, add `dt` to the timer, and include an instance of the pipe class when the variable exceeds the interval.

```lua
function love.update(dt)
  timer = timer + dt
  if timer > interval then
    timer = timer % interval
    table.insert(pipes, Pipe())
  end
end
```

### Update

The previous code works, but the pipes pop into frame as if out of nowhere. It makes sense to initialize the horizontal coordinate to start at `VIRTUAL_WIDTH`.

```lua
function Pipe:init()
    self.x = VIRTUAL_WIDTH
end
```

In this manner the pipes slide as if from the right side of the window.

For the vertical coordinate then, use a random integer.

```lua
function Pipe:init()
    self.y = math.random(VIRTUAL_HEIGHT / 8, VIRTUAL_HEIGHT / 8 * 7)
end
```

Just remember that the coordinate system starts at (0, 0) in the top left corner, and a greater value pushes the pipe downwards.

## Efficiency

The pipes are included at an interval, but never removed from the `pipes` table. This is especially inefficient considering that the movement of each instance is tracked and updated even if the visuals cross the left side of the window.

Use `table.remove` once the pipes exceed this threshold.

```lua
function love.update(dt)
  for k, pipe in pairs(pipes) do
    pipe:update(dt)

    if pipe.x < 0 - pipe.width then
      table.remove(pipes, k)
    end
  end
end
```

Notice that the `remove` function requires the key of the item being removed.

Modify the condition to see that the pipes are actually removed.

```lua
if pipe.x < VIRTUAL_WIDTH / 2 then
end
```

## Random

Since the game uses the `random` function, be sure to include a different seed every time the game starts.

```lua
function love.load()
  math.randomseed(os.time())
end
```
