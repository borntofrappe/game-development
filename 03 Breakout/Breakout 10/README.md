Complete a level when every brick is destroyed.

## Level cleared

The variable for the level is initialized in the `ServeState` and then passed to and from the `PlayState` and `PauseState`. In terms of gameplay, it is in the play state where the value proves its worth, however.

The idea is to include a function to check for a victory.

```lua
function PlayState:isLevelCleared()
  for k, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end
  return true
end
```

This function is then used every time a brick is hit.

```lua
function love.update(dt)
  if self.ball:collides(brick) and brick.inPlay then
    brick:hit()
    if self:isLevelCleared() then
      -- do something
    end
  end
end
```

This is where the game introduces an additional state: `VictoryState`. It works as an intermediate stage, between levels, to show the current score and let the player continue with the level which follows.

In terms of flow, you access this state only from the play state, by clearing the current level, and you move to the serve state by pressing enter.

In terms of data, it is necessary to consider the level, score, health and paddle, but not the bricks, nor the ball. These two are unnecessary since:

- the bricks are created anew with the new level

- the ball is fixed above the paddle
