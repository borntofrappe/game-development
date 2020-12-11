# Physics

Here I explore the physics of projectile motion, with the goal of describing the movement of the eventual cannonballs.

## Range

The game is based on two values, a velocity `v` and and angle `a`.

[The range of a projectile](https://en.wikipedia.org/wiki/Projectile_motion#Maximum_distance_of_projectile) is computed as follows:

```lua
range = (v ^ 2 * math.sin(2 * theta)) / g
```

where `g` describes the gravity, and is roughly set to `9.81` through a constant. `theta` does describe the angle, but in radians, which means the angle `a` needs to be converted to the format.

```lua
local theta = math.rad(a)
```

The demo uses the formula with a set value for the velocity and angle, but allows to modify each value by pressing the arrow keys `up` and `down`. The value being modified is changed by pressing the `v` and `a` key.

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

With every increment, the `(x,y)` coordinates describe a point in the trajectory's arc.

_Please note_: the previous snippet include a `break` statement as a precaution, to avoid running the snippet as-is and causing an infinite loop. To terminate the loop more conscientiously, I decided to use the `y` coordinate and stop adding points when the value exceeds the window's height.

```lua
if yOffset - y > WINDOW_HEIGHT then
  break
end
```

`yOffset` describes the initial height of the presumed player.

_Please note_: instead of incrementing the counter variable by an arbitrary, small amount, it is possible to consider the value `t` describing time between two consecutive points.

```lua
local tDelta = (terrain[3] - terrain[1]) / (v * math.cos(theta))
```

In this manner `points` and `trajectory` have a comparable number of points.

## Fire

Up to the previous demo, the goal was to showcase the motion of a projectile. However, this projectile needs to impact and modify the terrain. Here I stagger the movement of a circle to move away from the player, and considering the points detailed by the trajectory. The `Timer` utility allows to modify the coordinates at an interval, but the core of the demo is in the `fire` function.

The `fire` function considers the points described by `trajectory`, and loops through the table in order to set the `x` and `y` coordinate of the cannonball.

```lua
local index = 1
Timer:every(
  0.01,
  function()
    player.cannonball.x = trajectory[index]
    player.cannonball.y = trajectory[index + 1]

    index = index + 2
  end
)
```

As `index` reaches the end of the table then, the cannonball is reset to its original position.

```lua
if not trajectory[index] then
  player.cannonball.x = player.x
  player.cannonball.y = player.y
  Timer:reset()
end
```

_Please note_: I decided to include a boolean `isFiring` so that while the firing animation is taking place, the game is not allowed to update the speed, angle, and therefore trajectory of the projectile.

_Please note_: the demo does not consider the collision between cannonball and terrain. This is the topic of the demo which follows.

## Hit

The demo considers a collision between the moving cannonball and the terrain. It does so by checking the `y` coordinates of the cannonball as it travels on the arc describing its trajectory.

`terrain` and `trajectory` share a comparable number of points, in that each `x` coordinate is shared by the same amount, but it is still necessary to consider the offset of the player. Indeed the first point of the trajectory doesn match the first point of the terrain.

This explains the snippet setting the value of `indexStart`.

```lua
local indexStart

for i = 1, #terrain, 2 do
  if terrain[i] >= trajectory[1] then
    indexStart = i
    break
  end
end
```

Knowing this offset, the comparison is between the `y` coordinates of the two tables.

```lua
if trajectory[index + 1] > terrain[indexStart + index + 2] then
  -- collision
end
```

A couple of notes on this conditional:

- `+ 2` is to consier the y coordinate for the terrain, and is the result of `indexStart + 1` plus `index + 1`

- checking if the value is greater, `>` and not greater or equal is necessary to avoid signalling a collision with the first point of the trajectory
