# Excavation

## Spritesheet

The `res` folder includes supporting material, among which `spritesheet.png`. With the image I managed to create a visual for the texture, gems and tools. These assets are ultimately divvied up in quads and used in the project through `love.graphics.draw`.

### Sizes

By category:

- the tiles describing the texture are 8 pixels wide and tall

- the gems come in three different sizes: 16, 24 and 32 pixels

- the tools stretch 21 pixels horizontally and 22 pixels vertically

- the progress bar is sectioned in two pieces, the head 10 pixels and the body 26 pixels wide. Both are 12 pixels tall

### Colors

The spritesheet leans on a limited color palette.

_Please note:_ colors in Love2D describe rgb components in the `[0, 1]` range.

For the textures, there are seven types of maroons and greys:

- 0.392, 0.322, 0.255

- 0.475, 0.404, 0.239

- 0.569, 0.498, 0.349

- 0.659, 0.573, 0.396

- 0.651, 0.616, 0.580

- 0.749, 0.714, 0.678

- 0.694, 0.659, 0.624

For the gems, these use the first, darkest shade of maroon for the outline — 0.392, 0.322, 0.255 — while the inner glow is pure white — 1, 1, 1. What changes is the color chosen for the different varieties.

Blue:

- 0.549, 0.620, 0.996

- 0.384, 0.522, 1

Green:

- 0.522, 0.863, 0.388

- 0.451, 0.741, 0.29

Red:

- 1, 0.565, 0.522

- 0.965, 0.384, 0.353

Rose:

- 1, 0.792, 0.792

- 1, 0.902, 0.902

For the tools, the darkest shade of maroon is repeated for the body of the handle. Pure white is re-used for the outline, but only after an additional outline marking the edges of the shape:

- 0.173, 0.11, 0.106

. The difference between the tools boils down to the colors chosen for the fill.

Blueish:

- 0.71, 0.792, 0.945

- 0.318, 0.392, 0.804

Reddish:

- 0.91, 0.361, 0.333

- 0.714, 0.443, 0.388

For the progress bar, the cracks at the bottom of the spritesheet lean on the same, dark color used for the outline of the tools (right before pure white).

## Prep

In the `Prep` folder I create smaller demos to solve some of the challenges behind the game.

### Noise Field

> challenge: how to populate a grid with a series of random, but connected values

The idea is to benefit from a noise function in two dimensions, so to create values which change over time, but are inherently connected. In the demo, the smooth change is highlighted with a series of rectangle of different opacity and a grid of integers. Ultimately the idea is to map the noise value to one of the types of textures, so that this integer value is used to pick exactly which type.

`getNoiseField` builds a two-dimensional table where each individual cell describes a number in the `[0,1]` range.

```lua
for column = 1, columns do
  for row = 1, rows + 1 do
    local noise = love.math.noise(offsetColumn, offsetRow)
  end
end
```

The arguments describe the offset for the column and row, and are updated according to the specific loop:

- in the innermost loop update `offsetRow`

  ```lua
  for row = 1, rows + 1 do
    offsetRow = offsetRow + OFFSET_INCREMENT
  end
  ```

- after the nested loop increment `offsetColumn`

  ```lua
  for column = 1, columns do
    for row = 1, rows + 1 do
      -- update offset row
    end
    offsetColumn = offsetColumn + OFFSET_INCREMENT
  end
  ```

This works, but creates a connection between columns, where the last cell in one column is connected to the first cell in the column which follows. To fix this, and before the nested loop, reset the value of `offsetRow`.

```lua
for column = 1, columns do
  offsetRow = 0
  -- update offset values
end
```

`noise` provides a value in the `[0,1]` range. In the demo, the measure is used for the opacity of the rectangles. Notice that the value is limited to avoid having the noise field overpower the integers which follow.

```lua
local alpha = noise * ALPHA_MAX
```

The integer is finally computed weighing this opacity against the maximum possible value.

```lua
local value = math.floor(alpha * VALUE_MAX / ALPHA_MAX) + 1
```

Adding `1` means that the grid is populated with integers in the `[1,5]` range.

### Gems

> challenge: how to position gems of different sizes without overlap

The demo highlights how to position an arbitrary number of cells while ensuring that each entity is separate from the other.

The process begins with a table in which to keep track of available cells.

