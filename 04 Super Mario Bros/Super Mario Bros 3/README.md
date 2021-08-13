# Super Mario Bros 3

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

## pointToTile

The `pointToTile` function is defined in the `TileMap` class, and uses the input coordinates to determine a tile at the specific `(x, y)` point.

```lua
function TileMap:pointToTile(x, y)

end
```

Start by returning `nil` if the point exceeds the game window.

```lua
function TileMap:pointToTile(x, y)
  if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
    return nil
  end
end
```

Knowing the size of the tile in `TILE_SIZE`, and knowing tiles start at `1` then, find the column and row by dividing up the input coordinate the size of the tile.

```lua
function TileMap:pointToTile(x, y)
  local column = 1 + math.floor(x / TILE_SIZE)
  local row = 1 + math.floor(y / TILE_SIZE)
end
```

Finally, return the newfound tile.

```lua
return self.tiles[column][row]
```

## Player

With `pointToTile`, it's possible to have the player — and later other entities — aware of the surrounding environment.

```diff
self.player =
    Player(
    {
      x = VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2,
      y = TILE_SIZE * (ROWS_SKY - 1) - PLAYER_HEIGHT,
      width = PLAYER_WIDTH,
      height = PLAYER_HEIGHT,
      texture = "character",
      stateMachine = StateMachine(...),
+     map = self.level
    }
  )
```

It's then possible to have the player move, stop, fall, and all according to the level. The tilemap is accessible from the player class and its individual states.

## Walking

The idea is to consider the tiles right below the player.

```lua
local tileBottomLeft = self.player.map:pointToTile(self.player.x + 2, self.player.y + self.player.height)
local tileBottomRight =
self.player.map:pointToTile(self.player.x + self.player.width - 2, self.player.y + self.player.height)
```

`2` is used as a way to reduce the space covered by the player. By checking the horizontal coordinate without this extra padding, the player would not fall when finding a single chasm, as the sprite of both player and tile share the same `width`.

If these tiles both represent an instance of the sky tile then, move to the falling state.

```lua
if (tileBottomLeft and tileBottomRight) and (tileBottomLeft.id == TILE_SKY and tileBottomRight.id == TILE_SKY) then
      self.player:changeState("falling")
end
```

The condition seems complicated, but it's only because the `if` statement first checks that the tiles below the player are indeed available — consider how `pointToTile` returns `nil` if the input tile falls outside of the game's own window.

## Jumping

In the jump state, the game _would_ consider the tiles above the player, to have it immediately stop and fall if either tile describes solid ground.

```lua
local tileTopLeft = self.player.map:pointToTile(self.player.x + 2, self.player.y)
  local tileTopRight = self.player.map:pointToTile(self.player.x + self.player.width - 2, self.player.y)
```

In the current update, however, this checkup is superfluous. There are are no instances of platforms or other sections under which the player can go.

For future reference however, the player would stop its vertical ascent and move to the falling state if either tile were to describe ground.

```lua
if (tileTopLeft and tileTopRight) and (tileTopLeft.id == TILE_GROUND or tileTopRight.id == TILE_GROUND) then
    self.player.dy = 0
    self.player:changeState("falling")
end
```

## Falling

In the falling state, consider the tiles right below the player. This not only to have the player continue to fall if the tiles describe the sky, but to also stop the player if the tiles describe ground.

- update the vertical coordinate

  ```lua
  self.player.dy = self.player.dy + GRAVITY
  self.player.y = self.player.y + (self.player.dy * dt)
  ```

- if either tile describes ground, stop the vertical movement

  ```lua
  if (tileBottomLeft and tileBottomRight) and (tileBottomLeft.id == TILE_GROUND or tileBottomRight.id == TILE_GROUND) then
    self.player.dy = 0
  end
  ```

  Moreover, use the `y` coordinate of the either tile to reposition the player. This to ensure that the player is always above the tiles.

  ```lua
  self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height
  ```

## Collision

In the walking state, but also when jumping or falling, the game needs to consider horizontal movement when the `left` or `right` keys are being pressed.

```lua
if love.keyboard.isDown("left") then
  self.player.direction = "left"
  self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
elseif love.keyboard.isDown("right") then
  self.player.direction = "right"
  self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
end
```

To prevent the player from moving horizontally when the tiles on its side describe ground tiles — and to avoid repeating the logic across states — the update defines two more functions on the `Player` class: `checkLeftCollision` and `checkRightCollision`. These are used immediately after the horizontal position is modified.

```lua
self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
self.player:checkLeftCollision()
```

In terms of logic however, they repeat the idea described in previous paragraphs:

- consider the tiles on the side of the player

- if the tiles describe ground, fix the position to the tile's coordinates

The code is slightly more finnicky but only because the tile in the top/bottom corner consider `x` and `y` values slightly inside of the player sprite.

```lua
local tileTopLeft = self.map:pointToTile(self.x, self.y + 1)
local tileBottomLeft = self.map:pointToTile(self.x, self.y + self.height - 1)
```

In this instance, the tiles to the left of the player are identified one pixel below the top of the player, and one pixel above its bottom.

Regardless of the actual coordinate, the function prevents the player from moving by directly changing its position.

```lua
 if (tileTopLeft and tileBottomLeft) and (tileTopLeft.id == TILE_GROUND or tileBottomLeft.id == TILE_GROUND) then
    self.x = (tileBottomLeft.x - 1) * TILE_SIZE + tileBottomLeft.width
  end
```

The same logic is applied to the right side.
