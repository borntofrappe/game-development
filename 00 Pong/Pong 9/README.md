# Pong 9

_Please note:_ `main.lua` depends on `push.lua`, `class.lua` and `font.ttf` being available in the same folder

## Score

Instead of using two variables in the `load` function, the `Paddle` class is updated with an additional field

```lua
function Paddle:init(x, y, width, height)
  self.points = 0
end
```

Instead of updating the variables then, the number of points is adjusted when the ball exceeds the left or right edge.

```lua
if ball.x <= 0 then
  player2:score()
end

if ball.x >= VIRTUAL_WIDTH then
  player1:score()
end
```

The `:score` function is added to increment the number of points.

```lua
function Paddle:score()
  self.points = self.points + 1
end
```

The number of points is then shown in the `draw` function.

```lua
love.graphics.printf(
  tostring(player1.points),
  -- size and position
)

love.graphics.printf(
  tostring(player2.points),
  -- size and position
)
```
