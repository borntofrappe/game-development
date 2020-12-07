# Physics

Here I explore how to physics ultimately included for both players.

## Range

The game is based on two values, a velocity `v` and and angle `theta`. Based on these, and on a constant gravity `g` roughly set to `9.81`, a cannonball moves by an amount equal to the following.

```lua
range = (v ^ 2 * math.sin(2 * theta)) / g
```

The demo uses the formula with a set value for the velocity and angle, but allows to modify each value by pressing the arrow keys `up` and `down`. The value being modified is changed by pressing the `v` and `a` key.

It is important to note that `theta` is a value in radians, while the angle in the game is introduced in degrees. `math.rad` allows to convert to the desired format.

## Trajectory

Ultimately, terrain is not represented by flat line. Whatsmore, even if the visual is a straight line, `love.graphics.line` uses a table of points. In this light, it is necessary to compute the `x` and `y` coordinates for the points in the arc making up the cannonball's trajectory. The equations for the [projectile motion displacement](https://en.wikipedia.org/wiki/Projectile_motion#Displacement), and specifically those for the horizontal and vertical component describe the value as a function of time `t`.

```lua
x = v * t * math.cos(theta)
y = v * t * math.sin(theta) - 1 / 2 * g * t ^ 2
```

Knowing this, it is possible to describe the points by incrementing a counter variable.

```lua
local t = 0
while true do
  x = v * t * math.cos(theta)
  y = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2
  t = t + 0.5

  -- avoid an infinite loop !!!
  break
end
```

With every increment, the `(x,y)` coordinates describe a point in the arc.

_Please note_: the previous snippet include a `break` statement as a precaution, to avoid running the snippet as-is and causing an infinite loop. To terminate the loop more conscientiously, I decided to use the `y` coordinate and stop adding points when the value exceeds the window's height.

```lua
if yOffset - y > WINDOW_HEIGHT then
  break
end
```

`yOffset` describes the initial height of the presumed player.

_Please note_: instead of incrementing the counter variable by an arbitrary, small amount, it is possible to consider the value `t` describing time between two consecutive points.

```


```

In this manner `points` and `trajectory` have a comparable number of points.
