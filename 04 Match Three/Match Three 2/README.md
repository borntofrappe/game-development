# Match Three 2 - Removing Matches

Once `self.matches` stores all those adjacent tiles resulting in an match, it is necessary to remove them. Remove them from view and from the table of tiles. This also means that the table needs to be re-populated with new tiles, but one step at a time.

Upon removing the tiles it is indeed necessary to adjust the existing display, to re-allocate the remaining tiles in the places left by the cleared squares.

The approach can be described as follows:

- remove the tiles;

- loop from the bottom up, considering the grid one column at a time. It is indeed necessary to account only for gravity in the vertical dimension;

- upon finding a tile, do nothing;

- when finding a hole, left by a cleared tile, proceed upwards to find the next existing tile. If finding one of such type, bring it back down where the hole is found.

- repeat for every cell, for every column and bottom up.

## removeMatches()

To remove a tile you can set the respective value to `nil`.

```lua
-- function removing matches from the grid
function Board:removeMatches()
  -- loop through the table of matches
  for k, match in pairs(self.matches) do
    -- loop through the tiles of each match
    for j, tile in pairs(match) do
      -- set the tiles in self.tiles which match the tiles' own coordinates to nil
      self.tiles[tile.gridY][tile.gridX] = nil
    end
  end

  -- reset matches to nil
  self.matches = nil
end
```

Here we set equal to `nil` the tiles with the coordinates matching the items of the `self.matches` table and specifically each tile of every match. Remember that `self.matches` is a table of tables, built as follows:

```text
- matches
  - match
    - tile
    - tile
    - tile
  - match
    - tile
    - tile
    - tile
    - tile
```

This assuming there are two matches, of three and four tiles each.

Upon setting the tiles to nil, the board effectively disregards the tiles. It is however important to note that this will break the code insofar the `lua` file will try to consider the coordinate, color and variety of items which do not have coordinate, color nor variety.

This can be fixed by immediately placing new tiles, or conditionally rendering tiles as long as they are not nil, but before re-tiling the board it is necessary to animate the rest of the board in light of the empty spaces.
