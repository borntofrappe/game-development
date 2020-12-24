Generate a level with random backgrounds, tiles and tile tops.

## Quads

Before diving in how to generate different elvels every time the game is launched, the update considers the spritesheet for the backgrounds, tiles and tiles' tops to render a more realistic world.

For the backgrounds, the png image offers three varieties in 256\*144 rectangles. Fabricating the quads is therefore straightfoward.

```lua
gFrames = {
  ["backgrounds"] = GenerateQuads(gTextures["backgrounds"], 256, 144),
}
```

For the tiles and tiles' tops, however, the process is more complex. It's necessary to loop through the multiple varieties, and then loop through the different 16x16 rectangles to provide the various tiles.

The idea is to ultimately have nested tables, so that the first layer dictates the color, and the second the specific visual.

```lua
gFrames["tiles"][1][3] -- yellow diagonal, brick
gFrames["tiles"][1][5] -- yellow diagonal, empty
```

In "Utils.lua", you find this logic implemented in the `GenerateQuadsTiles` and `GenerateQuadsTileTops` function. The only difference between the two is that there are more varieties of tops, and thus the loop for the second function considers more rows.

> _Please note_: I've modified "tiles.png" to fix an error from the original codebase. This error relates to having the marron variant in the sixth row, first column already equipped with a tile top.

## Screen size

I've modified the values for the virtual width and height. This to make it possible for the background image to cover the screen in full.
