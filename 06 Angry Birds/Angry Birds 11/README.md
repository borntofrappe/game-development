# Angry Birds 11

_Note_: in the course, the lecturer introduced a `AlienLaunchMarker` class, responsible for the drag and release feature. Here I replicated the feature directly in the `PlayState`, and leveraging two boolean values.

## boolean

The idea is to use the functions `love.mouse.wasPressed()` and `love.mouse.wasReleased()` together with two booleans: `self.isUpdating` and `self.isDragging`. The update onsiders the following flow:

- player presses the mouse

- player drags the circle away from the original position

- player releases the mouse, launching the game in the prescribed direction

### Press

When the cursor gets pressed toggle `self.isDragging`, but only if the press is in the vicinity of the circle describing the player.

It is important to note that the coordinates of the mouse need to be processed through `push:toGame`, since the push library is projecting the window with a given scale.

```lua
if love.mouse.wasPressed(1) then
  local x, y = push:toGame(love.mouse.getPosition())
end
```

Once these coordinates exceed a fairly generous area, toggle the mentioned booleab to `true`.

```lua
  if  math.abs(x - self.player.x) < ALIEN_WIDTH and
      math.abs(y - self.player.y) < ALIEN_WIDTH
        then
          self.isDragging = true
  end
end
```

### Drag

Once `self.isDragging` resolves to `true`, start by considering the coordinates of the mouse cursor, and continuously update the body of the player to match the new values.

```lua
if self.isDragging then
  local x, y = push:toGame(love.mouse.getPosition())
  self.player.body:setPosition(x, y)
end
```

### Release

As the mouse is released, the idea is to consider the difference in horizontal and vertical coordinates, between the cursor and the original position of the player.

```lua
if love.mouse.wasReleased(1) then
  local x, y = push:toGame(love.mouse.getPosition())
end
```

The player is made to move by modifying its linear velocity, but only if the circle is dragged outside of the prescribed launch area.

```lua
if math.abs(x - self.player.x) < ALIEN_WIDTH and math.abs(y - self.player.y) < ALIEN_WIDTH then

end
```

Inside of this area, the player is reset to its original location.

```lua
self.player.body:setPosition(self.player.x, self.player.y)
```

Outside of the area, the linear velocity is modified considering the difference between horizontal and vertical values, together with a multplying factor.

```lua
local dx = self.player.x - x
local dy = self.player.y - y
self.player.body:setLinearVelocity(dx * 5, dy * 5)
```

Be sure to also modify `self.isDragging` and `self.isUpdating` to reflect the new situation:

- the player is no longer being dragged

  ```lua
  self.isDragging = false
  ```

- the player, and the larger words, need to be updated.

  ```lua
  self.isUpdating = true
  ```

### Updating

To have the game continue, it is finally necessary to reset the player as it stops moving. This is achieved by controlling the player's speed inside of the `if` statement considering `self.isUpdating`.

```lua
if self.isUpdating then
  local vX, vY = self.player.body:getLinearVelocity()
end
```

The logic is borrowed from that checking that the speed is high enough to destroy an obstacle/target. Here, however, the idea is to reset the player and the associated booleans if the speed is low enough.

```lua
local vSum = math.abs(vX) + math.abs(vY)
if vSum < VELOCITY_RESET then
  self.player.body:setPosition(self.player.x, self.player.y)
  self.isUpdating = false
end
```

### not booleans

As the game is updated, the idea is to prevent the press/drag/release operation from taking place.

This explains the additional conditions included in each operation. For instance and for the dragging operation.

```diff
if self.isDragging then
+if not self.isUpdating and self.isDragging then
```

## constants

This is but a minor update connected to arbitrary values included in the game. The gravity, the threshold describing the speed sufficient to destroy an obstacle/target. These are centralized in `constants.lua` with a descriptive label.

## Launch area

Unlike the project assignment, the update doesn't show the trajectory of the player as it is dragged, and instead renders a semi-transparent circle describing the launch area.

Consider checking [the cited resource](http://www.iforce2d.net/b2dtut/projected-trajectory) to add the trajectory in the final update.
