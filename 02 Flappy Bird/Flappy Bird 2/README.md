Add bird sprite.

> assumes a _res_ folder with the necessary dependencies and assets

## Class

The game uses the `class` library as provided [on GitHub](https://github.com/vrld/hump/blob/master/class.lua). This to work with classes, a concept not available in the lua programming language.

The basic structure of a class is as follows:

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
    self.image = love.graphics.newImage('Resources/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
  end
  ```

- add a `render()` function, to draw the object with the love2d syntax

  ```lua
  function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
  end
  ```

## Image functions

A few words on the body of the `init` function. The image is loaded through `love.graphics.newImage`, similarly to the ground and the background.

`image:getWidth()` and `image:getHeight()` are two functions provided by love2d to retrieve the dimensions of the image

Finally, in `x` and `y` describes where to draw the image. By default at the center of the window.

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