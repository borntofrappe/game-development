# Flappy Bird 3 - Gravity

Gravity is implemented by adding a value to the vertical offset of the bird.

Inspired by the solution implemented for Pong, and specifically the ball, we start by adding a `dy` field to the bird class and then update it in an `Bird:update(dt)` function, which gets called in the `love.update` function of the game and takes as argument delta time.

```lua
function Bird:init()
  -- beside the previous fields add a dy value for the vertical movement
  self.dy = 0
end

function Bird:update(dt)
  -- update bird.y according to bird.dy
end
```

Unlike the solution for Pong however, the offset is not updated by a constant amount, but to emulate a field of gravity it is updated by an increasing measure. This is achieved by defining a variable, such as `GRAVITY` and multiply it by the delta time argument. Given the nature of `dt`, we are ensured that this measure increases over time, and we can therefore rely on an increasing vertical offset.

```lua
GRAVITY = 10

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy
end
```

This forces the critter to bolt straight down toward the bottom of the window, once the function gets called in `love.update`:

```lua
function love.update(dt)
  -- background and ground offset

  -- critter movement
  if(bird.y < VIRTUAL_HEIGHT - bird.height - 16) then
    bird:update(dt)
  end
end
```

A simple if statement is created just to apply the gravity as long as the critter is above the ground level.

This works, but the critter gets stuck at the very bottom of the window. Even if we were to update the vertical coordinate according to an arbitrary value:

```lua
function love.keypressed(key)
  if key == 'space' then
    bird.y = bird.y -30
  end
end
```

The offset would be extremely temporary, as `dy` reaches greater and greater values. It is necessary to find a way to reset, so to speak, the strength given by the gravity. This might be a rough first attempt, but setting `dy` back to 0 actually does achieve a modicum of success.

```lua
function love.keypressed(key)
  if key == 'space' then
    bird.y = bird.y -30
    bird.dy = 0
  end
end
```

Indeed, if we consider how `dy` gets updated: `self.dy = self.dy + GRAVITY * dt` it is `self.dy` which creates creater and greater values. `dt` is not constant, but represents the frame rate of the game, and is generally around a fixed number of frame per seconds.

Of course this solution is quite approximative. The jump upwards is linear. The bird goes up and down without changing inclination, as one would expect. But already it is possible to see how to affect the vertical offset, both ways and with increasing strength.
