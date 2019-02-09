# Flappy Bird 4 - Anti Gravity

Anti gravity is added to offset the effects of the increasing gravity following a 'jump'. Before diving into how anti gravity is technically implemented <!-- I wasn't that far off with modifying dy --> the lecturer displays how to efficiently listen for user input and have a way to react to user input outside of the `main.lua` file. This gives the possibility to rapidly react to input directly in the Bird class.

## Custom Tables & Functions

- add an empty table to the `love.keyboard` object, in which to track the key being pressed by the player:

  ```lua
  love.keyboard.keyPressed = {}
  ```

- on `love.keypressed(key)` update the table with a field representing the key being pressed, and its value set to `true`. This allows to keep track of the key itself.

  ```lua
  love.keyboard.keyPressed[key] = true
  ```

- create a custom function to check the key that was pressed in the previous frame.

  This function is added here to the `love.keyboard` object for consistency.

  ```lua
  function love.keyboard.wasPressed(key)

  end
  ```

  It takes as argument a key and return whether this key was indeed pressed, by checking the `love.keyboard.keyPressed` table.

  ```lua
  function love.keyboard.wasPressed(key)
    return love.keyboard.keyPressed[key]
  end
  ```

  This allows to have a function which checks whether an arbitrary key has been pressed. We can then use this function outside of the `main.lua` file, in the bird class, and have its logic influence `bird:update(dt)` specifically.

  One essential addition though: as it stands, the table keeps track of the keys, setting their values to true, but never switches them back to false. In `love.update(dt)` we can account for this deficiency by re-initializing the table to an empty table.

  ```lua
  function love.update(dt)
    love.keyboard.keyPressed = {}
  end
  ```

  This way, `love.keyboard.wasPressed(key)` effectively checks a key being pressed in the lst frame.

## Anti Gravity

Leveraging the `love.keyboard.wasPressed(key)` function, we can modify `dy` directly in the bird class:

```lua
function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt

  -- check if the space key was pressed
  if love.keyboard.wasPressed('space') then
    -- set dy to be negative, effectively moving the bird upwards
    self.dy = -3
  end

  self.y = self.y + self.dy
end
```

This has the nice effect of moving the bird rapidly upwards and then have gravity once more take hold and drag it downwards.
