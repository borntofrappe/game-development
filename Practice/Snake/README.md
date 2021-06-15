# Snake

Recreate the popular game snake with a blocky design inspired by the display of a Nokia phone.

![Snake in a few frames](https://github.com/borntofrappe/game-development/blob/master/Showcase/snake.gif)

## Project structure

The `res` folder includes two sound files and a font. The most important assets are however the `.lua` scripts included at root level. The idea is to create two classes with `Snake.lua` and `Food.lua`, considering the object-oriented logic built in the lua language.

## Object-oriented programming

Programming in Lua introduces [object-oriented programming](https://www.lua.org/pil/16.html) by explaining how tables are like objects in several ways.

Tables can have their own operations, their own methods.

```lua
Snake = { points = 0 }
function Snake.eat(food)
  Snake.points = Snake.points + food.points
end
```

Operations can work on the receiver instead of affecting the table directly

```lua
Snake = { points = 0 }
function Snake.eat(self, food)
  self.points = self.points + food.points
end
```

The colon operator allows to hide the `self` argument.

```lua
Snake = { points = 0 }
function Snake:eat(food)
  self.points = self.points + food.points
end
```

To create multiple instances, objects of the same class, Lua offers metatables. Instead of objects and classes however, think in terms of a prototype, where tables look to other tables (the prototype) for operations it does not have.

```lua
Snake = {}

player = {}
setmetatable(player, {__index = Snake})
```

`player` inherits the properties and methods from the `Snake` table.

With a constructor function.

```lua
Snake = {}

function Snake:new()
  local snake = {
    points = 0
  }

  setmetatable(snake, {__index = Snake})
  return snake
end
```

When you create a table in this manner.

```lua
player = Snake:new()
```

`Snake` is the metatable.

Say you have a function on the prototype.

```lua
function Snake:eat(food)
  self.points = self.points + food.points
end
```

When you call the function from the instance.

```lua
player:eat({ points =  20 })
```

The process is as follows:

- `player:eat({})` is actually `player.eat(player, {})`

- `player` does not have a `.eat` function, and looks to the metatable

- `Snake:eat()` is called with the `player` as `self`, effectively executing `Snake.eat(player, {})`. The number of points is therefore increased in the instance table

### Inheritance

_Please note:_ while beyond the scope of the game, it is useful to continue the discussion on object-oriented programming considering the way lua manages [inheritance](https://www.lua.org/pil/16.2.html).

While the constructor function works setting the metatable to an initial table.

```lua
Snake = {}

function Snake:new()
  local snake = {
    points = 0
  }

  setmetatable(snake, {__index = Snake})
  return snake
end
```

It is possible to lean the `self` argument in the constructor function itself.

```lua
Snake = {}

function Snake:new()
  local snake = {
    points = 0
  }

  self.__index = self
  setmetatable(snake, self)
  return snake
end
```

Here `self` refers to `Snake`, which is useful to have classes inherit from one another.

```lua
HungrySnake = Snake:new()

player = HungrySnake:new()
```

In this situation `HungrySnake` inherits the methods from `Snake`. This means that `player.eat` would look for the function in the `player` table, then `HungrySnake`, then `Snake`, stopping at the first non `nil` value.

This makes it possible to redefine methods at any point in the sequence. `player` or `HungrySnake` can define a `eat` function which takes precedence over `Snake:eat`

## State

State is managed with a string, holding one of three possible values: waiting, playing, gameover:

- from waiting to playing by pressing one of the arrow keys

- from playing to gameover by having the snake eat itself

- from gameover back to waiting by pressing the enter key

## Grid

The window is split in two main areas, with the top portion devoted to the score and the bottom section describing the actual game. `MARGIN_TOP`, `PADDING_X` and `PADDING_Y` are included to simplify the whitespace for each area, but considering the game, the most important variables are `COLUMNS`. `ROWS` and `CELL_SIZE`.

```lua
COLUMNS = 24
ROWS = 16
CELL_SIZE = 20
```

These three constants dictate the size of the playing area.

```lua
GRID_WIDTH = CELL_SIZE * COLUMNS
GRID_HEIGHT = CELL_SIZE * ROWS
```

It is only by knowing these values that the script finally computes the size of the overall window.

The window itself is then sized relative to these values.

```lua
WINDOW_WIDTH = GRID_WIDTH + PADDING_X * 2
WINDOW_HEIGHT = GRID_HEIGHT + MARGIN_TOP + PADDING_Y * 2
```

_Please note:_ the size of the window is useful only in `main.lua`, which explains why in the script the constants are made into local variables.

In `love.draw` the main script renders the score and then translates the entire screen to render the snake and food.

```lua
function love.draw()
  love.graphics.translate(PADDING_X, MARGIN_TOP + PADDING_Y)
  snake:render()
  food:render()
end
```

`displayGrid` is defined to illustrate how this translation works by layering a series of grid lines. Uncomment the function to see how the snake and food are constrained to the selected area.

```lua
function love.draw()
  love.graphics.translate(PADDING_X, MARGIN_TOP + PADDING_Y)
  -- game assets

  -- displayGrid()
end
```

## Update

The idea is to update the game at an interval.

```lua
local INTERVAL = 0.2
```

In `love.update(dt)` a counter variable is increased so that the snake moves when crossing the desired threshold.

```lua
function love.update(dt)
  if state == "playing" then
    time = time + dt
    if time >= INTERVAL then
      time = time % INTERVAL

      -- update snake
    end
  end
end
```

Note that the way the snake is updated starts by considering an overlap between the snake and its body.

```lua
if snake:eatsItself() then
  state = "gameover"
end
```

If the snake is not eating itself, so to speak, `snake:update` is called to move the player.

```lua
if snake:eatsItself() then
  -- ...
else
  snake:update()
end
```

Here the game also considers whether the snake is on top of the food, in which instance the game is updated to increase the number of points and spawn a new instance of food.

```lua
if snake:collides(food) then
  snake:eat(food)
  food = Food:new()
end
```

## Snake

At first, `Snake.lua` is a rather simple class, moving a rectangle in the grid by changing its column and row.

```lua
local snake = {
  column = math.random(COLUMNS) - 1,
  row = math.random(ROWS) - 1,
}
```

`points` is also included to enumerate the score and the value is increased when the snake overlaps with the food.

```lua
local snake = {
  points = 0,
}
```

What complicates the logic is the fact that, when the snake eats a piece of food, it is necessary to elongate the animal, to grow its body. The game needs to then update the shapes in sequence.

### Movement

Without considering the body, the snake is updated with two variables, describing the offset relative to the column and row.

```lua
local snake = {
  dcolumn = 0,
  drow = 0,
}
```

`dcolumn` and `drow` are then updated from `main.lua`, considering the arrow key being pressed.

```lua
if key == "right" or key == "left" or key == "up" or key == "down" then
  snake:turn(key)
end
```

`Snake:turn` then updates the movement variable as needed.

```lua
function Snake:turn(direction)
  if direction == "up" then
    self.dcolumn = 0
    self.drow = -1

  -- ... other keys
  end
end
```

This setup is all that is necessary to move the head of the snake. In the update function, the column and row are incremented or decremented by the newly assigned value.

```lua
self.column = (self.column + self.dcolumn) % COLUMNS
self.row = (self.row + self.drow) % ROWS
```

The modulo operator allows to have the snake appear in the opposite direction of the grid.

As mentioned, however, the movement needs to consider the body of the snake.

### Body

The sections of the body are included in a table.

```lua
function Snake:new()
  local snake = {
    -- ... other elements
    body = {}
  }
end
```

Each item of the table describes the location of the part with a column and row.

```lua
function Snake:eat(food)
  table.insert(
    self.body,
    {
      column = self.column,
      row = self.row,
    }
  )
end
```

It would be possible to define a separate, dedicated class, but consider the feature as a goal of a later refactor.

The chosen values mean the body spawn in the position of the head of the snake. To move the element, I decided to include two additional variables: `delay` and `isMoving`. The goal is to literally delay the movement by a series of updates, matching the number of elements included in `self.body`.

```lua
{
  delay = #self.body + 1,
  isMoving = false,
}
```

With each iteration of the `Snake:update` function, `delay` is decremented and `isMoving` is used as a controlling variable, switched to `true` when the delay reaches `0`.

```lua
function Snake:update(dt)
  for k, section in pairs(self.body) do
    if not section.isMoving then
      section.delay = section.delay - 1
      if section.delay == 0 then
        section.isMoving = true
      end
    end
  end
end
```

It would be possible to just consider whether `delay` is equal to zero, but I chose a booelan to be more expressive.

The moving parts then are updated _in reverse_, and before the head of the snake. The idea is to loop `self.body` backwards, to have each section move in the position of the section included one step earlier.

```lua
for i = #self.body, 1, -1 do
  if self.body[i].isMoving then
    -- update column and row
  end
end
```

Every section up to the second one follows this logic. For the very first item of the table, then the idea is to use the column and row of the head of the snake. Again, before these two values are actually updated.

```lua
if i == 1 then
  self.body[i].column = self.column
  self.body[i].row = self.row
else
  self.body[i].column = self.body[i - 1].column
  self.body[i].row = self.body[i - 1].row
end
```

_Please note:_ the boolean variable describing the movement of the body is also included to alter the appearance of the sections.

_Please note:_ the sections of the body also include a `padding` to have the rectangle slightly smaller than the head of the snake. This is a minor choice regarding the design of the game.

### Overlap

To consider if the snake eats itself, `Snake:eatsItself` loops through the sections of the body and considers whether the elements overlap with the head of the snake, with the main `self.column` and `self.row` value.

It is not possible to check the coordinates as-is, however, seems the sections of the body spawn exactly where the snake is, moving with a delay. To this end, the script considers where the snake _will be_ according to the `dcolumn` and `drow` variable.

```lua
if i == 1 then
  if
    (self.column + self.dcolumn) % COLUMNS == self.body[1].column and
      (self.row + self.drow) % ROWS == self.body[1].row
    then
    return true
  end
end
```

This includes an annoying trait, however, when the snake is moving toward a piece of its body which will no longer create a collision once the sequence is updated. To fix this, the game consider a collision between the head of the snake up to the penultimate portion of its body.

```lua
if i == 1 then
  if
    (self.column + self.dcolumn) % COLUMNS == self.body[math.max(1, i - 1)].column and
      (self.row + self.drow) % ROWS == self.body[math.max(1, i - 1)].row
    then
    return true
  end
end
```

This works as in the parts of the body are essentially forced to match the coordinates of the previous segment.

## Food

`Food.lua` is perhaps the most straightforward of the two classes. Its only job is to render a rectangle in the grid.

```lua
local food = {
  column = math.random(COLUMNS) - 1,
  row = math.random(ROWS) - 1,
}
```

The table is updated to include the number of points, which is picked up by the `Snake:eat` function, and also an arbitrary value for padding, which allows to have the rectangle smaller than the actual grid cell.

```lua
local food = {
  -- other properties
  points = POINTS,
  padding = CELL_SIZE * 0.2
}
```
