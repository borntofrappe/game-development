# Snake 8 - Perfecting Appendages

While update 7 laid down the foundations behind the way appendages are included, as the snake collects items, it is necessary to dedicate another update to the feature. This given the shortcomings of the current approach:

1. if the snake changes direction twice in a row, and before the appendage has had a time to update its own direction, said appendage considers only the second movement. This results in the appendage effectively being separated from the head of the snake.

1. as more and more appendages are included, adding them on the basis of the head of the snake causes them to appear, even if momentarily, separate from the previous squares.

The main issue with the second point is that the appendages are always added in connection to the head of the snake. They are distant as necessary from the head, but they are better off being included in relation to the **previous** appendage. This is where the alternative approach I considered while considering how to make the snake longer might prove a better solution. If the squares are connected to the previous shapes, it makes sense to have a single class consider every piece, head and appendage alike. This makes even more sense considering the `turns` variable. If we were to include this in the snake class, from the get-go, we could have square elements incrementally updated not according to the direction of the snake, but to the key being pressed.

Putting it in simpler terms:

- the snake moves upwards;

- the player hits the right arrow key;

- the head of the snake turns immediately at the next available cell;

- the first appendage turns after two cells, following the first;

- the second one after three cells, and so forth and so on.

The first issue remains, but it might be easier to tackle it with the new implementation.

A new implementation in which a single class incorporates the squares making up the snake. Detailing the first in the random coordinates already given to the head of the snake, while giving using the previous square for every succeeding shape.

## Refactor

`main.lua` is immediately updated to incorporate a `snakes` table, to consider multiple instead of a single instance of the `Snake` class.

Other minor changes relate to:

- removing any reference to the `Appendage` class, especially the addition of appendages in case of collision with an item.

- using `SNAKE_SIZE` instead of two values in `SNAKE_WIDTH` and `SNAKE_HEIGHT`.

- using `SHAPE_OVERLAP` instead of `ITEM_OVERLAP`, and updating its value to have it refer to the entire size of the item. This effectively means a collision will be detected when the head of the snake and the item perfectly overlap one another.

- have the `randomCell()` function actually return 2 random values instead of one. This to have the `x` and `y` coordinate returned from a single function call.

In light of these changes, `constants.lua` is modified to include the mentioned constants, while `Dependencies.lua` removes its reference to the `Appendage` class.

`Snake.lua` is at first barely touched, but is nevertheless updated with more appropriate comments. Comments are also improved all across the board, to remove outdated references and unnecessary comments.

## Snake.lua

`Snake.lua` is immediately modified to incorporate the `counter` and `turns` variables. Without specifying additional instances of the snake class, the effect is not immediately visible, but the idea is to have the snake turn after the selected number of cells (0). `turns` can actually be better labeled to describe the purpose of the variable, in something akin to `turnInto`, or `delay`.

Instead of changing the direction as the square reaches a cell.

```lua
if self.x % CELL_SIZE == 0 and self.y % CELL_SIZE == 0 then
    -- check direction
    -- update dx and dy
end
```

Here is where the counter and turnInto variables come into play. Counter is incremented and the change in direction occurs only if the value exceedds the turnInto variable.

```lua
if self.x % CELL_SIZE == 0 and self.y % CELL_SIZE == 0 then
    -- increment counter
    self.counter = self.counter + 1
    -- when the counter exceeds the value described in turnInto, proceed to update the direction of the square
    if self.counter > self.turnInto then
        -- check direction
        -- update dx and dy
    end
end
```

Ultimately the chain of conditional is updated, checking the direction first and identifying the grid track later, but the logic holds true.


## main.lua

It is necessary to include new squares exactly like with the previous `Appendage` class, upon finding a collision between the snake and item. As items will be inevitably generated at random, it might occur that an item is included where the snake already is. This will be avoided through a future update, but already we can start to reduce the risk by imposing one simple condition: only the first square in the `snakes` table is responsible for a collision with the items.


```lua
-- check for a collision between the first instance of the snakes table and the items
if snakes[1]:collides(item) then
  -- update score and snakes table
end
```

Changing the color of the first square vis-a-vis those which follow might also help understanding the distinction.

The code actually takes a lot from the previous `Appendage.lua` file. The main difference is the reference not to the only instance of the `Snake` class, but the latest instance in the `snakes` table. In light of this, there's also no need to increment the distance with each successive instance. Just have the new instancce refer to the previous square's coordinate and movement.

```lua
-- ! if collision is detected

-- detail the x and y coordinate on the basis of the position and movement of the previous instance
local previousSnake = snakes[#snakes]
local snakeX = previousSnake.x
local snakeY = previousSnake.y

-- modify the coordinates according to the movement of the previous square and to always have the new square on the back of the previous one
if previousSnake.dx == 0 then
-- vertical movement
snakeY = previousSnake.dy > 0 and snakeY - CELL_SIZE or snakeY + CELL_SIZE
else
-- horizontal movement
snakeX = previousSnake.dx > 0 and snakeX - CELL_SIZE or snakeX + CELL_SIZE
end

-- define the instance of the snake
local snake = Snake:init({
-- coordinates computed on the basis of the previous square
x = snakeX,
y = snakeY,
-- speed of the previous square
dx = previousSnake.dx,
dy = previousSnake.dy,
-- turnInto considering an ever incrementing value in the length of the table
turnInto = #snakes,
-- slightly lighter hue
color = {
    r = 0.2,
    g = 0.85,
    b = 0.5
}
})
-- include the instance
table.insert(snakes, snake)
```

