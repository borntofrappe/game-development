A game of pong ultimately meant to replicate a mobile interface and touch-based input.

The paddles are created as semicircles and positioned at either end of the screen. The movement occurs by touching the left or right half of each respective panel.

## Development

Following the structure described in the course, the game is developed in increments.

### Update 0 – drawing

In the first update the goal is to draw the elements of the game. There are essentially three drawing functions in the `love.draw()` method:

- `love.graphics.circle(style, cx, cy, r)`

- `love.graphics.line(x0, y0, x1, y1, ..., xn, yn)`

- `love.graphics.arc(style, cx, cy, r, startAngle, endAngle)`

For the arc, the start and end angles are specified in radians. Use the `math` module to consider the value of PI, so to draw the two different semicircles.

With regards to other functions:

- `love.graphics.clear(color)` describes the background

- `love.graphics.setLineWidth(width)` changes the width of the stroke

- `love.graphics.setColor(color)` sets the color

The color is specified with a list of 4 values: `red, green, blue, alpha)`. Once set with the `setColor` function, it is applied to every drawing function which follows. This explains the repetition of the function, for instance to have the circle at the center of the screen semi-transparent, without compromising the opacity of the other elements.

```lua
love.graphics.setColor(1, 1, 1, 0.15)
love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42)
love.graphics.setColor(1, 1, 1, 1)
```

### Update 1 – class

Without adding any functionality, the update refactors the code to have two additional files: `Ball.lua` and `Paddle.lua`. The goal is to draw the elements using object-oriented programming, and without using the `class.lua` script introduced in the course.

I'll describe the logic for the `Ball`, but the same structure is repeated for the paddles, except for minor modifications. Refer to [programming with lua](https://www.lua.org/pil/contents.html) and the [object-oriented programming section](https://www.lua.org/pil/16.html) for more information.

In lua you don't have a concept of classes, or objects. That being said, you can create a similar construct with the only data structure it provides: tables. Tables and metatables to be precise.

Begin by initializing a table.

```lua
Ball = {}
```

In a function, labeled `:init` out of convenience, describe the characteristics of the table.

```lua
function Ball:init(cx, cy, r)

end
```

This function returns a table with a set of key value pairs.

```lua
function Ball:init(cx, cy, r)
    ball = {}

    ball.cx = cx
    ball.cy = cy
    ball.r = r

    return ball
end
```

Before returning the table however, the function specifies the following lines of code:

```lua
function Ball:init(cx, cy, r)
    -- set up table

    self.__index = self
    setmetatable(ball, self)

    return ball
end
```

What happens here is that, as you later initialize the table:

```lua
ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)
```

You get back a table with the specified key-value pairs. If you try to access one of its keys, lua will look at the table to try and find a match.

```lua
ball.dx -- WINDOW_WIDTH / 2
```

If it doesn't find a match, and instead of immediately returning `nil`, lua then looks for the key in the metatable `Ball`.

```lua
ball.dx
--[[
  1. ball.dx nil
  2. Ball.dx nil

  return nil
--]]
```

With this in mind, you can see how `ball` works similarly to an instance, an object of the class `Ball`. It is just a different mental model, where you have a table reference a "parent", "master" table if need be.

Conveniently, you can assign to the table attributes and functions alike. For the `:render` function for instance, you can make sure each "instance" has access to the render logic by specifying the function on the metatable.

```lua
function Ball:render()
    love.graphics.circle('fill', self.cx, self.cy, self.r)
end
```

Once the instance variable then calls `ball:render()`, you are effectively using the logic of `Ball:render`, with the `cx`, `cy` and `r` values of `ball`.
