Consider the [assignment for Match 3](https://cs50.harvard.edu/games/2019/spring/assignments/3/).

- [x] Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match

- [x] Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), with later levels generating the blocks with patterns on them (like the triangle, cross, etc.)

  - [x] These should be worth more points, at your discretion

- [ ] Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row

- [ ] Only allow swapping when it results in a match

- [ ] (Optional) Implement matching using the mouse

## Time addition

Adding a second for each tile is already covered in `PlayState:removeMatches()`.

```lua
function PlayState:removeMatches()
  for k, match in pairs(self.board.matches) do
    self.timer = self.timer + #match
    -- consider tiles
  end
end
```

Using the length of the individual matches' tables means the timer is incremented with each tile.

## Flat blocks

Instead of assigning the color and variety solely based on a random value, the `Tile` class is updated to consider the current `level`.

```lua
function Tile:init(x, y, level)
  self.x = x
  self.y = y
  self.level = level
end
```

The color still uses a random value among the available ones.

```lua
self.color = math.random(#gFrames["tiles"])
```

The variety considers instead a random value, dependant on the current level

```lua
self.variety = math.random(math.min(self.level, #gFrames["tiles"][1]))
```

`math.min` is to ensure a valid integer, even when the level surpasses the number of available varieties. At most, `math.random` will consider the length of the table, hence all possible varietis.

In terms of points, the variety is already accounted for:

```lua
self.score = self.score + 50 * tile.variety
```
