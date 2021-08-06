# Target Practice

A two-player game with a simple task: destroy your opponent before it destroys you.

## Prep

In the `Prep` folder I try to develop the building blocks for the final project.

- `Physics` considers projectile motion

- `Terrain` explores how to render the game's terrain and cannoball holes

### Physics

### Range

The game is based on two values: a velocity `v` and and angle `a`.

[The range of a projectile](https://en.wikipedia.org/wiki/Projectile_motion#Maximum_distance_of_projectile) is computed as follows:

```lua
range = (v ^ 2 * math.sin(2 * theta)) / g
```

`g` describes the gravity, and is roughly set to `9.81` through a constant. `theta` does describe the angle, but in radians.

```lua
local theta = math.rad(a)
```

The demo uses the formula with a set value for the velocity and angle, but allows to modify each value by pressing the arrow keys `up` and `down`. The value being modified is changed by pressing the `v` and `a` key.

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
