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

`love.graphics.line` is able to draw a line directly from the table.

```lua
love.graphics.line(points)
```

#### Hill

The idea is to include a curvature in the otherwise straight line by relying on trigonometric functions like cosine and sine. It is possible to rely on either knowing the behavior of the functions in the `[0, math.pi * 2]` range, but utimately I opted for the cosine function.

The table of points is now populated with three loops: two for flat platforms and one for the hill.

```lua
for point = 1, POINTS.flat do
  -- platform
end

for point = 1, POINTS.hill do
  -- hill
end

for point = 1, POINTS.flat + 1 do
  -- platform
end
```

The goal is to draw the player and target on either side, and have the hill separate the two.

For the flat surface, the loop repeats the logic introduced in previous demo: increment the `x` coordinate, rely on a fixed `y` value.

```lua
local dx = WINDOW_WIDTH / POINTS.total

for point = 1, POINTS.flat do
  x = x + dx
end
```

For the hill, the logic is slightly different: do increment the `x` coordinate, but rely on a `y` value considering a varying `angle` value.

```lua
for point = 1, POINTS.hill do
  local y = Y_START + math.cos(angle) * height / 2 - height / 2

end
```

`angle` is incremented with each passing point to create the curve. It is initialized at `0` with the goal of looping a full rotation to `math.pi * 2`.

```lua
local angle = 0
local dangle = math.pi * 2 / POINTS.hill
```

In so doing, the loop creates a curve which begins and ends at the same `y` coordinate.

#### Asymmetry

Creating a hill with trigonometric functions helps to have more interesting terrain. What is even more interesting is having an asymmetric hill, one that doesn't always peak at the same point and ends exactly where it started. In the demo, I accomplish this feat by first re-imagining the structure of the line.

The idea is to immediately decide the `y` coordinate of the two platforms.

```lua
local yStart = love.math.random(Y_FLAT.min, Y_FLAT.max)
local yEnd = love.math.random(Y_FLAT.min, Y_FLAT.max)
```

The minimum and maximum values are chosen to have the platforms in the bottom half of the window.

With the two coordinates, the two "flat" loops include a series of points at the fixed values.

```lua
for point = 1, POINTS.flat do
  table.insert(points, yStart)
end

-- hill

for point = 1, POINTS.flat do
  table.insert(points, yEnd)
end
```

The idea is to then connect the start and end coordinates with two segments, to create an asymmetric hill. Horizontally, it is possible to add variety in the form of the number of points required by the two segments.

```lua
local p1 = love.math.random(math.floor(POINTS.hill / 4), math.floor(POINTS.hill * 3 / 4))
local p2 = POINTS.hill - p1
```

Vertically, it is possible to create a wider range of hills by considering a random height, at least for the first segment.

```lua
local height1 = love.math.random(0, yStart - Y_UPPER_THRESHOLD)
local height2 = yEnd - (yStart - height1)
```

The threshold is chosen to guarantee that the line doesn't exceed a vertical limit. The height of the second segment is then dictated by how much space the curve needs to cover to connect to the second segment.

```lua
-- first loop
local y = yStart + height1 / 2 * math.cos(angle) - height1 / 2

-- second loop
local y = yEnd + height2 / 2 * math.cos(angle) - height2 / 2
```

The loops lean on the same angle, but this value is incremented by a different amount. This is necessary since the increment depends on how many points each loop has.

```lua
local dangle1 = math.pi / p1
local dangle2 = math.pi / p2
```

### Holes

The final demo in the `Prep` folder incorporates the progress achieved in the `Physics` and `Terrain` sub-folders, with the goal of showing how the projectile modifies the terrain itself. A few changes worth mentioning:

- `Terrain` is modified to consider the position of the player

  The class receives the player and uses its `x` coordinate to determine the number of points of the "flat" sections

  ```lua
  local POINTS = {
    ["flat"] = math.floor(WINDOW_WIDTH / player.x) * 2,
    ["hill"] = 120
  }
  ```

  The `y` coordinate is then relevant to describe where the line should begin

  ```lua
  local yStart = player.y
  ```

- the velocity is modified through the left and right arrow keys, while the angle consider the up and down arrows

- the logic of the trajectory is included in its own class and is updated every time the player or the terrain changes

- the interval updating the position of the projectile is stopped when there are no more points to consider in the terrain

For the purposes of the demo, creating holes in the terrain, refer to `main.lua` and roughly line `48`. Here the idea is to stop the interval and consider the number of points necessary to cover the projectile radius. Similarly to how the terrain uses the cosine function to draw the hill, finally, the code proceeds to modify the `y` coordinate of the terrain to create the desired gap.
