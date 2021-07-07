# Match Three 2

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

_Please note:_ the update removes the matches, but doesn't update the grid. This means the game raises an error in the moment you try to select and swap a `nil` value.

## removeMatches

Following the `updateMatches` function, `self.matches` stores a reference to the tiles creating a match. From this starting point, removing the tiles visually is a matter of setting the variables to `nil`.

```lua
for k, match in pairs(self.matches) do
  for j, tile in pairs(match) do
    self.tiles[tile.y][tile.x] = nil
  end
end
```

Just remember to reset the table to avoid removing the tiles in the same position.

```lua
self.matches = {}
```

This is enough, but the existing codebase requires two changes.

### pairs vs ipairs

`ipairs` works swimmingly with sequences — tables without `nil` values. In the moment values are set to `nil`,however, the iterator becomes less reliable and leads to entire rows being removed from view.

Since the position of the tiles is described by two of its fields, `x` and `y`, it's safe to to `pairs` instead.

### Timer.tween

As soon as the board is created, it is safe to remove the tiles immediately.

```lua
function Board:init()
  -- initialize board

  if self:updateMatches() then
    self:removeMatches()
  end
end
```

When swapping two tiles however, you risk to remove the tiles before the animation has had a chance to update the tiles' own coordinates.

Chain a `:finish` function to `Timer.tween` to remove the proper tiles.

```lua
Timer.tween(
  -- details
):finish(
  function()
    if self:updateMatches() then
      self:removeMatches()
    end
  end
)
```
