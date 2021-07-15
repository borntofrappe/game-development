# Angry Birds 10

## Levels

The update reconsiders the way the player, target and obstacles are initialized. In `constants.lua`, `TARGET` and `PLAYER` are used to describe the position of the two aliens.

```lua
PLAYER = {
  x = VIRTUAL_WIDTH / 4,
  y = VIRTUAL_HEIGHT - ALIEN_HEIGHT / 2
}
TARGET = {
  x = VIRTUAL_WIDTH * 3 / 4,
  y = VIRTUAL_HEIGHT - ALIEN_HEIGHT / 2
}
```

`OBSTACLES` describes the position and type of the obstacles as well.

```lua
OBSTACLES = {
  {
    x = VIRTUAL_WIDTH * 3 / 4 - 55,
    y = VIRTUAL_HEIGHT - 55,
    direction = "vertical"
  },
  -- other obstacles
}
```

With this technique, it is reasonable to assume a situation in which a `Levels` class describes several game structures, and the play state picks from the proposed levels, either at random or following an established order. The idea is to ultimately have data drive the building of the levels.

## User data

Game objects are given a label to differentiate the fixtures. A common label for the obstacles.

```lua
fixture:setUserData("Obstacle")
```

A different label for the aliens, depending on the type.

```lua
fixture:setUserData(self.type == "square" and "Target" or "Player")
```

The edges are also attributed a fixture, although the label is technically superfluous.

```lua
fixture:setUserData("Edge")
```

In the moment you later check for a label, you'd obtain a value of `nil` when user data is not specified.

## Collision callback

As mentioned in a previous update, callbacks are initialized in the world through `world:setCallbacks`. Here you specify a series of functions which are executed at different stages of a collision, `beginContact`, `endContact`, `preSolve` and `postSolve`.

For the specific game, we are interested only in the beginning of a collision.

```lua
function PlayState:init()
  -- define beginContact
  self.world:setCallbacks(beginContact)
end
```

The idea is to check the labels of two colliding objects, and have the obstacles/target disappear as a collision resolves with sufficient impact.

```lua
function beginContact(f1, f2, contact)

end
```

The code checks the labels by having a table describe a specific user data with a boolean.

```lua
local userData = {}
userData[f1:getUserData()] = true
userData[f2:getUserData()] = true
```

With this setup, it is enough to check for `userData["Player"]`, or again `userData["Obstacle"]` instead of checking whether either label contains either value.

In terms of dynamics, an obstacle or the target is removed only if the collision has enough speed. This is guaranteed by using the horizontal and vertical speed obtained through `getLinearVelocity`.

```lua
if userData["Player"] and userData["Obstacle"] then
  if f1:getUserData() == "Player" then
    local vX, vY = f1:getBody():getLinearVelocity()
  else
    -- same logic for f2 == "Player"
  end
end
```

The way objects are actually removed is however layered in two steps:

1. when detecting a fast enough collision, include the object in a table

   ```lua
   table.insert(self.destroyedObjects, f2:getBody())
   ```

2. after the world is updated then, consider the objects in the update function

   ```lua
   if #self.destroyedObjects > 0 then
    -- destroy
   end
   ```

The layered structure is necessary since removing the objects in the body of the `beginContact` function would prompt an error. This is because the body is still being considered by the physics library.

## Destroy

To destroy an object, `love.physics` provide two essential functions:

- `body:isDestroyed()` returns a boolean detailing whether or not the object is destroyed

- `body:destroy()` actually destroys the body

The first function returning a boolean is used to make sure that the game and its variables match with the world and its bodies. For the obstacles, for instance, you remove the bodies from the world looping through the `self.destroyedObjects` table.

```lua
for k, body in pairs(self.destroyedObjects) do
  if not body:isDestroyed() then
    body:destroy()
  end
end
```

With `isDestroyed`, then, you remove the obstacles from the `self.obstacles` table as well.

```lua
for i = #self.obstacles, 1, -1 do
  if self.obstacles[i].body:isDestroyed() then
    table.remove(self.obstacles, i)
  end
end
```

This ensures that the bodies are removed and the shapes are no longer drawn.

The logic is repeated the target, but with a considerable difference. The body is removed just like the obstacles, but the the variable describing the target is set to `nil`.

```lua
if self.target.body:isDestroyed() then
  self.target = nil
end
```

This prompts an error as the script uses `self.target` in the `update` and `render` function, and it is therefore necessary to condition the use of `self.target` to the variable storing a non-nil value.

Updating the target.

```lua
if self.target and self.target.body:isDestroyed() then
  self.target = nil
end
```

Rendering the target.

```lua
function PlayState:render()
  if self.target then
    self.target:render()
  end
end
```

**Important**: to make sure that the code removes the objects only once, be sure to reset `self.obstacles` after the table is used.

```lua
for i = #self.obstacles, 1, -1 do
  if self.obstacles[i].body:isDestroyed() then
    table.remove(self.obstacles, i)
  end
end

self.destroyedObjects = {}
```

## Visual debugging

In the play state you find a few lines of code commented out. These are used to have two variables store the label behing the objects colliding in `beginContact`, and have the `render` function print the text in the top left corner.

These instructions are useful to double-check the label of the bodies.
