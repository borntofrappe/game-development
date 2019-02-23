# Pong 6

## Code

The seventh installment of updates focuses on the frames per second in which the game runs. The game is set to show this performance metric using the Love2D native function `love.timer.getFPS()`, so the update is rather minor, but it does show how it is possible to create a function for any feature, and posit even later in the codebase.

It also shows how to concatenate strings, which really makes me want to reach for template literals.

```lua
function displayFPS()
  -- detail the frame per second in the top left corner
  love.graphics.print('FPS : ' .. tostring(love.timer.getFPS()), 10, 10)
```

The two consecutive dots `..` seem to function just like a plus sign `+` in JavaScript.

Finally, the snippet also shows how to color text, through the `setColor()` function available on the `love.graphics` module.

I don't think this is intentional, but the code is also updated in the `Ball.lua` file. Here, a new function `:collides` accepts as argument a paddle and considers when the ball overlaps said paddle. There is no mention of this function in the `main.lua` file, but it might be helpful to consider the logic behind it.
