# Noise

This folder works as a spiritual successor to `Lunar Lander/Noise`. The goal is to experiment with `love.math.noise`, particularly with two offset values, to draw an irregular circle.

## 2D Noise

The demo illustrates how the `love.math.noise` function accepts multiple arguments.

`makeGrid` builds a two-dimensional table in which each individual cell describes a number in the `[0,1]` range, with the goal of using the value for the alpha channel of a dark rectangle.

```lua
grid = {}
for x = 1, WINDOW_WIDTH + 1 do
  grid[x] = {}
  for y = 1, WINDOW_HEIGHT + 1 do
    grid[x][y] = love.math.noise(???, ???)
  end
end
```

The arguments describe the offset in the `x` and `y` dimension, and are updated according to the specific loop:

- in the innermost loop update `offsetY`

  ```lua
  for y = 1, WINDOW_HEIGHT + 1 do
    offsetY = offsetY + increment
  end
  ```

- in the outer loop increment `offsetX`

  ```lua
  for x = 1, WINDOW_WIDTH + 1 do
    for y = 1, WINDOW_HEIGHT + 1 do
    end
    offsetX = offsetX + increment
  end
  ```

This works, but creates a connection between rows. For each column, it is necessary to reset `offsetY`, so that the first cell in the new column is connected to the last cell of the column coming before it.

```lua
for x = 1, WINDOW_WIDTH + 1 do
  offsetY = 0
end
```

## Circle noise

The demo works to show how a circle can be drawn with a series of points. By then modifying the position of these points with a noise function, the goal is to create irregular, yet smooth circular shapes.

The points are computed using the `cos` and `sin` functions from the `math` module.

```lua
for i = 0, math.pi * 2, math.pi * 2 / 1000 do
  x = math.cos(i) * RADIUS
  y = math.sin(i) * RADIUS
end
```

Multiplying by radius is necessary to map the values returned by the trigonometric functions.

Considering these points and `love.graphics`, it is actually possible to draw a circle with at least two different methods:

1. `love.graphics.circle`

   The idea is to draw circles with a very small radius in the coordinates specified by `x` and `y`. One way to achieve this is by collecting the coordinates in individual tables, and then loop through the points' table in `love.draw`.

   In `love.load`

   ```lua
   for i = 0, math.pi * 2, math.pi * 2 / 1000 do
     table.insert(
       points,
       {
         ["x"] = RADIUS * math.cos(i),
         ["y"] = RADIUS * math.sin(i)
       }
     )
   end
   ```

   In `love.draw`

   ```lua
   for k, point in ipairs(points) do
     love.graphics.circle("fill", point.x, point.y, 2)
   end
   ```

2. `love.graphics.polygon`

   The idea is to here draw a line connecting the various points. The function is able to receive a one dimensional table as its second argument, so that the data structure is slightly different.

   In `love.load`, the coordinates are included one after the other

   ```lua
   for i = 0, math.pi * 2, math.pi * 2 / 1000 do
    local x = RADIUS * math.cos(i)
    local y = RADIUS * math.sin(i)
    table.insert(points, x)
    table.insert(points, y)
   end
   ```

   In `love.draw`, the graphics' function uses the table directly

   ```lua
   love.graphics.polygon("line", points)
   ```

The advantages of the second approach is that the points are actually connected. Reduce the number of points to see the difference.

```lua
for i = 0, math.pi * 2, math.pi * 2 / 5 do

end
```

With five points, you are essentially drawing a pentagon. With `love.graphics.polygon`, you see the polygon, while using `love.graphics.circle` you see only the vertices.

Regardless of how the points are drawn, and for reference I will be using the second solution, randomness is introduced in the measure describing the radius. The goal is to modify the radius so that the `x` and `y` values are offset from their original position.

```lua
local r = RADIUS / 2 + love.math.random() * RADIUS / 2
local x = r * math.cos(i)
local y = r * math.sin(i)
```

Here the radius varies in the `[RADIUS / 2, RADIUS]` range, since `love.math.random` returns a value in the `[0, 1]` range.

To have the radius change smoothly, randomness is introduced with `love.math.noise` instead.

```lua
local r = RADIUS / 2 + love.math.noise(offset) * RADIUS / 2
```

`offset` is initialized at `0`, and incremented by an arbitrary amount for each point.

```lua
offset = offset + OFFSET_INCREMENT
```

The higher the increment, the greater the difference between the points. To showcase this, I've modified `makeCircle` to return the points based on two arguments, the radius and the offset. In `love.update` then, I use the horizontal position of the mouse cursor to show different offset values.
