Initialize a player class, with an idle and walking state.

_Please note_: the technique used to introduce the player class was first introduced in "Super Mario Bros" and the update `Super Mario Bros 1`. Refer to that folder for more information.

## Player

The idea is to create a `Player` class which renders the desired sprite in the world.

```lua
function Player:init(def)
  self.column = def.column
  self.row = def.row

  self.sprite = def.sprite or 1
  self.direction = def.direction or "down"
  self.variety = def.variety or 2
end

function Player:render()
  love.graphics.draw(
    gTextures["entities"],
    gFrames["entities"][self.sprite][self.direction][self.variety],
    (self.column - 1) * TILE_SIZE,
    (self.row - 1) * TILE_SIZE
  )
end
```

To update the player, instead of describing the logic in `Player:update(dt)`, the class also benefits from a state machine. Here the goal is to delegate to different states how the player behaves.

```lua
function Player:init(def)
  -- previous attributes

  self.stateMachine = def.stateMachine
end

function Player:update(dt)
  self.stateMachine:update(dt)
end
```

This means the game uses both a state stack and a state machine. The stack is useful for the overall game, since multiple states can exist at the same time, while the machine is useful for the player, which can only be in one state at a time.

## States

The update includes two states: idle and walking. Picking up from the `Super Mario Bros` episode, they both initialize a player and an animation. This animation is included with the `Animation` class, to loop through a series of frames at a given interval. For instance and for the idle state, the idea is to show only the second frame.

```lua
function PlayerIdleState:init(player)
  self.player = player
  self.animation = Animation({["frames"] = {2}, ["interval"] = 1})
  self.player.currentAnimation = self.animation
end
```

In the `update` function of the individual states, the idea is to then map how the player behaves in the particular state.

Once again and for the idle state, the idea is to update the player's direction and move to the walking state when one of the arrow key is pressed.

```lua
function PlayerIdleState:update(dt)
  if love.keyboard.wasPressed("up") then
    self.player.direction = "up"
    self.player:changeState("walking")
  -- other keys
  end
end
```

## Walking

When the player is walking, the idea is to move the sprite from one cell to another. To allow for this grid-based movement, it is useful to have two separate sets of values, describing the position in the grid and in the game.

```lua
function Player:init(def)
  self.column = def.column
  self.row = def.row

  self.x = (self.column - 1) * TILE_SIZE
  self.y = (self.row - 1) * TILE_SIZE
end

function Player:render()
  love.graphics.draw(
    -- previous attributes
    self.x,
    self.y
  )
end
```

In the moment the `render` function uses `x` and `y`, we are able to update the position in the grid, `column` and `row`, and then animate the actual coordinates with the timer library. For instance and when pressing the up arrow key:

- update the `row` value of the player

  ```lua
  function PlayerWalkingState:update(dt)
    if self.player.direction == "up" then
      self.player.row = math.max(1, self.player.row - 1)
    end
  end
  ```

  `math.max` is used to ensure that the movement is restrained to the available rows.

- update the `y` coordinate with `Timer.tween`

  ```lua
  Timer.tween(
    0.4,
    {
      [self.player] = {y = (self.player.row - 1) * TILE_SIZE}
    }
  )
  ```

The same logic is used for the other arrow keys, updating the columns and rows, and only afterwards the actual coordinates.

### isMoving

A boolean is necessary to ensure that the player moves one cell at a time. This is because the `update()` function is called continuously.

The idea is to switch the boolean to `true` when first modifying the `row` and `column` value.

```lua
function PlayerWalkingState:init(player)
  -- previous attributes
  self.isMoving = false
end

function PlayerWalkingState:update(dt)
  if not self.isMoving then
    self.isMoving = true
    -- update column, row, x, y
  end
end
```

### finish

As the animation to the new coordinate comes to an end, the player should move to the idle state.

```lua
Timer.tween():finish(function()
  self.player:changeState("idle")
end)
```

If the arrow keys are still being pressed however, this results in the player not moving at all. Remember that the idle state waits for a specific key being pressed in the previous frame. To fix this issue, consider if the keys are pressed with the `love.keyboard.isDown()` function. If so, update the direction and call the walking state once more.

```lua
Timer.tween():finish(function()
  if love.keyboard.isDown("up") then
    self.player.direction = "up"
    self.player:changeState("walking")
  -- other keys
  else
    self.player:changeState("idle")
end)
```

By re-initializing the walking state, the booelean `isMoving` allows to move in the desired direction.

### update

To update the player, remember to call the update function on the instance of the player. This is done in the play state, where the instance is initialized and eventually used.

```lua
function PlayState:update(dt)
  self.player:update(dt)
end
```

Remember to also update the `Timer` object. `Timer.tween` is created in the walking state, which means you can update the timer in the individual state.

```lua
function PlayerWalkingState:update(dt)
  Timer.update(dt)
end
```

As the game grows in complexity however, it is more useful to update the object in the play state.

```lua
function PlayState:update(dt)
  Timer.update(dt)
  self.player:update(dt)
end
```

Consider a situation in which the library is used to transition from the play state to the battle state.

## y offset

This is but a minor change, but important in the context of game development. The player is rendered slightly above the current cell.

```lua
function Player:render()
  love.graphics.draw(
    -- previous attributes
    self.x,
    self.y - TILE_SIZE / 4
  )
end
```

This allows for a more credible movement, especially as the sprite overlaps with the tall grass.
