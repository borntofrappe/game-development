Select, highlight, swap tiles.

## Select

The current selection is highlighted with the stroke of a rectangle.

```lua
love.graphics.setLineWidth(4)
love.graphics.setColor(1, 0.1, 0.1, 1)
love.graphics.rectangle("line", (selectedTile.x - 1) * 32, (selectedTile.y - 1) * 32, 32, 32, 4)
```

The course includes the shape in the for loop, when the `x` and `y` coordinates match the tile being rendered, but it's actually possible to draw the outline outside of the for loop, using directly the coordinates stored in `selectedTile`.

`selectedTile` starts out in a random place in the grid.

```lua
selectedTile = {
  x = math.random(columns),
  y = math.random(rows)
}
```

It is then updated following a keypress using the arrow keys.

```lua
if key == "right" then
  selectedTile.x = math.min(columns, selectedTile.x + 1)
end

-- other arrows
```

## Highlight

By pressing enter, the idea is to highglight the tile behind the current selection.

```lua
if key == "enter" or key == "return" then
  highlightedTile = {
    x = selectedTile.x,
    y = selectedTile.y
  }
end
```

This variable starts out with a value of `nil`, so to render the desired visual only when a tile has been chosen.

```lua
function love.load()
  highlightedTile = nil
end

function love.draw()
  if highlightedTile then
    love.graphics.setColor(1, 1, 1, 0.4)
    love.graphics.rectangle("fill", (highlightedTile.x - 1) * 32, (highlightedTile.y - 1) * 32, 32, 32, 4)
    love.graphics.setColor(1, 1, 1, 1)
  end
end
```

Remember to reset the opacity once you alter it with `setColor`.

In this manner a tile is highlighted, but never returns to its default status. To this end, include a conditional in the function checking a key press.

```lua
if key == "enter" or key == "return" then
  if highlighted then
    highlighted = nil
  else
    highlightedTile = {
      x = selectedTile.x,
      y = selectedTile.y
    }
  end
end
```

## Swap

When resetting the highlighted tile, swap the tiles described by the highlighted and selected coordinates.

```lua
if key == "enter" or key == "return" then
  if highlighted then
    -- swap here
    highlighted = nil
  else
    -- set highlighted
  end
end
```

The swap is achieved by storing one of the two tiles in a temporary variable, and then override the board values.

```lua
tempTile = board[selectedTile.y][selectedTile.x]

board[selectedTile.y][selectedTile.x] = board[highlightedTile.y][highlightedTile.x]

board[highlightedTile.y][highlightedTile.x] = tempTile
```

In this instance the tile matching the coordinates of the selected tile receives the tile of the highlighted one. The highlighted tile then considers the value stored in the temporary variable.

### Update

Lua provides a way to swap two variables in a single line of code.

```lua
x, y = y, x
```

In light of this, the tiles are swapped more concisely and as follows.

```lua
board[selectedTile.y][selectedTile.x], board[highlightedTile.y][highlightedTile.x] =
  board[highlightedTile.y][highlightedTile.x],
  board[selectedTile.y][selectedTile.x]
```

