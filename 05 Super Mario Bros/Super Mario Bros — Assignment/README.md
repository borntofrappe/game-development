# [Assignment](https://docs.cs50.net/ocw/games/assignments/4/assignment4.html)

## Solid ground

> Program it such that when the player is dropped into the level, they’re always done so above solid ground

The update accomplishes the task to have the player not only on solid ground, but above solid ground as well. The idea is to have the player spawn at the very top of the level, so to avoid an immediate collision with a creature.

```lua
self.player =
  Player(
  {
    x = 0,
    y = -PLAYER_HEIGHT,
    -- other attributes
  }
)
```

Just be sure to initialize the player in its falling state, to have the sprite plummet toward the `tileMap`

```lua
self.player:changeState("falling")
```

From this starting point, finding a safe coordinate is a matter of looping through the `tileMap` object and return the coordinate for the first column providing ground tiles. This is achieved with a function, which loops through the columns, and then through the tiles.

```lua
function PlayState:getSafeTile()
  for x = 1, self.width do
    for y = 1, self.height do
      local tile = self.level.tileMap.tiles[x][y]
      if tile.id == TILE_GROUND then
        return tile
      end
    end
  end
end
```

Once the play state has access to a safe tile, the idea is to finally use the tile's coordinate to dictate the position of the player.

```lua
local tile = self:getSafeTile()

self.player =
  Player(
  {
    x = (tile.x - 1) * TILE_SIZE,
    y = -PLAYER_HEIGHT,
    -- other attributes
  }
)
```

### Bug report — safe chasm

An issue emerges when the player looks for a safe tile and finds a chasm. This is because in the `LevelMaker` class, the column describing a chasm have one ground tile still.

```lua
-- if chasm
rows_sky = height

-- set the id
id = y < rows_sky and TILE_SKY or TILE_GROUND,
```

To fix this issue end, increment the `rows_sky` variable by 1 when finding a chasm.

```diff
rows_sky = height
+rows_sky = height + 1
```

With this update, the column doesn't contain anything but sky tiles, and the `getSafeTile` function is able to move to the column which follows.

## Key and lock block

> In `LevelMaker.lua`, generate a random-colored key and lock block (taken from `keys_and_locks.png` in the `graphics` folder of the distro). The key should unlock the block when the player collides with it, triggering the block to disappear

## Goal post

> Once the lock has disappeared, trigger a goal post to spawn at the end of the level. Goal posts can be found in `flags.png`; feel free to use whichever one you’d like! Note that the flag and the pole are separated, so you’ll have to spawn a `GameObject` for each segment of the flag and one for the flag itself.

## New level

> When the player touches this goal post, we should regenerate the level, spawn the player at the beginning of it again (this can all be done via just reloading `PlayState`), and make it a little longer than it was before. You’ll need to introduce `params` to the `PlayState:enter` function that keeps track of the current level and persists the player’s score for this to work properly.
