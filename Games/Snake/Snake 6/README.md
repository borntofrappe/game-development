# Snake 6 - Appendages

Once an item is collected by the snake, or when a certain amount of items have been collected by the same entity, the shape making up the snake should be updated. I haven't decided yet how frequently the shape should update, but it is paramount that it should. It is essential for the game to end, eventually, and the main end condition Snake is the snake colliding with itself.

My first approach is inspired by the table of items. Just like the tiles are included with a for loop, updated and rendered as needed, I can think of another class, akin to 'Appendange', which itself renders squares exactly like the snake's own shape. The idea is to have this class render a square and update its position to always follow the snake's own position, with a delay that is.

Think of it this way. You have the grid in which the snake moves.

```text
|_|_|_|_|
|_|_|_|_|
|_|s|x|_|
|_|_|_|_|
```

Think of `s` as the position of the snake, `x` as the position of the item. As the snake moves to the right to collect the item, a square should be added to the left, at a distance equal to the width of the shape shared by both.

```text
|_|_|_|_|
|_|_|_|_|
|_|a|s|_|
|_|_|_|_|
```

As the snake changes direction, perhaps going upwards, the appendage should follow.

```text
|_|_|_|_|
|_|_|s|_|
|_|_|a|_|
|_|_|_|_|
```

Going upwards, but again with a delay.

```text
|_|_|s|_|
|_|_|a|_|
|_|_|_|_|
|_|_|_|_|
```

My second approach, conjured up while discussing the first, is to actually have the `Snake` class responsible for the entirety of the snake. Appendages included. Advantage: the logic of the snake is baked in its own file. Disadvantage: having to modify `Snake.lua`, creating a table of body parts, which would lead back to the same issue: having to create a separate class. Weighing my options, and cognizant of the fact that the game ends only when the square making up the head of the snake collides with the square(s) making up its body, it is perhaps optimal to create a separate class in `Appendage.lua`. The logic also stand to reason considering the purpose of the two classes:

- `Snake.lua` is responsible for the head the snake. It moves according to the input given by the player. When It reacts to a collision with items and appendages.

- `Appendage.lua` is responsible for the body of the snake. It moves according to the movement of the head, following exactly where the head is going/has been.

## Appendage.lua

For starters, `Appendage.lua` is created much similarly to the snake class, but without an update function.

- each instance sets up the coordinates and sizes of the shape.

  ```lua
  Appendage = {
    x = 0,
    y = 0,
    width = SNAKE_WIDTH,
    height = SNAKE_HEIGHT
  }
  ```

- each appendage is then rendered through a slightly rounded square of a slightly darker hue.

  ```lua
  function Appendage:render()
    love.graphics.setColor(0.224, 0.524, 0.604, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 2)
  end
  ```

## main.lua

As to incorporate the appendages, the logic eerily replicates the items' own logic.

- create a table

  ```lua
  appendages = {}
  ```

- loop through the table in the table in `love.draw()`

  ```lua
  for k, appendage in pairs(appendages) do
    appendage:render()
  end
  ```

The only difference is where the appendages are created and added to the table, that is when the snake collides with the item(s).

```lua
if snake:collides(item) then
  -- update score and inPlay flag

  -- add an appendage
    local appendage = Appendage:init({
      x = snake.x,
      y = snake.y
    })
  table.insert(appendages, appendage)
end
```

This has the effect of adding the shape when a collision is detected, but the shape, beside being static, is rendered mid-grid, never at precise coordinates. To fix this issue I can think of a function which takes as argument the `x` and `y` coordinates of the snake and returns the exact position in the grid.

```lua
-- create a function which returns the precise cell in the grid identified by the x and y coordinate passed as input
function pointToGrid(x, y)
  -- compute the position in the grid on the basis of the cell's size
  local gridX = math.floor(x / CELL_SIZE)
  local gridY = math.floor(y / CELL_SIZE)
  -- return the grid values
  return gridX, gridY
end
```

On the basis of the precise cell, it is then possible to include the shape exactly next, or over beneath, the snake.

