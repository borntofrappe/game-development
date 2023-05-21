# Breakout 1

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Spritesheet

The idea is to load a large image, and section the asset to only show a portion.

If you browse the `res/graphics` folder, you'll find a few images for the paddles, balls and bricks with different types, varying in color and size.

## Quads

A quad is a rectangle with specific coordinates, width and height. In LOVE2D, this concept is materialized through the functions `love.graphics.newQuad()` and `love.graphics.draw()`

### newQuad()

The function takes as arguments the coordinates of the rectangle, as well as its width and height. On top of these values, it also receives a _dimension_, which is an object returned from the image we want to section.

```lua
love.graphics.newQuad(x, y, width, height, dimension)
```

Use `image:getDimensions()` to retrieve this value.

### draw()

The function accepts a variable number of arguments, and in the context of quads, it allows to draw a specific portion of the image by referring to the image and then the quad.

```lua
love.graphics.draw(image, quad, x, y)
```

## Utils

`Utils.lua` introduces a few functions to work with quads.

### GenerateQuads()

This function is created to divide the sprite image into quads.

It takes as arguments:

- `atlas`, the image to be "quadded", so to speak

- `tileWidth`, the unit of measure detailing the smallest measure in which the image can be sectioned horizontally

- `tileHeight`, the same of `tileWidth`, but with respect to the height

Consider for instance the graphic in `arrows.png`:

- `atlas` refers to the entire image

- `tileWidth` and `tileHeight` both describe 24, for the width and the height of the individual sprite

With these arguments, the function `GenerateQuads` creates an empty table and fills it with quads from the image. This by looping through the tiles horizontally and vertically.

Notice the use of the `newQuad` function, within the context of the loops updating `x` and `y`

```lua
love.graphics.newQuad(
  x * tileWidth,
  y * tileHeight,
  tileWidth,
  tileHeight,
  atlas:getDimensions()
)
```

As described in the previous section, these values relate to the coordinates, size and dimensions of the quad.

Once you use this function on a spritesheet, you obtain a table, specifying the quads of the spritesheet in a structure similar to the following:

```lua
spritesheet = {
  [1] = q1, -- quad for the top left corner
  [2] = q2, -- quad for the rectangle right next to q1
  -- ...
}
```

### GenerateQuadsPaddles()

This function works similarly to `GenerateQuads`, but in the context of creating the quads for the paddles. Before looking at the syntax, look at `breakout.png`. This is the source image from which the paddles are sectioned.

In `breakout.png`, the paddles start at the coordinate (0, 64), and continue for eight rows, with paddles of different size and color. Each color comes in four sizes: (32x16), (64x16), (96x16) and finally (128x16).

This explains how the loop works, adding at each iteration the four paddles of different sizes, and using at each iteration precise values for the `x`, `y`, `width` and `height` arguments.

### table.slice()

This utility function allows to slice an input table. It is not included in any `.lua` file, but it's worth mentioning for its general usefulness and the flexibility of its syntax.

It takes as argument:

- a table

- `first`, `last` and `step`. The goal is to slice the table from a certain index to another specified index, and at a described interval

Notice how the loop includes default values, in case `first`, `last`, `step` are left undefined.

```lua
for i = first or 1, last or #table, step or 1 do

end
```

By default this means that the loop cycles through the table considering every single item.

Notice also how the `slice` table is populated.

```lua
slice[#slice + 1] = table[i]
```

Using `#slice + 1` to append the value at the end of the table.

## Draw quads

In `main.lua`, the `load` function is updated to include a table with the desired quads.

```lua
function love.load()
  -- previous gTables

  gTextures = {}

  gFrames = {
    ['paddles'] = GenerateQuadsPaddles(gTextures['breakout'])
  }
end
```

By using `GenerateQuadsPaddles`, the table now includes a `paddles` field describing the different paddles. Four sizes, and four colors.

In `Paddle.lua`, we can then use the global variable to draw the desired sprite.

```lua
function Paddle:render()
  love.graphics.draw(gTextures['breakout'], gFrames['paddles'][1], self.x, self.y)
end
```

I use a hard-coded index here, which results in the game rendering the smallest, blue paddle. To draw a specific sprite, the script introduces two additional variables.

```lua
function Paddle:init()
  self.skin = 1
  self.size = 2
end
```

With these variables, it's possible to target a specific image knowing that the table arranges, in order, paddles of different size, paddles of different color.

```diff
-gFrames['paddles'][1]
+gFrames['paddles'][self.size + 4 * (self.skin - 1)]
```

`-1` is included to comply with lua convention of being one-based indexed.

## Additional notes

The game identifies a continuous key press by using `love.keyboard.isDown`.

```lua
function Paddle:update(dt)
  if love.keyboard.isDown('left') then
    -- move left
  end
end
```
