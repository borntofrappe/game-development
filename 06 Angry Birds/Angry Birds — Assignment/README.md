# Angry Birds — Assignment

Consider the [assignment for Angry Birds](https://docs.cs50.net/ocw/games/assignments/6/assignment6.html):

- [x] implement it such that when the player presses the space bar after they’ve launched an alien (and it hasn’t hit anything yet), the alien splits into three copies that all behave just like the base object

## Space aliens

As suggested in the assignment, it is not necessary to modify the instance of the alien class already describing the player. It is sufficient to have two more instances in the position of the current one.

I've decided to include these instances in a separate table.

```lua
function PlayState:init()
  self.copies = {}
end
```

`self.copies` is initialized in the play state, with the idea of populating the table when the `space` key is pressed. As per the assignment, however, this action is also conditioned to a collision not having taken place already; this is achieved by way of an additional boolean.

```lua
function PlayState:init()
  self.hasCollided = false
  self.copies = {}
end
```

Initialized to `false`, `self.hasCollided` is set to `true` following a collision between the player and the target or obstacle.

```lua
if (userData["Player"] and userData["Obstacle"]) or (userData["Player"] and userData["Target"]) then
  self.hasCollided = true
end
```

It is set back to `false` as the game is reset and the player can launch the circle once more.

```lua
if vSum < VELOCITY.reset then
  self.hasCollided = false
end
```

### copies

`self.copies` is populated following three conditions:

- the player presses the "space" key

- a collision has not taken place

- copies are not already included

The last condition is added to make sure the game has at most three instances representing the player.

```lua
if not self.hasCollided and #self.copies == 0 and love.keyboard.wasPressed("space") then

end
```

Pending the `if` statement, copies are then initialized using the `Alien` class and the coordinates and speed of the player instance.

```lua
local x, y = self.player.body:getPosition()
local vX, vY = self.player.body:getLinearVelocity()

local copy =
  Alien(
  {
    ["world"] = self.world,
    ["x"] = x,
    ["y"] = y,
    ["type"] = "circle"
  }
)
copy.body:setLinearVelocity(vX, vY)
```

To avoid an overlap however, I decided to slightly modify the horizontal and vertical coordinates. The idea is to have the copies above and below the player, and slightly behind the original instance.

```lua
x = vX > 0 and x - ALIEN_WIDTH / 2 or x + ALIEN_WIDTH / 2,
y = i == 1 and y - ALIEN_HEIGHT / 2 or y + ALIEN_HEIGHT / 2,
```

Just remember to include the copy in the `self.copies` table, so that the play state can eventually draw the copies in the `:render` function.

```lua
self.player:render()
for k, copy in pairs(self.copies) do
  copy:render()
end
```

### Reset

The idea is to reset the game not only when the circle describing the player stops moving, but also when its copies reach a similar still position.

```lua
if vSum < VELOCITY.reset then
  -- check the velocity of the copies
end
```

The approach I took is to have a boolean initialized to `false`, and switched to `true` if one of the copies exceeds the speed threshold.

```lua
local isCopyMoving = false
for k, copy in pairs(self.copies) do
  local vX, vY = copy.body:getLinearVelocity()
  local vSum = math.abs(vX) + math.abs(vY)
  if vSum > VELOCITY_RESET then
    isCopyMoving = true
    break
  end
end
```

By checking this boolean after the loop, the game resets only if the boolean is still `false`.

```lua
if not isCopyMoving then
  -- reset
end
```

When resetting the game, remember to also destroy and copies and set `self.copies` back to an empty table, effectively removing the additional copies.

```lua
if not isCopyMoving then
  -- reset player and world

  for k, copy in pairs(self.copies) do
    copy.body:destroy()
  end
  self.copies = {}
end
```
