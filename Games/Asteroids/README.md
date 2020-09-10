# Asteroids

Recreate the popular game, taking inspiration from the Game Boy version, but starting with polygons instead of a spritesheet depicting the elements of the game.

## Project structure

In its first rendition, the game is structured as follows:

- "main.lua" represents the entry point for the application

- the "src" folder contains additional files. These describe the components of the game, as well as "Dependencies.lua", which includes every single file and is required by "main.lua".

## Object Oriented Programming

The game allows to experiment with object oriented programming in the context of the Lua language. Looking at "Player.lua", the idea is to create a table from which other tables are instantiated.

It is essential to:

1. modify `.__index` so that the instance looks at the "parent" table for variables and functions

   ```lua
   Player = {}
   Player.__index = Player
   ```

2. in a `:create()` function, initialize a table and set its metatable to refer to the same table

   ```lua
   function Player:create()
     this = {}

     setmetatable(this, self)
   end
   ```

   By returning `this`, the function is finally able to create an instance variable.

   ```lua
   return this
   ```

With this setup, and once you create a player, you have then access to the variables and functions you add on `Player`. For instance, once `Player` defines a function to draw a triangle.

```lua
function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", self.x, self.y - 10, self.x + 10, self.y + 10, self.x - 10, self.y + 10)
end
```

An instance variable of `Player` is equipped with the same function.

```lua
function love.load()
  player = Player:create()
end

function love.draw()
  player:render()
end
```
