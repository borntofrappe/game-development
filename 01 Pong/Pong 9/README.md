# Pong 8

## Score

To keep track of the score, the application is updated in the `load` function, as to keep track of the individual score in two different variables. I'd rather try to migrate this information in the two instances of the paddle class though, to practice a bit more with the class structure.

Instead of the following:

```lua
player1Score = 0
player2Score = 0
```

I therefore decide to update the `init` function of the paddle class.

```lua
function Paddle:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dy = 0
  -- include a field for the score of the paddle
  self.points = 0
end
```

Instead of the following then (in the update function when the game state identifies an ongoing game):

```lua
if ball.x <= 0 then
  player2Score = player2Score + 1
  ball:reset()
  gameState = 'waiting' -- waiting was the word I chose for the idle state
end
```

I need to update the score either with a function or simply and directly modifying the `points` value

```lua
if ball.x <= 0 then
  -- player2.score = player2.score + 1
  player2:score()
  ball:reset()
  gameState = 'waiting' -- waiting was the word I chose for the idle state
end
```

I chose a function once again to practice with the construct. In the `Paddle` file I can think of such a function as follows:

```lua
function Paddle:score()
  self.points = self.points + 1
end
```

That takes care of the left side and inrements the score for `player2`, but for `player1` it is a matter of mirroring the logic for the windows' width instead of `0`.

```lua
if ball.x > VIRTUAL_WIDTH then
  player1:score()
  ball:reset()
  gameState = 'waiting' -- waiting was the word I chose for the idle state
end
```

Without considering a winning condition, or a reset, the score is finally highlighted through the two `printf` functions, but instead of showing hardcoded `0` values, I now need to show the individual score of each paddle.

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

As an aside, update 8 also introduces a variable in `servingPlayer`, but doesn't use it anywhere else n the code. Probably a mishap for a later update.
