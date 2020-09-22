Incorporate changes from the lecturer's code:

- score

- jump blocks

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
self.player.score = self.player.score + 50
```

The gem is ultimately what would increase the score, but in the current update, and to test the feature, the increase is granted when hitting a block from underneath.

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

## Object collision

The object for the jump block is updated to have an additional boolean: `isSolid`.

```lua
GameObject(
  {
    x = x,
    y = rows_sky - 3,
    texture = "jump_blocks",
    color = colorJumpBlocks,
    variety = 1,
    isSolid = true
  }
)
```

This boolean is used in the logic of the player, and by giving the player class knowledge about the level itself.

```lua
self.player =
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
    level = self.level
  }
)
```

When the player knows about the level, the idea is to then check for a collision between the player and solid objects. Collision is checked with a function, performing an AABB test directly from the `GameObject` class.

```lua
function GameObject:collides(target)
  if target.x + target.width < (self.x - 1) * TILE_SIZE or target.x > (self.x - 1) * TILE_SIZE + self.width then
    return false
  end

  if target.y + target.height < (self.y - 1) * TILE_SIZE or target.y > (self.y - 1) * TILE_SIZE + self.height then
    return false
  end

  return true
end
```

### Jump state

In the jump state, the idea is to have the player stop its vetical ascent when the same player overlaps with a solide object.

```lua
for k, object in pairs(self.player.level.objects) do
    if object.isSolid and object:collides(self.player) then
      -- collision
    end
  end
```

In this instance immediately reset `dy` and set the vertical coordinate to the bottom of the block, before moving to the falling state.

```lua
self.player.y = (object.y - 1) * TILE_SIZE + object.height
self.player.dy = 0
self.player:changeState("falling")
```

### Falling state

In the falling state, a similar logic is repeated, but what changes is the reaction to a collision. In this instance, the player changes its vertical coordinate to consider the top of the object, before moving to the walking or idle state.

```lua
self.player.y = (object.y - 1) * TILE_SIZE - self.player.height
self.player.dy = 0
```

The change in state mirrors the situation in which the player finds a solid tile.

```lua
if love.keyboard.isDown("left") or love.keyboard.isDown("right") then
  self.player:changeState("walking")
else
  self.player:changeState("idle")
end
```

This works to have the player stop when jumping or falling on an object. In terms of gameplay however, it is necessary to consider objects when moving horizontally.

### left and right collision

The idea is to prevent the player from moving left and right, when a solid block is found in the respective direction. This is achieved by having the game literally offset the horizontal movement. For the function checking a collision on the left side, for instance, the game first moves the player left.

```lua
if love.keyboard.isDown("left") then
  self.player.direction = "left"
  self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
  self.player:checkLeftCollision(dt)
end
```

In `checkLeftCollision` then, the game looks for a collidable object — more on this soon — and offsets the change in the `x` dimension.

```lua
function Player:checkLeftCollision(dt)
  if collidable then
    self.x = self.x + PLAYER_WALK_SPEED * dt
  end
end
```

The same for the right side, but considering a mirrored change in `x`.

To check for collidable objects, the idea is to have a dedicated function in `checkObjectCollision`, and have the function return a table describing solid objects.

```lua
local collidedObjects = {}

for k, object in pairs(self.level.objects) do
  if object.isSolid and object:collides(self) then
    table.insert(collidedObjects, object)
  end
end

return collidedObjects
```

When looking for collidable objects, the table returned by the function is finally able to determine if a solid block is present.

```lua
function Player:checkLeftCollision(dt)
  local collidedObjects = self:checkObjectCollision()

  if #collidedObjects > 0 then
    self.x = self.x + PLAYER_WALK_SPEED * dt
  end
end
```

### Walking state

While the change in the horizontal dimension is considered with the `Player` class and the functions checking for a collision, it is finally necessary to update the walking state. The class is modified in two instances:

- move to the falling state if the player is above solid tiles — as earlier — but also if the player is above solid objects

  ```lua
  local collidedObjects = self.player:checkObjectCollision()

  if
    #collidedObjects == 0
    -- and consider tiles
    then
    self.player:changeState("falling")
  end
  ```

- consider a collision on either side, but only after shifting the player one pixel upwards

  ```lua
  self.player.y = self.player.y - 1
  self.player:checkLeftCollision(dt)
  ```

  This change is immediately offset after the checkup.

  ```lua
  self.player.y = self.player.y - 1
  self.player:checkLeftCollision(dt)
  self.player.y = self.player.y + 1
  ```

  And ultimately, it is a necessary shift to allow for horizontal movement when the player is above a solid object. Without this shift, the player would find the object underneath, and this would prevent the player from moving altogether.

### 1px shifts

Beside changing the vertical coordinate by 1 pixel, to move the player above a solid block, I've also included a shift in the horizontal dimension. This shift is again by one pixel, and in the `checkRightCollision` function.

```lua
self.x = self.x - 1
local collidedObjects = self:checkObjectCollision()
self.x = self.x + 1
```

Without this shift, the player is fixed 1 pixel before a solid tile, breaking the illusion of detecting a collision.

One important thing to note, however. Since the function now consider one pixel before the current position, it is necessary to offset the offset in the jumping and falling state.

```lua
if love.keyboard.isDown("right") then
    self.player.x = self.player.x - 1
end

-- find solid objects

if love.keyboard.isDown("right") then
    self.player.x = self.player.x + 1
end
```

Without this compromise, the player would detect a solid object in the jumping/falling state before finding the same object horizontally. Visually, it would mean the player would be moved below/above the tile abruptly.
