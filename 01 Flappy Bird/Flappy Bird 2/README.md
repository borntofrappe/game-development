# Flappy Bird 2

_Please note:_ `main.lua` depends on a few assets in the `res` folder:

- `push.lua` and `class.lua` in `res/lib`

- a series of images in `res/graphics`

## Class

The project leans on the `class` library to work with object oriented programming:

- create a class

  ```lua
  Bird = Class{}
  ```

- add a `init()` function, to initialize an object in `main.lua`

  ```lua
  function Bird:init()
  end
  ```

  In the body of the function, specify the different fields with the `self` keyword.

  ```lua
  function Bird:init()
    self.image = love.graphics.newImage('res/graphics/bird.png')
  end
  ```

- add a `render()` function, to draw the object with the love2d syntax

  ```lua
  function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
  end
  ```

## Image functions

The image is loaded through `love.graphics.newImage`, similarly to the ground and the background.

`image:getWidth()` and `image:getHeight()` are two functions provided by love2d to retrieve the dimensions of the image

```lua

function Bird:init()
    self.image = love.graphics.newImage("res/graphics/bird.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end
```

Finally, in `x` and `y` describes where to draw the image. By default, the bird is initialized to start at the center of the window.

```lua
function Bird:init()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end
```

## main

The class library is ultimately introduced in `main.lua`. You can specify it at the top of `Bird.lua`, but in this manner the module is available in every script included from the main entry point.

```lua
Class = require 'res/lib/class'

require 'Bird'

local bird = Bird()
```

`class.lua` initializes the object by calling `init`, so it's not necessary to explicitly use the method.

Once initialized, you have access to every additional attribute and method. In `love.draw` for instance, draw the sprite using `bird:render()`

```lua
function love.draw()
    push:start()

    -- background and ground
    bird:render()

    push:finish()
end
```
