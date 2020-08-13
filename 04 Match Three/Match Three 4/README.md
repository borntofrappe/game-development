Fill the board.

## Re-tiling

Once the tiles are moved downwards, to fill the empty spaces created by removing the matches, it's necessary to re-populate the `self.tiles` table.

Once again, loop column by column and row by row. In the code I proceed in reverse row order, but as the tiles are included in the same instant, there's fundamentally no difference.

```lua
for x = 1, self.columns do
  for y = self.rows, 1, -1 do

  end
end
```

In the loop, include a new instance of the `Tile` class in place of `nil` values.

```lua
if not self.tiles[y][x] then
  self.tiles[y][x] = Tile(x, y)
end
```

## Timer

The previous code works to include new tiles, but immediately. Since the tiles are animated when they are swapped, or when they move downwards to the empty spaces, the idea is to animate the appearance of the new tiles as well.

This is achieved by modifying the `y` coordinate, so that the tiles are effectively positioned above the board.

```lua
self.tiles[y][x].y = -1
```

With a tween then, the tiles are repositioned to their rightful place.

```lua
Timer.tween(
  0.2,
  {
    [self.tiles[y][x]] = {y = y}
  }
)
```

And this covers the animation. I've decided to include `Timer.after` function to delay the operation, but the essence is covered by `Timer.tween`.