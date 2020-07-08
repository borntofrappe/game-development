Here you display how fast the game runs.

**requires push.lua, font.ttf, class.lua**

## Code

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
