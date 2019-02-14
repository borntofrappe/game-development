# Breakout 3 - Bricks

As to introduce the bricks, we begin by including a few rows and columns of bricks which disappear as the ball collides with them.

## Util.lua

Follow up the `GenerateQuadsBalls` function to consider the bricks. These are always in `breakout.png`, and can be accessed more rapidly given that they begin at the very top left of the spritesheet.

- generate the bricks by slicing the table making up the quads of the entire spritesheet.

  ```lua
  table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
  ```

  Remember here the arguments of the slice function:

  - `tbl`, meaning the table. In this instance it refers to the 'quadded' spritesheet;

  - `first`, where to begin the slice;

  - `last`, where to end the slice (21 being the number of bricks).

  There's also `step`, but it is not specified and falls to the default `1` value.

  The generate quads function instead accepts as arguments:

  - the image to be divvied up;

  - the width of the tile (32 being the width of the brick);

  - the height of the tile (15 being the height of the brick).

Once the function is set up, include the quad table in the `gFrames` table.

**Important fix**: I had a typo in the utility function `GenerateQuads`, and specifically the way the dimensions where retrieved from the image. It is `image:getDimensions()`, and not `image:getDimension()`.

## Brick.lua

Bricks are created through instances of the brick class. This is initiated with the coordinates/sizes of the bricks, as well as a boolean to determine whether the brick is to be rendered on the page or not, `self.inPlay`. The idea is to toggle this to false as the ball hits the brick, and in the render function loop through the table of bricks and render only those with the flag set to true.

```lua
function Brick:render()
  if(self.inPlay) then
    -- 4 colors for every tier
    love.graphics.draw(gTextures['breakout'], gFrames['bricks'][self.tier + 4 * (self.color - 1)], self.x, self.y)
  end
end
```

Similarly to the ball, the specific brick is targeted by considering the number of variatiants. There exist multiple tiers of 4 colors.

This allows to render a brick when its flag of `inPlay` is set to true, but there needs to be a way to alter such a boolean. This feat is achieved through a `Brick:hit()` function.

```lua
function Brick:hit()
  self.inPlay = false
end
```

Once the class is set up, it can be called from the paly state, but remember to first add it to the dependencies of the project.

## PlayState.lua

The logic to make up the levels is created in a separate file, `LevelMaker.lua`. This will be responsible for the way bricks are generated, in different tiers and colors, but to start out it will only generate a random number of columns and rows of a specific type of brick, and center the structure in the top third of the screen.

In the play state, the table of bricks is created through the level maker just mentioned (more on this later).

```lua
self.bricks = LevelMaker.createMap()
```

In the `update(dt)` function, the file then checks for a collision between the balls and the bricks. This in a for loop allowing to consider every brick.

```lua
for k, brick in pairs(self.bricks) do
  if brick.inPlay and self.ball:collides(brick) then
    brick:hit()
  end
end
```

Notice how the function `hit()` gets run only when the ball collides **and** the brick is set to be in play, through the appropriate boolean. This to avoid having the function fired on bricks which are already removed from view.

In the `render()` function finally, loop through the bricks and render them. The conditional logic allowing to render only the bricks in play is already described in the brick class, so the `render()` function only loops through the table and calls `:render` on each item.

## LevelMaker.lua

Immediately, but this holds true for every new file, add the file to the dependencies used by the application.

In the file itself, instantiate a class and include a function to generate the level, meaning the series of bricks laid atop the screen. This is done at first by initializing an empty table and inserting one instance of the `Brick` class for every cell of a made up grid.

- create an empty table;

- determine a grid with a set of rows and columns;

- loop within the grid, so to speak, and for each row x column combination add a brick to the table;

- return the table.

This allows the play state to have a table of bricks, which can be in turn rendered through the `Brick:render()` function.

Essential are here the values passed to the instance of the brick class: `x` and `y`. `y` requires a relatively easy computation (the number of the row times the height of a single brick), but `x` requires a bit more math. Indeed we want to center the brick(s) in the screen, and this changes according to the number of columns in which the bricks are sorted.

Here's the reasoning behind the formula ultimately used to center the grid:

- start from (col -1) *  32, which can be 0 and multiple of 32 to separate each brick from one another;

- add as much as to center, which is based on the remaining space (virtual width to which the space occupied by the columns is removed, divided by two)

```lua
(col - 1) * 32 + (VIRTUAL_WIDTH - numCols * 32) / 2
```

