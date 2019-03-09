# Snake 1 - Moving Square

To have the game react to the arrow (or awsd) keys and update the position of the square, the update introduces the last main function provided by **Love2D**, `love.update(dt)`.

## dx and dy

The `x` and `y` coordinate are modified indirectly and through `dx` and `dy` variables.

These are included in the table describing the snake.

```lua
snake = {
  x = (math.random(WINDOW_WIDTH / SNAKE_WIDTH) - 1) * SNAKE_WIDTH,
  y = (math.random(WINDOW_HEIGHT / SNAKE_HEIGHT) - 1) * SNAKE_HEIGHT,
  dx = 0,
  dy = 0,
  width = SNAKE_WIDTH,
  height = SNAKE_HEIGHT
}
```

And are modified in `love.keypressed()` using the arrow keys to change the direction positively or negatively, according to the purpose given to each key.

```lua
function love.keypressed(key)
  if key == 'up' then
    snake.dy = -SNAKE_SPEED
  elseif key == 'down' then
    snake.dy = SNAKE_SPEED
  elseif key == 'right' then
    snake.dx = SNAKE_SPEED
  elseif key == 'left' then
    snake.dx = -SNAKE_SPEED
  end
end
```

In `love.update(dt)` finally, their values is included in the `x` and `y` coordinate of the square.

```lua
function love.update(dt)
  snake.y = snake.y + snake.dy
end
```

This means there is no need to modify the `love.draw` function to have the square moved. Every time the game refreshes, its coordinate is updated and the square is drawn at the modified `x` and `y` values.

## Moving Snake

As it stand, the square does move following the arrow keys. The snake it should represent needs to move in one direction at a time though. This is rapidly fixed by setting the `d` value which is not updated to `0`.

```lua
function love.keypressed(key)
  if key == 'up' then
    snake.dy = -SNAKE_SPEED
    snake.dx = 0
  elseif key == 'down' then
    snake.dy = SNAKE_SPEED
    snake.dx = 0
  elseif key == 'right' then
    snake.dx = SNAKE_SPEED
    snake.dy = 0
  elseif key == 'left' then
    snake.dx = -SNAKE_SPEED
    snake.dy = 0
  end
end
```

In addition to the uni-directional movement, the game needs to consider when the shape leaves the edges of the screen. The logic is to here have the square spawn the opposite direction from which it came.

```lua
function love.update(dt)
  -- update the position of the square
  snake.x = snake.x + snake.dx
  snake.y = snake.y + snake.dy

  -- if the square exceeds the boundaties of the screen, have it spawn the opposite way from which it came
  if snake.x < 0 - snake.width then
    snake.x = WINDOW_WIDTH
  end

  if snake.x > WINDOW_WIDTH then
    snake.x = 0 - snake.width
  end

  if snake.y < 0 - snake.height then
    snake.y = WINDOW_HEIGHT
  end

  if snake.y > WINDOW_HEIGHT then
    snake.y = 0 - snake.height
  end

end
```

One additional change: when pressing the escape key, the game is prematurely terminated, to avoid having to manually close the window.

```lua
if key == 'escape' then
  love.event.quit()
end
```

## Grid Movement

As mentioned in update 0, the square is positioned as in a grid. The idea is to move the shape only within the tracks provided by this grid, which means that the position of the needs to be updated only when reaching one of the tracks.

To achieve this feat, the `love.keypressed(key)` function proves to be rather inflexible. Taking inspiration from the course on game development, the new approach is to:

- create a table in which to add the keys being pressed;

  ```lua
  arrowKeys = {}
  ```

- populate the table only with arrow keys;

  ```lua
  -- react to a key press on a selection of keys
  function love.keypressed(key)
    -- ARROW KEYS
    -- create a table of acceptable keys
    local keys = {
      'up',
      'right',
      'down',
      'left'
    }
    -- loop through the table of acceptable keys
    for k, value in pairs(keys) do
      -- if the key matches one of the values, add the key to the prescribed table
      if key == value then
        table.insert(arrowKeys, key)
      end
    end

  end
  ```

- when reaching a track of the grid, use the last arrow key to change the direction of the square;

  ```lua
  -- update the position of the square when reaching a track in the grid
  if snake.x % SNAKE_WIDTH == 0 and snake.y % SNAKE_HEIGHT == 0 then
    -- look at the arrowKeys table, specifically if it includes more than one item
    if #arrowKeys > 0 then
      -- retrieve the last item from the table
      local key = arrowKeys[#arrowKeys]
      -- change dx and dy according to the actual value of the last key
      if key == 'up' then
        snake.dy = -SNAKE_SPEED
        snake.dx = 0
      elseif key == 'down' then
        snake.dy = SNAKE_SPEED
        snake.dx = 0
      elseif key == 'right' then
        snake.dy = 0
        snake.dx = SNAKE_SPEED
      elseif key == 'left' then
        snake.dy = 0
        snake.dx = -SNAKE_SPEED
      end
    end
  end
  ```

- empty the table. This last is useful to upadte the direction only when another arrow key is pressed.

  ```lua
  arrowKeys = {}
  ```

To highlight the change, a grid is rendered below the square.

```lua
for x = 1, WINDOW_WIDTH / SNAKE_WIDTH do
  for y = 1, WINDOW_HEIGHT / SNAKE_HEIGHT do
    love.graphics.rectangle('line', (x - 1) * SNAKE_WIDTH, (y - 1) * SNAKE_HEIGHT, SNAKE_WIDTH, SNAKE_HEIGHT)
  end
end
```

By toggling the opacity through the last value of `love.graphics.setColor` it is possible to have the square move and show the track if need be,
