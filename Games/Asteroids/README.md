# Asteroids

Recreate the popular game **Asteroid**, using the shape functions from the `love.graphics` module.

## Roadmap

- gameplay:

  - award a life every 10k points

  - allow to move in the victory state

  - remove text in the pause and victory state

  - keep updating the asteroids in the gameover state

- bonus: design and include a random enemy, moving horizontally and occasionally firing toward the player; starting from a level with 4 asteroids; awarding 200 points

- bonus: add decorative elements in the background

- docs: add notes on object oriented programming and object inheritance, considering how the state machine is implemented

## Notes

The game is structured as follows:

- "main.lua" works as the entry point for the application

- the "src" folder contains any additional files. "main.lua" requires every single component by including "Dependencies.lua" at the top of the document. Itself, "Dependencies.lua" is used to require every other asset

- the "res" folder provides audio files and the font used throughout the application. The font is [Audiowide](https://fonts.google.com/specimen/Audiowide), while the audio files are created with Bfxr.

The folder also describes a spritesheet I designed with GIMP. Ultimately, I decided not to use the raster images, and rely on the shapes provided by Love2D instead.

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
