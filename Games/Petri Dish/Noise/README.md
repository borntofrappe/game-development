# Noise

This folder works as a spiritual successor to `Lunar Lander/Noise`. The goal is to experiment with `love.math.noise`, particularly with two offset values.

## 2D Noise

The demo illustrates how the `love.math.noise` function accepts multiple arguments.

`makeGrid` builds a two-dimensional table where each individual cell describes a number in the `[0,1]` range. The goal is to use this value for the alpha channel of a black rectangle.

```lua
for column = 1, columns do
  grid[column] = {}
  for row = 1, rows + 1 do
    grid[column][row] = {
      ["alpha"] = love.math.noise(???, ???)
    }
  end
end
```

The arguments describe the offset in the `x` and `y` dimension, and are updated according to the specific loop:

- in the innermost loop update `offsetY`

  ```lua
  for row = 1, rows + 1 do
    offsetRow = offsetRow + OFFSET_INCREMENT
  end
  ```

- before the end of the outer loop increment `offsetX`

  ```lua
  for column = 1, columns do
    for row = 1, rows + 1 do
      -- update offset row
    end
    offsetColumn = offsetColumn + OFFSET_INCREMENT
  end
  ```

This works, but creates a connection between rows. For each column, it is necessary to reset `offsetY`, so that the first cell in the new column is connected to the last cell of the column coming before it.

```lua
for column = 1, columns do
  offsetRow = 0
  -- update offset values
end
```

## Circle noise

The demo works to show how a circle can be drawn with a series of points, and how a noise function is able to render a circle with smooth irregularities.

### Points

The points benefit from the polar coordinates computed using the `cos` and `sin` functions.

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

   In `love.load`:

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

   In `love.draw`:

   ```lua
   for i, point in ipairs(points) do
     love.graphics.circle("fill", point.x, point.y, 2)
   end
   ```

2. `love.graphics.polygon`

   The idea is to here draw a line connecting the various points. The function is able to receive a one dimensional table as its second argument, so that the data structure is slightly different.

   In `love.load`, the coordinates are included one after the other:

   ```lua
   for i = 0, math.pi * 2, math.pi * 2 / 1000 do
    local x = RADIUS * math.cos(i)
    local y = RADIUS * math.sin(i)
    table.insert(points, x)
    table.insert(points, y)
   end
   ```

   In `love.draw`, the graphics' function uses the table directly:

   ```lua
   love.graphics.polygon("line", points)
   ```

The advantages of the second approach is that the points are actually connected. Reduce the number of points to see the difference.

```lua
for i = 0, math.pi * 2, math.pi * 2 / 5 do

end
```

With five points, you are essentially drawing a pentagon. With `love.graphics.polygon`, you see the polygon, while using `love.graphics.circle` you see only the vertices.

### Noise

Regardless of how the points are drawn (for reference I'll adopt the `polygon` function), randomness is introduced in the measure describing the radius. The goal is to modify the radius so that the `x` and `y` values are offset from their original position.

```lua
local r = RADIUS / 2 + love.math.random() * RADIUS / 2
local x = r * math.cos(i)
local y = r * math.sin(i)
```

Here the radius varies in the `[RADIUS / 2, RADIUS]` range, since `love.math.random` returns a value in the `[0, 1]` range. The snippet finally creates a shape with jagged edges, as there is not connection between successive points.

To have the radius change smoothly, randomness is introduced with `love.math.noise` instead.

```lua
local r = RADIUS / 2 + love.math.noise(offset) * RADIUS / 2
```

`offset` is initialized at `0`, and incremented by an arbitrary amount for each point.

```lua
offset = offset + OFFSET_INCREMENT
```

The higher the increment, the greater the difference between the points.

_Please note_: the demo is updated so that it considers the position of the mouse cursor. As the mouse moves horizontally, the idea is to create a circle with an offset proportional to the `x` coordinate.

## Circle 2D noise

Building on top of the code described in `Circle noise`, the goal is to create a shape which closes itself. A shape in which the first and last point match.

This is achieved by having `love.math.noise` use two arguments, and have these arguments describe an offset in two dimensions.

```lua
local offsetX = ???
local offsetY = ???
local r = radius / 2 + love.math.noise(offsetX, offsetY) * radius / 2
```

To have the first and last offset match, it is possible once again to use the polar coordinates.

```lua
local offsetX = offsetStart + math.cos(i)
local offsetY = offsetStart + math.sin(i)
```

Since the counter variable varies in the `[0, math.pi * 2]` range, the first and last offset describe the same values.

_Please note_: once again, I modified the demo to have the `update` function react to the position of the mouse cursor. The idea is to here modify the offset values to provide more/less change between individual points.

```lua
local offsetX = offsetStart + math.cos(i) * multiplier
local offsetY = offsetStart + math.sin(i) * multiplier
```

`multiplier` considers the horizontal coordinate of the mouse cursor, so that as the mouse moves to the right of the screen, the shape becomes less and less circular. The shape is however and always closing itself.

## Resources

- [Coding Train on noise loops](https://thecodingtrain.com/CodingChallenges/136.1-polar-perlin-noise-loops.html)

- [Coding Train on Perlin noise GIF loops](https://thecodingtrain.com/CodingChallenges/136.2-perlin-noise-gif-loops)
