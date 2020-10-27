# Tetris

Recreate the basic experience of a game of tetris.

## Notes

To understand the code it is necessary to understand how the individual tetriminos and the grid are structured.

### Tetriminos and offsets

Tetriminos are made up of bricks, positioned carefully in different configurations. Refer to [this image](https://upload.wikimedia.org/wikipedia/commons/3/39/Tetrominoes_IJLO_STZ_Worlds.svg) for the seven possible shapes. The complexity is increased by the fact that the shapes can also rotate. To accommodate this premise, `TETRIMINOS_OFFSETS` describes the position of the bricks with a series of tables.

```lua
[1] = {
  {-1, 0},
  {0, 0},
  {1, 0},
  {2, 0}
}
```

The idea is to position the tetriminos in the grid, and then the bricks modifying the column and row. In the snippet's example, for instance, positioning four bricks at different horizontal coordinates, and producing the following shape.

```text
oooo
```

As the shape rotates, the solution is to add yet another table, with different offset values.

```lua
[1] = {
  {-1, 0},
  {0, 0},
  {1, 0},
  {2, 0}
},
[2] = {
  {0, -1},
  {0, 0},
  {0, 1},
  {0, 2}
}
```

The tetriminos class starts from the first configuration, `[1]`, and then updates the structure of the bricks looping through the offsets' table.

_Please note_: the constant `TETRIMINOS_OFFSETS` also describes two additional offsets for the center of the shape.

```lua
["center"] = {0, 0.5}
```

This is handy to position the tetriminos with respect to their center, and it is ultimately how the next tetriminos is always centered on the side panel.

### Grid and bricks

The grid is made up of rows and columns, starting with `nil` values.

```lua
local bricks = {}
for row = 1, def.rows do
  bricks[row] = {}
  for column = 1, def.columns do
    bricks[row][column] = nil
  end
end
```

As the tetraminos reach the bottom of the grid, and later existing bricks, the bricks making up the pieces are used to populate the grid.

```lua
if tetriminoses.current.inPlay then
  -- update position
else
  -- deconstruct bricks
  for i, brick in ipairs(tetriminoses.current.bricks) do
    local column = brick.column
    local row = brick.row
    local color = brick.color
  end
end
```

The game is essentially creating `Brick` instances from the tetraminos, and populating the grid accessing the specific row and column.

```lua
grid.bricks[row][column] =
  Brick:new(
  {
    ["column"] = column,
    ["row"] = row,
    ["color"] = color
  }
)
```

## Concluding remarks

- the game uses a tilesheet to describe the appearance of the individual bricks. The `.png` image is divvied up in quads and using the `love.graphics.newQuad` function

- the `gui` folder provides two pieces of interface in the form of a panel and a description list. The panel is nothing but a solid rectangle with a solid outline. The description list is a panel overlaid with two pieces of text, a term and a description, positioned at either end. This last interface is inspired by the HTML element for the description list, `<dl>`
