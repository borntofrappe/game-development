Include anti-gravity and map user input.

> assumes a _res_ folder with the necessary dependencies and assets

## Bird movement

In the previous update the bird moves downwards with an increasing `dy` value. When hitting the spacebar however, the jump is linear.

```lua
function love.keypressed(key)
  if key == 'space' then
    bird.y = bird.y - 30
    bird.dy = 0
  end
end
```

To fix this, do not modify `bird.y` directly. Instead, modify `dy` to have a negative value.

```lua
function love.keypressed(key)
  if key == 'space' then
    bird.dy = -2
  end
end
```

Looking back at the bird class.

```lua
function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
end
```

`dy` is added to `y`, which means that the bird moves upwards, and `dy` is incremented continuously using `GRAVITY * dt`. This means the variable starts out with a negative value, and then grows to become positive and move the sprite down once more.

## User input

The goal is to here simplify the way we consider user input. This is achieved by adding a table to the `love.keyboard`. This is provided by love2d to describe keyboard interaction, but is provided as a table, which means you can specify additional attributes by working directly on the entity.

```lua
function love.load()
  love.keyboard.key_pressed = {}
end
```

Here we add an attribute, `key_pressed`, and initialize its value to an empty table.

To map user input, we then include the key being pressed in the table, with a boolean describing how the key is indeed being pressed.

```lua
function love.keypressed(key)
    love.keyboard.key_pressed[key] = true
end
```

Finally, we add a function to `love.keyboard`, to describe if a particular key is pressed.

```lua
function love.keyboard.waspressed(key)
    return love.keyboard.key_pressed[key]
end
```

You can check the `key_pressed` table directly, but this makes for a more declarative approach.

You now have modified `love.keyboard` to include:

1. a table describing the key being pressed

2. a function to check that a particular key was pressed

This ultimately means you can finally modify the movement of the bird directly in the `Bird` class.

```lua
function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy

end
```

**Be warned** however. This works, but the boolean values included in the table always describe that the key is being pressed. You need to re-initialize the table so that the game considers only the key pressed in the last frame.

```lua
function love.update(dt)
  -- previous code

  love.keyboard.key_pressed = {}
end
```
