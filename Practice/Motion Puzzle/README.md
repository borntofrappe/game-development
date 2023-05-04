# Motion Puzzle

[Motion Puzzle](https://serebii.net/mini/puzzle/#motion) is a game developed for the Pokemon Mini system where you are tasked to swap the pieces of a picture until you complete the original design. The goal of this project is to replicate the basic concept starting from a spritesheet and a few levels.

![A few frames from the demo "Motion Puzzle"](https://github.com/borntofrappe/game-development/blob/main/Practice/Motion%20Puzzle/motion-puzzle.gif)

## Spritesheet

Among the games resources, and specifically in the `res/graphics` subfolder, you find the spritesheet I created with GIMP for the game. The visual packs the spites for the different levels one above the other. In the top right corner, then, the spritesheet includes additional graphics for:

- the tiles used in the background and for the border

- the supporting visuals to stress the highlighted and selected tiles

## Utils

`Utils.lua` divides the larger texture to store the different sprites in dedicated tables.

The table dedicated to the levels includes the sprites with a nested structure, focusing in increments on:

1. the level

2. the frame

3. the column

4. the row

The table for the supporting visuals is instead populated with two frames for each graphic, with the goal of alternating between the frames to provide a subtle and yet effective animation.

## Sprite batch

A sprite batch helps to efficiently render a series of visuals. In the game, the feature is used to:

1. render the tiles in the background

2. render the tiles for the border

In both instances, the feature is implemented by first initializing the sprite batch.

```lua
backgroundTiles = love.graphics.newSpriteBatch(gTexture)
```

Once initialized, the `:add` method describes the visuals, in this instance the quads, which are incorporated in the batch.

```lua
backgroundTiles:add(gQuads.tiles[2], x, y)
```

Once added, `love.graphics.draw` is finally able to render the visuals in a single line.

```lua
love.graphics.setColor(1, 1, 1)
love.graphics.draw(backgroundTiles)
```

## Puzzle

`Puzzle.lua` populates a table with the pieces of the puzzle. The `:new` function begins by keeping track of the possible coordinates.

```lua
local piecesPositions = {}
for column = 1, PUZZLE_DIMENSIONS do
    for row = 1, PUZZLE_DIMENSIONS do
        -- add column and row to piecesPositions
    end
end
```

The idea is to then create a separate loop, once again considering the puzzle dimensions, and populate a different table with the actual pieces.

```lua
local pieces = {}

for column = 1, PUZZLE_DIMENSIONS do
    for row = 1, PUZZLE_DIMENSIONS do

    end
end
```

Each piece includes two values for the column and row initialized in the loop, to retrieve the individual piece from the quads table:

```lua
pieces[key] = {
    ["column"] = column,
    ["row"] = row
}
```

Beyond the two coordinates, each piece also includes a column and row picked at random from the table describing the position.

```lua
local piecePosition = table.remove(piecesPositions, love.math.random(#piecesPositions))

pieces[key] = {
    -- previous field
    ["position"] = {
        ["column"] = piecePosition.column,
        ["row"] = piecePosition.row
    }
}
```

The discrepancy between the pair describing the frame, which piece to draw, and the pair describing the position, where to draw the piece, is what ultimately allows to implement the game's logic. The idea is to update the puzzle by targeting a specific piece and modifying the values describing the frame, not the position.

To target a specific piece, notice the use of a `key` — `key` to populate the table, `key1` and `key2` to identify the pieces from the play state. The `GenerateKey` function receives the column and row describing the position to return a unique value.

```lua
function GenerateKey(column, row)
    return "c" .. column .. "r" .. row
end
```

In this manner it is possible to directly use the column and row describing the selected and highlighted tile.

## Timer

The play state sets up two intervals, to update the frames in the puzzle and the supporting visuals. For the first interval the idea is to alternate the order of the frames.

```lua
self.puzzle.frame = self.puzzle.frame + self.frameDirection
```

`frameDirection` is toggled between `1` and `-1` to ensure a valid frame.

For the second interval the idea is to instead loop continuously between the available frames, resetting the value when reaching the last frame.

```lua
self.support.frame = self.support.frame == self.support.frames and 1 or self.support.frame + 1
```

Notice that the interval for the supporting visuals includes a label.

```lua
Timer:every(
    duration,
    function()
        -- callback
    end,
    false, -- isImmediate
    self.support.label
)
```

The string helps to remove the interval when moving to the finish state.

```lua
Timer:remove(self.support.label)
```

In this instance I chose not to rely on `Timer:reset` since I wanted to preserve the interval animating the puzzle. Speaking of which, the finish state "speeds up" the interval in a rather unusual manner, that is by calling the update function twice.

```lua
Timer:update(dt)
Timer:update(dt)
```

## Input

The game can be played with keyboard or mouse input. With a keyboard you move between states with the enter and escape key, you update the puzzle with the enter and arrow keys. With a mouse you move between states by pressing the right or left button and update the puzzle on click.
