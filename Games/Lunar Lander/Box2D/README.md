# Box2D

The folder illustrates how to set up a world, terrain and lunar lander. Dedicating a specific environment for these elements allows to experiment with how the physics work.

- moon gravity: 1.62

## Terrain

Including the points from `makeTerrain` has the unfortunate result of having a line connecting the first to last points. This is fixed by adding four points, describing the contours of the gaming window.

```lua
local points = makeTerrain()

table.insert(points, WINDOW_WIDTH)
table.insert(points, 0)
table.insert(points, 0)
table.insert(points, 0)
```