```lua
-- find the position in the grid of the snake
local gridX, gridY = pointToGrid(snake.x, snake.y)
```

And have the appendage shown as needed, in the grid.

```lua
local appendage = Appendage:init({
    x = gridX * CELL_SIZE,
    y = gridY * CELL_SIZE
  })
table.insert(appendages, appendage)
```

This is where a judgment call is then made with regards to where the appendage should be created. Consider the following instance

```text
| | |s|x| |
```

Again where `s` refers to the snake, `x` to the item. As it collects the item, the snake is in between the third and fourth cell and a decision must be made between spawning the appendage where the snake was or where it will be (in other words, before or on the cell making up the item).

Before:

```lua
| | |a|s| |
```

Overlapping:

```lua
| | | |as| |
```

To avoid a glitchy addition of the appendage (as the snake overlaps only partly on the item), I decided to go with the first option.

This first option doesn't require any modification as the snake collects the item from the left or from the top.

From the left:

```lua
| | |s|x| |

  correct
    |↓|
| | |a|s| |
```

From the top:

```lua
|_|_|s|_|_|
| | |x| | |

|_|_|a|_|_| ← correct
| | |s| | |
```

In both instances, the cell identified through the function is the correct one. On the other hand, when approaching the item from the right or from the bottom, the function identifies the wrong cell.

From the right:

```lua
| | |x|s| |

  incorrect
    |↓|
| | |sa| | |
```

From the bottom:


```lua
|_|_|x|_|_|
| | |s| | |

|_|_|sa|_|_| ← correct
| | | | | |
```

As the function looks for the top left corner of the snake, it identifies the cell on top of the item. To fix this, it is possible to consider the tile respectively to the right and to the bottom, when the snake is respectively going to the left and to the top.

```lua
-- ! (snake.x, snake.y) refers to the top left corner of the snake **while** it hits the item
-- when collecting the item on the left or bottom, it is then necessary to consider the preceding cell
if snake.dx < 0 then
  gridX = gridX + 1
end
if snake.dy < 0 then
  gridY = gridY + 1
end
```


## Update

While considering the implications of the current approach, I realized that the `pointToGrid()` function, while useful, it is not actually appropriate for the current game. Indeed, while the appendage is shown in a cell of the grid, it is also and immediately overlapping with the snake. If we were to implement a collision detection between the snake and the appendage (which is ultimately the test terminating the game session), the test would immediately resolve to true.

Instead of using `pointToGrid` therefore, it is necesasry to have the appendage spawn immediately to the side of the snake, **even** if said appendage would be outside of the boundaries of a single cell. The idea is to have the appendage follow the snake's head, and the guarantee that the elements will turn only upon a grid track is included when the appendage eventually moves.

Based on this considerations, the initial coordinates are given by the coordinates of the snake, but also the direction taken by the snake. Indeed, it is necessary to have the appendage spawn on the opposide side from which the item actually finds itself.

Simply put: the snake collects an item going from left to right. The appendages spawns to the left. And so forth and so on. It is possible to leverage `dx`, `dy` and the coordinate system of the rectangles to achieve this result.

```lua
--[[
  snake ← item
]]
appendage.x = snake.x - appendage.width

--[[
  item ← snake
]]
appendage.x = snake.x + snake.width

--[[
  snake
    ↓
  item
]]
appendage.y = snake.y - appendage.height


--[[
  item
    ↑
  snake
]]
appendage.y = snake.y + snake.height
```

Given that the appendage is a square, and its size is also equal to the measures of the snake, it is possible to specify the logic in the following conditional.

```lua
-- initialize the variables describing the coordinates of the appendage
local appendageX = snake.x
local appendageY = snake.y

-- modify the coordinates according to the movement of the snake and to always have the appendage spawn the opposite side the snake hits the item
if snake.dx == 0 then
  -- vertical movement
  appendageY = snake.dy > 0 and appendageY - snake.height or appendageY + snake.height
else
  -- horizontal movement
  appendageX = snake.dx > 0 and appendageX - snake.width or appendageX + snake.width
end
```
