# Pong 9

Index:

- [Serving](#serving)
  - [Variable](#variable)
  - [State](#state)

## Serving

Once a point has been scored, the game directs the ball toward the player which has suffered the loss. To allow for such a feature, the application introduces a new game state in `serving`, which complements the game's logic with `playing` and `waiting`. The interplay between the three can be highlighted for clarity as follows:

- by default: waiting

- by pressing enter:

  - if playing --> waiting
  - if waiting --> playing
  - if serving --> playing

- by scoring a point: serving.

Conditional statements need to consider the relationship between states.

### Variable

With regards to the `servingPlayer` variable, this is created in the `load` function

```lua
-- create a variable to keep track of the serving player
servingPlayer = 1
```

In the `update()` function, it is used to identify the serving player in the serving state. It is also used to determine the horizontal movement of the player, with a random speed and toward the player suffering a loss:

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

And finally it is used in the `draw()` function to conditinally display on the screen the player currently serving.

### State

The state of the game, as mentioned, can be one of three values:

- waiting,
- serving,
- playing.

The three are implemented as described above with the following logic:

- in the `load()` function, the state is initialized to `waiting`;

- following a press on the `enter` key, the state is updated to either playing or waiting:

```lua
function love.keypressed(key)
  if key == 'enter' or key == 'return' then
    -- if waiting or serving, set the state to playing
    if gameState == 'waiting' or gameState == 'serving' then
      gameState = 'playing'
    -- otherwise (the game is ongoing) set the state to waiting
    else
      gameState = 'waiting'
    end

  end
end
```

- in the `update()` function, the state is finally updated as a point is scored, to `serving`.
