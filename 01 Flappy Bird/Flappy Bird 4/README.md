# Flappy Bird 4

_Please note:_ `main.lua` depends on a few assets in the `res` folder:

- `push.lua` and `class.lua` in `res/lib`

- a series of images in `res/graphics`

## Bird movement

In the previous update the bird moved downwards with an increasing `dy` value, and jumped upwards by literally modifying the `y` coordinate.

```lua
function love.keypressed(key)
  if key == 'space' then
    bird.y = bird.y - 30
    bird.dy = 0
  end
end
```

To have the movement change smoothly, the idea is to not modify `bird.y` directly, but through `dy`.

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

`dy` is added to `y`, which means a negative value moves the bird moves upwards. As `dy` is incremented continuously with `GRAVITY * dt`, the variable starts out with a negative value, and then grows to become positive and move the sprite down once more.

## User input

The goal is to here simplify the way we consider user input. This is achieved by adding a table to the `love.keyboard` module. This is provided by LOVE2D to describe keyboard interaction, but is provided as a table, which means you can specify additional attributes.

```lua
function love.load()
  love.keyboard.key_pressed = {}
end
```

Here we add an attribute, `key_pressed`, and initialize its value to an empty table.

To map user input, we then include the key being pressed in the table with a boolean describing how the key is indeed being pressed.

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
  if love.keyboard.waspressed("space") then
      self.dy = -2
  end
end
```

**Be warned**, however. This works, but the boolean values included in the table always describe that the key is being pressed. You need to re-initialize the table so that the game considers only the key pressed in the last frame.

```lua
function love.update(dt)
  -- previous code
  bird:update(dt)

  love.keyboard.key_pressed = {}
end
```

Just remember to reset the table _after_ you update the entities.
