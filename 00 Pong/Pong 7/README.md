# Pong 7

_Please note:_ `main.lua` depends on `push.lua`, `class.lua` and `font.ttf` being available in the same folder

## displayFPS

Love2D offers a `love.timer.getFPS()` to display the frames per seconds at which the game runs.

Instead of using `getFPS` directly in `love.draw` however, the lecturer separates the utility in a function. This is out of convenience, to encapsulate the functionality and have the code in `love.draw` be more declarative.

```lua
function love.draw()
  displayFPS()
end
```

In `displayFPS`, the frames per second are drawn in the top left corner and using the default font.

```lua
function displayFPS()
  love.graphics.setFont(appFont)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
```

For the color, the default value is updated using `love.graphics.setColor` describing a green hue.

```lua
love.graphics.setColor(0, 1, 0)
```

Note that where you call the function in this instance matters. Every time `love.draw` runs the color is reset to white, but once you execute `setColor` the value is repeated for any graphics which follow. If you were to call the function before painting the game everything would be tinted green.
