Here you allow one side to win.

**requires push.lua, font.ttf, class.lua**

## Victory

With an additional `if` statement, and when a point is scored, check if said score exceeds an arbitrary threshold.

It is important to note how the presence of a winning condition introduces a new state, for the victorious outcome of the game. The code therefore needs to account for changes to and from this state as well.

- when scoring a point _and_ reaching the threshold, move to the `victory` state

  ```lua
  if ball.x < 0 then
    -- update score
    if player1.points >= 10 then
      gameState = 'victory'

  elseif ball.x > VIRTUAL_WIDTH then
    -- update score
    if player2.points >= 10 then
      gameState = 'victory'
    end
  end
  ```

- when in the `victory` state and pressing enter, move to `playing` and reset the score for both players

  ```lua
  if gameState == 'victory' then
    gameState = 'playing'
    player1.points = 0
    player2.points = 0
  end
  ```

## winningPlayer

An additional variable `winningPlayer` allows to keep track of the winning side.

```lua
function love.load()
  winningPlayer = 0
end
```

- when reaching the victorious state then, update the variable with the winning side.

  ```lua
  -- scoring a point
  if player1.points >= 10 then
    gameState = 'victory'
    winningPlayer = 1
    servingPlayer = 2

  if player2.points >= 10 then
    gameState = 'victory'
    winningPlayer = 2
    servingPlayer = 1
  ```

- in `love.draw()` show an appropriate message

  ```lua
  if gameState == 'victory' then
    love.graphics.printf(
        'Winner: player ' .. tostring(winningPlayer),
        0,
        VIRTUAL_HEIGHT * 3 / 4 - 16,
        VIRTUAL_WIDTH, -- centered in connection to the screen's width
        'center'
      )
  end
  ```
