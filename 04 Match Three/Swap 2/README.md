Tween the position of the tiles.

## Board

To smoothly change the position of the tiles, it's necessary to have two dedicated fields describing the `x` and `y` coordinate.

The table is updated to include the values.

```lua
{
  x = x,
  y = y,
  color = math.random(#gFrames["tiles"]),
  variety = math.random(#gFrames["tiles"][1])
}
```

And the render function uses the `x` and `y` field instead of the indexes.

```lua
love.graphics.draw(
  gTextures["match3"],
  gFrames["tiles"][tile.color][tile.variety],
  (tile.x - 1) * TILE_WIDTH,
  (tile.y - 1) * TILE_HEIGHT
)
```

This means that when you swap the tiles however, you need to swap the values of the coordinates as well.

```lua
-- swap in board


-- swap coordinates
tempX = board[selectedTile.y][selectedTile.x].x
tempY = board[selectedTile.y][selectedTile.x].y

board[selectedTile.y][selectedTile.x].x = board[highlightedTile.y][highlightedTile.x].x
board[selectedTile.y][selectedTile.x].y = board[highlightedTile.y][highlightedTile.x].y

board[highlightedTile.y][highlightedTile.x].x = tempX
board[highlightedTile.y][highlightedTile.x].y = tempY
```

It's not enough to change the position of the tiles in `board`.

## Tween

The previous snippet works to modify the board and the coordinates immediately. With the `timer` module however, the change in coordinates is nested in the callback function of `Timer.tween()`

```lua
-- swap in board


-- swap coordinates

tempX = board[selectedTile.y][selectedTile.x].x
tempY = board[selectedTile.y][selectedTile.x].y

Timer.tween(0.25, {
  [board[selectedTile.y][selectedTile.x]] = { x = board[highlightedTile.y][highlightedTile.x].x, y = board[highlightedTile.y][highlightedTile.x].y},
  [board[highlightedTile.y][highlightedTile.x]] = { x = tempX, y = tempY}
})
```

This works, but only if you allow the `Timer` object to be updated.

```lua
function love.update(dt)
  Timer.update(dt)
end
```

## Gameplay

As mentioned in the video, the swap should occur only when the selected and highlighted tiles are adjacent. This means the operation is nested in a conditional checking the coordinates — technically the difference between the coordinates — of the two.

```lua
if math.abs(highlightedTile.x - selectedTile.x) + math.abs(highlightedTile.y - selectedTile.y) == 1 then
  --  swap
end
```

Only when the tiles are adjacent, the difference between the coordinates in absolute terms totals `1`.
