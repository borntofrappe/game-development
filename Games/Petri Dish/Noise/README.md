# Noise

This folder works as a spiritual successor to `Lunar Lander/Noise`. The goal is to experiment with `love.math.noise`, particularly with two offset values, to draw an irregular circle.

## 2D Noise

The demo illustrates how the `love.math.noise` function accepts multiple arguments.

`makeGrid` builds a two-dimensional table in which each individual cell describes a number in the `[0,1]` range, with the goal of using the value for the alpha channel of a black rectangle.

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
