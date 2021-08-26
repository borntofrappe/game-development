# Object Oriented Programming

Lua does not have a built-in construct for object-oriented programming, be it a system where you create instances of a class or set up a prototype. As explained in [Programming with Lua](https://www.lua.org/pil/16.html), however, it is possible to implement a similar construct with metatables. Here I try to explain how, starting from the notes I jotted down for the project <i>Snake</i>.

## Snake

Similarly to objects, tables can have their own operations, their own methods.

```lua
Snake = { points = 0 }

function Snake.eat(food)
  Snake.points = Snake.points + food.points
end
```

Operations can work on a receiver instead of affecting the table directly.

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

To create multiple instances, objects of the same class, Lua offers metatables. Instead of objects and classes however, think in terms of a prototype, where a table looks to another table, the prototype, for operations it does not have.

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

- `player:eat({})` is actually `player.eat(player, {})`, since the colon operator works by hiding the `self` argument

- the `player` table does not have a `.eat` function, and looks to its metatable

- `Snake` a `.eat` function, which is called as `Snake:eat()` with `self` now describing the player. Effectively, `player:eat({})` executes `Snake.eat(player, {})`. The number of points is therefore increased in the instance table

### Inheritance

Inheritance goes beyond the scope of the game <i>Snake</i>, but, it is useful to continue the discussion on object-oriented programming in Lua.

The constructor function works by referencing the initial table in the `setmetatable` function.

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

It is however possible to lean the `self` argument in the constructor function itself.

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

The construct is useful to have classes inherit from one another.

```lua
HungrySnake = Snake:new()

player = HungrySnake:new()
```

In this situation `HungrySnake` inherits the methods from `Snake`. This means that `player.eat` would look for the function in the `player` table, then `HungrySnake`, then `Snake`, stopping at the first non `nil` value.

This makes it possible to redefine methods at any point in the sequence. `player` or `HungrySnake` can define a `eat` function which takes precedence over `Snake:eat`.

## Demo

The demo in this very folder creates `Particle` as an entity subject to gravity. The particle itself is position according to the input `x` and `y` arguments.

```lua
function Particle:new(x, y)
  -- set up metatable
end
```

The particle defines two additional functions:

- `update` to move the object downwards according to an arbitrary force of gravity

- `render` as an empty function.

  ```lua
  function Particle:render()
  end
  ```

  This is to avoid a potential issue in the moment a table inheriting from the particle doesn't instatiate the function itself. Indeed and from `main.lua`, every particle calls the function in `love.draw`

To highlight the concept of inheritance, the demo then introduces `SquareParticle` and `CircleParticle`. The two tables use `Particle` as a metatable by way of the `new` function.

```lua
CircleParticle = Particle:new()
SquareParticle = Particle:new()
```

This is enough to have the update and render function available.

The tables then implement their own bespoke logic. `SquareParticle` renders a rectangle with an arbitrary length for its four sides, while `CircleParticles` a circle with a given radius.

`main.lua` highlights the code by populating a table at an interval and following a press on the right or left button of the mouse cursor.
