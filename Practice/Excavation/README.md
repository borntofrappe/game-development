# Excavation

## Preface

Pokemon Diamond and Pearl introduce the underground, where the trainer explores an area hidden below the games' region. In this underground you find a minigame where you are tasked to dig walls for gems, and find the all the treasure before the surface collapses.

## Spritesheet

The `res` folder includes supporting material, among which `spritesheet.png`. With the image I managed to create a visual for the texture, gems and tools and progress bar. These assets are ultimately divvied up in quads and used in the project through `love.graphics.draw`.

### Sizes

By category:

- the tiles describing the texture are 8 pixels wide and tall

- the gems come in three different sizes: 16, 24 and 32 pixels

- the tools are 21 pixels wide and 22 pixels tool, both the ouline and filled variant

- the progress bar is sectioned in four fragments, two describing the tip of the bar and two its body. The first kind is 6 pixels wide, while the second covers 8 pixels, All are designed to be 16 pixels tall, and match the height of the progress bar, even if the actual content covers a smaller area

### Colors

The spritesheet introduces several color for the textures, gems and tools, but I tried to limit the number of colors with a few variants of maroon and grey hues

_Please note:_ Love2D accepts rgb components in the `[0, 1]` range.

From the darkest shade to the lightest hue, the textures introduce seven colors:

- 0.392, 0.322, 0.255

- 0.475, 0.404, 0.239

- 0.569, 0.498, 0.349

- 0.659, 0.573, 0.396

- 0.651, 0.616, 0.580

- 0.749, 0.714, 0.678

- 0.694, 0.659, 0.624

To highlight the selected tile, an additional square relies on pure white — 1, 1, 1.

The gems rely on the darkest pick for the outline — 0.392, 0.322, 0.255 — while the inner glow is again pure white. What changes is the color pair for the different varieties.

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

Similarly to the gems, the tools re-use the dark maroon, but this time for the handle of the hammer or pickaxe. Each tool is designed to have a dark outline — 0.173, 0.11, 0.106 — and a white border.

Similarly to the gems, the tools rely on a pair of colors.

Blueish pickaxe:

- 0.71, 0.792, 0.945

- 0.318, 0.392, 0.804

Reddish hammer:

- 0.91, 0.361, 0.333

- 0.714, 0.443, 0.388

The progress bar re-uses the dark color chosen for the tools' outline — 0.173, 0.11, 0.106.

## Prep

In the `Prep` folder I create smaller projects to solve some of the challenges behind the game.

### Noise Field

> challenge: populate a grid with a series of random, but connected values

The idea is to benefit from a noise function in two dimensions, so to create values which change over time, but are inherently connected in a grid-like pattern. In the demo, the smooth change is highlighted with a series of rectangle of different opacity and a series of integers. Ultimately the idea is to map the noise value to one of the types of textures.

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

`noise` provides a value in the `[0,1]` range, which is then incorporated in the opacity of the rectangles, in the `[0, ALPHA_MAX]` range.

```lua
local alpha = noise * ALPHA_MAX
```

The same value is finally mapped to an integer in the `[1, VALUE_MAX]` range.

```lua
local value = math.floor(noise * VALUE_MAX) + 1
```

### Gems

> challenge: position gems of different sizes without overlap

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

### Particle System

> challenge: render a series of particles

The Love2D API provides a particle system to manage and render a series of particles. In the game, the idea is to show such particles as the player digs with a tool, perhaps changing the number of particles with the heavier hammer.

The sub-folder provides a basic demo to emit a fixed number of particles, be it on click or a specific key press. With a mouse cursor the game updates the origin to follow the appropriate coordinates.

Note the use of radial acceleration, instead of the linear counterpart, and also the `setEmissionArea` function, to spawn the individual particles in a wider area. In the game, the area should match the dimensions of the tiles in the grid.

```lua
gParticleSystem:setEmissionArea("uniform", 8, 8)
```

### Camera Shake

> translate the visuals in `love.draw` to simulate a camera shake

As the player uses a tool, the idea is to shake the window to simulate the impact of the tool on the fragile surface. The demo shows how the effect can be achieved with a series of offset values stored in a table.

```lua
local offsets = {}

for a = 0, angle, increment do
  table.insert(offsets, math.sin(a))
end
```

I rely on the sine function since it allows to create a series of values which increment and decrement smoothly, and most importantly a series of values which match at beginning and end. This last feat is achieved by choosing the start and end angle as a multiple of `math.pi * 2`.

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

```lua
love.graphics.translate(offsets[index], 0)
```

_Please note:_ with a large number of offsets, or with a very small duration, it is likely that delta time `dt` becomes larger than the necessary interval. In this instance the animation might take longer than necessary. Luckily, having fewer offsets results in a less-than-smooth camera shake which fits the tone of the game.

_Please note:_ when considering the offsets, it is actually unnecessary to compute the value for more than one iteration, as the sine function repeats itself. Consider updating the logic when implementing the feature in the actual game.

### Stencil Transition

> progressively hide and show content to transition between states

_Please note:_ the demo hides and shows the same content, and doesn't bother implementing the state transition. In the actual game consider a state stack in place of a state machine, so to render multiple states on top of one another.

Love2D's stencil allows to prescribe the instructions in `love.draw` to a specific area, and with two functions:

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

### Sprite Batch

> batch drawing instructions in a single call to `love.graphics.draw`

Love2D's sprite batch helps to efficiently draw a series of sprites that do not need to change over time. In the game, the feature is useful to draw the bottom layer of the grid, since the layer relies on a single, repeating quad.

The demo highlights the feature considering the quads of a rudimentary spritesheet. Initialize the sprite batch by referencing the texture.

```lua
gTexture = love.graphics.newImage("spritesheet.png")
gSpriteBatch = love.graphics.newSpriteBatch(gTexture)
```

With the `:add` method describe what to draw and where. In this instance, the quads in a grid-like pattern.

```lua
for column = 1, COLUMNS do
  for row = 1, ROWS do
    gSpriteBatch:add(gQuads[love.math.random(#gQuads)], (column - 1) * TILE_SIZE, (row - 1) * TILE_SIZE)
  end
end
```

Once initialized, it is enough to reference the batch in `love.graphics.draw`.

```lua
love.graphics.setColor(1, 1, 1)
love.graphics.draw(gSpriteBatch)
```

I set, or rather reset, the color since it appears the batch is influenced by a different rgb combination.
