## Lessons learned

### Drawing functions

Functions like `setColor`, `translate` and `rotate` affect every graphic which follows. Consider the semicircles showing the serving side. Setting the color with a lower alpha channel affects every shape, and it is necessary to set a new value, or reset the previous one after the shapes are drawn.

```lua
love.graphics.setColor(1, 1, 1, 0.05)
-- arc1
love.graphics.setColor(1, 1, 1, 0.2)
-- arc2

-- other shapes
love.graphics.setColor(1, 1, 1, 1)
```

### OOP with Lua

In the playlist, the lecturer introduces a utility to work with classes. Lua does not provide class as a native construct, but it can implement a similar structure by working on the single data structure it provides: tables.

The concept is explained in increments in the [object oriented programming section](https://www.lua.org/pil/16.html) of [programming with lua](https://www.lua.org/pil/contents.html), and the step by step tutorial is more than recommended.

That being said, here's how I rationalize the concept for the project at hand. I'll consider `Ball.lua` as a reference, but the same consideration holds true for `Paddle.lua` as well.

Begin by initializing a table.

```lua
Ball = {}
```

In a function, labeled here `:init` out of convenience, describe the characteristics of the table.

```lua
function Paddle:init(x, y, r)

end
```

`x` and `y` detail the coordinates for the center of the circle, while `r` its radius. The idea is to ultimately repeat the syntax introduced with classes:

```lua
ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)
```

To get to this point however, `Paddle:init` requires a few more instructions than just setting the values through the `self.variable` syntax.

In the `init` function, initialize another table. Consider this a template.

```lua
function Ball:init(x, y, r)
    ball = {}

end
```

Include the values passed in the `:init` function in the table itself.

```lua
function Ball:init(x, y, r)
    ball = {}

    ball.x = x
    ball.y = y
    ball.r = r

end
```

This is the tricky portion. Add the following lines of code:

```lua
function Ball:init(x, y, r)
    -- set up table

    self.__index = self
    setmetatable(ball, self)

    return ball
end
```

I'll point you once more toward [the docs](https://www.lua.org/pil/2.5.html), but the idea is to specify a metatable, that is a reference, a connection to a table.

Say you create an instance of the ball:

```lua
ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8)
```

When retrieving a value from the table, Lua will look into the table and try to provide an answer.

```lua
ball.x -- WINDOW_WIDTH / 2
```

If it doesn't find a match, it should return `nil`

```lua
ball.dx -- nil
```

However, if you set a metatable as with the previous snippet, Lua will look in the metatable before returning `nil`. Effectively, the following lines of code:

```lua
self.__index = self
setmetatable(ball, self)
```

Ensure that the instance of the `Ball` table picks up every attribute, every function set up specified for `Ball` itself. Almost as if you were creating an object of the `Ball` class.

Once you add a function to render the ball for instance (notice how the function uses `Ball`).

```lua
function Ball:render()
    love.graphics.circle('fill', self.x, self.y, self.r)
end
```

As you then call `ball:render()`, Lua will look into the table `ball`, but it won't find any `render` function. It will then look into the metatable `Ball`, and find the necessary instructions.

## Loop through a table

The players are initialized in the `load` function, and then stored in a table.

```lua
player1 = Paddle:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT, 28, true)
player2 = Paddle:init(WINDOW_WIDTH / 2, 0, 28, false)

players = {
    {
        player = player1,
        right = "right",
        left = "left"
    },
    {
        player = player2,
        right = "d",
        left = "a"
    }
}
```

The idea is to then loop through this table to update/render both paddles with a more concise syntax. I'm still experimenting with Lua and data structures, so this approach might change.

To loop through the table, use the following syntax:

```lua
for i, player in ipairs(players) do

end
```

`i` refers to a counter variable, while `player` describes the nested tables.

One note regarding `ipairs`: you can use `pairs` and the code would still work.

```lua
for i, player in pairs(players) do

end
```

The difference emerges when the table has keys. In this instance, it is necessary to use `pairs`

```lua
table = {
    name = 'timothy',
    age = 28,
    gender = 'M'
}

for k, v in pairs(table) do
    print(k, v)
end
--[[
name	timothy
age	28
gender	M
]]
```

When the table doesn't have keys, `pairs` uses the index, which explains why the two are equivalent in the project at hand.

```lua
table = {
    'timothy',
    28,
    'M'
}

for k, v in pairs(table) do
    print(k, v)
end
--[[
1	timothy
2	28
3	M
]]

for k, v in ipairs(table) do
    print(k, v)
end
--[[
1	timothy
2	28
3	M
]]
```