This is already an improvement from the previous solution. If one forgoes the choice of color, definitely to be improved, the game now includes one square after the other. Even in a situation in which the head of the snake collects an item and the other squares have yet to catch up, the new addition is included at the very end of the queue.

While the squares are added at the end however, their movement is still relative to the key being pressed, regardless of the position in the `snakes` table. The following:

```lua
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
    -- if the key matches one of the values, update the direction of the snake
    if key == value then
      for k, snake in pairs(snakes) do
        snake.direction = key
      end
    end
  end
end
```

While allowing to update each and every shape falls short of the divide introduced between the first square (the head) and the following instances (the appendages). The idea was, and still is, to have only the first square follow player input.

```lua
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
    -- if the key matches one of the values, update the direction of the head of the snake
    if key == value then
      snake[1].direction = key -- changes
    end
  end
end
```

While the remaining instances need to pick up from the preceding one. This makes the `turnInto` variable rather less useful. If each square is updated in connection to the previous one, it is indeed possible to change its direction upon finding the first cell in the grid. There's no need to consider the number of cells that need to be crossed before turning.

The challenge is then how to have the squares follow one another, which brings me to another re-write/refactor of the existing code.

## hasTurned

Here's the new idea:

- instead of `turnsInto`, include a new field in `hasTurned`. This is used as a boolean, but to describe when a square has indeed changed in direction.

```lua
Snake = {
  x = 0,
  y = 0,
  size = SNAKE_SIZE,
  dx = 0,
  dy = 0,
  direction = nil,
  hasTurned = false, -- addition
  color = {
    r = 1,
    g = 1,
    b = 1
  }
}
```

- instead of switching `self.direction` to nil when the square changes in direction (as to avoid continuously changing the movement according to this value), switch `self.hasTurned` to true.

```lua
if self.direction then
    -- when reaching the first track in the grid
  if self.x % CELL_SIZE == 0 and self.y % CELL_SIZE == 0 then
    -- retrieve the direction to avoid typying self.direction every time
    local direction = self.direction
    -- change dx and dy according to the actual value of direction
    if direction == 'up' then
      self.dy = -SNAKE_SPEED
      self.dx = 0
    elseif direction == 'down' then
      self.dy = SNAKE_SPEED
      self.dx = 0
    elseif direction == 'right' then
      self.dy = 0
      self.dx = SNAKE_SPEED
    elseif direction == 'left' then
      self.dy = 0
      self.dx = -SNAKE_SPEED
    end

    self.hasTurned = true -- addition
  end
end
```

- in `main.lua`, loop through the table of snakes.

```lua
for i = 1, #snakes do
end
```

The loop making use of `pairs` is not chosen to have a variable referring to the index in the table, in `i`.

- when looping through the instances, consider the `hasTurned` value of each one. If true, switch both `hasTurned` and `direction` on the instance to false. The first one to avoid checking the condition continuously, the second one to avoid updating the movement through `snake:update` (remember that `self.direction = nil` was removed in favor of `self.hasTurned = true`).

```lua
for i = 1, #snakes do

  if snakes[i].hasTurned then
    snakes[i].hasTurned = false
    snakes[i].direction = nil
  end
end
```

- in addition to switching the flag to false, and **before** switching the direction to `nil`, give the direction of the square to the instance which follows. Since this means referring to the value of a later instance, it is necessary to avoid running this logic for the very last shape in the table, which is is why the change in direction is prematurely attributed on the penultimate instance.

```lua
for i = 1, #snakes do
  if snakes[i].hasTurned then
    snakes[i].hasTurned = false
    if i < #snakes then
      snakes[i + 1].direction = snakes[i].direction
    end
    snakes[i].direction = nil
  end
end
```

It might seem like a convoluted solution, but it can be put simply in the following sequence of events:

- the first instance of the `snakes` table changes in direction following the arrow keys; its `hasTurned` flag is switched to true;

- while looping through the table, the flag of the first instance is set back to `nil`, alongside the variable referring to its direction;

- before setting the direction to `nil`, the value is attributed to the instance which follows;

- the second instance of the table has now a direction different from `nil`, which means that its direction changes following the direction of the preceding shape.

- lather, rinse, repeat. One at a time, each instance is updated with the preceding direction's value, until the last one which receives the direction and, upon turning, switches both variables to `nil`.

Following the refactor, this solution fully considers the second bullet point: appendages are added at the end of the queue **and** their movement is influenced by the preceding instance.

The first issue however remains: switch rapidly direction twice in a row and the appendage inherits only the last value. This is because the instances pick up the value immediately as the `hasTurned` boolean is switched to true. Since this change occurs as the shape reaches a cell, the instancecs which follow don't have the time to update before another change is detected.

<!-- TODO: figure out how to avoid the glitchy behavior following two rapid changes in direction -->
