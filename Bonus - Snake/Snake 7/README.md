# Snake 7 - Moving Appendages

## Early Updates

Before diving in how the appendages are made to move after the snake's head, a few notes on how `Appendage.lua`, `constants.lua` and `main.lua` have been slightly modified.

### Appendage Size

The width and height of the appendage class are substituted by a unique value, in `APPENDAGE_SIZE`. This not only simplifies the structure of the class, but allows to immediately check for a collision without modifying the `Snake:update(dt)` function, which checks for the `.size` of the item passed as argument.

```lua
Appendage = {
  x = 0,
  y = 0,
  size = APPENDAGE_SIZE
}
```

This streamlines the way the shape is rendered.

```lua
love.graphics.rectangle('fill', self.x, self.y, self.size, self.size, 2)
```

But as mentioned, is mainly put in place to detect a collision as follows:

```lua
-- in love.update(dt)
for k, appendage in pairs(appendages) do
  if snake:collides(appendage) then
    -- game over
  end
end
```

In light of the fact that `Snake:collides` exactly checks for the `size` of the item passes as argument.

### Fonts

This is a really minor update, but a font is included to change the default typeface.

## Real Update

Coming back to the true purpose behind the update, the game is updated to have the appendages move after the snake.

### The Idea

Here's the approach, starting with 1 single appendage for simplicity's sake:

- have the appendage spawn exactly at the edge of the snake. This has been already achieved through the previous update.

- when an appendage is created, give it the same `dx` and `dy` values of the snake. Makes sense, takes very little.

  Add the fields to the instance of the `Appendage` class.

  ```lua
  Appendage = {
    x = 0,
    y = 0,
    size = APPENDAGE_SIZE,
    dx = 0,
    dy = 0
  }
  ```

  Attribute the values when instantiating one of the class.

  ```lua
  local appendage = Appendage:init({
      x = appendageX,
      y = appendageY,
      dx = snake.dx, -- new value
      dy = snake.dy -- new value
    })
  table.insert(appendages, appendage)
  ```

  In the `Appendage:update()` function use these values to modify the coordinates of the appendage.

  ```lua
  function Appendage:update(dt)
    self.x = self.x + self.dx
    self.y = self.y + self.dy
  end
  ```

  Just remember in `main.lua` to include the logic to have the instances of the `Appendage` class update.

  ```lua
  -- update the instance(s) of the Appendage class
  for k, appendage in pairs(appendages) do
    -- update dx and dy according to the values of the snake
    appendage:update(dt)
  end
  ```

  This allows to have the appendage(s) spawn, move, but innefectively. Indeed the appendage moves in only one direction, and rapidly exceeds the boundaries of the window. To make the appendage turn, a bit more logic is required though, which is why I am separating the next point in its own section.

- as the snake turns, have the appendage follow. More on this in the next section.

### Folow Along

The appendages need to follow the head of the snake. However, the following behavior needs to occur with a delay. Here's my approach to this problem.

- have 2 new fields declared in the instance of the `Appendage` class: `counter` and `turns`.

  ```lua
  Appendage = {
    x = 0,
    y = 0,
    size = APPENDAGE_SIZE,
    dx = 0,
    dy = 0,
    turns = 0, -- new value
    counter = 0 -- new value
  }
  ```

  `counter` is used as a variable incremented each time the appendage crossed a track in the grid, whereas `turns` represents the number of tracks the appendage needs to take before changing its direction.

- include `turns` comes instantiation time, on the basis of the length of the `appendages` table.

  ```lua
  local appendage = Appendage:init({
      x = appendageX,
      y = appendageY,
      dx = snake.dx,
      dy = snake.dy,
      turns = #appendages + 1 -- new value
    })
  ```

  The first appendage is initialized to 1, the second to 2 and so forth and so on.

  The logic is then to use this variable **with** the counter to have the appendage literally wait a certain number of cells before inheriting the direction changed on the snake.

- when it is time to update the appendage, pass as argument not just `dt`, but so the `dx` and `dy` values of the snake.

  ```lua
  for k, appendage in pairs(appendages) do
    appendage:update(dt, snake.dx, snake.dy)
  end
  ```

- in the update function for the Appendage class then, beside updating the `x` and `y` coordinates of the instance, establish if the movement of the appendage is different from the one picked up by the snake.

  ```lua
  function Appendage:update(dt, dx, dy)
    if self.dx ~= dx or self.dy ~= dy then
      -- the direction has changed
    end


    self.x = self.x + self.dx
    self.y = self.y + self.dy
  end
  ```

- if so, proceed to establish the number of tracks crossed by the appendage.

  It is here where we use the two new values. `counter` is incremented when crossing any track in the grid.

  ```lua
  function Appendage:update(dt, dx, dy)
    if self.dx ~= dx or self.dy ~= dy then

      if self.x % CELL_SIZE == 0 and self.y % CELL_SIZE == 0 then
        -- a cell has been reached
        self.counter = self.counter + 1

      end
    end

    self.x = self.x + self.dx
    self.y = self.y + self.dy
  end
  ```

  `turns` is instead used in comparison to `counter`, to determine when the new direction should be picked up by the appendage.

  ```lua
  function Appendage:update(dt, dx, dy)
    if self.dx ~= dx or self.dy ~= dy then

      if self.x % CELL_SIZE == 0 and self.y % CELL_SIZE == 0 then
        self.counter = self.counter + 1

        if self.counter > self.turns then
          -- the appendage has crossed the number of cells before turning, before its position should be updated
          self.dx = dx
          self.dy = dy

          self.counter = 0
        end
      end
    end

    self.x = self.x + self.dx
    self.y = self.y + self.dy
  end
  ```

  Just remember to reset the counter, otherwise the condition would continuously resolve to true.

It is not a perfect solution. Immediately a few issues arise with multiple instances of the appendage class. Moreover, if the snake were to change direction rapidly, before an appendage has a time to update, only the new direction would be picked up. Finally, the game doesn't contemplate what happes as the snake exceeds the boundaries of the screen, and the head moves to the opposite side.

Certainly there's room for improvement.

A first approach to tackle multiple appendages and where they appear: use the length of the appendages table to describe where the shape should spawn.

For the vertical position for instance:

```lua
appendageY = snake.dy > 0 and appendageY - snake.height * (#appendages + 1) or appendageY + snake.height * (#appendages + 1)
```   
