Incorporate changes from the lecturer's code:

- entity class

## Entity

The lecturer organizes the code to have _entities_, a helper structure to accommodate both the player and snails. With this update, I create the `Entity` class to have the player inherit its functionality only. I am also interested in only implementing the features developed so far, which means having the player move, jump, but not react to its surrounding environment; this last feat will be the topic of a future update.

### init

The class is initialized with a `def` table, which contains the necessary information:

- `x`, `y`; coordinates

- `width`, `height`; dimensions

- `texture`; a string describing the png image in the global `gTexture` and `gFrames`

- `stateMachine`; a state machine describing the player. This is actually important to warrant a separate section, see below

### update

Just like the game, the entity is updated through its respective state machine.

```lua
function Entity:update(dt)
    self.stateMachine:update(dt)
end
```

The individual states have therefore a structure similar to the one developed for the `StartState` or `PlayState`, and feature an `update` function describing how to update the entity.

### changeState

The game moves between the individual states for the entity with the `changeState` function. This one mirrors the behavior of the `:change` function first introduced with the game's state.

```lua
function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end
```

### render

With the `render` function the entity uses the texture described in `self.texture` to target the specific image. For the actual quad, it uses the same value, which means the tables must have matching keys, and the current animation.

```lua
function Entity:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], self.x, self.y)
end
```

Less relevant for the update, the direction is also used to flip the sprite when moving to the left.

### currentAnimation

In the lecturer's code, the `Entity` class does not introduce a variable for `currentAnimation`.

```lua
function Entity:init(def)
  self.currentAnimation = def.animation
end
```

The value is however included in the separate states, like for the falling state.

```lua
function PlayerFallingState:init(player)
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
    self.player.currentAnimation = self.animation
end
```

This is reasonable as the animation makes sense only in the context of the individual states. It is slightly strange to see that the value is used even if not defined in the same class.

## State machines

As prefaced in the previous section, the game introduces additional state machines, and this time for the entities of the game; the idea is similar to the state machine for the entire game however.

The goal is to have dedicated files, like `PlayerWalkingState` and `PlayerIdleState`, in which to develop how the entity behaves, like what kind of input produces which kind of effect. Taking for example `PlayerWalkingState`:

- have the player move in the direction described by the `self.direction`

- move to the idle state when the left and right keys are released

### Player

By looking at how the player is first initialized, it's possible to see how the individual states consider an input in the form of the player itself.

```lua
StateMachine {
    ['idle'] = function() return PlayerIdleState(self.player) end,
    ...
}
```

This is ultimately to give access to the player in the state, and modify its position, appearance _from_ the state.

### states

The different states seems to share a few commonalities:

- initialize the player with the input variable

  ```lua
  function PlayerWalkingState:init(player)
  self.player = player
  end
  ```

- initialize an animation and set the `currentAnimation` for the player to said animation

  ```lua
  function PlayerWalkingState:init(player)
  self.animation =
      Animation(
      {
      frames = {10, 11},
      interval = 0.1
      }
  )

  self.player.currentAnimation = self.animation
  end
  ```

- develop how the player behaves in the `update` function

  ```lua
  function PlayerWalkingState:update(dt)
  end
  ```

`PlayerJumpState` also describes the `:enter` function, but this seems superfluous.

```lua
function PlayerJumpState:enter(params)
    gSounds['jump']:play()
    self.player.dy = PLAYER_JUMP_VELOCITY
end
```

The instructions can be moved in the `init` function since they don't depend on the `params` argument.

### IdleState

In the idle state:

- check if the right or left key is being pressed, in which case move to the walking state

- check if the space key was pressed, in which case move to the jumping state

### WalkingState

In the walking state:

- update the animation, as the animation actually includes more than a single frame

- check if both the right and left key are released, in which case move to the idle sate

- check if the space key was pressed, in which case move to the jumping state. This is exactly like for the idle state

- update the player to move left or right, depending on the actual key

**Please note**: the horizontal movement is limited to the beginning/end of the level in the `PlayState`,

```lua
if self.player.x <= 0 then
    self.player.x = 0
elseif self.player.x >= self.width * TILE_SIZE - self.player.width then
    self.player.x = self.width * TILE_SIZE - self.player.width
end
```

### JumpState

In the jump state:

- change `self.player.dy` to have the player move upwards

- update `dy` and `y` to have the player move vertically and as subject to gravity

- keep updating the horizontal movement if the left or right key is being pressed

- move to the falling state in the moment `dy` becomes positive

### FallingState

In the fall state (most similar to the jump state):

- update `dy` and `y` to have the player move vertically and as subject to gravity

- keep updating the horizontal movement if the left or right key is being pressed

- move to the idle or walking state in the moment the player finds the coordinate of the ground

## player and Player

In terms of implementation, it's important to note that the player is initialized in the play state describing the values in the `def` table.

```lua
self.player =
    Player(
    {
      x = VIRTUAL_WIDTH / 2 - PLAYER_WIDTH / 2,
      y = TILE_SIZE * (ROWS_SKY - 1) - PLAYER_HEIGHT,
      width = PLAYER_WIDTH,
      height = PLAYER_HEIGHT,
      texture = "character",
      stateMachine = StateMachine(
        {
          ["idle"] = function()
            return PlayerIdleState(self.player)
          end,
          ...
        }
      )
    }
  )
```

`Player` itself inherits from `Entity`, but uses its functions with the following syntax:

```lua
function Player:init(def)
  Entity.init(self, def)
end
```

It does not use `Entity:init(def)`, because in this instance `self` would refer to `Entity`, not `Player`. It is necessary to explicitly use the argument in the `.init` function.

### Order

In the list of dependencies included in "Dependency.lua". be sure to require the entity class _before_ the player class. In the wrong order the player doesn't have a class from which to inherit.
