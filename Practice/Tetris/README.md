# Tetris

Recreate the game Tetris considering the black and white version for the Game Boy console.

## Resources

The `res` folder includes the `push` library to scale the window while maintaining a pixelated look, the same font used in `00 Pong`, once again to establish a retro look, and `spritesheet.png`, to describe the appearance of the bricks. The first row describes 5 types of bricks, plus one for the gameover screen and one for the columns describing the border of the playing area. The second row details the color palette.

## Source

`main.lua` imports the necessary resources from the `res` folder, and with regards to the script in the `src` folder, it requires the files through `Dependencies.lua`.

```lua
require "src/Dependencies"
```

## Dimensions

In `constants.lua`, the idea is to compute the dimensions of the game starting from the size of an individual cell and the number of columns and rows devoted to the grid.

```lua
CELL_SIZE = 8
GRID_COLUMNS = 10
GRID_ROWS = 18
```

The idea is to maintain the structure of the original game, with a grid ten bricks wide, eighteen bricks tall.

On top of these measures:

- `BORDER_COLUMNS` describes the space devoted to the border around the grid

- `PADDING_COLUMNS` helps to add whitespace around the game (only horizontally)

- `INFO_COLUMNS` details the space for the information regarding the current level, number of points, line cleared and upcoming tetraminos

All these variables describe the space in terms of columns. The actual measure for the window is computed by multiplying the value by `CELL_WIDTH`.

## Scale

As mentioned earlier, the `push` library helps to scale the game up to a larger screen. Once `constants.lua` determines the virtual width and height, from the size of the cells and the arbitrary columns, `SCALE` is computed as a multiplying factor to obtain the window width and height.

```lua
local SCALE = math.floor(700 / VIRTUAL_WIDTH)
```

The idea is to roughly have the window 700 pixels wide (up to 700) and howerver many pixels tall to maintain the aspect ratio.

```lua
WINDOW_WIDTH = VIRTUAL_WIDTH * SCALE
WINDOW_HEIGHT = VIRTUAL_HEIGHT * SCALE
```

Given the tile size, it would be easy to find an actual measure (a multiple of eight) instead of roughly estimating the value with the division.

## Information

`Info.lua` and `Infobox.lua` are created to describe the game in terms of level, score, lines (and in a future section in terms of upcoming tetrominos).

`Infobox` receives several arguments to display a label above its corresponding value and at specific coordinates. `x`, `y`, `width` and `height` are computed in the `Info` class to have the boxes aligned, with the width based on the longer label and the height of two and a half an individual line.

The approach can be improved, but the code is clear enough to understand how the logic works.

## Brick

The brick class renders a specific brick accessing the `gFrames` table. `Utils.lua` helps to populate this table with the quads from the input spritesheet, similarly to `02 Breakout` and `Match Memory`.

```lua
gTexture = love.graphics.newImage("res/graphics/spritesheet.png")
gFrames = GenerateQuads(gTexture, CELL_SIZE, CELL_SIZE)
```

## Grid

The grid class renders two types of visual in the first half of the screen, and thanks to two separate tables:

- `border` includes the bricks for the columns surrounding the playing area

- `bricks` includes the bricks for the tetrominos. The table is intially populated with `nil` values, but as the pieces fall and ultimately stop at the bottom of the grid, the corresponding cells are updated with a copy of the pieces of the tetrominos

## Refactor

The grid and brick classes are refactored to have the bricks laid according to column and row, instead of x and y.
