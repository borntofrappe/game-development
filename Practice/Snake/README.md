# Snake

Recreate the popular game snake with a blocky design inspired by the display of a Nokia phone.

## Project structure

Classes strictly necessary for the most basic game:

- snake

- food

## Object-oriented programming

Tables are like objects in several ways.

### Operations

Tables can have their own operations, their own methods.

```lua
Snake = { points = 0 }
function Snake.eat(food)
  Snake.points = Snake.points + food.points
end
```

### Receiver

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
