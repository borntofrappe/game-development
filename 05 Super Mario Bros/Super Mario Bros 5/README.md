Incorporate changes from the lecturer's code:

- game level

## GameLevel

As prefaced in the previous update, the `GameLevel` class is used as a container for the elements of the game, like its tiles, objects and later entities.

```lua
function GameLevel:init(def)
  self.objects = def.objects
  self.tileMap = def.tileMap
end
```

It is then the `GameLevel` class responsible for actually rendering, and later updating the game.

```lua
function GameLevel:render()
  self.tileMap:render()

  for k, object in pairs(self.objects) do
    object:render()
  end
end
```

## LevelMaker

With the `GameLevel` class, `LevelMaker` returns an instance describing both the objects and tilemap.

```lua
local level =
  GameLevel(
  {
    objects = objects,
    tileMap = tileMap
  }
)
return level
```

## PlayState

While `StartState` is equipped to handle the new table returned by the `LevelMaker` class, `PlayState` produces a bug when trying to move the player. This is because the state uses `self.level` to equip the player with the instance of the `TileMap` class.

```lua
Player(
  {
    x = VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2,
    y = TILE_SIZE * (ROWS_SKY - 1) - PLAYER_HEIGHT,
    width = PLAYER_WIDTH,
    height = PLAYER_HEIGHT,
    texture = "character",
    stateMachine = StateMachine(
      -- ...
    ),
    tileMap = self.level
  }
)
```

This is now available in `self.level.tileMap`.

```lua
Player(
  {
    x = VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2,
    y = TILE_SIZE * (ROWS_SKY - 1) - PLAYER_HEIGHT,
    width = PLAYER_WIDTH,
    height = PLAYER_HEIGHT,
    texture = "character",
    stateMachine = StateMachine(
      -- ...
    ),
    tileMap = self.level.tileMap
  }
)
```

## tileMap

This is but a minor change, but I decided to update every reference to the `TileMap` in order to use the label `tileMap` instead of `map`.
