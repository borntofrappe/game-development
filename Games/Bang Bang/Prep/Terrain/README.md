# Terrain

Here I explore how to create the terrain for the eventual game.

## Line

Render a line by connecting a series of points. This allows to later create holes by modifying the `y` coordinates of consecutive points.

## Holes

Include holes in the form of a series of points with varying `y` coordinates. The value is modified through the `sin` function and considering the range `[math.pi, 0]`, describing a counter-clockwise arc.

## Hill

Alter the default terrain to draw a hill. The idea is to use the result of a function returning the value for a normal distribution.

```lua
function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * EULER_NUMBER ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end
```

Euler's number is included at the top of the script as `2.71828`, `mu` and `sigma` relate to the key parameters of the functions (more on these in a bit) and `x` describes instead the coordinate on the horizontal axis. The value returned by the function is scaled to have a clear impact on the terrain.

```lua
local y = WINDOW_HEIGHT * 3 / 4 - getNormalDistribution(x, mu, sigma) * NORMAL_DISTRIBUTION_SCALE
```

For `mu` and `sigma`, remember the following:

- `mu`, the mean, describes the horizontal coordinate for the topmost value. It is initialized in the middle section of the screen to have the slope distance from both players sides

- `sigma` details the incline of the slope by determining the number of values falling in the `[mu - sigma, mu + sigma]` range. The greater the value, the more wide and gentle the slope. The smaller, the more tall and steep

Notice that the hole included through the makeshift cannonball from the previous demo still works with the uneven terrain. This is because ultimately, the hole is created by adding a value to the `y` coordinate of consecutive points.

## Asymmetric Hill

The goal is to have the line describing the terrain start and end at different `y` values. This is achieved by scaling the normal distribution with two different values.

```lua
local scale1 = love.math.random(NORMAL_DISTRIBUTION_SCALE_MIN, NORMAL_DISTRIBUTION_SCALE_MAX)
local scale2 = love.math.random(2) == 1 and math.floor(scale1 * 1.5) or math.floor(scale1 * 0.75)
```

The idea is to increase/decrease the scale factor after the halfway point represented by `mu`.

```lua
if x < mu then
  dy = dy * scale1
else
  dy = dy * scale2
end

local y = yStart - dy
```

This works, but has the unfortunate side effect of creating discontinuity between the two halves. Immediately, the topmost value of the normal distribution is scaled to a different value and it is necessary to compensate the offset. The amount to compensate which is described by the difference of the two topmost values, considering the different scaling factors.

```lua
if x < mu then
  dy = dy * scale1
else
  dy = dy * scale2 - (getNormalDistribution(mu, mu, sigma) * scale2 - getNormalDistribution(mu, mu, sigma) * scale1)
end
```

_Please note_: instead of scaling the second factor at random, I decided to use the y coordinate of the initial point as a reference. This value describes where the line should begin, and is initialized between half the window's height and the total height.

```lua
local yStart = love.math.random(math.floor(WINDOW_HEIGHT / 2), WINDOW_HEIGHT)
```

To avoid cropping the line then, the scale is increased only if the y coordinate crosses the threshold of the three fourths. This allows to have the second half steeper, and therefore lower, only if there is enough space for it.

```lua
local scale2 = yStart < WINDOW_HEIGHT * 3 / 4 and math.floor(scale1 * 1.5) or math.floor(scale1 * 0.75)
```
