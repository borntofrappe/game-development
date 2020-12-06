# Terrain

Here I explore how to create the terrain for the eventual game.

## Flat line

Render a line by connecting a series of points. This allows to later create holes by modifying the `y` coordinates of consecutive points.

## Trigonometric holes

Include holes in the form of a series of points with varying `y` coordinates. The value is modified through the `sin` function and considering the range `[math.pi, 0]`, describing a counter-clockwise arc.

## Normal distribution

Alter the default flat line to draw a hill. The idea is to use the result of a function returning the value for a normal distribution.

```lua
function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * EULER_NUMBER ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end
```

Euler's number is prefaced at the top of the script as `2.71828`, `mu` and `sigma` relate to the key parameters of the functions, more on these in a bit, and `x` describes instead the coordinate on the horizontal axis. The value returned by the function is scaled to have a clear impact on the terrain.

```lua
local y = WINDOW_HEIGHT * 3 / 4 - getNormalDistribution(x, mu, sigma) * NORMAL_DISTRIBUTION_SCALE
```

For `mu` and `sigma`, remember the following:

- `mu`, the mean, describes the horizontal coordinate for the topmost value. It is initialized in the middle section of the screen to have the slope distance from both players sides

- `sigma` details the incline of the slope by determining the number of values falling in the `[mu - sigma, mu + sigma]` range. The greater the value, the more wide and gentle the slope. The smaller, the more tall and steep
