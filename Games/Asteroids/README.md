# Asteroids

Recreate the popular game, taking inspiration from the Game Boy version.

## Roadmap

- feature: detect collision with asteroid; consider a size attribute (3, 2, 1) populating the game with smaller and smaller asteroids

- feature: add level based on difficulty; 1, 2, 3, starting with 2, 4, 6 asteroids respectively

- feature: add lives with a mishapen triangle

- feature: add score, with 20, 50, 100 points

- feature: add state with title, play and gameover state

- feature: register high score, starting at 35000 points

- feature: allow to teleport to somewhere random on the screen — where an asteroid is not present

- feature: allow to pause the game

- bonus: design sprite sheet for asteroids and spaceship

- bonus: add a random enemy, moving horizontally and occasionally firing toward the player; starting from a level with 4 asteroids, awarding 200 points

- bonus: add decorative elements in the background

## Notes

The game is structured as follows:

- "main.lua" works as the entry point for the application

- the "src" folder contains any additional files. "main.lua" requires every single component by including "Dependencies.lua" at the top of the document. Itself, "Dependencies.lua" is used to require every other asset.

### Object Oriented Programming

Lua doesn't have a concept of classes, nor of objects. It is however possible to implement an prototype-instance structure by using the data structure of a table.

Using `Player` as a reference:

1. initialize a table and modify its `.__index`

   ```lua
   Player = {}
   Player.__index = Player
   ```

   This will make it possible to have every instance of the `Player` table look at the table for its attributes and methods

2. specify a `:create()` function to initialize an instance variable

   ```lua
   function Player:create()
   end
   ```

   This function is called whenever you need an instance of the `Player` table.

   ```lua
   player = Player:create()
   ```

   In the body of the function, create a separate table, and link this table to the larger, "parent", `Player` table.

   ```lua
   function Player:create()
     this = {}

     setmetatable(this, self)

     return this
   end
   ```

With this setup, and once you create a player, you have then a table which looks at `Player` for any attribute or method it does not have. Say you allow to draw a triangle through the `Player:render` method.

```lua
function Player:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setLineWidth(2)
  love.graphics.polygon("line", self.x, self.y - 10, self.x + 10, self.y + 10, self.x - 10, self.y + 10)
end
```

Once you call the function from the `player` — small p — table, the script will look at prototype since the `player` table doesn't have a function with the same name.
