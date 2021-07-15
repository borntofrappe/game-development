# Angry Birds 11

_Note_: in the course the lecturer introduced a `AlienLaunchMarker` class, responsible for the drag and release feature. Here I implemented the feature directly in the `PlayState`, but using two boolean values: `isDragging` and `isUpdating`.

## Mouse pressed

When the right button of the mouse cursor is pressed, the idea is to set to `true` the boolean `isDragging`. This action, however, is conditioned to the coordinates describing a point in launch area described by an arbitrary circle.

```lua
if ((x - self.player.x) ^ 2 + (y - self.player.y) ^ 2) ^ 0.5 < ALIEN_WIDTH then
  self.isDragging = true
end
```

It is important to note that the coordinates of the mouse need to be processed through `push:toGame`, since the push library is projecting the window with a given scale. The method is necessary every time the script compares the mouse coordinates with the player's own position.

```lua
local x, y = push:toGame(love.mouse.getPosition())
```

## Drag

If the boolean `isDragging` is set to `true`, the idea is to start considering the coordinates of the mouse cursor to update the player.

```lua
if self.isDragging then
  local x, y = push:toGame(love.mouse.getPosition())
  self.player.body:setPosition(x, y)
end
```

## Release

When the right button of the mouse cursor is released, the idea is to finally launch the dragged player. Once again, however, the script considers the coordinates and the launch area. Inside this area the player is reset to its original position and the boolean `isDragging` is set back to `false`.

```lua
if ((x - self.player.x) ^ 2 + (y - self.player.y) ^ 2) ^ 0.5 < ALIEN_WIDTH then
  self.isDragging = false
  self.player.body:setPosition(self.player.x, self.player.y)
end
```

Outside of the launch area, the linear velocity is modified considering the difference between horizontal and vertical values, together with a multplying factor.

```lua
local dx = self.player.x - x
local dy = self.player.y - y
self.player.body:setLinearVelocity(dx * 5, dy * 5)
```

In this instance, it is the boolean `isUpdating` which is set to `true`, allowing for the world to actually simulate the launch.

## Updating

Pending the `isUpdating` boolean, the game updates the worlds and considers the destroyed objects.

```lua
if self.isUpdating then
  self.world:update(dt)
  if #self.destroyedObjects > 0 then
    -- ...
  end
end
```

To continue the game with a new launch, it is finally necessary to reset the player as it stops moving. This is achieved by considering the player's speed.

```lua
local vX, vY = self.player.body:getLinearVelocity()
```

The logic is borrowed from the section checking that the speed is high enough to destroy an obstacle or target. Here, however, the idea is to reset the player and the associated booleans if the speed is low enough.

```lua
local vSum = math.abs(vX) + math.abs(vY)
if vSum < VELOCITY.reset then
  self.player.body:setPosition(self.player.x, self.player.y)
  self.isUpdating = false
end
```

To slow the player down, further than the default, the body is modified through the `setLinearDamping` and `setAngularDamping` functions.

```lua
player.body:setLinearDamping(0.25)
player.body:setAngularDamping(0.8)
```

## Not booleans

As the game is updated, the idea is to prevent the press, drag, or again release operations from taking place. This explains the additional conditions included in each operation. For instance, the dragging operation is conditioned to the game not being updated.

```diff
if self.isDragging then
+if not self.isUpdating and self.isDragging then
```

## Launch area

Unlike the game introduced in the course, the project doesn't show the trajectory of the player as it is dragged. Instead, the launch area is highlighted with a basic semi-transparent circle.

A future update might implement the feature considering [the resource](http://www.iforce2d.net/b2dtut/projected-trajectory) cited in the video.
