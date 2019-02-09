# Flappy Bird 7 - Collision

Once the pipes are rendered and scrolled, it is necessary to assess a collision between the bird character and the pipes.

## main.lua

To start out, create a boolean to assess a collision:

```lua
local scrolling = true
```

The idea is to use this variable to continue the game or stop it. The update logic developed so far is therefore used conditional to this flag being true.

```lua
function love.update(dt)
if scrolling then
  -- scroll

  end

  -- reset the table (keeps taking input)
end
```

This covers how to stop/play the game based on the boolean, but it is necessary to change this boolean according to its meaning.

In `update(dt)` and in the loop updating the pairs check for a colliision and set the boolean appropriately to false.

```lua
for k, pair in pairs(pipePairs) do
  pair:update(dt)
  -- check for collision on the individual pipes
  for l, pipe in pairs(pair.pipes) do
    if bird:collides(pipe) then
      scrolling = false
      end
  end

end
```

The `bird:collides` function is the key of the conditional, but it is important to remark how the for loop is nested in the previous one. In the loop updating the pairs, loop through the pairs and check for a collision between the bird and the individual pipes.

## bird.lua

Collision is detected through `bird:collides` it takes as argument a pipe and returns true if a collision is detected. This works similarly to the detection implemented in pong, using AABB (axis aligned bounding box). Instead of copying the solution, go through the code implented in pong for `ball:collides` and try to replicate the feat.

```lua
-- in the :collides() function checks if the bird collides with the pipe passed as argument
function Bird:collides(pipe)
  -- return false if the bird cannot be overlapping with the pipe, else return true
  --[[
    horizontally
    the coordinate of the bird is past the coordinate of the pipe + the pipe's width
    or
    the coordinate of the bird is before the coordinate of the pipe - the bird's width
  ]]
  if self.x > pipe.x + pipe.width or self.x < pipe.x - self.width then
    return false
  end
  --[[
    vertically
    the coordinate of the bird is more than the coordinate of the pipe + the pipe's height (lower in the graphic)
    or
    the coordinate of the bird is less than the coordinate of the pipe - the bird's height
  ]]
  if self.y > pipe.y + pipe.height or self.y < pipe.y - self.height then
    return false
  end

  -- are overlapping
  return true
end
```

Just a note on the actual implementation of the AABB test. The lecturer introduces a few fixed values to reduce the size of the bounding box. This is meant to give a bit of leeway to the players, to allow for small overlaps and detect collision less often (more generously one could say).
