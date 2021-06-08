# Flappy Bird 6

_Please note:_ `main.lua` depends on a few assets in the `res` folder:

- `push.lua` and `class.lua` in `res/lib`

- a series of images in `res/graphics`

## Pairs

The idea of the game is to have pipes presented in pairs, so that the bird can fly in the gap between the two. To this end, add a new class in `PipePair.lua`

- `Pipe` is responsible for drawing a single pipe

- `PipePair` is responsible for initializing two pipes, with the same horizontal coordinate, but different vertical dimension. It is also responsible for the movement of the pipes. Ultimately, the game will initialize the pipes through `PipePair` instead of `Pipe`

## Pipe

Since it is necessary to draw the pipes one opposed to the other, the class is updated to draw the image straight, or mirrored.

So far `love.draw` describes what to draw and where to draw it with three arguments.

```lua
-- drawable, x, y
love.draw(PIPE_IMAGE, self.x, self.y)
```

The function however, accepts more arguments.

```lua
-- drawable, x, y, rotation, horizontal scale, vertical scale
love.draw(PIPE_IMAGE, self.x, self.y, 0, 1, 1)
```

Using a negative value for the vertical scale allows to draw the pipe top down.

```lua
love.draw(PIPE_IMAGE, self.x, self.y, 0, 1, -1)
```

With this in mind, update the `init` function to consider the different origin.

```lua
function Pipe:init(origin)
  self.origin = origin
end
```

If we assume the `origin` can be either `top` or `bottom`, the draw function uses then a ternary operator depending on this value.

```lua
love.graphics.draw(
  PIPE_IMAGE,
  self.x,
  self.y
  0,
  1,
  self.origin == 'top' and 1 or -1
)
```

The image is "flipped" vertically and using the top left corner as a hinge. Keep this in mind once you describe the coordinates of the pipes.

### Update

Since the logic for the pipes is moved up a level, to `PipePair`, modify the `Pipe` class to receive the `x` and `y` coordinate as well.

```lua
function Pipe:init(x, y, orientation)
    self.x = x
    self.y = y
    self.orientation = orientation
end
```

Moreover, remove the logic dedicated to the movement of the pipe. Once again, `PipePair` is responsible for the scroll, while `Pipe` is included purely to draw a single instance of a pipe.

## PipePair

### init

The class initializes two instances of the `Pipe` class.

```lua
require 'Pipe'

function PipePair:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT / 8, VIRTUAL_HEIGHT / 8 * 7)
    self.pipes = {
        upper = Pipe(),
        lower = Pipe()
    }
end
```

Notice how the pipes are included in a table. For the coordinates of the two, use `self.x`, `self.y`, and a value for the origin describing the two opposite sides.

```lua
function PipePair:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT / 8, VIRTUAL_HEIGHT / 8 * 7)
    self.pipes = {
        upper = Pipe(self.x, self.y, 'top'),
        lower = Pipe(self.x, self.y, 'bottom')
    }
end
```

The image is flipped from the top left corner, which means the two pipes are effectively attached. To create a gap, change the vertical coordinate of one of the two instances:

- move the upper pipe toward the top

  ```lua
  upper = Pipe(self.x, self.y - GAP_HEIGHT, 'top')
  ```

- **or**, move the lower pipe toward the bottom

  ```lua
  lower = Pipe(self.x, self.y + GAP_HEIGHT, 'bottom')
  ```

### render

Since the class describes two pipes, it is necessary to loop through the table render both.

```lua
function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
```

### update

This is where the logic which previously described the movement of the pipe is included.

The idea is to modify the `x` coordinate exactly like for the individual pipe.

```lua
local PAIR_SCROLL = -40

function PipePair:update(dt)
    self.x = self.x + PAIR_SCROLL * dt
end
```

Unlike the previous version however, it is then necessary to modify the position of the pipes by considering the contents of `self.pipes`

```lua
function PipePair:update(dt)
    self.x = self.x + PAIR_SCROLL * dt
    -- have the pipes match the x value
    for k, pipe in pairs(self.pipes) do
        pipe.x = self.x
    end
end
```

## main

Instead of using the `Pipe` class, require and use `PipePair`.

```diff
-require 'Pipe'
+require 'PipePair'

-local pipes = {}
+local pipePairs = {}
```

In the `update` and `draw` function, continue updating the code to use `pipePairs` instead of `pipes`. The only difference is how the pairs are ultimately removed. Since `main.lua` has no longer access to the width of the individual pipe, use the value of a boolean set up in the `PipePair` class.

```lua
if pipePair.remove then
  table.remove(pipePairs, k)
end
```

In `PipePair.lua` then, use the boolean depending on the horizontal positoin of the pair.

```lua
function PipePair:init()
    self.remove = false
end
```

Since the width of the pipes does not change, you can use a constant to then switch the boolean to `true`

```lua
PAIR_WIDTH = 70
function PipePair:update(dt)
    self.x = self.x + PAIR_SCROLL * dt

    if self.x < -PAIR_WIDTH then
        self.remove = true
    end
end
```

## y

Instead of using a purely random value for the `y` coordinate, the course introduces a variable in `y`. The idea is to initialize the value at random, and then have the value fluctuate within a range. In this manner, the gaps between successive pipes are not too distant.

```lua
local y = math.random(VIRTUAL_HEIGHT / 7, VIRTUAL_HEIGHT / 7 * 6)
```

Use the value when initializing the pipes.

```lua
table.insert(pipePairs, PipePair(y))
```

Update the value after the initialization of a pair.

```lua
table.insert(pipePairs, PipePair(y))

following_y = y + math.random(50, -50)
y = math.min(math.max(0, following_y), VIRTUAL_HEIGHT)
```

Using `math.min` and `math.max` you can clamp the coordinate in the boundaries of the game window.
