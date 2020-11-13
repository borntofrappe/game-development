# Box2D

The folder illustrates the different components of the eventual game _Lunar Lander_. Dedicating a specific environment for these elements allows to experiment with the physics library.

## Terrain

The demo considers the `makeTerrain` function developed for the game in the `src/Utils`. This one is however modified so that the `y` coordinates describe the height with a negative value. This is beceuse the body making up the terrain is already positioned at the bottom of the window.

```lua
love.physics.newBody(world, 0, WINDOW_HEIGHT)
```

To build the terrain in the Box2D world, the script uses a chain shape, passing the points to the `newChainShape` function.

```lua
local points = makeTerrain()
terrain.shape = love.physics.newChainShape(false, points)
```

This works, but has the unfortumate result of having a line connecting the first and last points. To fix this, I decided to add two additional points, describing the outline of the gaming window.

Bottom right corner.

```lua
table.insert(points, WINDOW_WIDTH)
table.insert(points, 0)
```

Bottom left corner.

```lua
table.insert(points, 0)
table.insert(points, 0)
```

To illustrate that the demo works, the game adds circle objects through a dedicated function. The code is borrowed here from the `Box2D Demos` folder, and specifically the `Dynamic particles` demo.
