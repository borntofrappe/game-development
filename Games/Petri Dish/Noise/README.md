# Noise

The goal is to experiment with `love.math.noise`, particularly with two offset values.

## 2D Noise

> draw noise in two dimensions, creating a field of semi-transparent rectangles

The demo illustrates how the `love.math.noise` function works with multiple — two — arguments.

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

Consider the following visual

<svg viewBox="0 0 100 100" width="200" height="200">
<pattern id="polka-dots-1" viewBox="-5 -5 10 10" width="0.2" height="0.2">
<circle r="2" />
</pattern>

<rect width="100" height="100" fill="url(#polka-dots-1)" />
</svg>

Without resetting the offset in the row dimension, it is as if the connection exists between columns. The first cell of a column is connected to the last cell of the column before it. See the reddish dots.

<svg viewBox="0 0 100 100" width="200" height="200">
<pattern id="polka-dots-2" viewBox="-5 -5 10 10" width="0.2" height="0.2">
<circle r="2" />
</pattern>

<rect width="100" height="100" fill="url(#polka-dots-2)" />
<g fill="hsl(0, 90%, 48%)">
  <circle r="5" cx="30" cy="10" />
  <g opacity="0.75">
    <circle  r="5" cx="10" cy="90" />
  </g>
</g>
</svg>

By resetting the value, it is instead connected to the neighboring cell.

<svg viewBox="0 0 100 100" width="200" height="200">
<pattern id="polka-dots-3" viewBox="-5 -5 10 10" width="0.2" height="0.2">
<circle r="2" />
</pattern>

<rect width="100" height="100" fill="url(#polka-dots-3)" />
<g fill="hsl(0, 90%, 48%)">
  <circle r="5" cx="30" cy="10" />
  <g opacity="0.75">
    <circle  r="5" cx="10" cy="10" />
  </g>
</g>
</svg>

## Circle noise

The demo works to show how a circle can be drawn with a series of points, and how a noise function is able to render a circle with smooth irregularities.

### Points

The idea is to compute the polar coordinates of a series of points using the `cos` and `sin` functions. These essentially trace the outline of a circle.

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

Building on top of the code described in `Circle noise` demo, the goal is to create a shape which closes itself. A shape in which the first and last point match.

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

Considering the following, simplified noise field, it is essentially as if you are taking the offset values in a circle.

<svg viewBox="0 0 100 100" width="200" height="200">
<pattern id="polka-dots-3" viewBox="-5 -5 10 10" width="0.2" height="0.2">
<circle r="2" />
</pattern>

<rect width="100" height="100" fill="url(#polka-dots-3)" />
<g fill="hsl(0, 90%, 48%)">
  <circle r="5" cx="50" cy="10" />
  <g opacity="0.75">
    <circle  r="5" cx="70" cy="30" />
    <circle  r="5" cx="90" cy="50" />
    <circle  r="5" cx="70" cy="70" />
    <circle  r="5" cx="50" cy="90" />
    <circle  r="5" cx="30" cy="70" />
    <circle  r="5" cx="10" cy="50" />
    <circle  r="5" cx="30" cy="30" />
  </g>
</g>
</svg>

By walking through the circle, the first and last offset provide the same value.

_Please note_: once again, I modified the demo to have the `update` function react to the position of the mouse cursor. The idea is to here modify the offset values to provide more/less change between individual points.

```lua
local offsetX = offsetStart + math.cos(i) * multiplier
local offsetY = offsetStart + math.sin(i) * multiplier
```

`multiplier` considers the horizontal coordinate of the mouse cursor, so that as the mouse moves to the right of the screen, the shape becomes less and less circular. The shape is however and always closing itself.

## 2D Noise walk

The goal of this demo is to illustrate how and why the demo `Circle 2D noise` produces a shape which closes itself. It is based on the project shown at roughly second 38 of [this coding challenge from The Coding Train](https://youtu.be/c6K-wJQ77yQ?t=38).

Starting from `love.load`, the demo can be explained as follows:

- create a noise field in the top section of the screen, using the `makeGrid` function first developed in `2D Noise`.

  The function provides a series of cells in a 2D space, with a distinct alpha value. The alpha value is finally used for the opacity of the individual cell.

  _Please note_: the alpha value is in the `[0, 1]` range

- compute the `x` and `y` coordinates of a circle in the top section of the screen

  The idea is to ultimately loop through the points of this circle to find the alpha values of the corresponding cells

- create a table in which to store the `x` and `y` coordinates for a line drawn in the bottom section

  The coordinates are computed by looping through the points of the circle.

  Horizontally, the idea is to consider a fraction of the width, so that the line goes from end to end.

  Vertically, the idea is to instead consider the alpha value of the cell matching the coordinate of the individual point.

  _Please note_: the value in the `[0, 1]` range is mapped to the height of the available space. In this instance, the height of the window minus the height of the grid describing the noise field.

The logic works to provide the necessary data for `love.draw`:

- `grid` describes a two-dimensional table in order to draw a series of rectangles in two dimensions

- `points` describes the points for the circle overlapping the grid

- `values` describes the points for the line connecting the points and grid

_Please note_: in order to highlight the relation between the noise field and the line below, and to stress how the shape closes itself, `love.load` introduces a counter variable in `index`. This one is used to highlight the individual point in the circle in the top section, and the individual point in the line below.

The goal is to show how the first and last point match, thanks to the circular pattern, but to also stress the connection between the two areas:. Lighter values in the noise field — with lower opacity — correspond to taller points in the line — with smaller `y` values from the top.

## Blob noise

The goal is to show the design of the particles as introduced in the game. These particles have an irregular shape inspired by the `Circle 2D noise` demo, and are animated to have the irregularities constantly move.

In order to have the animation roll smoothly, the way the offset is incremented is with another two-dimensional noise. The idea is to attribute to each blob an angle, and update this angle in `love.update(dt)`.

```lua
function love.update(dt)
  for i, blob in ipairs(blobs) do
    blob.angle = blob.angle + blob.angleChange
  end
end
```

By using the angle to compute the change in the offset, it is possible to use the polar coordinates of the makeshift circle.

```lua
blob.offset = blob.offsetInitial + love.math.noise(math.cos(blob.angle), math.sin(blob.angle))
```

This ensures that the offset at angle `0` matches the offset at angle `math.pi * 2`, which means it is then possible to reset the value with a smooth transition.

```lua
if math.abs(blob.angle) > math.pi * 2 then
  blob.angle = 0
end
```

I use `math.abs` since ultimately, the way the angle is updated is by adding or removing a random amount.

```lua
["angleChange"] = love.math.random(2) == 1 and angleChange or angleChange * -1
```

This adds a bit of variety in the form of the direction of the animation.
