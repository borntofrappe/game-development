# Pong 10

_Please note:_ `main.lua` depends on `push.lua`, `class.lua` and `font.ttf` being available in the same folder

## Serving

Once a point is scored, the idea is to redirect the ball toward the player which has suffered the loss. To allow for such a feature, the application introduces a new state in `serving`, which complements the game's logic with `playing` and `waiting`

To summarize the state in `main.lua`:

- start in the `waiting` state

  ```lua
  function love.load()
    gameState = 'waiting'
  end
  ```

- when pressing enter, move between `waiting` and `playing`

  ```lua
  function love.keypressed(key)
    if key == 'enter' or key == 'return' then
      if gameState == 'waiting' then
        gameState = 'playing'
      else
        gameState = 'waiting'
      end
    end
  end
  ```

- when scoring a point, move to the `serving` state

  ```lua
  if ball.x < 0 then
    -- update score
    gameState = 'serving'
  elseif ball.x > VIRTUAL_WIDTH then
    -- update score
    gameState = 'serving'
  end
  ```

- when in the `serving` state, allow to move to `playing` by once again pressing enter. This is achieved by updating the conditional already covering the `waiting` state

  ```lua
  if gameState == 'waiting' or gameState == 'serving' then
    gameState = 'playing'
  else
    gameState = 'waiting'
  end
  ```

## servingPlayer

To keep track of the serving player, the game introduces the `servingPlayer` variable

```lua
function love.load()
  servingPlayer = 1
end
```

When a point is scored, update the variable to consider the side suffering a loss

```lua
if ball.x < 0 then
  -- update score
  servingPlayer = 1
  gameState = 'serving'
elseif ball.x > VIRTUAL_WIDTH then
  -- update score
  servingPlayer = 2
  gameState = 'serving'
end
```

In the `update()` function then, update the code to identify the serving player when the `serving` state is reached. Based on this checkup, change the direction of the ball, with a random value toward the player suffering a loss:

```lua
-- if serving, set the ball to move toward the serving player
if gameState == 'serving' then
  if servingPlayer == 1 then
    ball.dx = -math.random(140, 200)
  else
    ball.dx = math.random(140, 200)
  end
end
```

`love.draw()` is finally updated to show the serving player.

```lua
if gameState == 'serving' then
  love.graphics.printf(
      'Now serving: player ' .. tostring(servingPlayer),
      0,
      VIRTUAL_HEIGHT / 12,
      VIRTUAL_WIDTH,
      'center'
    )
end
```
