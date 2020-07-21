Have the raster images scroll indefinitely.

> assumes a _res_ folder with the necessary dependencies and assets

## Infinite scroll

Movement is created by offsetting the position of the images used in the project. By making the ground move toward the left, it is possible to give the impression that the game moves right. By making the background move slower than the ground, it is also possible to give the appearance of increasing speed.

- define constants for the images speed, as well as the point at which to reset the horizontal position

  ```lua
  BACKGROUND_OFFSET_SPEED = 10
  BACKGROUND_LOOPING_POINT = 512
  ```

  `512` matching the `VIRTUAL_WIDTH`

- define variables to keep track of the horizontal position

  ```lua
  function love.load()
    background_offset = 0
  end
  ```

- use the variables instead of hard coded values

  ```lua
  function love.load()
    love.graphics.draw(background, -background_offset, 0)
  end
  ```

- update the variables using `dt` in `love.update()`

  ```lua
  function love.update(dt)
    background_offset = (background_offset + BACKGROUND_OFFSET_SPEED * dt) % BACKGROUND_LOOPING_POINT
  end
  ```

The same logic applies to the ground image.

## Modulo

The expression in `love.update(dt)` uses the modulo operator to reset the horizontal position. Fundamentally, you can replicate the feature with an `if` statement. It's a more expressive, but less concise syntax.

```lua
function love.update(dt)
  background_offset = background_offset + BACKGROUND_OFFSET_SPEED * dt
  if background_offset >= BACKGROUND_LOOPING_POINT then
    background_offset = background_offset - BACKGROUND_LOOPING_POINT
  end
end
```
