Incorporate changes from the lecturer's code:

- score

- gems and jump blocks

## Score

The idea is to ultimately increase a score when the player collects a gem. The score is initialized within the player class.

```lua
function Player:init(def)
  Entity.init(self, def)
  self.score = 0
end
```

And it is rendered in the context of `PlayState`. This to have the score visible in the top left corner regardless of camera scroll.

```lua
function PlayState:render()
  love.graphics.setFont(gFonts["medium"])
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print("Score: " .. self.player.score, 4 + 1, 4 + 1)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Score: " .. self.player.score, 4, 4)

  love.graphics.translate(-math.floor(self.camX), 0)

  -- game elements
end
```

Once a gem is picked up then, the score is increased with a certain value.

```lua
self.player.score = self.player.score + 100
```

## Jump blocks

Jump blocks are included directly in the `LevelMaker` class.

```lua
local hasJumpBlock = math.random(8) == 1
if hasJumpBlock then
  table.insert(
    objects,
    GameObject(
      {
        x = x,
        y = rows_sky - 3,
        texture = "jump_blocks",
        color = colorJumpBlocks,
        variety = 1
      }
    )
  )
end
```

This is similar to the bushes and cacti, but I decided to:

- use a color at random

  ```lua
  -- -- previously
  -- local colorJumpBlocks = math.random(#gFrames["jump_blocks"])

  color = colorJumpBlocks,
  ```

- use a fixed variety in the first sprite of each set

  ```lua
  variety = 1
  ```

- add the jump block two rows above the ground

  ```lua
  y = rows_sky - 3,
  ```

What changes is that the player is supposed to collide with the game object.

## Game Object — collision

## Game Object — consumption
