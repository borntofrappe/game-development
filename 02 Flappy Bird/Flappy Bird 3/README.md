Include gravity.

> assumes a _res_ folder with the necessary dependencies and assets

## Bird movement

Gravity is implemented by adding a value to the vertical offset of the bird.

In `Bird.lua`, initialize a variable to keep track of how much to move the bird vertically.

```lua
function Bird:init()
  --previous attributes

  self.dy = 0
end
```

In Pong, you'd use `dy` to increment/decrement the matching coordinate.

```lua
function Ball:update(dt)
  self.y = self.y + self.dy
end
```

In this game, and in order to fake gravity, you also modify `dy`

```lua
GRAVITY = 5

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy
end
```

`dy` grows as the game continues, which means that the sprite moves faster toward the bottom.

This is already enough to move the sprite down and at an increasing speed, but it's necessary to adjust the movement:

- stop the bird at the bottom of the window

- move the bird in the opposite direction following user interaction

With regards to the last point, it is also necessary to reset `dy` as the bird "jumps" back up. Fail to reset this value and the bird plummets with an ever increasing speed toward the bottom.

## main

To stop the bird when it reaches the bottom of the window, call the `:update` method only when the vertical coordinates is within a desired threshold.

```lua
function love.update(dt)
  if bird.y < VIRTUAL_HEIGHT - bird.height - 16 then
      bird:update(dt)
  end
end
```

`16` being the height of the sprite making up the ground.

To move the bird in the opposite direction, listen to key presses with `love.keypressed`.

```lua
function love.keypressed(key)
  if key == 'space' then
    bird.y = bird.y - 30
    bird.dy = 0
  end
end
```

As mentioned, reset `dy` to have the gravity impact the sprite from `0`.
