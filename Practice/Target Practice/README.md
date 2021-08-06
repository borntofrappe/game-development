# Target Practice

A two-player game with a simple task: destroy your opponent before it destroys you.

## Prep

In the `Prep` folder I try to develop the building blocks for the final project.

- `Physics` considers projectile motion

- `Terrain` explores how to render the game's terrain and cannoball holes

### Physics

#### Range

In the game the player fires a cannonball on the basis of two values: a velocity `v` and and angle `a`.

The demo shows how to use the values to compute [range of the projectile](https://en.wikipedia.org/wiki/Projectile_motion#Maximum_distance_of_projectile).

```lua
range = (v ^ 2 * math.sin(2 * theta)) / g
```

`g` describes the gravity, and is approximated to `9.81`. `theta` does describe the angle, but in radians.

```lua
local theta = math.rad(a)
```

The formula immediately relies on hard-coded values, but the demo allows to change the velocity and angle by pressing the arrow keys. To choose a specific metric it is further possible to press the `v`, `a` or `tab` keys.

#### Trajectory

The movement of the projectile is simulated by having the object move in a sequence of points approximating an arc.

The equations for the [projectile motion displacement](https://en.wikipedia.org/wiki/Projectile_motion#Displacement), and specifically those for the horizontal and vertical component help to find the `x` and `y` coordinates as a function of time `t`.

```lua
dx = v * t * math.cos(theta)
dy = v * t * math.sin(theta) - 1 / 2 * g * t ^ 2
```

Knowing this, it is possible to describe the points by incrementing a counter variable.

```lua
local t = 0
while true do
  dx = v * t * math.cos(theta)
  dy = v * t * math.sin(theta) - 1 / 2 * GRAVITY * t ^ 2
  t = t + 0.1

  -- avoid an infinite loop !!!
  break
end
```

With every increment, the `(x,y)` coordinates describe a point in the trajectory's arc.

_Please note_: the previous snippet include a `break` statement as a precaution, to avoid running the snippet as-is and causing an infinite loop. To terminate the loop more conscientiously, I decided to use the `y` coordinate and stop adding points when the value exceeds the window's height.

```lua
if dy - y > WINDOW_HEIGHT then
  break
end
```

#### Fire

The demo highlights the path of the projectile through the table of points describing the trajectory. Leaning on `Timer.lua`, the idea is to set up an interval to progressively use the points in the table for the projectile's own position.

```lua
Timer:every(
  INTERVAL,
  function()
  end
)
```

#### Collision

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

### Terrain

Terrain is included with a line connecting a series of points.

To draw a straight line, for instance, it is enough to increment the `x` coordinate and rely on a fixed `y` value.

```lua
local points = {}

for point = 1, POINTS + 1 do
  table.insert(points, (point - 1) * WINDOW_WIDTH / POINTS)
  table.insert(points, Y_BASELINE)
end
```

The table of points is enough to have `love.graphics.line` render the visual.

```lua
love.graphics.line(points)
```

Having a sequence of points allows to update the terrain by modifying the different coordinates. Move the cannonball with the mouse cursor and click the left button to highlight the feature.

```lua
for point = 1, #points, 2 do
  if points[point] >= cannonball.x - cannonball.r and points[point] <= cannonball.x + cannonball.r then
    points[point + 1] = math.min(WINDOW_HEIGHT, points[point + 1] + cannonball.r)
  end
end
```

- every other x coordinate

- math.min

For a circle???????????????????????''???????????????????????''???????????????????????''
