# Pokemon 2

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Pokemon — Final`.

_Please note_: taking inspiration from the suggestion of the lecturer, the update creates a single class for both a fade-in and a fade-out operation.

_Plese also note_: the notes describe the fading transition between the start state and the play-dialogue pair. That being said, the technique is repeated between as the player moves back to the start state from the playing screen.

## FadeState

`FadeState` is initialized with a table, itself describing the following:

- `color`, for the color of the overlay in its rgb components

- `duration`, for the `Timer.tween()` function

- `opacity`, describing the goal opacity

The class initiazes `self.opacity` with the value opposite to the goal opacity.

```lua
function FadeState:init()
  self.color = def.color
  self.duration = def.duration
  self.opacity = def.opacity == 1 and 0 or 1
end
```

The variable is then updated to the input value.

```lua
gStateStack:push(
  FadeState(
    {
      color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
      duration = 0.5,
      opacity = 1 -- fade in
    }
  )
)
```

For the actual animation, the timer library uses the `Timer.tween` function.

```lua
Timer.tween(
  self.duration,
  {
    [self] = {opacity = def.opacity}
  }
)
```

The `Timer` object needs to be updated.

```lua
function FadeState:update(dt)
  Timer.update(dt)
end
```

`self.opacity` can be then used in the `render` logic to overlay the current screen.

```lua
love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.opacity)
-- rectangle
```

Past the transition, it is necessary to describe how to continue. The timer library allows to execute code after the transition by way of the `:finish()` function

```lua
Timer.tween():finish(function()

end)
```

This is where the `FadeState` can be removed from the stack.

```lua
Timer.tween():finish(function()
  gStateStack:pop()
end)
```

To continue with the game, the `FadeState` needs to accommodate multiple scenarios. For instance, and between start and play state, the code needs to push the play state. Between play state and combat state (consider when a battle begins), the code needs to trigger the battle sequence. To consider this variety, the class is initialized with an additional argument, a function to be executed as `FadeState` is popped from the stack.

```lua
Timer.tween():finish(function()
  gStateStack:pop()
  def.callback()
end)
```

### callback

Considering the transition between start and play-dialogue once more, the two states are added to the stack in the body of the callback function.

```lua
gStateStack:push(
  FadeState(
    {
      -- previous attributes
      callback = function()
        gStateStack:pop()
        gStateStack:push(PlayState())
        gStateStack:push(DialogueState())
      end
    }
  )
)
```

The code is not executed immediately, but only when the `tween` operation is complete.

### Fade in fade out

To complete the fading transition, the callback function includes yet another push operation. This time for a `FadeState` where a white rectangle is animated to be fully transparent.

```lua
gStateStack:push(
  FadeState(
    {
      color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
      duration = 0.5,
      opacity = 0,
      callback = function()
      end
    }
  )
)
```