```lua
local coords = {}
for column = 1, COLUMNS do
  coords[column] = {}
  for row = 1, ROWS do
    coords[column][row] = true
  end
end
```

With a given size, the idea is to then continue pick a column and a row until the newly created gem fits. In most practical terms, until every single cell of the gem is available, `true` in the made-up table.

```lua
while true do
  column = love.math.random(COLUMNS - (size - 1))
  row = love.math.random(ROWS - (size - 1))
  -- check if the gem fits in coords
end
```

Notice that the column and row are picked with a random value considering the size; with this precaution it is possible to avoid considering a cell outside of the existing grid.

With the chosen coordinates, a nested for loop considers if the cells are all available with a boolean, ultimately allowing to break out of the `while` statement.

```lua
if canFit then
  break
end
```

Past the `while` statement, then, the gem is created with the chosen size, column and row. The same nested for loop checking for valid coordinates is then repeated to toggle the corresponding coordinates off.

```lua
for c = column, column + (size - 1) do
  for r = row, row + (size - 1) do
    coords[c][r] = false
  end
end
```

-2. `love.graphics.setStencilTest` details the condition following which love2D updates the content with the prescribed action

```lua
love.graphics.setStencilTest("greater", 0)
```

In this instance every bit of content is replaced, effectively hidden

### Particle System

> challenge: how to render a series of particles

Love2D provides a way to generate and manage a series of particles with a particle sytem. In the game, the idea is to show such particles as the player digs with a tool, perhaps changing the number of particles with the heavier hammer.

The sub-folder provides a basic demo to emit a fixed number of particles, be it on click or a specific key press. With a mouse cursor the game updates the origin to follow the appropriate coordinates.

Note the use of radial acceleration, instead of the linear counterpart, and also the `setEmissionArea` function, to spawn the individual particles in a wider area. In the game, the area could match the dimensions of the individual tiles.

### Camera Shake

> how to simulate a camera shake

As the player uses a tool, the idea is to shake the viewport to simulate the impact of the tool on the fragile surface. The demo shows how the effect can be achieved with a series of offset values stored in a table.

```lua
local offsets = {}

for a = 0, angle, increment do
  table.insert(offsets, math.sin(a))
end
```

I rely on the sine function since it allows to create a series of values which increment and decrement smoothly. Moreover, by choosing the start and end angle as a multiple of `math.pi * 2`, it is possible to have the final translation match the first one,

The angle considers a full rotation, that is `math.pi * 2` as well as an arbitrary number of rotations.

```lua
local ITERATIONS = 2
local angle = math.pi * 2 * ITERATIONS
```

The increment is picked considering a fixed number of offsets.

```lua
local OFFSETS = 20
local increment = angle / OFFSETS
```

_Please note:_ the demo populates a table to show the offset with a line, plotting the sine function.

With the table of offsets, the demo translates the content with `love.graphics.translate`, progressively moving through the table at an interval.

_Please note:_ with a large number of offsets, or with a very small duration, it is likely that delta time `dt` becomes larger than the necessary interval. In this instance the animation might take longer than necessary. Luckily, having fewer offsets results in a less-than-smooth camera shake which fits the tone of the game.

### Stencil Transition

> how to progressively hide and show content

When moving between states the idea is to hide the existing content, update the visuals and then show the new material. The demo illustrates how to complete the task with Love2D's stencil feature.

1. `love.graphics.stencil` describes a drawing function, as well as two parameters

   ```lua
   love.graphics.stencil(stencilFunction, "replace", 1)
   ```

   The drawing function renders a circle with a varying radius.

   ```lua
   love.graphics.circle("fill", WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, radius)
   ```

   The parameters describe how the drawing function should impact the desired content (more on this later). Here the desired content is replaced in full, and therefore hidden from view

2. `love.graphics.setStencilTest` details the condition for the desired content

   ```lua
   love.graphics.setStencilTest("greater", 0)
   ```

   In this instance any pixel value greater than zero, and therefore the entirety of the content is replaced, effectively hidden

Note that `setStencilTest` is called once again, and this time without arguments.

```lua
love.graphics.setStencilTest()
```

In this manner it is possible to remove the logic of the stencil.

## Libraries

The game benefits from two libraries:

1. `push` to scale the window while preserving the pixelated art style chosen in the spritesheet

2. `Timer` to manage time events, like delays and tweens

## Input

The goal of the game is to support both keyboard and mouse input.
