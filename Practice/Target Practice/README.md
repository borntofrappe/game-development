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

The equations for the [projectile motion displacement](https://en.wikipedia.org/wiki/Projectile_motion#Displacement), and specifically those for the horizontal and vertical component, help to find the `x` and `y` coordinates as a function of time `t`.

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

The trajectory as described in the previous demo helps to move the projectile from the perspective of the player. In the demo specifically, `Timer.lua` helps to progressively move the cannonball at an interval.

```lua
Timer:every(
  INTERVAL,
  function()
  end
)
```

In the function, the idea is to update a counter variable to cycle through the coordinates of the trajectory.

```lua
local index = 1

Timer:every(
  INTERVAL,
  function()
    index = index + 2
  end
)
```

The projectile `x` and `y` coordinate pick up the value from the point described in `player.trajectory`, always considering how the table includes the horizontal and vertical measures in sequence.

```lua
projectile.x = player.trajectory[index]
projectile.y = player.trajectory[index + 1]
```

_Please note:_ the interval is removed once the projectile reaches the final set of points. It is also removed immediately, before setting up the interval, in order to avoid multiple, coexisting functions.

```lua
if key == "return" then
    Timer:reset()

    -- set up the interval
end
```

#### Collision

The demo considers a collision between the projectile and the terrain. In order to detect a collision, it is helpful to have the terrain described by a sequence of points instead of a straight line.

```lua
local terrain = {}
for point = 1, POINTS + 1 do
  local x = (point - 1) * WINDOW_WIDTH / POINTS
  table.insert(terrain, x)
  table.insert(terrain, Y_TERRAIN)
end
```

With this setup, it also helps to have the points in the trajectory separated horizontally by the same amount separating the terrain. This explains why `getTrajectory` updates the counter variable `t` by considering two `x` coordinates of the terrain.

```lua
local dt = (terrain[3] - terrain[1]) / (v * math.cos(theta))
```

The amount is computed considering the equation for `dx`, and rearranging the arguments.

```lua
dx = v * t * math.cos(theta)
```

`terrain` and `trajectory` share a comparable number of points, but when considering a collision it is necessary to offset the initial index considering how the player does not start at the very left edge of the window. This explains the snippet setting the value of `indexStart`.

```lua
local indexStart

for i = 1, #terrain, 2 do
  if terrain[i] >= trajectory[1] then
    indexStart = i
    break
  end
end
```

A collision is then detected comparing the `y` coordinates of the two tables, terrain and trajectory.

```lua
if trajectory[index + 1] > terrain[indexStart + index + 2] then
  -- collision
end
```

_Please note:_

- the index in the terrain is incremented by two to consider the `y` coordinate, and is the result of `indexStart + 1` and `index + 1`

- checking if the value is greater than, `>`, and not greater than or equal, `>=` is necessary to avoid signalling a collision with the first point of the trajectory

### Terrain

#### Line

Terrain is included with a line connecting a series of points. It is possible to show this immediately by incrementing the `x` coordinate and rely on a fixed `y` value.

```lua
local points = {}
local y = WINDOW_HEIGHT * 3 / 4

for point = 1, POINTS + 1 do
  local x = (point - 1) * WINDOW_WIDTH / POINTS
  table.insert(points, x)
  table.insert(points, y)
end
```

The table of points is enough to have `love.graphics.line` render the visual.

```lua
love.graphics.line(points)
```

`Terrain.lua` is created to highlight the concept and starting from a random `y` coordinate. Press the enter key or the left button of a mouse to show a start from a different value.
