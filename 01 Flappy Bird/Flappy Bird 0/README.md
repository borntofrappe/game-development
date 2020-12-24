Draw text, include images.

> assumes a _res_ folder with the necessary dependencies and assets

## push

The library is used to project the game to a pixelated resolution.

- set up the game's window not with `love.window.setMode`, but `push:setupScreen`.

  ```lua
  function love.load()
      push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
  end
  ```

  For the desired resolution change the default filter

  ```lua
  function love.load()
      love.graphics.setDefaultFilter('nearest', 'nearest')
      push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, OPTIONS)
  end
  ```

- draw the assets between `push:start()` and `push:finish()`

  ```lua
  function love.draw()
      push:start()

      -- draw

      push:end()
  end
  ```

On top of this default, adjust the resolution when the window is resized.

```lua
function love.resize(width, height)
    push:resize(width, height)
end
```

## Images

Instead of rendering shapes with `love.graphics.circle`, or `love.graphics.rectangle`, include raster images in two steps.

- load images with `love.graphics.newImage()`

  ```lua
  local background = love.graphics.newImage('res/graphics/background.png')
  local ground = love.graphics.newImage('res/graphics/ground.png')
  ```

  The function takes as argument the path of the images.

  `local` means that the variables are accessible only within the file in which they are created (`main.lua`).

- render images with `love.graphics.draw()`

  ```lua
  love.graphics.draw(background, 0, 0)
  love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
  ```

  The function takes as argument a drawable, and the `(x, y)` coordinates

## Size

The images in the _res/graphics_ folder have a meaningul size.

- both images are `1024` wide, which is double the `VIRTUAL_WIDTH`. This allows to translate the assets horizontally and then reset the position without jumps between iterations

- the background is `288` tall, which matches the height of `VIRTUAL_HEIGHT`

- the ground is `16` tall, which explans the offset introduced in the `draw` function

## Order matters

The images are drawn on the screen in order. This means that if you print a string before the images, it would be hidden behind them.
