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

#### Hill

The idea is to include a curvature in the otherwise straight line by relying on trigonometric functions like cosine and sine. It is possible to rely on either knowing the behavior of the functions in the `[0, math.pi * 2]` range, but utimately I opted for the cosine function.

The table of points is now populated with three loops: two for flat platforms and one for the hill. The goal is to draw the player and target on either side, and have the hill separate the two.

For the flat surface, the loop repeats the logic introduced in previous demo: increment the `x` coordinate, rely on a fixed `y` value.

For the hill, however, the logic is slightly different: do increment the `x` coordinate, rely on a `y` value considering a varying `angle` value. `angle` is incremented with each passing point to create the curve. It is initialized at `0` with the goal of looping a full rotation to `math.pi * 2`. In so doing, the idea is to have a symmetric hill, and have the two platforms at the same height level.

_Please note:_ the cosine of `0` and of `math.pi * 2` is `1`, which needs it is necessary to offset the initial coordinate to have the point comparable to the surrounding platforms.

```lua
local y = Y_START + math.cos(angle) * height - height
```

As mentioned, it would be possible to also use the sine function. In this instance, however, you'd want to loop in the `[math.pi / 2, math.pi * 5 / 2]` range. Therefore, and with `math.sin`, update the angle to start at `math.pi / 2`.

```lua
local angle = math.pi / 2

-- hill loop
local y = Y_START + math.sin(angle) * height - height
```

#### Asymmetry

Creating a hill with trigonometric functions helps to have more interesting terrain. What is even more interesting is having an asymmetric hill, one that doesn't always peak at the same point and ends exactly where it started.

To fix the first issue, the number of points describing the hill is used to describe two halves.

```lua
local p1 = love.math.random(math.floor(POINTS.hill / 4), math.floor(POINTS.hill * 3 / 4))
local p2 = POINTS.hill - p1
```

The idea is to then create two loops to add the necessary amount of points for the left and right section. With a different number of points, it is necessary to have different increments in terms of angle.

```lua
local dangle1 = math.pi / p1
local dangle2 = math.pi / p2
```

Each variable accounts for half the rotation of the cosine function.

To fix the second issue, it is possible to rely on a different height value.

```lua
local height1 = love.math.random(math.floor(height / 4), math.floor(height * 3 / 4))
local height2 = height - height1
```

Here I decided to implement a similar solution to how the number of points is split, but ultimately it might be more beneficial to consider the starting `y` coordinate to contain the hill in the available height and yet guarantee enough variety.

Using a different height has the effect of having the two sections cover a different vertical spread. However, the smooth line is interrupted in between the two loops. To fix this, and finally have the two flat portions at different heights, it is necessary to have the second loop start from where the first loop ends.
