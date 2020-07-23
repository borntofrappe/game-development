Add touch controls.

> assumes a _res_ folder with the necessary dependencies and assets

## love.mousepressed

The idea is to have the bird jump whenever a click is registered in the boundaries of its bounding box.

`love.mousepressed` allows to retrieve the `x` and `y` coordinates of a touch, but it is necessary to have these values in `Bird.lua`, so to have the bird jump when the coordinates overlap with the bird itself.

Similarly to the approach introduced for key presses, the idea is to modify the function provided by love2d, and to include a table in the `love.mouse` global.

```lua
function love.load()
  love.mouse.coor = {
    ['x'] = 0,
    ['y'] = 0
  }
end
```

Since the game sets up a projection with the `push` library, however, the actual coordinates do not match the values described in the game. `push` provides the function `toGame` to return the desired `x` and `y` values.

```lua
function love.mousepressed(x, y)
  love.mouse.coor['x'], love.mouse.coor['y'] = push:toGame(x, y)
end

function love.update(dt)
  love.mouse.coor['x'], love.mouse.coor['y'] = 0, 0
end
```

In `Bird.lua` then, you can check the overlap and react accordingly.

```lua
function love.update(dt)
  if love.mouse.coor['x'] > self.x and love.mouse.coor['x'] < self.x + self.width then
    if love.mouse.coor['y'] > self.y and love.mouse.coor['y'] < self.y + self.height then
      sounds['jump']:play()
      self.dy = -2
    end
  end
end

```
